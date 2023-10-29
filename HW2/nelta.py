"""
Add LabeledList and Table classes
"""
import csv

class LabeledList:
    def __init__(self, data=None, index=None):
        self.values = data
        if index == None:
            index = list(range(len(data)))
        self.index = index

    def __repr__(self):
        return str(self)
    
    def __str__(self):
        max_len = 0
        value_list = []
        ret = ""
        for i in self.values:
            if i == True and type(i) == bool:
                value_list.append("True")
            elif i == False and type(i) == bool:
                value_list.append("False")
            else:
                value_list.append(str(i))

        for i in self.index:
            if len(str(i)) > max_len:
                max_len = len(str(i))
        
        format_spec = f'>{max_len}'

        for i in range(len(self.index)):
            ret += f'{str(self.index[i]):{format_spec}}'
            ret += " "
            ret += str(value_list[i])
            ret += "\n"
        
        return ret
    
    def __getitem__(self, key_list):
        if isinstance(key_list, LabeledList):
            key_list = key_list.values

        if isinstance(key_list, list):
            ret_index = []
            ret_data = []
            for i in range(len(key_list)):
                if isinstance(key_list[i], bool):
                    if key_list[i] == True:
                        ret_index.append(self.index[i])
                        ret_data.append(self.values[i])
                else:
                    for k in range(len(self.index)):
                        if self.index[k] == key_list[i]:
                            ret_index.append(key_list[i])
                            ret_data.append(self.values[k])
                    
            return LabeledList(ret_data, ret_index)
        else:
            ret_index = []
            ret_data = [] 
            for i in range(len(self.index)):
                if self.index[i] == key_list:
                    ret_index.append(key_list)
                    ret_data.append(self.values[i])
            if len(ret_index) == 1:
                return ret_data[0]
            else:
                return LabeledList(ret_data, ret_index)
        
    def __iter__(self):
        return iter(self.values)
    
    def __eq__(self, scalar):
        ret_data = [i == scalar if i is not None else False for i in self.values]
        return LabeledList(ret_data, self.index)
    
    def __nq__(self, scalar):
        ret_data = [i != scalar if i is not None else False for i in self.values]
        return LabeledList(ret_data, self.index)     

    def __gt__(self, scalar):
        ret_data = [i > scalar if i is not None else False for i in self.values]
        return LabeledList(ret_data, self.index) 

    def __lt__(self, scalar):
        ret_data = [i < scalar if i is not None else False for i in self.values]
        return LabeledList(ret_data, self.index) 

    def map(self, f):
        ret_data = [f(i) for i in self.values]
        return LabeledList(ret_data, self.index)

class Table:
    def __init__(self, data, index=None, columns=None):
        if index == None:
            index = list(range(len(data)))
        if columns == None:
            columns = list(range(len(data[0])))
        self.values = data
        self.index = index
        self.columns = columns
    
    def __str__(self):
        rec = ''
        length = []                             # store the longest length of each column

        max_index = 0                           # find the longest index
        for i in self.index:
            if len(str(i)) > max_index:
                max_index = len(str(i))
        length.append(max_index)

        for i in range(len(self.columns)):      # find the longest element for each column
            max_length = len(str(self.columns[i]))
            for k in range(len(self.index)):
                if len(str(self.values[k][i])) > max_length:
                    max_length = len(str(self.values[k][i]))
            length.append(max_length)
        
        title = ' ' * (length[0] + 3)           # add the title
        for i in range(len(self.columns)):
            format_spec = f'>{length[i+1]}'
            title += f'{str(self.columns[i]):{format_spec}}'
            title += ' ' * 3
        rec += title
        rec += '\n'

        for i in range(len(self.index)):        # add each line
            line = ''
            format_spec = f'>{length[0]}'
            line += f'{str(self.index[i]):{format_spec}}'
            line += ' ' * 3
            for k in range(len(self.columns)):
                format_spec = f'>{length[k+1]}'
                line += f'{str(self.values[i][k]):{format_spec}}'
                line += ' ' * 3
            rec += line
            rec += '\n'
        
        return rec
    
    def __repr__(self):
        return str(self)
    
    def __getitem__(self, col_list):
        if isinstance(col_list, LabeledList):
            col_list = col_list.values
        
        if isinstance(col_list, list):
            data = []
            if all((isinstance(i, bool) for i in col_list)):
                new_index = []
                for k in range(len(col_list)):
                    if col_list[k] == True:
                        data.append(self.values[k])
                        new_index.append(self.index[k])
                return Table(data, new_index, self.columns)
            else:
                for i in range(len(self.index)):
                    line = []
                    for k in range(len(self.columns)):
                        for j in col_list:
                                if j == self.columns[k]:
                                    line.append(self.values[i][k])
                    data.append(line)
                return Table(data, self.index, col_list)
        
        else:
            single_index = []
            for i in range(len(self.columns)):
                if self.columns[i] == col_list:
                    single_index.append(i)

            data = []
            if len(single_index) == 1:
                for i in range(len(self.index)):
                    data.append(self.values[i][single_index[0]])
                return LabeledList(data, self.index)
            else:
                for i in range(len(self.index)):
                    line = []
                    for k in range(len(single_index)):
                        line.append(self.values[i][single_index[k]])
                    data.append(line)
                return Table(data, self.index, col_list * len(self.index))
        
    def head(self, n):
        data = self.values[:n]
        new_index = self.index[:n]
        return Table(data, new_index, self.columns)
    
    def tail(self, n):
        data = self.values[-n:]
        new_index = self.index[-n:]
        return Table(data, new_index, self.columns)

    def shape(self):
        col = len(self.columns)
        row = len(self.index)
        return (row, col)

def read_csv(fn):
    with open(fn, "r") as f:
        data = csv.reader(f, delimiter = ',') 
        new_data = []
        for i in data:
            line = []
            for k in i:
                try:
                    line.append(float(k))
                except ValueError:
                    line.append(k)
            new_data.append(line)
        col = new_data[0]
        return Table(new_data[1:], columns = col)

# d = [[1000, 10], [200, 2], [3, 300], [40, 4000], [7, 8]]
# t = Table(d, ['foo', 'bar', 'bazzy', 'qux', 'quxx'], ['a', 'b', 'c', 'd', 'e'])
# print(t[LabeledList(['a', 'b'])])

# t = Table([[15, 17, 19], [14, 16, 18]], columns=['x', 'y', 'z'])
# print(t[['x', 'x', 'y']])

# t = Table([[1, 2, 3], [4, 5, 6], [7, 8 , 9]], columns=['x', 'y', 'z'])
# print(t[[True, False, True]])

# t = Table([[1, 2, 3], [4, 5, 6]], columns=['a', 'b', 'a'])
# print(t['b'])

# t = Table([[1, 2, 3], [4, 5, 6]], columns=['a', 'b', 'a'])
# print(t['a'])

# t = Table([[1, 2], [3, 4], [5, 6], [7, 8]], columns=['x', 'y'])
# print(t.head(2))
# print(t.tail(2))

# t = Table([[1, 2], [3, 4], [5, 6], [7, 8]], columns=['x', 'y'])
# print(t.shape())

# print(read_csv('fruitarians.csv'))