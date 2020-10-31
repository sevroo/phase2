import pandas as pd

# read steam csv file
df = pd.read_csv('steam.csv')
# limit to games with less than 60 characters
# df = df[df['name'].map(len) <= 60]

# take midpoint of owners
owners = df['owners']
interval = owners.str.split('-')
first, second = interval.str[0].astype(int), interval.str[1].astype(int)
midpoint = ((first+second)/2).astype(int)
df['owners'] = midpoint

# drop unnecessary columns
df = df.drop(columns=['required_age', 'achievements', 'english'])

# init "relations"
game = df[['appid', 'name', 'release_date', 'price']]
developer = df[['appid', 'developer']]
publisher = df[['appid', 'publisher']]
platform = df[['appid', 'platforms']]
stat = df[['appid', 'positive_ratings', 'negative_ratings', 'average_playtime', 'median_playtime', 'owners']]
genre = df[['appid', 'genres']]
communitytag = df[['appid', 'steamspy_tags']]
category = df[['appid', 'categories']]

# split developer
developer = pd.DataFrame(developer.developer.str.split(';').tolist(), index=developer.appid).stack()
developer = developer.reset_index()[['appid', 0]] # developer variable is currently labeled 0
developer.columns = ['appid', 'developer'] # renaming developer

# split publisher
publisher = pd.DataFrame(publisher.publisher.str.split(';').tolist(), index=publisher.appid).stack()
publisher = publisher.reset_index()[['appid', 0]] # publisher variable is currently labeled 0
publisher.columns = ['appid', 'publisher'] # renaming publisher

# split platform
platform = pd.DataFrame(platform.platforms.str.split(';').tolist(), index=platform.appid).stack()
platform = platform.reset_index()[['appid', 0]] # platforms variable is currently labeled 0
platform.columns = ['appid', 'platform'] # renaming platform

# split genre
genre = pd.DataFrame(genre.genres.str.split(';').tolist(), index=genre.appid).stack()
genre = genre.reset_index()[['appid', 0]] # genres variable is currently labeled 0
genre.columns = ['appid', 'genre'] # renaming genres

# split communitytag (steamspy_tags)
communitytag = pd.DataFrame(communitytag.steamspy_tags.str.split(';').tolist(), index=communitytag.appid).stack()
communitytag = communitytag.reset_index()[['appid', 0]] # steamspy_tags variable is currently labeled 0
communitytag.columns = ['appid', 'steamspy_tags'] # renaming steamspy_tags

# split categories
category = pd.DataFrame(category.categories.str.split(';').tolist(), index=category.appid).stack()
category = category.reset_index()[['appid', 0]] # categories variable is currently labeled 0
category.columns = ['appid', 'category'] # renaming categories

# save to csv
game.drop_duplicates().to_csv('game.csv', index=False)
developer.drop_duplicates().to_csv('developer.csv', index=False)
publisher.drop_duplicates().to_csv('publisher.csv', index=False)
platform.drop_duplicates().to_csv('platform.csv', index=False)
stat.drop_duplicates().to_csv('stat.csv', index=False)
genre.drop_duplicates().to_csv('genre.csv', index=False)
communitytag.drop_duplicates().to_csv('communitytag.csv', index=False)
category.drop_duplicates().to_csv('category.csv', index=False)