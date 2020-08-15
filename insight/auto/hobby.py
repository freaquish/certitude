import requests as req
import json


def make(code_name, name, weight, editors=['custom_editor'], limits={}):
    return {'code_name': code_name, 'name': name, 'weight': weight, 'editors': ",".join(editors), 'limits': limits}


def create_hobby():
    hobbies = [
        make('fashion1075', 'Fashion', 10.75),
        make('knitting1050', 'Knitting', 10.50),
        make('nail_art1025', 'Nail Art', 10.25),
        make('make_up1000', 'Makeup', 10.00),
        make('gardening950', 'Gardening', 9.50),
        make('cooking925', 'Cooking', 9.25),
        make('acting875', 'Acting', 8.75),
        make('dance850', 'Dance', 8.50),
        make('body_building825', 'Body Building', 8.25),
        make('sports800', 'Sports', 8.00),
        make('rapping750', 'Rapping', 7.50),
        make('singing725', 'Singing', 7.25),
        make('dj700', 'DJ', 7.00),
        make('video_graphy650', 'Videograhphy', 6.50),
        make('photography625', 'Photography', 6.25),
        make('calligraphy575', 'Calligraphy', 5.75),
        make('poetry550', 'Poetry', ['custom_editor', 'type_writer']),
    ]
    met_hobb = [['Thought', 5.25, 'a'], ['Quotes', 5.00, 'a'], ['Free Writing', 4.75, 'a'], ['Sketching', 4.25],
                ['Drawing', 4.00], ['Painting', 3.75], ['Astronomy', 3.25], ['Digital Art', 2.75],
                ['Graphics Design', 2.50],
                ['Animation', 2.25], ['Video Games', 1.75], ['Puzzles', 1.50], ['Computer', 1.25]
                ]
    for hob in met_hobb:
        code = hob[0].lower()
        code = code.replace(" ", "_")
        code = f'{code}{int(hob[1] * 100)}'
        editor = ['custome_editor']
        if len(hob) > 2:
            if hob[-1] == 't':
                editor = ['type_writer']
            elif hob[-1] == 'a':
                editor.append('type_writer')
        hobbies.append(make(code, hob[0], hob[1], editor))
    token = 'ca78671356db96a9e4101a92cc4ca4bb478ccd07'
    for hobby in hobbies:
        res = req.post('http://localhost:8080/api/v1/create_hobby', data=json.dumps(hobby),
                       headers={'Authorization': f'Token {token}'})
        print("====================================================\n")
        print(f'Hobby {hobby["name"]} is Done with {res}\n')


create_hobby()
