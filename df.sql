--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

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
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: get_action_count(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_action_count(post_id character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
   actions integer;
begin
  select count(*)
  into actions
  from insight_action_store
  where post_id == post_id;
  
  return actions;
end;
$$;


ALTER FUNCTION public.get_action_count(post_id character) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id character varying(20) NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO postgres;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id character varying(20) NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: insight_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_account (
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    account_id character varying(20) NOT NULL,
    id_type character varying(6) NOT NULL,
    joined_at date NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL,
    is_active boolean NOT NULL,
    details jsonb NOT NULL,
    comfort_zones_text character varying(70)[] NOT NULL,
    activity_coords jsonb NOT NULL,
    avatar text NOT NULL,
    places text[] NOT NULL,
    hobby_map jsonb NOT NULL,
    primary_hobby character varying(20) NOT NULL,
    primary_weight numeric(4,2) NOT NULL,
    follower_count integer NOT NULL,
    following_count integer NOT NULL,
    description text NOT NULL,
    following character varying(30)[] NOT NULL,
    current_coord public.geometry(Point,4326) NOT NULL,
    new_notification boolean NOT NULL,
    country_code character varying(4) NOT NULL
);


ALTER TABLE public.insight_account OWNER TO postgres;

--
-- Name: insight_account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_account_groups (
    id integer NOT NULL,
    account_id character varying(20) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.insight_account_groups OWNER TO postgres;

--
-- Name: insight_account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_account_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_account_groups_id_seq OWNER TO postgres;

--
-- Name: insight_account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_account_groups_id_seq OWNED BY public.insight_account_groups.id;


--
-- Name: insight_account_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_account_user_permissions (
    id integer NOT NULL,
    account_id character varying(20) NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.insight_account_user_permissions OWNER TO postgres;

--
-- Name: insight_account_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_account_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_account_user_permissions_id_seq OWNER TO postgres;

--
-- Name: insight_account_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_account_user_permissions_id_seq OWNED BY public.insight_account_user_permissions.id;


--
-- Name: insight_hobby; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_hobby (
    code_name character varying(30) NOT NULL,
    name character varying(40) NOT NULL,
    editors character varying(30)[] NOT NULL,
    limits jsonb NOT NULL,
    weight numeric(5,3) NOT NULL
);


ALTER TABLE public.insight_hobby OWNER TO postgres;

--
-- Name: insight_hobbyreport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_hobbyreport (
    id integer NOT NULL,
    views integer NOT NULL,
    loves integer NOT NULL,
    shares integer NOT NULL,
    comments integer NOT NULL,
    communities_involved integer NOT NULL,
    competition_participated integer NOT NULL,
    competition_hosted integer NOT NULL,
    account_id character varying(20) NOT NULL,
    hobby_id character varying(30) NOT NULL,
    posts integer NOT NULL
);


ALTER TABLE public.insight_hobbyreport OWNER TO postgres;

--
-- Name: insight_hobbyreport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_hobbyreport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_hobbyreport_id_seq OWNER TO postgres;

--
-- Name: insight_hobbyreport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_hobbyreport_id_seq OWNED BY public.insight_hobbyreport.id;


--
-- Name: insight_places; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_places (
    id integer NOT NULL,
    place_name text NOT NULL,
    city text NOT NULL,
    coordinates public.geometry(Point,4326) NOT NULL
);


ALTER TABLE public.insight_places OWNER TO postgres;

--
-- Name: insight_places_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_places_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_places_id_seq OWNER TO postgres;

--
-- Name: insight_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_places_id_seq OWNED BY public.insight_places.id;


--
-- Name: insight_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post (
    post_id character varying(22) NOT NULL,
    assets jsonb NOT NULL,
    caption text NOT NULL,
    hastags character varying(20)[] NOT NULL,
    atags character varying(20)[] NOT NULL,
    coordinates public.geometry(Point,4326),
    action_count jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    rank integer NOT NULL,
    score numeric(7,4) NOT NULL,
    is_global boolean NOT NULL,
    account_id character varying(20) NOT NULL,
    hobby_id character varying(30) NOT NULL,
    freshness_score numeric(7,4) NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    net_score numeric(7,4) NOT NULL
);


ALTER TABLE public.insight_post OWNER TO postgres;

--
-- Name: insight_post_a_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_a_tags (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    tags_id text NOT NULL
);


ALTER TABLE public.insight_post_a_tags OWNER TO postgres;

--
-- Name: insight_post_a_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_a_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_a_tags_id_seq OWNER TO postgres;

--
-- Name: insight_post_a_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_a_tags_id_seq OWNED BY public.insight_post_a_tags.id;


--
-- Name: insight_post_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_comments (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    userpostcomment_id integer NOT NULL
);


ALTER TABLE public.insight_post_comments OWNER TO postgres;

--
-- Name: insight_post_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_comments_id_seq OWNER TO postgres;

--
-- Name: insight_post_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_comments_id_seq OWNED BY public.insight_post_comments.id;


--
-- Name: insight_post_down_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_down_votes (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_post_down_votes OWNER TO postgres;

--
-- Name: insight_post_down_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_down_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_down_votes_id_seq OWNER TO postgres;

--
-- Name: insight_post_down_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_down_votes_id_seq OWNED BY public.insight_post_down_votes.id;


--
-- Name: insight_post_hash_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_hash_tags (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    tags_id text NOT NULL
);


ALTER TABLE public.insight_post_hash_tags OWNER TO postgres;

--
-- Name: insight_post_hash_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_hash_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_hash_tags_id_seq OWNER TO postgres;

--
-- Name: insight_post_hash_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_hash_tags_id_seq OWNED BY public.insight_post_hash_tags.id;


--
-- Name: insight_post_loves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_loves (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_post_loves OWNER TO postgres;

--
-- Name: insight_post_loves_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_loves_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_loves_id_seq OWNER TO postgres;

--
-- Name: insight_post_loves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_loves_id_seq OWNED BY public.insight_post_loves.id;


--
-- Name: insight_post_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_shares (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_post_shares OWNER TO postgres;

--
-- Name: insight_post_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_shares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_shares_id_seq OWNER TO postgres;

--
-- Name: insight_post_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_shares_id_seq OWNED BY public.insight_post_shares.id;


--
-- Name: insight_post_up_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_up_votes (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_post_up_votes OWNER TO postgres;

--
-- Name: insight_post_up_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_up_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_up_votes_id_seq OWNER TO postgres;

--
-- Name: insight_post_up_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_up_votes_id_seq OWNED BY public.insight_post_up_votes.id;


--
-- Name: insight_post_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_post_views (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_post_views OWNER TO postgres;

--
-- Name: insight_post_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_post_views_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_post_views_id_seq OWNER TO postgres;

--
-- Name: insight_post_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_post_views_id_seq OWNED BY public.insight_post_views.id;


--
-- Name: insight_scoreboard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_scoreboard (
    id integer NOT NULL,
    created_at date NOT NULL,
    expires_on date NOT NULL,
    retention numeric(9,5) NOT NULL,
    account_id character varying(20) NOT NULL,
    original_creation timestamp with time zone NOT NULL,
    down_votes integer NOT NULL,
    loves integer NOT NULL,
    shares integer NOT NULL,
    up_votes integer NOT NULL,
    views integer NOT NULL
);


ALTER TABLE public.insight_scoreboard OWNER TO postgres;

--
-- Name: insight_scoreboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_scoreboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_scoreboard_id_seq OWNER TO postgres;

--
-- Name: insight_scoreboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_scoreboard_id_seq OWNED BY public.insight_scoreboard.id;


--
-- Name: insight_scoreboard_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_scoreboard_posts (
    id integer NOT NULL,
    scoreboard_id integer NOT NULL,
    post_id character varying(22) NOT NULL
);


ALTER TABLE public.insight_scoreboard_posts OWNER TO postgres;

--
-- Name: insight_scoreboard_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_scoreboard_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_scoreboard_posts_id_seq OWNER TO postgres;

--
-- Name: insight_scoreboard_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_scoreboard_posts_id_seq OWNED BY public.insight_scoreboard_posts.id;


--
-- Name: insight_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_tags (
    tag text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    first_used character varying(22) NOT NULL,
    tag_type character varying(10) NOT NULL
);


ALTER TABLE public.insight_tags OWNER TO postgres;

--
-- Name: insight_userpostcomment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_userpostcomment (
    id integer NOT NULL,
    post_id character varying(22) NOT NULL,
    comment text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    count integer NOT NULL,
    account_id character varying(20) NOT NULL
);


ALTER TABLE public.insight_userpostcomment OWNER TO postgres;

--
-- Name: insight_userpostcomment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_userpostcomment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_userpostcomment_id_seq OWNER TO postgres;

--
-- Name: insight_userpostcomment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_userpostcomment_id_seq OWNED BY public.insight_userpostcomment.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: insight_account_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_groups ALTER COLUMN id SET DEFAULT nextval('public.insight_account_groups_id_seq'::regclass);


--
-- Name: insight_account_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.insight_account_user_permissions_id_seq'::regclass);


--
-- Name: insight_hobbyreport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_hobbyreport ALTER COLUMN id SET DEFAULT nextval('public.insight_hobbyreport_id_seq'::regclass);


--
-- Name: insight_places id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_places ALTER COLUMN id SET DEFAULT nextval('public.insight_places_id_seq'::regclass);


--
-- Name: insight_post_a_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_a_tags ALTER COLUMN id SET DEFAULT nextval('public.insight_post_a_tags_id_seq'::regclass);


--
-- Name: insight_post_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_comments ALTER COLUMN id SET DEFAULT nextval('public.insight_post_comments_id_seq'::regclass);


--
-- Name: insight_post_down_votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_down_votes ALTER COLUMN id SET DEFAULT nextval('public.insight_post_down_votes_id_seq'::regclass);


--
-- Name: insight_post_hash_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_hash_tags ALTER COLUMN id SET DEFAULT nextval('public.insight_post_hash_tags_id_seq'::regclass);


--
-- Name: insight_post_loves id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_loves ALTER COLUMN id SET DEFAULT nextval('public.insight_post_loves_id_seq'::regclass);


--
-- Name: insight_post_shares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_shares ALTER COLUMN id SET DEFAULT nextval('public.insight_post_shares_id_seq'::regclass);


--
-- Name: insight_post_up_votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_up_votes ALTER COLUMN id SET DEFAULT nextval('public.insight_post_up_votes_id_seq'::regclass);


--
-- Name: insight_post_views id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_views ALTER COLUMN id SET DEFAULT nextval('public.insight_post_views_id_seq'::regclass);


--
-- Name: insight_scoreboard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard ALTER COLUMN id SET DEFAULT nextval('public.insight_scoreboard_id_seq'::regclass);


--
-- Name: insight_scoreboard_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard_posts ALTER COLUMN id SET DEFAULT nextval('public.insight_scoreboard_posts_id_seq'::regclass);


--
-- Name: insight_userpostcomment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_userpostcomment ALTER COLUMN id SET DEFAULT nextval('public.insight_userpostcomment_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add Token	6	add_token
22	Can change Token	6	change_token
23	Can delete Token	6	delete_token
24	Can view Token	6	view_token
25	Can add account	7	add_account
26	Can change account	7	change_account
27	Can delete account	7	delete_account
28	Can view account	7	view_account
29	Can add action store	8	add_actionstore
30	Can change action store	8	change_actionstore
31	Can delete action store	8	delete_actionstore
32	Can view action store	8	view_actionstore
33	Can add community	9	add_community
34	Can change community	9	change_community
35	Can delete community	9	delete_community
36	Can view community	9	view_community
37	Can add competition	10	add_competition
38	Can change competition	10	change_competition
39	Can delete competition	10	delete_competition
40	Can view competition	10	view_competition
41	Can add hobby	11	add_hobby
42	Can change hobby	11	change_hobby
43	Can delete hobby	11	delete_hobby
44	Can view hobby	11	view_hobby
45	Can add leaderboard	12	add_leaderboard
46	Can change leaderboard	12	change_leaderboard
47	Can delete leaderboard	12	delete_leaderboard
48	Can view leaderboard	12	view_leaderboard
49	Can add places	13	add_places
50	Can change places	13	change_places
51	Can delete places	13	delete_places
52	Can view places	13	view_places
53	Can add post	14	add_post
54	Can change post	14	change_post
55	Can delete post	14	delete_post
56	Can view post	14	view_post
57	Can add tags	15	add_tags
58	Can change tags	15	change_tags
59	Can delete tags	15	delete_tags
60	Can view tags	15	view_tags
61	Can add user post comment	16	add_userpostcomment
62	Can change user post comment	16	change_userpostcomment
63	Can delete user post comment	16	delete_userpostcomment
64	Can view user post comment	16	view_userpostcomment
65	Can add team member	17	add_teammember
66	Can change team member	17	change_teammember
67	Can delete team member	17	delete_teammember
68	Can view team member	17	view_teammember
69	Can add score post	18	add_scorepost
70	Can change score post	18	change_scorepost
71	Can delete score post	18	delete_scorepost
72	Can view score post	18	view_scorepost
73	Can add scoreboard	19	add_scoreboard
74	Can change scoreboard	19	change_scoreboard
75	Can delete scoreboard	19	delete_scoreboard
76	Can view scoreboard	19	view_scoreboard
77	Can add rank badge	20	add_rankbadge
78	Can change rank badge	20	change_rankbadge
79	Can delete rank badge	20	delete_rankbadge
80	Can view rank badge	20	view_rankbadge
81	Can add notification	21	add_notification
82	Can change notification	21	change_notification
83	Can delete notification	21	delete_notification
84	Can view notification	21	view_notification
85	Can add competition post	22	add_competitionpost
86	Can change competition post	22	change_competitionpost
87	Can delete competition post	22	delete_competitionpost
88	Can view competition post	22	view_competitionpost
89	Can add community post	23	add_communitypost
90	Can change community post	23	change_communitypost
91	Can delete community post	23	delete_communitypost
92	Can view community post	23	view_communitypost
93	Can add community member	24	add_communitymember
94	Can change community member	24	change_communitymember
95	Can delete community member	24	delete_communitymember
96	Can view community member	24	view_communitymember
97	Can add hobby report	25	add_hobbyreport
98	Can change hobby report	25	change_hobbyreport
99	Can delete hobby report	25	delete_hobbyreport
100	Can view hobby report	25	view_hobbyreport
101	Can add data log	26	add_datalog
102	Can change data log	26	change_datalog
103	Can delete data log	26	delete_datalog
104	Can view data log	26	view_datalog
105	Can add hobby nearest	27	add_hobbynearest
106	Can change hobby nearest	27	change_hobbynearest
107	Can delete hobby nearest	27	delete_hobbynearest
108	Can view hobby nearest	27	view_hobbynearest
109	Can add rank report	28	add_rankreport
110	Can change rank report	28	change_rankreport
111	Can delete rank report	28	delete_rankreport
112	Can view rank report	28	view_rankreport
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
fef42fb625eba8ce65b71ac6c0752653c181d365	2020-11-25 21:30:20.924852+05:30	7081878499
bf18d59607190c13135dbbc11f04130491a650a1	2020-11-26 17:28:39.173892+05:30	6392885645
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
31	2020-08-17 01:06:22.723+05:30	rTSapdddQbdssbBgtu6RTg	Post object (rTSapdddQbdssbBgtu6RTg)	3		10	iampiyush
32	2020-08-17 01:06:22.929+05:30	bhymR0gjG0QuOZTgE30QTA	Post object (bhymR0gjG0QuOZTgE30QTA)	3		10	iampiyush
33	2020-08-17 01:50:21.58+05:30	wTedYyAacGrsCgdo7QPkMQ	Post object (wTedYyAacGrsCgdo7QPkMQ)	3		10	iampiyush
34	2020-08-17 01:50:21.621+05:30	WPmRaZevOfE8oEmzvipUqw	Post object (WPmRaZevOfE8oEmzvipUqw)	3		10	iampiyush
35	2020-08-17 01:50:21.632+05:30	8QFrwk4ZmKfIWKxr3qWdTA	Post object (8QFrwk4ZmKfIWKxr3qWdTA)	3		10	iampiyush
36	2020-08-17 02:14:58.362+05:30	xkV86zQXHT7Hyned1j31Xg	Post object (xkV86zQXHT7Hyned1j31Xg)	3		10	iampiyush
37	2020-08-17 02:14:58.386+05:30	vY2paGDPXrPzqxtTH0z6dw	Post object (vY2paGDPXrPzqxtTH0z6dw)	3		10	iampiyush
38	2020-08-17 02:18:12.37+05:30	vUiqMNgw5t31eBrrs6HcAA	Post object (vUiqMNgw5t31eBrrs6HcAA)	3		10	iampiyush
39	2020-08-17 02:18:12.392+05:30	jyxQ7PwXayoSYhO6bax8AA	Post object (jyxQ7PwXayoSYhO6bax8AA)	3		10	iampiyush
40	2020-08-17 02:24:56.867+05:30	TptXn8VGF0CMF_es3GokOg	Post object (TptXn8VGF0CMF_es3GokOg)	3		10	iampiyush
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	authtoken	token
7	insight	account
8	insight	actionstore
9	insight	community
10	insight	competition
11	insight	hobby
12	insight	leaderboard
13	insight	places
14	insight	post
15	insight	tags
16	insight	userpostcomment
17	insight	teammember
18	insight	scorepost
19	insight	scoreboard
20	insight	rankbadge
21	insight	notification
22	insight	competitionpost
23	insight	communitypost
24	insight	communitymember
25	insight	hobbyreport
26	insight	datalog
27	insight	hobbynearest
28	insight	rankreport
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2020-10-29 10:26:12.790354+05:30
2	contenttypes	0002_remove_content_type_name	2020-10-29 10:26:12.812402+05:30
3	auth	0001_initial	2020-10-29 10:26:12.846644+05:30
4	auth	0002_alter_permission_name_max_length	2020-10-29 10:26:12.878039+05:30
5	auth	0003_alter_user_email_max_length	2020-10-29 10:26:12.88801+05:30
6	auth	0004_alter_user_username_opts	2020-10-29 10:26:12.897618+05:30
7	auth	0005_alter_user_last_login_null	2020-10-29 10:26:12.908912+05:30
8	auth	0006_require_contenttypes_0002	2020-10-29 10:26:12.912545+05:30
9	auth	0007_alter_validators_add_error_messages	2020-10-29 10:26:12.922595+05:30
10	auth	0008_alter_user_username_max_length	2020-10-29 10:26:12.932036+05:30
11	auth	0009_alter_user_last_name_max_length	2020-10-29 10:26:12.944264+05:30
12	auth	0010_alter_group_name_max_length	2020-10-29 10:26:12.955765+05:30
13	auth	0011_update_proxy_permissions	2020-10-29 10:26:12.968387+05:30
14	insight	0001_initial	2020-10-29 10:26:13.344916+05:30
15	admin	0001_initial	2020-10-29 10:26:13.538018+05:30
16	admin	0002_logentry_remove_auto_add	2020-10-29 10:26:13.577732+05:30
17	admin	0003_logentry_add_action_flag_choices	2020-10-29 10:26:13.605161+05:30
18	authtoken	0001_initial	2020-10-29 10:26:13.635492+05:30
19	authtoken	0002_auto_20160226_1747	2020-10-29 10:26:13.800188+05:30
20	sessions	0001_initial	2020-10-29 10:26:13.813764+05:30
21	insight	0002_auto_20201101_1731	2020-11-01 23:02:47.249065+05:30
22	insight	0003_auto_20201102_1726	2020-11-02 22:57:16.144622+05:30
23	insight	0004_auto_20201105_1617	2020-11-05 21:47:53.204008+05:30
24	insight	0005_auto_20201106_0959	2020-11-06 15:30:03.167811+05:30
25	insight	0006_auto_20201117_1240	2020-11-17 18:11:07.103874+05:30
26	insight	0007_auto_20201118_0536	2020-11-18 11:07:06.457309+05:30
27	insight	0008_auto_20201119_1003	2020-11-19 15:33:57.107623+05:30
28	insight	0009_auto_20201120_1844	2020-11-21 00:15:01.781908+05:30
29	insight	0010_auto_20201122_0459	2020-11-22 10:31:32.000787+05:30
30	insight	0011_auto_20201130_0953	2020-11-30 15:23:57.92518+05:30
31	insight	0012_auto_20201201_1933	2020-12-02 01:19:53.245976+05:30
32	insight	0013_auto_20201201_1949	2020-12-02 01:19:53.309496+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
1b7uzm8hamgf3urzea9ivxgxkfwyeekp	NWIzZmMzOTlkYmVhNjAxMmM2MTUyNjJiYzZmYjI1YjIzZmVmNzk0Zjp7Il9hdXRoX3VzZXJfaWQiOiJpYW1waXl1c2giLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjgwMjRhODdkYmI0MWYyY2Q0N2JmMDk4OWIxNzQ3ZWIxM2JhODViMzYifQ==	2020-08-29 00:31:58.051+05:30
c8w5j15i615js0jdr92ptn060ytf7o6q	YzI1ZmNhYzliM2NlMmUyYTFhNDIxNDEwNWFlODk0M2NmNjBiNDY1MTp7Il9hdXRoX3VzZXJfaWQiOiJhY2NvdW50X2lkIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI4MDI0YTg3ZGJiNDFmMmNkNDdiZjA5ODliMTc0N2ViMTNiYTg1YjM2In0=	2020-08-27 20:15:51.325+05:30
\.


--
-- Data for Name: insight_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_account (password, last_login, account_id, id_type, joined_at, username, first_name, last_name, is_staff, is_superuser, is_active, details, comfort_zones_text, activity_coords, avatar, places, hobby_map, primary_hobby, primary_weight, follower_count, following_count, description, following, current_coord, new_notification, country_code) FROM stdin;
pbkdf2_sha256$180000$YMlKzPjxCwkE$869eYx34PoDyxHq13Xr1DSj9JAYkoVzjX2QIArRy+mQ=	2020-08-13 20:15:51.301+05:30	account_id	EMAIL	2020-08-13		Piyush	Jaiswal	t	t	t	{}	{}	{}		{}	{}		0.00	0	0	Hello world #fuck @you me	{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$YMlKzPjxCwkE$869eYx34PoDyxHq13Xr1DSj9JAYkoVzjX2QIArRy+mQ=	2020-08-15 00:31:58.015+05:30	iampiyush	EMAIL	2020-08-13	jarden	Piyush	Jaiswal	t	t	t	{}	{}	{}		{}	{}		0.00	0	0	Hello world #fuck @you me	{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$vlRyXigfsNFF$+2XvQAziXvYXJTGVodUqXmgjYNcq6+c34ruMoehSBkQ=	\N	7081878499	PHONE	2020-08-18	rakesh	Rakesh	Roshan	f	f	t	{"email": "locieteam@gmail.com", "phone_number": "7081878499"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FSqXyoIZbXPXlCmwMdqs1aaXIO53CpKCB.png?alt=media&token=9d27203d-2f50-4896-a6e5-26e5538bb517	{}	{"singing725": 1.5, "thought525": 7.65, "painting375": 1.1, "sketching425": 7.35, "photography625": 4.75, "graphics_design250": 5.1}	sketching425	7.65	1	0	Hello #me @you	{}	0101000020E610000000000000000000000000000000000000	t	+91
pbkdf2_sha256$180000$MlYK8cMm552m$qgap5bgFwHMW3xpswahV2cIAtmqSQYwLbVzuOSuqk68=	\N	6392885645	PHONE	2020-11-07	jarden345	Piyush	Jaiswal	f	f	t	{"email": "iampiyushjaiswal103@gmail.com", "phone_number": "6392885645"}	{}	{}		{}	{}	graphics_design250	0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	376
\.


--
-- Data for Name: insight_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_account_groups (id, account_id, group_id) FROM stdin;
\.


--
-- Data for Name: insight_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_account_user_permissions (id, account_id, permission_id) FROM stdin;
\.


--
-- Data for Name: insight_hobby; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_hobby (code_name, name, editors, limits, weight) FROM stdin;
animation225	Animation	{custom_editor}	{}	2.250
astronomy325	Astronomy	{custom_editor}	{}	3.250
body_building825	Body Building	{custom_editor}	{}	8.250
calligraphy575	Calligraphy	{custom_editor}	{}	5.750
computer125	Computer	{custom_editor}	{}	1.250
cooking925	Cooking	{custom_editor}	{}	9.250
dance850	Dance	{custom_editor}	{}	8.500
digital_art275	Digital Art	{custom_editor}	{}	2.750
dj700	DJ	{custom_editor}	{}	7.000
drawing400	Drawing	{custom_editor}	{}	4.000
fashion1075		{}	{}	0.000
free_writing475	Free Writing	{custom_editor,type_writer}	{}	4.750
gardening950	Gardening	{custom_editor}	{}	9.500
graphics_design250	Graphics Design	{custom_editor}	{}	2.500
painting375	Painting	{custom_editor}	{}	3.750
photography625	Photography	{custom_editor}	{}	6.250
puzzles150	Puzzles	{custom_editor}	{}	1.500
quotes500	Quotes	{custom_editor,type_writer}	{}	5.000
rapping750	Rapping	{custom_editor}	{}	7.500
singing725	Singing	{custom_editor}	{}	7.250
sketching425	Sketching	{custom_editor}	{}	4.250
sports800	Sports	{custom_editor}	{}	8.000
thought525	Thought	{custom_editor,type_writer}	{}	5.250
video_games175	Video Games	{custom_editor}	{}	1.750
video_graphy650	Videograhphy	{custom_editor}	{}	6.500
acting875	Acting	{custom_editor}	{}	8.750
knitting1050	Knitting	{}	{}	0.000
make_up1000	Makeup	{}	{}	0.000
nail_art1025	Nail Art	{}	{}	0.000
poetry550	Poetry	{}	{}	0.000
\.


--
-- Data for Name: insight_hobbyreport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_hobbyreport (id, views, loves, shares, comments, communities_involved, competition_participated, competition_hosted, account_id, hobby_id, posts) FROM stdin;
1	0	0	0	0	0	0	0	7081878499	quotes500	1
2	0	0	0	0	0	0	0	7081878499	video_graphy650	1
3	0	0	0	0	0	0	0	7081878499	photography625	1
4	0	0	0	0	0	0	0	7081878499	graphics_design250	2
6	1	0	0	0	0	0	0	6392885645	painting375	0
7	1	0	0	0	0	0	0	6392885645	sketching425	0
8	1	0	0	0	0	0	0	6392885645	thought525	0
9	1	1	0	0	0	0	0	7081878499	graphics_design250	0
10	1	0	0	0	0	0	0	7081878499	painting375	0
11	2	0	0	0	0	0	0	7081878499	photography625	0
12	1	1	0	0	0	0	0	7081878499	singing725	0
13	1	1	0	5	0	0	0	7081878499	sketching425	0
14	6	1	0	0	0	0	0	7081878499	thought525	0
15	0	0	0	0	0	0	0	6392885645	photography625	1
5	1	0	0	0	0	0	0	6392885645	graphics_design250	3
\.


--
-- Data for Name: insight_places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_places (id, place_name, city, coordinates) FROM stdin;
\.


--
-- Data for Name: insight_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post (post_id, assets, caption, hastags, atags, coordinates, action_count, created_at, rank, score, is_global, account_id, hobby_id, freshness_score, last_modified, net_score) FROM stdin;
9dO2HMZPJYzKYjbCpMiv2g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FRSHJwoFPWPRiGSHtAEZHQFbVDti0NIDz.jpeg?alt=media&token=a0172021-c7f6-4d40-9587-a7ae7a7af569"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-20 18:46:57.038+05:30	5	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
ByoqAmx5JqlDNDlU7hQo1Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FzxGPl8FJIYVpxllvOeP3zrWZxbKXI7cf.png?alt=media&token=e3a02aa4-cd44-4bee-90cf-fb1577a8c091"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-20 23:11:55.05+05:30	1	0.0045	t	7081878499	thought525	0.8000	2020-11-18 11:06:48.960928+05:30	0.8045
VNZgYWKE_4RBLOK-rm3uSQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FwTh21ozYks4lMR0iVHbktrBBQyxhtfBa.png?alt=media&token=1ea942f9-4a8a-42d1-a686-24673b2f8118"]}	Work work	{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-20 18:02:42.188+05:30	6	0.0030	t	7081878499	photography625	0.8000	2020-11-22 17:44:50.639743+05:30	0.8030
nNj8E8B8zwWqiruaj6kxDQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FRkKEw5U3kyCMR9tJn1cwhpk2DbFW0WdJ.png?alt=media&token=6c21a0ba-2f95-441a-89fc-9fb294837f5c"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-21 21:32:21.469+05:30	4	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
qzxzsPfzIw5pa3fuxTN35Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FFDPIhpfUcAtFzafaKca9sXjrNDxKNddY.png?alt=media&token=53a5eef3-4418-4e28-9da7-732732103405"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-21 21:39:32.782+05:30	2	0.0015	t	7081878499	thought525	0.8000	2020-11-18 11:06:48.960928+05:30	0.8015
RYZwzPuHcIiCBiIiWJOnxg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fb7eOXXMtoidjHRyiEQYCdVX60hLmDNDL.png?alt=media&token=bba9b247-c349-45bf-a60c-2adad105fd61", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fb7eOXXMtoidjHRyiEQYCdVX60hLmDNDL.png?alt=media&token=bba9b247-c349-45bf-a60c-2adad105fd61"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-20 20:12:28.714+05:30	0	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
TAsiQUDNTg6iyk2lAnmPoA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FoWYXfivx7uISrVe7RoVE5JrkfAjMavez.png?alt=media&token=7de1a974-d839-4ea7-8ead-d652c8c12d90", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FoWYXfivx7uISrVe7RoVE5JrkfAjMavez.png?alt=media&token=7de1a974-d839-4ea7-8ead-d652c8c12d90"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-20 20:03:39.93+05:30	1	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
sbeeZq4vjk_zuZdXRLcwHQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FOy0gZad0a0LCitjgMA5B2avX1jgIj6TY.png?alt=media&token=3598b210-6590-4a84-97eb-d8732d0a2a0e", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FskuEEsbIxQvzDsRZ7ZlCKfpOXhnsiiS2.png?alt=media&token=95b41f5c-9c6f-484b-beff-213f7cb5f98c"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 2, "share": 0, "comment": 0}	2020-08-27 20:48:21.136+05:30	0	0.0060	t	7081878499	thought525	0.8000	2020-11-22 17:45:43.06393+05:30	0.8060
UA7bvfOidnY5xi4v7c-S7A	{"text": {"data": "Life rules work my way", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}, "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FFePUAmes39H8qI6SqO7U59oiwlsNiKP3.jpeg?alt=media&token=273ff8b7-eab5-4eb9-a65d-693072c6e419"]}	work hard	{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-20 18:14:36.93+05:30	3	0.0030	t	7081878499	thought525	0.8000	2020-11-22 17:44:50.652669+05:30	0.8030
KKXwcASFNyFTRnwjzpBJqg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FQ5orAqR82rOKs2DeJhi6xDV2T8qyzL5z.png?alt=media&token=107ba935-fdd5-4b67-bde7-ac571862aa0e"]}	#good #goofy	{#good,#goofy}	{#good,#goofy}	\N	{"love": 2, "save": 0, "view": 2, "share": 0, "comment": 5}	2020-09-20 22:53:59.901+05:30	0	0.0060	t	7081878499	sketching425	0.8000	2020-11-18 11:06:48.960928+05:30	0.8060
vvJkGc7_K69XYJ-06nBu6A	{"audio": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FiQ9o4CMUo5hW7zKld3NdeNPkDlhKFXEr.mpeg?alt=media&token=1736f35b-6cff-4a63-b8cc-a80414c97d44"}	nice	{#goofy}	{}	\N	{"love": 1, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-22 19:43:34.624+05:30	0	0.0045	t	7081878499	singing725	0.8000	2020-11-18 11:06:48.960928+05:30	0.8045
e9gy816jvj_5kWhhWxVZ9g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FdhQZybyzP2VjG1VxCx9v0BGPCGL1G0lI.png?alt=media&token=71fa8200-b00c-48f2-83f8-1db026ed755f"]}		{}	{}	\N	{"love": 1, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-22 16:10:28.814+05:30	7	0.0030	t	7081878499	photography625	0.8000	2020-11-22 17:44:50.389883+05:30	0.8030
3wBlgCJ0F2W3HwrKtV5OSQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FVjmkNom9CAX1o2LkWcyRYPPiLhBNTH4q.png?alt=media&token=b9978fb3-1b6a-4f56-808e-6ec9410f0cc3", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FVjmkNom9CAX1o2LkWcyRYPPiLhBNTH4q.png?alt=media&token=b9978fb3-1b6a-4f56-808e-6ec9410f0cc3"]}	work hard bitch	{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-20 20:00:10.156+05:30	2	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
ITjfDDtJP43s3UnZCiRrBQ	{"text": {"data": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}, "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FbWRwwf9pJ2f7JAUybvJ2RqWIvWK9ZsOy.png?alt=media&token=4757c417-ee39-407e-bdb2-73bc390773a4"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-08 02:06:22.557871+05:30	0	0.0000	t	7081878499	quotes500	0.8604	2020-11-18 11:06:48.960928+05:30	0.8604
yqsqw86F5B22XObYYRNqTA	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FtiEOY5kq0JIZamH0lL3jdJW3eoPe1mAV.mp4?alt=media&token=990e79e0-7492-4560-8915-87bfa4b052d4"}	Home	{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-08 02:27:46.996887+05:30	0	0.0000	t	7081878499	video_graphy650	0.8604	2020-11-18 11:06:48.960928+05:30	0.8604
7AYmDV3mSGbHRzArn3tgJQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FTV3rt4VrzPbvdKBkbAHS4W0yX9x6uAdE.png?alt=media&token=bdd4212a-7d04-4355-9d3b-2a8767090409"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-10 02:51:11.024704+05:30	0	0.0000	t	7081878499	graphics_design250	0.8996	2020-11-18 11:06:48.960928+05:30	0.8996
lpjQxzfXrI6XjGSm7driew	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FC3H30A5CdGSGFKkzAhw83eXd8QKVGUzf.png?alt=media&token=cf0a8075-c56a-4aef-a448-7e6a4a554f5c"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-10 02:56:27.036485+05:30	0	0.0000	t	7081878499	graphics_design250	0.8996	2020-11-18 11:06:48.960928+05:30	0.8996
Xtg7eZR2sBrrc1l9jigC7g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FnVtgAOKdSlTAu9waVcaSf6o0hlH1xizx.png?alt=media&token=bb25a242-8e73-41a1-9adf-c084be4b9678"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-21 21:34:59.357+05:30	4	0.0030	t	7081878499	thought525	0.8000	2020-11-22 17:44:50.436661+05:30	0.8030
1lTxNmR7t2VmkvHJ0apKgQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FGlkWO6DFUcsyT8NMYuEvPDgXtuaCE6PB.png?alt=media&token=3b6df955-de54-4723-8a58-6be9051a79f7"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0}	2020-08-21 21:34:09.994+05:30	3	0.0000	t	7081878499	photography625	0.8000	2020-11-18 11:06:48.960928+05:30	0.8000
VWuTITDup31SCL2P1Xg16w	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FzxGPl8FJIYVpxllvOeP3zrWZxbKXI7cf.png?alt=media&token=e3a02aa4-cd44-4bee-90cf-fb1577a8c091", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FVSa0DuUxL9NNtHiFwHAtjtqxc9eTM68K.png?alt=media&token=c7cf9afd-271d-4271-80d7-e56d62b41297"]}		{}	{}	\N	{"love": 0, "save": 0, "view": 1, "share": 0, "comment": 0}	2020-08-20 23:11:55.118+05:30	5	0.0015	t	7081878499	thought525	0.8000	2020-11-18 11:06:48.960928+05:30	0.8015
TozbCZgj9awccNzWi8rzow	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#Leaderboard	{}	{}	\N	{}	2020-11-23 19:14:40.630792+05:30	0	0.0015	t	6392885645	photography625	2.3576	2020-11-25 01:20:53.904396+05:30	2.3591
Sk17TJEDPU52uhW94pm1og	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FPhUmbiohBDbSH4YtAYvLZpPtoBc9YnDq.svg%2Bxml?alt=media&token=5eee7889-f869-4a65-8639-32dd3a8f2171"]}	Nice #work @you	{#work}	{#work}	\N	{"love": 0, "save": 0, "view": 2, "share": 0, "comment": 0}	2020-10-04 02:17:45.259+05:30	0	0.0030	t	7081878499	painting375	0.8000	2020-11-18 11:06:48.960928+05:30	0.8030
lUaAR0wivhE5lnw2bpiXdQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#Leaderboard	{}	{}	\N	{}	2020-11-23 19:09:33.347943+05:30	0	0.0015	t	6392885645	photography625	2.8000	2020-11-24 17:26:30.966049+05:30	2.8015
trZaMEAsDllfx_3b8wMN6Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fa53Rb3i0onkLWvam1BXq5DbExdlg21Gg.png?alt=media&token=25472f11-1fb0-432c-a0e1-f97ca5dbdec6"]}	Nice	{}	{}	\N	{"love": 0, "save": 0, "view": 0, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-10 02:45:58.984815+05:30	0	0.0000	t	7081878499	photography625	0.8996	2020-11-18 11:06:48.960928+05:30	0.8996
oyrk3b_7vKKBb1h-RmP9fw	{"text": {"data": "Hello fuck", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}}		{}	{}	\N	{"love": 4, "save": 0, "view": 4, "share": 0, "comment": 0}	2020-08-28 22:11:24.258+05:30	0	0.0090	t	7081878499	graphics_design250	0.8000	2020-11-23 19:41:17.426195+05:30	0.8090
sjtvrpRCHI-Q7X1g0IK76Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#Leaderboard	{}	{}	\N	{}	2020-11-23 19:19:57.111472+05:30	0	0.0045	t	6392885645	photography625	2.8000	2020-11-24 17:26:08.827563+05:30	2.8045
hQjC5X1XKR4sj2RSCZVN2A	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#Leaderboard	{}	{}	\N	{}	2020-11-23 19:18:30.753029+05:30	0	0.0015	t	6392885645	photography625	2.8000	2020-11-24 17:26:08.82856+05:30	2.8015
DqQdPJTln5YIGl0xEIveJA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:27:56.282104+05:30	0	0.0015	t	6392885645	graphics_design250	1.2463	2020-12-01 16:19:32.977938+05:30	1.2478
_wEUjIcGv64E3k8eG0hQFg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:18:48.91101+05:30	0	0.0000	t	7081878499	graphics_design250	2.8000	2020-11-25 01:46:14.765443+05:30	2.8000
Mod43y0S-rweVS11GErPag	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:30:50.710251+05:30	0	0.0045	t	6392885645	graphics_design250	1.2463	2020-12-01 16:57:35.312909+05:30	1.2508
KuC0xT5SiKKOkgpCcNA9jQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:32:27.088813+05:30	0	0.0045	t	6392885645	graphics_design250	2.8000	2020-11-25 01:51:36.019627+05:30	2.8045
zBYAHLqqgZzR6Pp-dZUO3g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:34:02.554218+05:30	0	0.0045	t	6392885645	graphics_design250	2.8000	2020-11-25 01:52:01.115866+05:30	2.8045
-iYp8Jdo3cOd6su1Vd5XAg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:30:15.802287+05:30	0	0.0045	t	6392885645	graphics_design250	1.2463	2020-12-01 17:03:17.412664+05:30	1.2508
PLFncLQ2-EDoRwpNkEe84g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeXh0FOkd6LbCS6JOoQv6qhaQDpVuOPxa.png?alt=media&token=a9f4c545-7f71-4f2f-8e0d-86968f8d27d8"]}	#paint @home	{}	{}	\N	{}	2020-11-25 01:29:55.510597+05:30	0	0.0015	t	6392885645	graphics_design250	1.2463	2020-12-01 17:05:19.357638+05:30	1.2478
\.


--
-- Data for Name: insight_post_a_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_a_tags (id, post_id, tags_id) FROM stdin;
3	KuC0xT5SiKKOkgpCcNA9jQ	painting
\.


--
-- Data for Name: insight_post_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_comments (id, post_id, userpostcomment_id) FROM stdin;
1	KKXwcASFNyFTRnwjzpBJqg	1
2	KKXwcASFNyFTRnwjzpBJqg	2
3	KKXwcASFNyFTRnwjzpBJqg	3
4	KKXwcASFNyFTRnwjzpBJqg	4
5	KKXwcASFNyFTRnwjzpBJqg	5
6	_wEUjIcGv64E3k8eG0hQFg	6
\.


--
-- Data for Name: insight_post_down_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_down_votes (id, post_id, account_id) FROM stdin;
\.


--
-- Data for Name: insight_post_hash_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_hash_tags (id, post_id, tags_id) FROM stdin;
10	zBYAHLqqgZzR6Pp-dZUO3g	painter
\.


--
-- Data for Name: insight_post_loves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_loves (id, post_id, account_id) FROM stdin;
1	ByoqAmx5JqlDNDlU7hQo1Q	7081878499
2	KKXwcASFNyFTRnwjzpBJqg	7081878499
3	vvJkGc7_K69XYJ-06nBu6A	7081878499
4	oyrk3b_7vKKBb1h-RmP9fw	7081878499
5	sbeeZq4vjk_zuZdXRLcwHQ	6392885645
10	oyrk3b_7vKKBb1h-RmP9fw	6392885645
11	sjtvrpRCHI-Q7X1g0IK76Q	7081878499
17	KuC0xT5SiKKOkgpCcNA9jQ	7081878499
18	Mod43y0S-rweVS11GErPag	7081878499
19	zBYAHLqqgZzR6Pp-dZUO3g	7081878499
22	-iYp8Jdo3cOd6su1Vd5XAg	7081878499
\.


--
-- Data for Name: insight_post_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_shares (id, post_id, account_id) FROM stdin;
\.


--
-- Data for Name: insight_post_up_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_up_votes (id, post_id, account_id) FROM stdin;
\.


--
-- Data for Name: insight_post_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_views (id, post_id, account_id) FROM stdin;
9	ByoqAmx5JqlDNDlU7hQo1Q	7081878499
10	e9gy816jvj_5kWhhWxVZ9g	7081878499
11	qzxzsPfzIw5pa3fuxTN35Q	7081878499
12	UA7bvfOidnY5xi4v7c-S7A	7081878499
13	VNZgYWKE_4RBLOK-rm3uSQ	7081878499
14	sbeeZq4vjk_zuZdXRLcwHQ	6392885645
15	sbeeZq4vjk_zuZdXRLcwHQ	7081878499
16	KKXwcASFNyFTRnwjzpBJqg	6392885645
17	KKXwcASFNyFTRnwjzpBJqg	7081878499
18	vvJkGc7_K69XYJ-06nBu6A	7081878499
19	VWuTITDup31SCL2P1Xg16w	7081878499
20	Xtg7eZR2sBrrc1l9jigC7g	7081878499
21	oyrk3b_7vKKBb1h-RmP9fw	6392885645
22	oyrk3b_7vKKBb1h-RmP9fw	7081878499
23	Sk17TJEDPU52uhW94pm1og	6392885645
24	Sk17TJEDPU52uhW94pm1og	7081878499
25	e9gy816jvj_5kWhhWxVZ9g	6392885645
26	Xtg7eZR2sBrrc1l9jigC7g	6392885645
27	VNZgYWKE_4RBLOK-rm3uSQ	6392885645
28	UA7bvfOidnY5xi4v7c-S7A	6392885645
29	sjtvrpRCHI-Q7X1g0IK76Q	7081878499
30	hQjC5X1XKR4sj2RSCZVN2A	7081878499
31	lUaAR0wivhE5lnw2bpiXdQ	7081878499
32	TozbCZgj9awccNzWi8rzow	7081878499
37	Mod43y0S-rweVS11GErPag	7081878499
38	KuC0xT5SiKKOkgpCcNA9jQ	7081878499
39	zBYAHLqqgZzR6Pp-dZUO3g	7081878499
40	PLFncLQ2-EDoRwpNkEe84g	7081878499
41	-iYp8Jdo3cOd6su1Vd5XAg	7081878499
42	DqQdPJTln5YIGl0xEIveJA	7081878499
\.


--
-- Data for Name: insight_scoreboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_scoreboard (id, created_at, expires_on, retention, account_id, original_creation, down_votes, loves, shares, up_votes, views) FROM stdin;
4	2020-11-21	2020-12-06	0.00000	7081878499	2020-11-21 00:15:36.812902+05:30	0	10	0	0	22
6	2020-11-22	2020-12-06	0.22314	7081878499	2020-11-22 17:44:50.99744+05:30	0	2	0	0	10
8	2020-11-23	2020-12-06	0.00000	7081878499	2020-11-23 19:41:17.465973+05:30	0	4	0	0	4
7	2020-11-23	2020-12-06	0.91629	6392885645	2020-11-23 19:14:40.784102+05:30	0	10	0	0	11
\.


--
-- Data for Name: insight_scoreboard_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_scoreboard_posts (id, scoreboard_id, post_id) FROM stdin;
24	4	RYZwzPuHcIiCBiIiWJOnxg
25	4	oyrk3b_7vKKBb1h-RmP9fw
26	4	trZaMEAsDllfx_3b8wMN6Q
27	4	nNj8E8B8zwWqiruaj6kxDQ
28	4	9dO2HMZPJYzKYjbCpMiv2g
29	4	KKXwcASFNyFTRnwjzpBJqg
30	4	1lTxNmR7t2VmkvHJ0apKgQ
31	4	ByoqAmx5JqlDNDlU7hQo1Q
32	4	VNZgYWKE_4RBLOK-rm3uSQ
33	4	yqsqw86F5B22XObYYRNqTA
34	4	Sk17TJEDPU52uhW94pm1og
35	4	e9gy816jvj_5kWhhWxVZ9g
36	4	VWuTITDup31SCL2P1Xg16w
37	4	qzxzsPfzIw5pa3fuxTN35Q
38	4	vvJkGc7_K69XYJ-06nBu6A
39	4	TAsiQUDNTg6iyk2lAnmPoA
40	4	7AYmDV3mSGbHRzArn3tgJQ
41	4	Xtg7eZR2sBrrc1l9jigC7g
42	4	UA7bvfOidnY5xi4v7c-S7A
43	4	sbeeZq4vjk_zuZdXRLcwHQ
44	4	ITjfDDtJP43s3UnZCiRrBQ
45	4	lpjQxzfXrI6XjGSm7driew
46	4	3wBlgCJ0F2W3HwrKtV5OSQ
56	6	e9gy816jvj_5kWhhWxVZ9g
57	6	UA7bvfOidnY5xi4v7c-S7A
58	6	Xtg7eZR2sBrrc1l9jigC7g
59	6	VNZgYWKE_4RBLOK-rm3uSQ
60	6	sbeeZq4vjk_zuZdXRLcwHQ
65	7	TozbCZgj9awccNzWi8rzow
66	7	sjtvrpRCHI-Q7X1g0IK76Q
67	8	oyrk3b_7vKKBb1h-RmP9fw
75	7	hQjC5X1XKR4sj2RSCZVN2A
76	7	lUaAR0wivhE5lnw2bpiXdQ
82	7	DqQdPJTln5YIGl0xEIveJA
83	7	KuC0xT5SiKKOkgpCcNA9jQ
84	7	zBYAHLqqgZzR6Pp-dZUO3g
85	8	_wEUjIcGv64E3k8eG0hQFg
87	7	Mod43y0S-rweVS11GErPag
89	7	PLFncLQ2-EDoRwpNkEe84g
94	7	-iYp8Jdo3cOd6su1Vd5XAg
\.


--
-- Data for Name: insight_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_tags (tag, created_at, first_used, tag_type) FROM stdin;
work	2020-11-23 15:18:41.270041+05:30		HASH
goofy	2020-11-23 15:18:41.279087+05:30		HASH
painting	2020-11-25 01:32:27.098347+05:30	KuC0xT5SiKKOkgpCcNA9jQ	A_TAG
homie	2020-11-25 01:32:27.098455+05:30	KuC0xT5SiKKOkgpCcNA9jQ	A_TAG
painter	2020-11-25 01:34:02.565535+05:30	zBYAHLqqgZzR6Pp-dZUO3g	HASH
homierr	2020-11-25 01:34:02.565653+05:30	zBYAHLqqgZzR6Pp-dZUO3g	A_TAG
TIME	2020-12-01 22:38:23.201594+05:30		HASH
Introspection	2020-12-01 22:38:23.201594+05:30		HASH
\.


--
-- Data for Name: insight_userpostcomment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_userpostcomment (id, post_id, comment, created_at, count, account_id) FROM stdin;
1	KKXwcASFNyFTRnwjzpBJqg	Tesh Comment	2020-09-30 03:14:44.711+05:30	0	7081878499
2	KKXwcASFNyFTRnwjzpBJqg	hello	2020-10-01 21:24:52.88+05:30	0	7081878499
3	KKXwcASFNyFTRnwjzpBJqg	hellow	2020-10-01 21:28:39.842+05:30	0	7081878499
4	KKXwcASFNyFTRnwjzpBJqg	hi	2020-10-01 21:29:13.73+05:30	0	7081878499
5	KKXwcASFNyFTRnwjzpBJqg	hello \nthis is piyush wanna meeta you and say something	2020-10-01 22:37:20.676+05:30	0	7081878499
6	_wEUjIcGv64E3k8eG0hQFg	hello	2020-11-25 01:46:14.735237+05:30	0	7081878499
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 112, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 40, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 28, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 32, true);


--
-- Name: insight_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_account_groups_id_seq', 1, false);


--
-- Name: insight_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_account_user_permissions_id_seq', 1, false);


--
-- Name: insight_hobbyreport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_hobbyreport_id_seq', 15, true);


--
-- Name: insight_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_places_id_seq', 1, false);


--
-- Name: insight_post_a_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_a_tags_id_seq', 3, true);


--
-- Name: insight_post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_comments_id_seq', 6, true);


--
-- Name: insight_post_down_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_down_votes_id_seq', 1, false);


--
-- Name: insight_post_hash_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_hash_tags_id_seq', 10, true);


--
-- Name: insight_post_loves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_loves_id_seq', 27, true);


--
-- Name: insight_post_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_shares_id_seq', 1, false);


--
-- Name: insight_post_up_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_up_votes_id_seq', 1, false);


--
-- Name: insight_post_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_views_id_seq', 43, true);


--
-- Name: insight_scoreboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_scoreboard_id_seq', 8, true);


--
-- Name: insight_scoreboard_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_scoreboard_posts_id_seq', 94, true);


--
-- Name: insight_userpostcomment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_userpostcomment_id_seq', 6, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: insight_account_groups insight_account_groups_account_id_group_id_12914a11_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_groups
    ADD CONSTRAINT insight_account_groups_account_id_group_id_12914a11_uniq UNIQUE (account_id, group_id);


--
-- Name: insight_account_groups insight_account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_groups
    ADD CONSTRAINT insight_account_groups_pkey PRIMARY KEY (id);


--
-- Name: insight_account insight_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account
    ADD CONSTRAINT insight_account_pkey PRIMARY KEY (account_id);


--
-- Name: insight_account_user_permissions insight_account_user_per_account_id_permission_id_91eb3cff_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_user_permissions
    ADD CONSTRAINT insight_account_user_per_account_id_permission_id_91eb3cff_uniq UNIQUE (account_id, permission_id);


--
-- Name: insight_account_user_permissions insight_account_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_user_permissions
    ADD CONSTRAINT insight_account_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: insight_account insight_account_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account
    ADD CONSTRAINT insight_account_username_key UNIQUE (username);


--
-- Name: insight_hobby insight_hobby_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_hobby
    ADD CONSTRAINT insight_hobby_pkey PRIMARY KEY (code_name);


--
-- Name: insight_hobbyreport insight_hobbyreport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_hobbyreport
    ADD CONSTRAINT insight_hobbyreport_pkey PRIMARY KEY (id);


--
-- Name: insight_places insight_places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_places
    ADD CONSTRAINT insight_places_pkey PRIMARY KEY (id);


--
-- Name: insight_post_a_tags insight_post_a_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_a_tags
    ADD CONSTRAINT insight_post_a_tags_pkey PRIMARY KEY (id);


--
-- Name: insight_post_a_tags insight_post_a_tags_post_id_tags_id_92b8bc03_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_a_tags
    ADD CONSTRAINT insight_post_a_tags_post_id_tags_id_92b8bc03_uniq UNIQUE (post_id, tags_id);


--
-- Name: insight_post_comments insight_post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_comments
    ADD CONSTRAINT insight_post_comments_pkey PRIMARY KEY (id);


--
-- Name: insight_post_comments insight_post_comments_post_id_userpostcomment_id_b1bb0f2d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_comments
    ADD CONSTRAINT insight_post_comments_post_id_userpostcomment_id_b1bb0f2d_uniq UNIQUE (post_id, userpostcomment_id);


--
-- Name: insight_post_down_votes insight_post_down_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_down_votes
    ADD CONSTRAINT insight_post_down_votes_pkey PRIMARY KEY (id);


--
-- Name: insight_post_down_votes insight_post_down_votes_post_id_account_id_4cbe8dcc_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_down_votes
    ADD CONSTRAINT insight_post_down_votes_post_id_account_id_4cbe8dcc_uniq UNIQUE (post_id, account_id);


--
-- Name: insight_post_hash_tags insight_post_hash_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_hash_tags
    ADD CONSTRAINT insight_post_hash_tags_pkey PRIMARY KEY (id);


--
-- Name: insight_post_hash_tags insight_post_hash_tags_post_id_tags_id_ec7075f2_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_hash_tags
    ADD CONSTRAINT insight_post_hash_tags_post_id_tags_id_ec7075f2_uniq UNIQUE (post_id, tags_id);


--
-- Name: insight_post_loves insight_post_loves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_loves
    ADD CONSTRAINT insight_post_loves_pkey PRIMARY KEY (id);


--
-- Name: insight_post_loves insight_post_loves_post_id_account_id_51a3910d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_loves
    ADD CONSTRAINT insight_post_loves_post_id_account_id_51a3910d_uniq UNIQUE (post_id, account_id);


--
-- Name: insight_post insight_post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post
    ADD CONSTRAINT insight_post_pkey PRIMARY KEY (post_id);


--
-- Name: insight_post_shares insight_post_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_shares
    ADD CONSTRAINT insight_post_shares_pkey PRIMARY KEY (id);


--
-- Name: insight_post_shares insight_post_shares_post_id_account_id_d74d9259_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_shares
    ADD CONSTRAINT insight_post_shares_post_id_account_id_d74d9259_uniq UNIQUE (post_id, account_id);


--
-- Name: insight_post_up_votes insight_post_up_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_up_votes
    ADD CONSTRAINT insight_post_up_votes_pkey PRIMARY KEY (id);


--
-- Name: insight_post_up_votes insight_post_up_votes_post_id_account_id_dea5c51f_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_up_votes
    ADD CONSTRAINT insight_post_up_votes_post_id_account_id_dea5c51f_uniq UNIQUE (post_id, account_id);


--
-- Name: insight_post_views insight_post_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_views
    ADD CONSTRAINT insight_post_views_pkey PRIMARY KEY (id);


--
-- Name: insight_post_views insight_post_views_post_id_account_id_61829783_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_views
    ADD CONSTRAINT insight_post_views_post_id_account_id_61829783_uniq UNIQUE (post_id, account_id);


--
-- Name: insight_scoreboard insight_scoreboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard
    ADD CONSTRAINT insight_scoreboard_pkey PRIMARY KEY (id);


--
-- Name: insight_scoreboard_posts insight_scoreboard_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard_posts
    ADD CONSTRAINT insight_scoreboard_posts_pkey PRIMARY KEY (id);


--
-- Name: insight_scoreboard_posts insight_scoreboard_posts_scoreboard_id_post_id_f212c88d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard_posts
    ADD CONSTRAINT insight_scoreboard_posts_scoreboard_id_post_id_f212c88d_uniq UNIQUE (scoreboard_id, post_id);


--
-- Name: insight_tags insight_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_tags
    ADD CONSTRAINT insight_tags_pkey PRIMARY KEY (tag);


--
-- Name: insight_userpostcomment insight_userpostcomment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_userpostcomment
    ADD CONSTRAINT insight_userpostcomment_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: authtoken_token_user_id_35299eff_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authtoken_token_user_id_35299eff_like ON public.authtoken_token USING btree (user_id varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_admin_log_user_id_c564eba6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6_like ON public.django_admin_log USING btree (user_id varchar_pattern_ops);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: insight_account_account_id_f04f881e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_account_id_f04f881e_like ON public.insight_account USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_account_current_coord_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_current_coord_id ON public.insight_account USING gist (current_coord);


--
-- Name: insight_account_groups_account_id_0df28f50; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_groups_account_id_0df28f50 ON public.insight_account_groups USING btree (account_id);


--
-- Name: insight_account_groups_account_id_0df28f50_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_groups_account_id_0df28f50_like ON public.insight_account_groups USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_account_groups_group_id_edae7219; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_groups_group_id_edae7219 ON public.insight_account_groups USING btree (group_id);


--
-- Name: insight_account_user_permissions_account_id_00c11457; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_user_permissions_account_id_00c11457 ON public.insight_account_user_permissions USING btree (account_id);


--
-- Name: insight_account_user_permissions_account_id_00c11457_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_user_permissions_account_id_00c11457_like ON public.insight_account_user_permissions USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_account_user_permissions_permission_id_a18a8c4a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_user_permissions_permission_id_a18a8c4a ON public.insight_account_user_permissions USING btree (permission_id);


--
-- Name: insight_account_username_250aa265_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_account_username_250aa265_like ON public.insight_account USING btree (username varchar_pattern_ops);


--
-- Name: insight_hobby_code_name_208b0e40_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_hobby_code_name_208b0e40_like ON public.insight_hobby USING btree (code_name varchar_pattern_ops);


--
-- Name: insight_hobbyreport_account_id_d5f0f223; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_hobbyreport_account_id_d5f0f223 ON public.insight_hobbyreport USING btree (account_id);


--
-- Name: insight_hobbyreport_account_id_d5f0f223_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_hobbyreport_account_id_d5f0f223_like ON public.insight_hobbyreport USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_hobbyreport_hobby_id_687bb78d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_hobbyreport_hobby_id_687bb78d ON public.insight_hobbyreport USING btree (hobby_id);


--
-- Name: insight_hobbyreport_hobby_id_687bb78d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_hobbyreport_hobby_id_687bb78d_like ON public.insight_hobbyreport USING btree (hobby_id varchar_pattern_ops);


--
-- Name: insight_places_coords_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_places_coords_id ON public.insight_places USING gist (coordinates);


--
-- Name: insight_post_a_tags_post_id_7968b797; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_a_tags_post_id_7968b797 ON public.insight_post_a_tags USING btree (post_id);


--
-- Name: insight_post_a_tags_post_id_7968b797_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_a_tags_post_id_7968b797_like ON public.insight_post_a_tags USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_a_tags_tags_id_32032521; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_a_tags_tags_id_32032521 ON public.insight_post_a_tags USING btree (tags_id);


--
-- Name: insight_post_a_tags_tags_id_32032521_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_a_tags_tags_id_32032521_like ON public.insight_post_a_tags USING btree (tags_id text_pattern_ops);


--
-- Name: insight_post_account_id_6245c4e1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_account_id_6245c4e1 ON public.insight_post USING btree (account_id);


--
-- Name: insight_post_account_id_6245c4e1_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_account_id_6245c4e1_like ON public.insight_post USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_comments_post_id_8fbdf15c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_comments_post_id_8fbdf15c ON public.insight_post_comments USING btree (post_id);


--
-- Name: insight_post_comments_post_id_8fbdf15c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_comments_post_id_8fbdf15c_like ON public.insight_post_comments USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_comments_userpostcomment_id_d2166910; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_comments_userpostcomment_id_d2166910 ON public.insight_post_comments USING btree (userpostcomment_id);


--
-- Name: insight_post_coords_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_coords_id ON public.insight_post USING gist (coordinates);


--
-- Name: insight_post_down_votes_account_id_ba9cada0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_down_votes_account_id_ba9cada0 ON public.insight_post_down_votes USING btree (account_id);


--
-- Name: insight_post_down_votes_account_id_ba9cada0_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_down_votes_account_id_ba9cada0_like ON public.insight_post_down_votes USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_down_votes_post_id_c3e3fce4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_down_votes_post_id_c3e3fce4 ON public.insight_post_down_votes USING btree (post_id);


--
-- Name: insight_post_down_votes_post_id_c3e3fce4_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_down_votes_post_id_c3e3fce4_like ON public.insight_post_down_votes USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_hash_tags_post_id_e661cdbd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hash_tags_post_id_e661cdbd ON public.insight_post_hash_tags USING btree (post_id);


--
-- Name: insight_post_hash_tags_post_id_e661cdbd_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hash_tags_post_id_e661cdbd_like ON public.insight_post_hash_tags USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_hash_tags_tags_id_f1c10503; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hash_tags_tags_id_f1c10503 ON public.insight_post_hash_tags USING btree (tags_id);


--
-- Name: insight_post_hash_tags_tags_id_f1c10503_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hash_tags_tags_id_f1c10503_like ON public.insight_post_hash_tags USING btree (tags_id text_pattern_ops);


--
-- Name: insight_post_hobby_id_fb4b58ca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hobby_id_fb4b58ca ON public.insight_post USING btree (hobby_id);


--
-- Name: insight_post_hobby_id_fb4b58ca_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_hobby_id_fb4b58ca_like ON public.insight_post USING btree (hobby_id varchar_pattern_ops);


--
-- Name: insight_post_loves_account_id_10e01590; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_loves_account_id_10e01590 ON public.insight_post_loves USING btree (account_id);


--
-- Name: insight_post_loves_account_id_10e01590_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_loves_account_id_10e01590_like ON public.insight_post_loves USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_loves_post_id_a4cca0b2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_loves_post_id_a4cca0b2 ON public.insight_post_loves USING btree (post_id);


--
-- Name: insight_post_loves_post_id_a4cca0b2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_loves_post_id_a4cca0b2_like ON public.insight_post_loves USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_post_id_8bde7ed3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_post_id_8bde7ed3_like ON public.insight_post USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_shares_account_id_8773ecdb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_shares_account_id_8773ecdb ON public.insight_post_shares USING btree (account_id);


--
-- Name: insight_post_shares_account_id_8773ecdb_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_shares_account_id_8773ecdb_like ON public.insight_post_shares USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_shares_post_id_32c0f9c1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_shares_post_id_32c0f9c1 ON public.insight_post_shares USING btree (post_id);


--
-- Name: insight_post_shares_post_id_32c0f9c1_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_shares_post_id_32c0f9c1_like ON public.insight_post_shares USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_up_votes_account_id_1193b8b8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_up_votes_account_id_1193b8b8 ON public.insight_post_up_votes USING btree (account_id);


--
-- Name: insight_post_up_votes_account_id_1193b8b8_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_up_votes_account_id_1193b8b8_like ON public.insight_post_up_votes USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_up_votes_post_id_07b87904; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_up_votes_post_id_07b87904 ON public.insight_post_up_votes USING btree (post_id);


--
-- Name: insight_post_up_votes_post_id_07b87904_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_up_votes_post_id_07b87904_like ON public.insight_post_up_votes USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_post_views_account_id_2b1f7070; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_views_account_id_2b1f7070 ON public.insight_post_views USING btree (account_id);


--
-- Name: insight_post_views_account_id_2b1f7070_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_views_account_id_2b1f7070_like ON public.insight_post_views USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_post_views_post_id_aa29f3f6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_views_post_id_aa29f3f6 ON public.insight_post_views USING btree (post_id);


--
-- Name: insight_post_views_post_id_aa29f3f6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_post_views_post_id_aa29f3f6_like ON public.insight_post_views USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_scoreboard_account_id_99549a90; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_scoreboard_account_id_99549a90 ON public.insight_scoreboard USING btree (account_id);


--
-- Name: insight_scoreboard_account_id_99549a90_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_scoreboard_account_id_99549a90_like ON public.insight_scoreboard USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_scoreboard_posts_post_id_fa7b4dbc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_scoreboard_posts_post_id_fa7b4dbc ON public.insight_scoreboard_posts USING btree (post_id);


--
-- Name: insight_scoreboard_posts_post_id_fa7b4dbc_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_scoreboard_posts_post_id_fa7b4dbc_like ON public.insight_scoreboard_posts USING btree (post_id varchar_pattern_ops);


--
-- Name: insight_scoreboard_posts_scoreboard_id_cbf8ae17; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_scoreboard_posts_scoreboard_id_cbf8ae17 ON public.insight_scoreboard_posts USING btree (scoreboard_id);


--
-- Name: insight_tags_tag_84bdff16_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_tags_tag_84bdff16_like ON public.insight_tags USING btree (tag text_pattern_ops);


--
-- Name: insight_userpostcomment_account_id_c929cce8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_userpostcomment_account_id_c929cce8 ON public.insight_userpostcomment USING btree (account_id);


--
-- Name: insight_userpostcomment_account_id_c929cce8_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_userpostcomment_account_id_c929cce8_like ON public.insight_userpostcomment USING btree (account_id varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_insight_account_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_insight_account_account_id FOREIGN KEY (user_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_insight_account_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_insight_account_account_id FOREIGN KEY (user_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_account_groups insight_account_grou_account_id_0df28f50_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_groups
    ADD CONSTRAINT insight_account_grou_account_id_0df28f50_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_account_groups insight_account_groups_group_id_edae7219_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_groups
    ADD CONSTRAINT insight_account_groups_group_id_edae7219_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_account_user_permissions insight_account_user_account_id_00c11457_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_user_permissions
    ADD CONSTRAINT insight_account_user_account_id_00c11457_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_account_user_permissions insight_account_user_permission_id_a18a8c4a_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_account_user_permissions
    ADD CONSTRAINT insight_account_user_permission_id_a18a8c4a_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_hobbyreport insight_hobbyreport_account_id_d5f0f223_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_hobbyreport
    ADD CONSTRAINT insight_hobbyreport_account_id_d5f0f223_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_hobbyreport insight_hobbyreport_hobby_id_687bb78d_fk_insight_h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_hobbyreport
    ADD CONSTRAINT insight_hobbyreport_hobby_id_687bb78d_fk_insight_h FOREIGN KEY (hobby_id) REFERENCES public.insight_hobby(code_name) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_a_tags insight_post_a_tags_post_id_7968b797_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_a_tags
    ADD CONSTRAINT insight_post_a_tags_post_id_7968b797_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_a_tags insight_post_a_tags_tags_id_32032521_fk_insight_tags_tag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_a_tags
    ADD CONSTRAINT insight_post_a_tags_tags_id_32032521_fk_insight_tags_tag FOREIGN KEY (tags_id) REFERENCES public.insight_tags(tag) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post insight_post_account_id_6245c4e1_fk_insight_account_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post
    ADD CONSTRAINT insight_post_account_id_6245c4e1_fk_insight_account_account_id FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_comments insight_post_comment_userpostcomment_id_d2166910_fk_insight_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_comments
    ADD CONSTRAINT insight_post_comment_userpostcomment_id_d2166910_fk_insight_u FOREIGN KEY (userpostcomment_id) REFERENCES public.insight_userpostcomment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_comments insight_post_comments_post_id_8fbdf15c_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_comments
    ADD CONSTRAINT insight_post_comments_post_id_8fbdf15c_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_down_votes insight_post_down_vo_account_id_ba9cada0_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_down_votes
    ADD CONSTRAINT insight_post_down_vo_account_id_ba9cada0_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_down_votes insight_post_down_vo_post_id_c3e3fce4_fk_insight_p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_down_votes
    ADD CONSTRAINT insight_post_down_vo_post_id_c3e3fce4_fk_insight_p FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_hash_tags insight_post_hash_tags_post_id_e661cdbd_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_hash_tags
    ADD CONSTRAINT insight_post_hash_tags_post_id_e661cdbd_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_hash_tags insight_post_hash_tags_tags_id_f1c10503_fk_insight_tags_tag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_hash_tags
    ADD CONSTRAINT insight_post_hash_tags_tags_id_f1c10503_fk_insight_tags_tag FOREIGN KEY (tags_id) REFERENCES public.insight_tags(tag) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post insight_post_hobby_id_fb4b58ca_fk_insight_hobby_code_name; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post
    ADD CONSTRAINT insight_post_hobby_id_fb4b58ca_fk_insight_hobby_code_name FOREIGN KEY (hobby_id) REFERENCES public.insight_hobby(code_name) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_loves insight_post_loves_account_id_10e01590_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_loves
    ADD CONSTRAINT insight_post_loves_account_id_10e01590_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_loves insight_post_loves_post_id_a4cca0b2_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_loves
    ADD CONSTRAINT insight_post_loves_post_id_a4cca0b2_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_shares insight_post_shares_account_id_8773ecdb_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_shares
    ADD CONSTRAINT insight_post_shares_account_id_8773ecdb_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_shares insight_post_shares_post_id_32c0f9c1_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_shares
    ADD CONSTRAINT insight_post_shares_post_id_32c0f9c1_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_up_votes insight_post_up_vote_account_id_1193b8b8_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_up_votes
    ADD CONSTRAINT insight_post_up_vote_account_id_1193b8b8_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_up_votes insight_post_up_votes_post_id_07b87904_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_up_votes
    ADD CONSTRAINT insight_post_up_votes_post_id_07b87904_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_views insight_post_views_account_id_2b1f7070_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_views
    ADD CONSTRAINT insight_post_views_account_id_2b1f7070_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_post_views insight_post_views_post_id_aa29f3f6_fk_insight_post_post_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_post_views
    ADD CONSTRAINT insight_post_views_post_id_aa29f3f6_fk_insight_post_post_id FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_scoreboard insight_scoreboard_account_id_99549a90_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard
    ADD CONSTRAINT insight_scoreboard_account_id_99549a90_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_scoreboard_posts insight_scoreboard_p_post_id_fa7b4dbc_fk_insight_p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard_posts
    ADD CONSTRAINT insight_scoreboard_p_post_id_fa7b4dbc_fk_insight_p FOREIGN KEY (post_id) REFERENCES public.insight_post(post_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_scoreboard_posts insight_scoreboard_p_scoreboard_id_cbf8ae17_fk_insight_s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_scoreboard_posts
    ADD CONSTRAINT insight_scoreboard_p_scoreboard_id_cbf8ae17_fk_insight_s FOREIGN KEY (scoreboard_id) REFERENCES public.insight_scoreboard(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: insight_userpostcomment insight_userpostcomm_account_id_c929cce8_fk_insight_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_userpostcomment
    ADD CONSTRAINT insight_userpostcomm_account_id_c929cce8_fk_insight_a FOREIGN KEY (account_id) REFERENCES public.insight_account(account_id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

