class DecodeError(Exception): pass
class ChunkError(Exception): pass

# Part 1 goes here!
class BitList:
    def __init__(self, s):
        for i in s:
            if i != '0' and i != '1':
                raise ValueError("Format is invalid; does not consist of only 0 and 1")
        self.bit = s

    def __str__(self):
        return self.bit

    def __eq__(self, other):
        if self.bit == other.bit:
            return True
        else:
            return False

    @staticmethod
    def from_ints(*args):
        bit = ''
        for i in args:
            if i != 0 and i != 1:
                raise ValueError("Format is invalid; does not consist of only 0 and 1")
            else:
                bit += str(i)
        return BitList(bit)

    def arithmetic_shift_left(self):
        new_bit = ''
        for i in range(1, len(self.bit)):
            new_bit += self.bit[i]
        new_bit += '0'
        self.bit = new_bit

    def arithmetic_shift_right(self):
        new_bit = self.bit[0]
        for i in range(0, len(self.bit)-1):
            new_bit += self.bit[i]
        self.bit = new_bit

    def bitwise_and(self, otherBitList):
        new_bit = ''
        for i in range(0, len(self.bit)):
            if int(self.bit[i]) * int(otherBitList.bit[i]) == 0:
                new_bit += '0'
            else:
                new_bit += '1'
        return BitList(new_bit)

    def chunk(self, chunk_length):
        list = []
        if len(self.bit) % chunk_length != 0:
            raise ChunkError("Length is invalid. Could not chunk the BitList into chunk of " + str(chunk_length) + " bits")
        else:
            num = len(self.bit) // chunk_length

            start_index = 0
            for i in range(0, num):
                sublist = []
                for i in range(0, chunk_length):
                    sublist.append(int(self.bit[start_index + i]))
                start_index += chunk_length
                list.append(sublist)
            return list
    
    def decode(self, encoding='utf-8'):
        result = ''
        if encoding == 'us-ascii':
            chunk_list = self.chunk(7)
            for i in chunk_list:
                chunk_str = ''
                for k in i:
                    chunk_str += str(k)
                chunk_dec = int(chunk_str, 2)
                result += chr(chunk_dec)
        
        elif encoding == 'utf-8':
            chunk_list = self.chunk(8)
            chunk_length = len(chunk_list)              # how many bits are there
            index = 0                                   # starting with index 0
            lead = 0                                    # record the next leading index
            end = 0                                     # record the next ending index
            chunk_str = ''                              # store the binary string from any bit
            while index < chunk_length:                 # iterate through the bits
                byte_list = chunk_list[index]           # the sub-list that contains a bit
                if index == lead:                       # when we find a leading bit
                    count = 0                           # count how many '1's are there
                    while byte_list[count] == 1:
                        count += 1
                        if count >= 5:                  # cannot have more than 4 bytes
                            raise DecodeError("Leading byte is invalid.")
                    if count == 0:                      # if the leading byte contains no '1's
                        lead += 1
                        for i in range(0, 8):                                   # record the binary string
                            chunk_str += str(byte_list[i])
                        chunk_dec = int(chunk_str, 2)
                        result += chr(chunk_dec)
                        chunk_str = ''
                        index += 1
                    elif count == 1:
                        raise DecodeError("Leading byte is invalid.")           # raise decode error if there's only one '1'
                    else:
                        lead += count                                           # set the next leading index
                        end = lead - 1                                          # set the next ending index
                        if lead > chunk_length:
                            raise DecodeError("Leading byte is invalid.")       # raise decode error if the next leading index exceeds the range
                        for i in range(count, 8):                               # record the binary string
                            chunk_str += str(byte_list[i])
                    index += 1
                else:
                    if byte_list[0] != 1 or byte_list[1] != 0:
                        raise DecodeError("Continuation byte is invalid.")      # if the continuation byte does not start with '10', raise decode error
                    else:
                        for i in range(2, 8):
                            chunk_str += str(byte_list[i])                      # record the binary string
                        if index == end:                                        # if we come to the ending byte, update the result
                            chunk_dec = int(chunk_str, 2)
                            result += chr(chunk_dec)
                            chunk_str = ''
                    index += 1

        else:
            raise ValueError("Encoding name is invalid. Must be us-ascii or utf-8")

        return result