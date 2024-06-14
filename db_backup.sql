--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.1

-- Started on 2024-06-14 04:31:50

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 219 (class 1255 OID 16667)
-- Name: orders_delete(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.orders_delete(p_order_id character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
 delete from orders
 where order_id = p_order_id;
 return true;
 exception when others then
 return false;
end;
$$;


ALTER FUNCTION public.orders_delete(p_order_id character varying) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 16666)
-- Name: orders_insert(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.orders_insert(p_order_value character varying, p_sum_of_payment integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  declare p_new_order_number text:= 1 + count(*) from orders;
  declare p_loop_max_length int= 10 - length(p_new_order_number);
  declare p_new_number varchar(10) := '';
  declare p_order_date DATE := current_date;
  declare p_order_number text := '';
 begin 
  for i in 1..p_loop_max_length loop
   p_new_number := p_new_number||'0';
  end loop;
  p_order_number := concat('ЗКЗ/', substring(p_order_date::text,3,4),'/', p_new_number ,p_new_order_number);
  
  insert into orders(order_id, status_value, sum_of_payment, order_date)
  values(p_order_number, p_order_value, p_sum_of_payment, p_order_date);
  return true;
  exception when others then
  return false;
 end;
$$;


ALTER FUNCTION public.orders_insert(p_order_value character varying, p_sum_of_payment integer) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 16669)
-- Name: orders_update(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.orders_update(p_order_id character varying, p_order_status character varying, p_sum_of_payment integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
 declare meeting_count int := count(*) from orders where order_id = p_order_id;
begin
 if (meeting_count > 0 ) then
 update orders set
 order_status = p_order_status,
 sum_of_payment = p_sum_of_payment;
 return true;
 else
 return false;
 end if;
end;
$$;


ALTER FUNCTION public.orders_update(p_order_id character varying, p_order_status character varying, p_sum_of_payment integer) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16665)
-- Name: status_insert(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.status_insert(p_status_value character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
 declare meeting_count int := count(*) from status where status_value = p_status_value;
 begin
  if (meeting_count > 0) then
  return false;
  else
  insert into status(status_value)
  values(p_status_value);
  return true;
  end if;
 end;
$$;


ALTER FUNCTION public.status_insert(p_status_value character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 24666)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id_log integer NOT NULL,
    host_name character varying(15) NOT NULL,
    login character varying(15) NOT NULL,
    event_date date NOT NULL,
    request character varying(250) NOT NULL,
    status integer NOT NULL,
    response_size character varying(10) NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24665)
-- Name: logs_id_log_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_log_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_log_seq OWNER TO postgres;

--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 215
-- Name: logs_id_log_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_log_seq OWNED BY public.logs.id_log;


--
-- TOC entry 3207 (class 2604 OID 24669)
-- Name: logs id_log; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id_log SET DEFAULT nextval('public.logs_id_log_seq'::regclass);


--
-- TOC entry 3354 (class 0 OID 24666)
-- Dependencies: 216
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id_log, host_name, login, event_date, request, status, response_size) FROM stdin;
1	127.0.0.1	- -	2024-12-06	GET / HTTP/1.1	200	46
2	127.0.0.1	- -	2024-12-06	GET /favicon.ico HTTP/1.1	404	196
3	127.0.0.1	- -	2024-12-06	-	408	-
4	127.0.0.1	- -	2024-12-06	-	408	-
5	127.0.0.1	- -	2024-12-06	GET / HTTP/1.1	304	-
6	127.0.0.1	user1	2024-12-06	GET / HTTP/1.1	200	46
7	127.0.0.1	user2	2024-12-06	POST /login HTTP/1.1	401	22
8	127.0.0.1	user3	2024-12-06	GET /images/logo.png HTTP/1.1	200	30456
9	127.0.0.1	user4	2024-12-06	GET /about_us HTTP/1.1	404	15
10	127.0.0.1	user5	2024-12-06	PUT /update_profile HTTP/1.1	200	87
\.


--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 215
-- Name: logs_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_log_seq', 10, true);


--
-- TOC entry 3209 (class 2606 OID 24671)
-- Name: logs pk_log; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT pk_log PRIMARY KEY (id_log);


--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 219
-- Name: FUNCTION orders_delete(p_order_id character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.orders_delete(p_order_id character varying) TO orders_administrator;


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 224
-- Name: FUNCTION orders_insert(p_order_value character varying, p_sum_of_payment integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.orders_insert(p_order_value character varying, p_sum_of_payment integer) TO orders_administrator;


--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 218
-- Name: FUNCTION orders_update(p_order_id character varying, p_order_status character varying, p_sum_of_payment integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.orders_update(p_order_id character varying, p_order_status character varying, p_sum_of_payment integer) TO orders_administrator;


-- Completed on 2024-06-14 04:31:51

--
-- PostgreSQL database dump complete
--

