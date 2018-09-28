# Using python 2.7.15

import os
import sys
import time

path = os.path.dirname(os.path.abspath(sys.argv[0]))
current_milli_time = lambda: int(round(time.time() * 1000))

def addColor(line, color):
    string_to_be_replace = r"environment\" = 'stage' AND color = '" + color + r"' AND \"api\" = 'dummy-api-v1'"

    string_to_be_identified = r"environment\" = 'stage' AND \"api\" = 'dummy-api-v1'"
    string_to_be_identified1 = r"environment\" = 'stage' AND  \"api\" = 'dummy-api-v1'"
    string_to_be_identified2 = r"environment\" = 'stage' AND  \"api\" = 'dummy-api-v1'"
    string_to_be_identified3 = r"environment\" = 'stage'  AND  \"api\" = 'dummy-api-v1'"
    string_to_be_identified4 = r"environment\" = 'stage'  AND \"api\" = 'dummy-api-v1'"
    string_to_be_identified5 = r"environment\" = 'stage'   AND \"api\" = 'dummy-api-v1'"

    str_repl = line.replace(string_to_be_identified, string_to_be_replace) \
        .replace(string_to_be_identified1, string_to_be_replace) \
        .replace(string_to_be_identified2, string_to_be_replace) \
        .replace(string_to_be_identified3, string_to_be_replace) \
        .replace(string_to_be_identified4, string_to_be_replace) \
        .replace(string_to_be_identified5, string_to_be_replace)
    return str_repl


def removeColor(line, color):
    replace_color_string = r"environment\" = 'stage' AND \"api\" = 'dummy-api-v1'"

    remove_color_string = r"environment\" = 'stage' AND \"color\" = '" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string1 = r"environment\" = 'stage' AND color = '" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string2 = r"environment\" = 'stage' AND color='" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string3 = r"environment\" = 'stage' AND \"color\"='" + color + r"' AND \"api\" = 'dummy-api-v1'"

    str_repl = line.replace(remove_color_string, replace_color_string) \
        .replace(remove_color_string1, replace_color_string) \
        .replace(remove_color_string2, replace_color_string)\
        .replace(remove_color_string3, replace_color_string)
    print line == str_repl
    return str_repl

def updateColor(line, color, update_color):
    string_to_be_replace = r"environment\" = 'stage' AND color = '" + update_color + r"' AND \"api\" = 'dummy-api-v1'"

    remove_color_string = r"environment\" = 'stage' AND \"color\" = '" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string1 = r"environment\" = 'stage' AND color = '" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string2 = r"environment\" = 'stage' AND color='" + color + r"' AND \"api\" = 'dummy-api-v1'"
    remove_color_string3 = r"environment\" = 'stage' AND \"color\"='" + color + r"' AND \"api\" = 'dummy-api-v1'"

    str_repl = line.replace(remove_color_string, string_to_be_replace) \
        .replace(remove_color_string1, string_to_be_replace)\
        .replace(remove_color_string2, string_to_be_replace)\
        .replace(remove_color_string3, string_to_be_replace)
    return str_repl


# ---------------------------------------------------------
#Config
# Usage: add existing json to alerts.json file and new json will be alerts-new.json
do_you_want_to_remove_color = False
do_you_want_to_update_color = False
add_color = search_color = 'red'
update_color = 'black'

line_num = 0

# ---------------------------------------------------------
print "replaced text at lines :"

start = current_milli_time()
with open(path + '/alerts.json', 'r') as file:
    for line in file:
        line_num += 1
        with open(path + '/alerts-new.json', 'a+') as newfile:
            if(do_you_want_to_remove_color and (not do_you_want_to_update_color)):
                str_repl = removeColor(line, search_color)
            elif(do_you_want_to_update_color and (not do_you_want_to_remove_color)):
                str_repl = updateColor(line, search_color, update_color)
            else:
                str_repl = addColor(line, add_color)
            if(not line.__eq__(str_repl)):
                print line_num
            newfile.write(str_repl)
            newfile.flush()
        newfile.close()
file.close()

end = current_milli_time()
total_time = (end-start) / 1000
print "total time:", total_time, "seconds"
