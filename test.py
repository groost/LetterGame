words = []
inp = []
with open('common_words.txt', 'r') as f:
    inp = f.readlines()

for word in inp:
    if len(word) > 3:
        words.append(word)

# print(words)
with open('common_words.txt', 'w') as f:
    f.writelines(words)