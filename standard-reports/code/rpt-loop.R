#------------------------------------------------------------------------------#
#
### READ AND PREPARE TCOM WASHINGTON BEHAVIORAL HEALTH DATA
# Author: Nick Mader <nmader@chapinhall.org>
#
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
### Set up workspace and load data----------------------------------------------
#------------------------------------------------------------------------------#

try(setwd("G:/GitLab/standard-reports"))
rm(list = ls())

package.list <- c("dplyr", "tidyr", "data.table", "stringr", "lubridate")
for (p in package.list){
  if (!p %in% installed.packages()[, "Package"]) install.packages(p)
  library(p, character.only = TRUE)
}

grepv <- function(p, x, ...) grep(pattern = p, x = x, value = TRUE, ...)
cn <- function(x) colnames(x)
myStartYear <- 2015

load(file = "data/System Report Calc Values.Rda", verbose = TRUE)

#------------------------------------------------------------------------------#
### Set up loop across reporting levels, and units within each level -----------
#------------------------------------------------------------------------------#

### Examine number of loops
actNeedsRpt %>%
  distinct(rptLvl, rptLvlVal) %>%
  group_by(rptLvl) %>%
  summarize(n = n())

i <- 1
nonReportsList <- "The following entities did not have a report generated because of too small of a sample size. These are:\n"

## Generate albel for #Quarter label for ALL reports (date range changes between reports, but all reports display CURRENT quarter even if there's no new data)
label <- 
  fullTimeRpt %>%
  within({
    q <- as.numeric(paste0(startYear, str_replace_all(startQtr, "Q", "")))
  }) %>%
  ungroup()   %>%
  filter(q == max(q, na.rm = TRUE))%>%
  filter(n == max(n, na.rm = TRUE))
qtrLabel <- paste0(label$startYear, label$startQtr)
qtrLabelLong <- paste0(str_replace_all(label$startQtr, "Q", "Quarter "), ", ", label$startYear)

#------------------------------------------------------------------------------#
### Run loops ------------------------------------------------------------------
#------------------------------------------------------------------------------#

system.time({
  for (rl in c("Systemwide", reportFields)){
    
    # Create a subfolder for reports of that level if it doesn't already exist
    rlDir <- paste0(getwd(), "/output/reports/", rl)
    if (!file.exists(rlDir)) dir.create(file.path(rlDir))

    # Pull all values of given reporting level
    act      <- filter(actNeedsRpt,   rptLvl == rl)
    trt      <- filter(trtNeedsRpt,   rptLvl == rl)
    use      <- filter(usefulStrRpt,  rptLvl == rl)
    cohMo    <- filter(cohortMoRpt,   rptLvl == rl)
    cohQt    <- filter(cohortQtrRpt,  rptLvl == rl)
    comp     <- filter(compRpt,       rptLvl == rl)
    fTime    <- filter(fullTimeRpt,   rptLvl == rl)
    sTime    <- filter(screenTimeRpt, rptLvl == rl)
    date     <- filter(dateRangeRpt,  rptLvl == rl)
    
    rus <- unique(act$rptLvlVal)
    
    for (ru in rus){
      
      if (i %% 10 == 0) print(paste("Working on run", i, "of ", nrow(entityNs)))
      
      entityN <- 
        entityNs %>%
        ungroup() %>%
        filter(rptLvl == rl, rptLvlVal == ru) %>%
        select(n)
      
      if (entityN >= 10) {
        myAct    <- filter(act,   rptLvlVal == ru)
        myTrt    <- filter(trt,   rptLvlVal == ru)
        myUse    <- filter(use,   rptLvlVal == ru)
        myCohM   <- filter(cohMo, rptLvlVal == ru)
        myCohQ   <- filter(cohQt, rptLvlVal == ru)
        myComp   <- filter(comp,  rptLvlVal == ru)
        myFTime  <- filter(fTime, rptLvlVal == ru)
        MySTime  <- filter(sTime, rptLvlVal == ru)
        myDate   <- filter(date,  rptLvlVal == ru)
        
        # Generate date range documentation
        dateRange <- paste0(myDate[1,]$dateRange)
        datePull  <- paste0(myDate[1,]$datePull)
        reportName <- paste0("CANS Report - ",
                             ifelse(rl == "Statewide", rl, ru),
                             " ", qtrLabel, ".html")

        rmarkdown::render(input = "code/rpt-tmplt.Rmd",
                          output_format = "html_document",
                          output_file = paste0(rlDir, "/", reportName))
        
      } else {
        nonReportsList <- paste0(nonReportsList,
                                 paste0(rl, ": ", ru, ", with n = ", entityN), "\n")
      }
      i <- i + 1
    }
  }
}) 

writeLines(nonReportsList, con = "output/reports/Entities that were omitted from reports.txt")
