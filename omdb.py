import requests

class Omdb:
    def __init__(self,logger):
        self.logger = logger

    def get_series_title(self,imdbId,season,episode,OMDBkey):
        url = f"https://www.omdbapi.com/?i={imdbId}&season={season}&episode={episode}&apikey={OMDBkey}"
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            return data["Title"]
        else:
            self.logger.info(f"Error: Could not connect to OMDB API - {response.status_code}")
            return None
        
    def get_movie_title(self,imdbId,OMDBkey):
        url = f"https://www.omdbapi.com/?i={imdbId}&apikey={OMDBkey}"
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            return data["Title"]
        else:
            self.logger.info(f"Error: Could not connect to OMDB API - {response.status_code}")
            return None