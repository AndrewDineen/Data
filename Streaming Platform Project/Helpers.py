import pandas as pd
from dotenv import load_dotenv
import os
import urllib.request
import json

load_dotenv()
api_key = os.getenv("WATCH_MODE_KEY")


"""
Get results by provider
key: rank, value: [provider, results]
"""
def get_sources():
    with urllib.request.urlopen("https://api.watchmode.com/v1/sources/?apiKey=" + api_key) as url:
        data = json.loads(url.read().decode())
        return data

"""Given a dataframe of sources, retreive offerings"""
def get_offerings_by_source(sources):
    sources['id'] = sources['id'].astype(str)
    offerings = pd.DataFrame()
    for index, row in sources.iterrows():
        pageNum = 1
        while True:
            with urllib.request.urlopen("https://api.watchmode.com/v1/list-titles/?apiKey=" + api_key + "&source_ids=" + row['id'] + "&page=" + str(pageNum)) as url:
                data = json.loads(url.read().decode())
                frame = pd.DataFrame(data)
                frame['source_id'] = row['id']
                offerings = pd.concat([offerings, frame], ignore_index=True)
                pageNum += 1
                if not frame.empty: print(frame.iloc[-1]['page'], frame.iloc[-1]['total_pages'])
            if frame.empty or frame.iloc[-1]['page'] > frame.iloc[-1]['total_pages']: 
                break      
    return offerings
