from Helpers import *
import pandas as pd

"""Edit this list to change source results"""
def saveOfferingsToCsv(rankedSources):
    set(rankedSources)

    sources = pd.DataFrame(get_sources())

    sources = sources[(sources['name'].isin(rankedSources)) & (sources['type'] == 'sub')]
    sources = sources[['id', 'name']]

    offerings = pd.DataFrame(get_offerings_by_source(sources))
    offerings.drop(['page', 'total_pages', 'total_results'], axis=1, inplace=True)

    normalized_offerings = pd.json_normalize(offerings['titles'])
    normalized_offerings['source_id'] = offerings['source_id']

    sources.to_csv('sources.csv', index=False)
    normalized_offerings.to_csv('normalized_offerings.csv', index=False)
    offerings.to_csv('offerings.csv', index=False)

def mergeData():   
    offerings = pd.read_csv('normalized_offerings.csv')
        
    base = pd.read_csv('imdb.title.basics.tsv', sep='\t')
    ratings = pd.read_csv('imdb.title.ratings.tsv', sep='\t')
    crew = pd.read_csv('imdb.title.crew.tsv', sep='\t')
    names = pd.read_csv('imdb.name.basics.tsv', sep='\t')
        
    """We don't want any titles that haven't been rated"""
    merged_data = pd.merge(offerings, base, left_on='imdb_id', right_on='tconst', how='inner')
    merged_data = pd.merge(merged_data, ratings, left_on='imdb_id', right_on='tconst', how='inner')
        
    """If we have no crew data, that's okay"""
    merged_names = pd.merge(crew, names, left_on='directors', right_on='nconst', how='inner')
    merged_data = pd.merge(merged_data, merged_names, left_on='imdb_id', right_on='tconst', how='left')
        
    merged_data.to_csv('combined.csv', index=False)

rankedSources = ['Netflix', 'Prime Video', 'Disney+', 'Max', 'Paramount+', 'Hulu']

saveOfferingsToCsv(rankedSources)
mergeData()

