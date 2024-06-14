import sys
import db_usage_funcs as db # type: ignore
import API_funcs as API # type: ignore
import parse_funcs as pf # type: ignore
from time import sleep

def validate_args(args) -> bool:
    if(len(sys.argv) == 1):
        print('no arguments given error')
        return False
    return True

def get_wts(params):
    columns = []
    if(params['ip'] != None):
        columns.append(params['ip'])

    if(params['status'] != None):
        columns.append(params['status'])

    if(len(columns) > 0):
        if(len(columns) > 1):
            columns = columns[0] + ', ' + columns[1]
        else:
            columns = columns[0]
    else:
        columns = '*'
    return columns


if __name__ == "__main__":
    if(validate_args(sys.argv)):
        if(sys.argv[1] == 'parse'):
            print('значения перезаписываются автоматически каждые 3 секунды')
            while True:
                db.clear_table()
                logs_data = pf.parse_file(pf.parse_config('files_dir') + '.' + pf.parse_config('ext'))
                for log in logs_data:
                    for i in range(len(log)):
                        log[i] = '\'' + log[i] + '\''
                    log = ', '.join(map(str, log))
                    db.query(f'insert into logs(host_name,login,event_date,request,status,response_size) values ({log})')
                    print(f'зачисленное значение - {log}', end='\r')
                    sleep(0.5)
                sleep(3)

        elif(sys.argv[1] == 'api'):
            print('API started')
            API.API()
            exit
        
        else:
            print('selecting from database')
            params = pf.init_params(sys.argv)

            columns = get_wts(params)
            
            print('Полученный ответ - ' + db.query_with_response(db.build_query(params['start_date'], params['till_date'], None, None, columns)))
            exit

    print('the end! fellas')
