install.packages("multilinguer")
library(multilinguer)
install_jdk()
install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"), 
                 type = "binary")

install.packages("remotes")


remotes::install_github("haven-jeon/KoNLP", upgrade = "never", 
                        INSTALL_opts=c("--no-multiarch"))


library(KoNLP)
useNIADic()

txt <- readline("R/hiphop.txt")
txt
library(stringr)
txt <- str_replace_all(txt, "\\W", " ")  # remove all symbols

extractNoun("대한민국의 영토는 한반도와 그 부속 도서로 한다")

nouns <- extractNoun(txt)

wordcount <- table(unlist(noun))
wordcount

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word

df_word <- rename(df_word, word =Var1, freq = Freq)

# get words which is longer than 2
df_word <- filter(df_word, nchar(word) >= 2)



top_20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top_20

pal2 <- brewer.pal(8, )




















