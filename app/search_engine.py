from elasticsearch import Elasticsearch


class SearchEngine():

    def __init__(self, config) -> None:
        url = config['URL'] if config['URL'] else None
        try:
            self.search_engine = Elasticsearch([url])
        except Exception as err:
            print(f'Ooops! Search engine error: {err}')

    def is_connected(self):
        return self.search_engine.ping()

    def index(self, index, id, body):
        if self.is_connected():
            self.search_engine.index(index=index, id=id, body=body)

    def delete(self, index, id):
        if self.is_connected():
            self.search_engine.delete(index=index, id=id)

    def delete_index(self, index):
        if self.is_connected():
            self.search_engine.indices.delete(index=index)

    def search(self, index, body):
        if self.is_connected():
            return self.search_engine.search(index=index, body=body)
        else:
            return None
