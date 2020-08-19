import requests as req
import json

def make(name, weight, *editors):
    edit = list(editors)
    if len(editors) == 1 and editors[0] == 'all':
        edit = ['custom_editor','type_writer']
    elif len(editors) == 0:
        edit = ['custom_editor']
    return {"name":name, "weight": weight, "code_name": f'{name.lower().replace(" ","")}{int(weight*100)}', "editors": edit}

def create_hobby():
    hobbies = [['Fashion',10.75,'all'],['Knitting',10.50],['Nail Art',10.25],['Makeup',10.0],['Gardening',9.50],
               ['Cooking',9.25,'all'],['Acting',8.75,'all'],['Dance',8.50],['Body Building',8.25,'all'],['Sports',8.0,'all'],
               ['Rapping', 7.50, 'all'], ['Singing', 7.25, 'all'],['DJ', 7.00],['Videography',6.50],['Photography',6.25,'all'],
               ['Calligraphy',5.75],['Poetry',5.50,'all'],['Thoughts',5.25,'type_writer'],['Quotes',5.00,'type_writer'],['Story',4.75,'type_writer'],
               ['Sketching',4.25,'all'],['Drawing',4.0],['Painting',3.75],['Astronomy',3.25,'all'],['Digital Arts',2.75],['Graphics Design',2.50],
               ['Animation',2.25],['Electronic Games',1.75],['Puzzles',1.50,'all'],['Computer',1.25,'all']
               ]
    for hobby in hobbies:
        mde = make(hobby[0],hobby[1],hobby[2] if len(hobby) == 3 else 'custom_editor')
        post_hobby(mde)


def post_hobby(hobby):
    token = '1265aad3e2b424700d14bcd65f9421b29ce255ea'
    js = json.dumps(hobby)
    print(hobby,js)
    res = req.post('https://condom.freaquish.com/api/v1/create_hobby', data=js,
                   headers={'Authorization': f'Token {token}'})
    print("====================================================\n")
    print(f'Hobby {hobby["name"]} is Done with {res}\n')


create_hobby()
