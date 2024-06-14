import tornado.ioloop
import tornado.web
from parse_funcs import parse_config # type: ignore
import db_usage_funcs as db # type: ignore

def API():
    class MainHandler(tornado.web.RequestHandler):
         def get(self):
            self.write(db.query_with_response(db.build_query(
                self.get_argument('start_date', None), 
                self.get_argument('end_date', None), 
                self.get_argument('host_name', None), 
                self.get_argument('status', None),
                '*'
            )))

    application = tornado.web.Application([
        (r"/search", MainHandler)
    ])

    application.listen(parse_config('port'))#do in config
    tornado.ioloop.IOLoop.instance().start()