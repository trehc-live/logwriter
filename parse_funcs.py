import db_usage_funcs as db # type: ignore
import re
from datetime import datetime

def date_reformat(date, from_format, to_format):
    date_obj = datetime.strptime(date, from_format)
    return date_obj.strftime(to_format)

def parse_config(asd):
    pattern = f'{asd} = '
    with open('config.txt') as f:
        lenght=len(f.readlines())
        f.seek(0)
        lines = f.readlines()
        for l in range(lenght):
            if re.match(pattern, lines[l]):
                return re.split(pattern,lines[l])[1].replace('\n', '')

def init_params(args):
    params = {'start_date': None, 'till_date': None, 'ip': None, 'status': None}
    
    for i in range(len(args)):
        print(args[i])
        if re.match('\d{2}.\d{2}.\d{4}', args[i], flags=0):
            if params['start_date'] != None: 
                params['till_date'] = args[i]
            if params['till_date'] != None: continue
            else: 
                params['start_date'] = args[i]
            continue
        if args[i] == 'ip':
            params['ip'] = 'host_name'
            continue
        if args[i] == 'status':
            params['status'] = args[i]
    return params

def parse_file(file_name):
    pattern= '([(\d\.)]+) (.*?) \[(.*?)\] \"(.*?)\" (\d+) (-|\d*)(\s)?'
    logs_data = []
    with open(file_name) as f:
        lines = f.readlines()
        for line in (range(len(lines))):
            if re.match(pattern, lines[line]):
                log_data = re.split(pattern, lines[line])[1:-2]
                log_data[2] = date_reformat(log_data[2][0:11], "%d/%b/%Y", "%d.%m.%Y")
                logs_data.append(log_data)
    return logs_data