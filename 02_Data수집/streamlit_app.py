import streamlit as st
import pandas as pd
from sqlalchemy import create_engine

# DB 연결 
engine = create_engine("mysql+mysqlconnector://root:1234@localhost/data_collection")

# 데이터 로딩
df = pd.read_sql("SELECT * FROM project_sales", engine)
df["날짜"] = pd.to_datetime(df["날짜"])
df["월"] = df["날짜"].dt.month
 
# 대시보드 제목 
st.title("실시간 매출 분석 대시보드") 
 
# 날짜 필터 
start_date, end_date = st.date_input("날짜 선택", [df["날짜"].min(), df["날짜"].max()]) 
filtered = df[(df["날짜"] >= pd.to_datetime(start_date)) & (df["날짜"] <= 
pd.to_datetime(end_date))] 
 
# 지역 필터 
지역_선택 = st.multiselect("지역 필터", options=df["지역"].unique(), 
default=df["지역"].unique()) 
filtered = filtered[filtered["지역"].isin(지역_선택)] 
 
# 제품별 매출 차트 
st.subheader("제품별 매출") 
제품별 = filtered.groupby("제품")["매출"].sum() 
st.bar_chart(제품별) 
 
# 날짜별 매출 라인차트 
st.subheader("날짜별 매출 추이") 
날짜별 = filtered.groupby("날짜")["매출"].sum() 
st.line_chart(날짜별)