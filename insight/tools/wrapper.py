from django.db.models import Model, QuerySet
from typing import List, Dict, Any


class ModelWrapper:
    function_score: List[int]

    def __init__(self, model: Model, **kwargs):
        self.model: Model = model
        self.kwargs = kwargs
        # Create list of scores fuzz.ratio
        self.function_score = [value(self.execute_value(key)) for key, value in self.kwargs.items()]

    # Return value from each model working similar to F('va')
    def execute_value(self, key: str):
        vals = None
        if '__' in key:
            splitted = key.split('__')
            vals = self.model.__dict__[splitted[0]]
            for index in range(1, len(splitted)):
                vals = vals.__dict__[splitted[index]]
        else:
            vals = self.model.__dict__[key]
        return vals


class WrapperSet:
    def __init__(self, *querysets, **kwargs):
        self.querysets = querysets
        self.wrapperset = self.init(**kwargs)

    def init(self, **kwargs):
        wrapperset: List[ModelWrapper] = []
        for queryset in self.querysets:
            for model in queryset:
                wrapperset.append(ModelWrapper(model, **kwargs))
        return wrapperset

    def sort(self):
        return sorted(self.wrapperset, key=lambda wrapper: wrapper.function_score, reverse=True)

    def __len__(self):
        return len(self.queryset)

    def __bool__(self):
        return len(self.queryset) > 0

    def __iter__(self):
        self._index = 0
        self.model = self.queryset[self._index]

    def __next__(self):
        if self._index < len(self.queryset):
            result = self.queryset[self._index]
            self._index += 1
            return result
        raise StopIteration


