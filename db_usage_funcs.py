import psycopg2
import parse_funcs as pf # type: ignore

conn = psycopg2.connect(pf.parse_config('db conection string'))
conn.autocommit = True
cursor = conn.cursor()


def build_query(start_date, end_date, host_name, status, wts) -> str:
    str = f'select {wts} from logs'
    query = []
    if start_date != None:
        start_date = pf.date_reformat(start_date, "%d.%m.%Y", "%Y-%m-%d")
        query.append(f'(event_date >= \'{start_date}\')')

    if end_date != None:
        end_date = pf.date_reformat(end_date, "%d.%m.%Y", "%Y-%m-%d")
        query.append(f'(event_date <= \'{end_date}\')')
    else:
        end_date = start_date
        query.append(f'(event_date <= \'{end_date}\')')

    if host_name != None:
        query.append(f'(host_name = \'{host_name}\')')
    
    if status != None:
        query.append(f'(status = {status});')

    query_str = ' and '.join(query)
    if len(query_str) != 0:
        str += ' where ' + query_str
    print('Сформированный запрос - ' + str)
    return str

def query(query_str):
    cursor.execute(query_str)

def query_with_response(query_str):
    cursor.execute(query_str)
    return str(cursor.fetchall())

def clear_table():
    cursor.execute('delete from logs; ALTER SEQUENCE logs_id_log_seq RESTART WITH 1;')