install.packages('foreign') # to use spss

library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

#read data
raw_welfare <- read.spss(file = 'R/Koweps_hpc10_2015_beta1.sav', to.data.frame = T)


welfare <- raw_welfare

head(welfare)
tail(welfare)
View(welfare)
str(welfare)
summary(welfare)

welfare <- rename(welfare,
                  sex = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  income = p1002_8aq1,
                  code_job = h10_eco9,
                  code_region = h10_reg7)


table(welfare$sex)
class(welfare$sex)

# outlier -> NA
welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex)

# see NA
table(is.na(welfare$sex))
# there is no NA

# give name to sex
welfare$sex <- ifelse(welfare$sex == 1, 'male', 'female')
table(welfare$sex)
qplot(welfare$sex)

# income information
class(welfare$income)
summary(welfare$income)
qplot(welfare$income)
qplot(welfare$income) + xlim(0, 1000) 

# outlier -> NA
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

# check NA
table(is.na(welfare$income))


# mean income of sex
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_incom = mean(income))

sex_income

ggplot(data = sex_income, aes(x=sex, y=mean_incom)) + geom_col()


class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

# outlier of age
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)
table(is.na(welfare$birth))

# get age
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)


# filter !na group age     summa income

age_income <- welfare %>%  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))


head(age_income)
ggplot(data=age_income, aes(x=age, y=mean_income)) + geom_line()

welfare <- welfare %>% mutate(ageg = ifelse(age < 30, 'young', ifelse(age <= 59,
                              'middle', 'old')))


table(welfare$ageg)
qplot(welfare$ageg)


# income difference by age
age_income <- welfare %>%  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))

ggplot(data = age_income, aes(x=ageg, y=mean_income)) + geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

# by age, sex
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))

sex_income

ggplot(data= sex_income, aes(x=ageg, y=mean_income, fill=sex)) + geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))
# fill: split the bar by two colors(male, female) 


ggplot(data= sex_income, aes(x=ageg, y=mean_income, fill=sex)) + 
  geom_col(position='dodge') + # male plot is next to female
  scale_x_discrete(limits = c('young', 'middle', 'old'))



sex_income2 <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

sex_income2

ggplot(data = sex_income2,  aes(x=age, y=mean_income, col=sex)) + geom_line()
# col=sex makes two lines


# income difference by job
list_job <- read_excel('R/Koweps_Codebook.xlsx', col_names = T, sheet =2)

dim(list_job)
class(list_job)
table(welfare$code_job)


welfare <- left_join(welfare, list_job, by ='code_job')
welfare

welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))

head(job_income)

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)

bottom10 <- job_income %>% 
  arrange(mean_income) %>% 
  head(10)

ggplot(data = top10, aes(x=reorder(job, mean_income), y=mean_income)) +
  geom_col() + 
  coord_flip() # x-axis --> vertical           


ggplot(data = bottom10, aes(x=reorder(job, -mean_income), y=mean_income)) +
  geom_col() + 
  coord_flip() #+ ylim(0,850) 

# 9-7 common job of each sex
job_male <- welfare %>% 
  filter(!is.na(job) & sex == 'male') %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_male    

job_female <- welfare %>% 
  filter(!is.na(job) & sex == 'female') %>% 
  group_by(job) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_female


ggplot(data = job_male, aes(x=reorder(job, n), y=n)) + geom_col() + coord_flip()
ggplot(data = job_female, aes(x=reorder(job, -n), y=n)) + geom_col()


# 9-8

class(welfare$religion)
table(welfare$religion)

# religion yes or no
welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")
qplot(welfare$religion)

# marriage
table(welfare$table)

welfare$group_marriage <- ifelse(welfare$marriage == 1, 'marriage', 
                                 ifelse(welfare$marriage ==3, 'divorce', NA))

table(is.na(welfare$group_marriage))
qplot(welfare$group_marriage)






