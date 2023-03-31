library(dplyr)
exam <- read.csv('R/csv_exam.csv')

View(exam)
head(exam, 3)

# choose class==1
exam %>% filter(class == 1)
# choose class==2
exam %>% filter(class == 2)
# choose class is not 1
exam %>% filter(class != 1)

# math > 50
exam %>% filter(math > 50)
exam %>% filter(math < 50)
exam %>% filter(english >= 80)
exam %>% filter(english <= 80)

# and
exam %>% filter(class == 1 & math >= 50)
exam %>% filter(class == 2 & english >= 80)

# or 
exam %>% filter(math >= 90 | english >= 90)
exam %>% filter(english <= 90 | science < 50)

# class 1 or 3 or 5
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1, 3, 5))

# mean math of class 1
exam_cl1 <- exam %>% filter(class == 1)
mean(exam_cl1$math)
# mean math of class 2
exam_cl2 <- exam %>% filter(class == 2)
mean(exam_cl2$math)




# exercise
# Q1.
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
low_dis <- mpg %>% filter(displ<=4)
high_dis <- mpg %>% filter(displ>5)
mean(low_dis$hwy); mean(high_dis$hwy)
# low dis has higher hwy

# Q2.
audi <- mpg %>% filter(manufacturer == 'audi')
toyota <- mpg %>%  filter(manufacturer == 'toyota')
head(toyota)
mean(audi$cty); mean(toyota$cty)
# toyota has higher cty

# Q3.
car3 <- mpg %>% filter(manufacturer == 'chevrolet' | manufacturer == 'ford' | manufacturer == 'honda')
# alternative: car3 <- filter(manufacturer %in% c('chevrolet', 'ford', 'honda'))
head(car3)
mean(car3$hwy)

# 6-3

# select() 
exam %>% select(math)
exam %>% select(english)
exam %>% select(class, math, english) # choose the columns

exam %>% select(-math) # choose all columns except math
exam %>% select(-math, -english) # no math, no english

# class == 1 and english
exam %>% filter(class == 1) %>% select(english)

# id, math with first 6 rows
id_mat <- exam %>% select(id, math)
head(id_mat, 6)
# alternative: 
exam %>% select(id, math) %>% head(6)


# exercise
mpg_new <- mpg %>% select(class, cty)
head(mpg_new)
suv <- mpg_new %>% filter(class == 'suv')
compact <- mpg_new %>% filter(class == 'compact')
mean(suv$cty); mean(compact$cty)
# compact has higher cty


# 6-4
exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class, math) # sort class first and then sort math

#exercise
mpg %>% filter(manufacturer=='audi') %>% 
        arrange(desc(hwy)) %>% 
        head(5)



# 6-5

exam_new <- exam %>% 
  mutate(total = math + english + science,
         mean = (math + english + science)/3) %>% # create two columns
  arrange(desc(total)) %>% 
  head 
exam_new

exam %>% mutate(pf = ifelse(science>=60, 'pass', 'fail')) %>% 
  head 


head(mpg)
mpg_new <- mpg %>% mutate(sum = cty + hwy, av_sum = (cty + hwy)/2)
head(mpg_new)
mpg_new %>% arrange(desc(av_sum)) %>% head(3)

# combine in one dplyr
mpg %>% mutate(sum = cty + hwy, av_sum = (cty + hwy)/2) %>% arrange(desc(av_sum)) %>% head(3)


# 6-6

exam %>% summarise(mean_math = mean(math))
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math), 
            sum_math = sum(math),
            median_math = median(math),
            n=n())

mpg %>% 
  group_by(manufacturer) %>% mutate(tot = (cty + hwy)/2) %>% 
  filter(class == 'suv') %>% 
  summarise(mean_tot = mean(tot)) %>% 
  arrange(desc(mean_tot)) %>% 
  head(5)

# exercise

mpg %>% 
  group_by(class) %>% 
  summarise(mean_city = mean(city)) %>% 
  arrange(desc(mean_city))

head(mpg)

mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hw = mean(highway)) %>% 
  arrange(desc(mean_hw)) %>% 
  head(3)


mpg %>% filter(class == 'compact') %>% 
  group_by(manufacturer) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))
  


# 6-7 left_join, bind_rows
exam <- read.csv('R/csv_exam.csv')


test1 <- data.frame(id=c(1,2,3,4,5), midterm=c(60,80,70,90,85))
  
test2 <- data.frame(id=c(1,2,3,4,5), final=c(70,83,65,95,80))

total <- left_join(test1, test2, by = 'id')

# teacher name
name <- data.frame(class = c(1,2,3,4,5), teacher = c('kim', 'lee', 'park', 'choi', 'jung'))

head(exam)
exam_new <- left_join(exam, name, by = "class")
head(exam_new)


# bind_rows(add rows)
group_a <- data.frame(id=c(1,2,3,4,5), test = c(60,70,80,90,85))
group_b <- data.frame(id=c(6,7,8,9,10), test = c(63,73,83,93,89))
group_c <- data.frame(id=c(6,7,8,9,10), test1 = c(63,73,83,93,89))


group_all <- bind_rows(group_a, group_b)
  
group_call <- bind_rows(group_a, group_c)

# exercise

mpg<- as.data.frame(ggplot2::mpg)
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"), price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22), stringsAsFactors = F)
fuel
head(mpg)

mpg_fl <- left_join(mpg, fuel, by = 'fl')
head(mpg_fl)

mpg_fl %>% select(model, fl, price_fl) %>% head(5)

  
# exercise 
midwest<- as.data.frame(ggplot2::midwest)

mid_new <- midwest %>% mutate( kid_rate= (poptotal - popadults)/poptotal *100) %>% 
        group_by(county) %>% 
        summarise(mean_kid = mean(kid_rate))  

head(mid_new, 5)


mid_new2 <- midwest %>% mutate( kid_rate= (poptotal - popadults)/poptotal*100)
mid_new2 %>% mutate(class = ifelse(kid_rate>=40, 'large',
                           ifelse(kid_rate>=30, 'middle', 'small')))
  
mid_new2 %>% mutate(asian_rate = (popasian/poptotal)*100) %>% 
             group_by(state, county) %>% 
             summarise(mean_asian = mean(asian_rate)) %>% 
             tail(10)

# using select
midwest<- as.data.frame(ggplot2::midwest)
midwest <- midwest %>% mutate(ratio_child= (poptotal - popadults)/poptotal*100)
midwest %>% arrange(desc(ratio_child)) %>% 
            select(county, ratio_child) %>% 
            head(5)


  
  
  







































