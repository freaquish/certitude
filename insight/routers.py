class MongoDatabaseRouter:
    """
    Router Responsible for routing mongo db models to MongoDb and
    rest to PostgreSQL.
    The important use of Meta with required_db_vendor field
    class Meta:
       required_db_vendor = 'db_name'
    if required_db_vendor is None then the model will be directed to default database
    """
    database_labels = ['insight_story']
    supported_models = ['datalog', 'rankreport', 'hobbynearest']

    def db_for_read(self, model, **hints):
        """
        Attempts to read data of model from respective database
        """
        db = getattr(model._meta, 'required_db_vendor', None)
        if db is not None and db in self.database_labels:
            return db
        return None

    def db_for_write(self, model, **hints):
        """
        Attempts to write data of model from respective database
        """
        db = getattr(model._meta, 'required_db_vendor', None)
        if db is not None and db in self.database_labels:
            return db
        return None

    def allow_relations(self, obj1, obj2):
        if (obj1._meta.required_db_vendor in self.database_labels or obj2._meta.required_db_vendor in self.database_labels):
            return True
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if model_name in self.supported_models and db in self.database_labels:
            return True
        return None
