from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys 
from webdriver_manager.chrome import ChromeDriverManager
import time

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

url = "https://www.naver.com/"
driver.get(url)
time.sleep(2)

search_box = driver.find_element(By.CSS_SELECTOR, '#search #query')
search_box.send_keys('영화')
search_box.send_keys(Keys.RETURN)
time.sleep(2)

review_data_list = []

def collect_reviews_on_page():
  i = 0
  while True:
    cards = driver.find_elements(By.CSS_SELECTOR, '.sc_new .card_area .card_item .data_area .data_box .area_text_box ._text')
    print(f"현재 페이지 cards 개수: {len(cards)}")
    
    if i == len(cards):
      break
    
    cards[i].click()
    time.sleep(2)

    go_review_btn = driver.find_element(By.CSS_SELECTOR, '.sc_new .tab_list ._item:nth-of-type(5)')
    go_review_btn.click()
    time.sleep(2)

    review_box = driver.find_element(By.CSS_SELECTOR, '.lego_review_list')
    driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight", review_box)
    time.sleep(2)

    title = driver.find_element(By.CSS_SELECTOR, '.sc_new .title_area .title .area_text_title ._text')
    score = driver.find_elements(By.CSS_SELECTOR, '.lego_review_list .area_card_outer .area_card .area_title_box .area_text_box')
    text = driver.find_elements(By.CSS_SELECTOR, '.lego_review_list .area_card_outer .area_card .area_review_content ._text')
    date = driver.find_elements(By.CSS_SELECTOR, '.lego_review_list .area_card_outer .area_card .cm_upload_info dd:nth-of-type(2)')
    pos = driver.find_elements(By.CSS_SELECTOR, '.lego_review_list .area_card_outer .area_card .cm_sympathy_area ._btn_upvote ._count_num')
    neg = driver.find_elements(By.CSS_SELECTOR, '.lego_review_list .area_card_outer .area_card .cm_sympathy_area ._btn_downvote ._count_num')

    for j in range(len(score)):
      review_data = {
        'title': title.text,
        'score': score[j].text,
        'text': text[j].text,
        'date': date[j].text,
        'positive': pos[j].text,
        'negative': neg[j].text
      }
      review_data_list.append(review_data)

    for _ in range(2):
      driver.back()
      time.sleep(2)
      
    i += 1
collect_reviews_on_page()

cards_page_next_btn = driver.find_element(By.CSS_SELECTOR, '.sc_new .cm_paging_area .pgs .pg_next')
cards_page_next_btn.click()
time.sleep(2)
collect_reviews_on_page()

for review in review_data_list:
  print(review)