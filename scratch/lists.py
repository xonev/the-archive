class List:
    def __init__(self, list=None):
        self.list = [] if not list else list

    def add(self, item):
        self.list.append(item)

    def add_all(self, items):
        for item in items:
            self.add(item)


class CounterList(List):
    def __init__(self, list=None):
        super().__init__(list)
        self.count = 0

    def add(self, item):
        super().add(item)
        self.count += 1

    def add_all(self, items):
        super().add_all(items)
        self.count += len(items)


if __name__ == '__main__':
    list = CounterList([])
    list.add(1)
    list.add_all([1, 2, 3])

    print(f'The list: {list.list}')
    print(f"I've now added 4 items to the list, so the count should be 4 if this CounterList were correct.")
    print(f"count is actually: {list.count}")
