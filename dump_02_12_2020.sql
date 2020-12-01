--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Ubuntu 12.2-4)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-4)

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


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
-- Name: insight_actionstore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insight_actionstore (
    id integer NOT NULL,
    account_id character varying(50) NOT NULL,
    post_id character varying(25) NOT NULL,
    loved boolean NOT NULL,
    loved_at timestamp with time zone NOT NULL,
    viewed boolean NOT NULL,
    viewed_at timestamp with time zone NOT NULL,
    shared boolean NOT NULL,
    saved boolean NOT NULL,
    commented boolean NOT NULL,
    up_voted boolean NOT NULL,
    down_voted boolean NOT NULL
);


ALTER TABLE public.insight_actionstore OWNER TO postgres;

--
-- Name: insight_actionstore_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insight_actionstore_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insight_actionstore_id_seq OWNER TO postgres;

--
-- Name: insight_actionstore_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insight_actionstore_id_seq OWNED BY public.insight_actionstore.id;


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
    is_global boolean NOT NULL,
    account_id character varying(20) NOT NULL,
    hobby_id character varying(30) NOT NULL,
    freshness_score numeric(7,4) NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    net_score numeric(7,4) NOT NULL,
    score numeric(7,4) NOT NULL
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
-- Name: insight_actionstore id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_actionstore ALTER COLUMN id SET DEFAULT nextval('public.insight_actionstore_id_seq'::regclass);


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
0083297f0389666691fbbd1201024e1caecd7a47	2020-09-24 14:38:50.738+00	9598239351
04349d4a3231f8b48e8c1b6beb66049a6657f71c	2020-08-29 03:16:41.641+00	9889024257
067e7de531fd2bca5ab95789977aa35dc1125d1e	2020-08-28 16:24:19.397+00	6386240651
08648582940e7783c1a55eb75e5bc092a07ff639	2020-08-28 18:23:02.452+00	8400735434
0acb203186fdb5a53fafb4f973d3f0a766110d0a	2020-09-29 00:55:45.273+00	9336394079
0d6f863580064d5e0de8dae11b6711cc7d26615a	2020-08-28 16:43:02.171+00	9140471417
1c0b1ebc7a6886f478d2558995e32b16ed80b0e5	2020-08-28 16:21:07.923+00	9793816217
1d15ac7e6ca126a1956b92361ed1cc446e069150	2020-08-28 16:30:34.153+00	8082091408
2200e4285ff15550d04c496b1cc3c16b40d2a5eb	2020-09-28 13:52:23.674+00	9119143495
22d0473fcc443c12be92e4b81249b84dff9e37e0	2020-08-28 16:16:53.571+00	9772110330
25a6e4d32e0460646077fbc4d523f622a544fce4	2020-08-28 15:53:45.921+00	9517505550
284cf1fc945845886e63c6669fca8bc8403bb003	2020-09-24 13:54:33.059+00	7705078595
2c3fd0d398fa3b2cd12569c6dcf11e45113c9e06	2020-08-28 17:28:14.193+00	7518894470
2e262f131cc0855d13be47075719c1fdcc77d5d1	2020-08-28 16:24:49.762+00	9118733514
2e98ae613bfee5567876df77fbcc84a0fbe10d9d	2020-08-29 07:51:09.583+00	8881989296
317ac3ed7848d08835ba89f5aafec2dd14ca2947	2020-08-28 17:45:25.437+00	8737942594
3a0aedfe79e637863fbb89d73c165795f8b4d311	2020-09-28 07:36:09.217+00	7905806732
3b1926b17376cabc7bd0e9310a89861f4f4d7d77	2020-08-30 06:00:59.285+00	7860080923
3b6c766164e04f083c694ceee5c9ff23f4e15a20	2020-08-28 15:59:17.103+00	7905124622
46fbcdac1e6242d8bb26de17c5e2e97c2eba690d	2020-09-28 15:04:35.953+00	7753966074
4857f19d824ae4c61977ed08244cb8c86439b495	2020-08-28 16:18:38.477+00	7317544896
4ec03ad6c77091c1e057ab48050d385f445de863	2020-08-28 17:14:54.781+00	7347753366
4f6f84910ff5b0fda028166713f51c503d9925b0	2020-08-28 16:23:49.728+00	8303307214
5430c281221f4555fa62eba851db12fd961fb7ff	2020-08-28 15:18:26.041+00	7737102386
5a16a7ae5f6414511d49d707db4bf2c1aaa03a94	2020-08-29 03:18:21.521+00	7052200095
5cda3de0605bd785b35be2621d4e0408fbda2718	2020-09-28 18:17:41.079+00	6855849137
5dc310e14e718684125f5de4b10529e25b90b1b9	2020-08-28 19:10:50.468+00	9696109124
6423024cb716d7bd41d717616eb8ea843cb96912	2020-09-28 08:50:51.189+00	6306416908
6456c2a5356c2842bf64624a92b0a595a2184136	2020-08-29 04:12:44.861+00	9120759992
657b60d53010713d1ba2dcf8a4e544ad2fe854fd	2020-08-28 14:55:07.412+00	8756636544
6a4c5292cc29d49dda07a5031affa16a42cf24b9	2020-08-29 03:58:45.074+00	7755830359
6a5ecfba481435c21326df026e679ac17c4d1d2a	2020-08-28 16:29:53.226+00	7619963044
6bd59aac167104214f05372fef89ac9a90ab5ec2	2020-09-28 08:03:35.292+00	9935682117
6e6b45309016bd39728ca398d487f5c275d1a724	2020-08-28 16:46:53.876+00	8400032481
74a73fae1532c832dc630078ec04c35035b721fb	2020-10-02 08:04:19.272+00	9198572009
7a8d6fc3615a565972336f6765cdf75d0b7b935d	2020-11-24 12:51:13.627944+00	8756516916
7b8deae76478280296fcda08376e885b4c5af50f	2020-08-28 15:58:35.323+00	6387466037
7bc94e781181ba5b15827bda0960aab9957ba670	2020-09-01 14:16:19.162+00	7317537460
8159d65c9c6a4102006a28a3f7878f945f213182	2020-08-28 15:47:39.216+00	9918751848
8195f2cba69061125557cf7a8b2c37bb1ccebfce	2020-08-29 04:49:27.218+00	6394694324
81ed2c6ff9f67624caeee7d4b3a95d9f87f96666	2020-08-28 16:43:27.105+00	7895706226
85b35a2e004b0ad3f24202827955a877e9e5a640	2020-08-29 04:32:11.188+00	7012345699
88b6b9a6e8762cb54aa1118162b673d4087defa1	2020-08-28 16:25:34.104+00	8957115191
92e14a29c789ad0b58792d3aa72bf3e22efadea5	2020-08-28 14:52:12.205+00	7007257972
94287d67f544bb1988e39368a24b6b40d173e826	2020-08-28 15:01:16.053+00	6391857675
9ea8e742a83dec2f341ffa578b3e37a28d312368	2020-09-17 09:34:24.197+00	9177914130
a0656fb9d125942b3ac7166fc8e2aa84138d2803	2020-08-28 16:04:38.299+00	7007436997
a06ce455d1cc2b2d95a344b10e346516cb8c9064	2020-08-29 03:14:19.618+00	7905547721
a4086d33bd4d492d8f13a971b26eac9960d47e69	2020-08-28 16:22:34.331+00	7906800363
a5fcaad0bc899bbd82a1ed8d5203381042a0175f	2020-08-29 03:14:00.029+00	8081842052
a8040da85add572cef9a0933e787881d489dbeb1	2020-08-28 17:17:55.587+00	9871966890
a911779d36040e071a07fc9aef8dba5c4c8f1d22	2020-08-29 04:01:55.389+00	8851709477
a94862c586cb07d7092083577a314bb60861ab2f	2020-08-28 14:57:54.605+00	6387348945
a97fb139bd1af9ab62637722efa72de82ce96471	2020-09-28 09:28:43.955+00	8127581701
b42cc8689c7f2ae7f690417eb10c610e4294f92c	2020-08-29 04:22:13.739+00	9084970825
b9888f1643fed9f3d6424bc13a167c9bc695e2dd	2020-08-29 12:51:29.174+00	7234840507
be5a68a7a51203cbc6b9e8f36d97401ba52188fa	2020-09-28 09:15:11.69+00	9555782418
c50eea85f4362957f35589a73c7eb979bace51cf	2020-08-29 06:25:53.768+00	8303263859
c67cb46521303cb241982afe62528b23e62338a5	2020-08-28 16:35:12.795+00	7081878499
c77076c83152478db7ea16505b7e35568f46f9e9	2020-08-29 01:44:02.276+00	6398301356
c91d4982c54a1d8eeb89d0eed97effc0a51fdb33	2020-08-29 03:36:57.931+00	7054548210
c962263182da5933a193091e5be1612895561470	2020-08-29 00:52:54.562+00	7310207098
cb8bbfae7466f6c1d87fab16c4d4a65331a09768	2020-08-28 17:02:41.279+00	9721528613
cd1da74130bf61522427a292bdb2c1cfa8ec095a	2020-08-28 15:50:09.25+00	7052546269
cdd80816e4a2c40098335338e67f71fff9d17478	2020-08-28 15:40:23.697+00	6387284707
ce58cee4a7f18739b3fad7b680bb96c5e985a709	2020-08-28 14:58:46.867+00	8429089691
cf82cfec6789acb0e8a7e2580e59bb8ff011f7b4	2020-08-28 17:19:10.15+00	9368732941
d00fe36c430e48417ba18c90059a7acf28990dcc	2020-08-29 12:02:57.546+00	7618806480
d1ccff25ea85cec9bb285bf325304911876afac5	2020-08-28 15:26:10.043+00	6307900213
d33cb0d79256ff4f4c78c55405c051fda06383cb	2020-08-29 08:26:05.424+00	8416970886
d3aed9fe362bc24d3219eb67932db454b5f38f8f	2020-08-28 16:30:39.469+00	7006332683
d4d63d65a438ed44ce6fb9939ea5a9d878e510c9	2020-08-28 15:05:55.749+00	8955118758
dc42caf7f83bf4828a683dbed731192721c4ea0a	2020-08-29 06:52:16.926+00	9660808647
e6170983019fd9b18a6455e922e9ad08755c0210	2020-08-28 14:55:14.123+00	6394094664
e9743e5cc2cef8a22f26a11aa9b90348575e4ac7	2020-08-28 16:18:24.771+00	9193075476
eca9ec1c8f5a797288135d06141111a44b1fb3c5	2020-08-28 17:12:29.752+00	7394029339
ed6d18ce9cbb7bb352fe9e7795a40af26ed1af4a	2020-08-28 16:40:03.07+00	8953643577
08c5eb4f0f5e39dc192daae66ef453e9a296d03d	2020-11-28 08:30:53.400628+00	8173047441
f10e60c3b43b2355c476c7fd3f7184c500360402	2020-08-28 16:48:38.802+00	8685809251
f5440a5073a59d27453a876f9d2b3480571b4220	2020-08-28 16:28:30+00	8473638494
f5a6c4a91656ad7cfd248a87475f3ad4d932b477	2020-08-30 13:13:46.182+00	7651892854
fd713dc422f5ce7cf56003da743cae7623d65c6a	2020-08-28 17:22:32.758+00	7905305951
c1bd53cb32a622049c26832fef787a198e54275b	2020-11-11 08:36:37.989751+00	7007320787
b098ddc1c393c391e2b180a413239c1f2a633e45	2020-11-25 05:29:36.620453+00	8932081360
b320e2391c3a6e3138bb4d1ff4343fa62a2578b3	2020-11-29 14:06:20.21157+00	9026457979
373a31b022b816a9903166ddd72efb3fd4918106	2020-11-16 20:48:18.79947+00	7080588884
ff7f546d3cd7b0aae925657e49a814e5182bc14a	2020-11-30 05:16:38.649526+00	9838712221
3808d0b5526cdb0e1da33bc0987a9cf65d824a58	2020-11-30 05:33:50.32807+00	8005089340
518ba5e517f293507db9aaf42e0386b47d057b19	2020-11-30 05:41:17.871848+00	7860626143
d4a94c7622e62dab4b8ac31d35b245e57fb2da94	2020-11-30 06:09:22.641465+00	7881168249
0d2ab5f803e6bbdb3e6cf9618ce3e084f7fda977	2020-11-30 06:42:59.355591+00	9653010765
91e5f506229a7e7948d416cef5334f6f6b88cffa	2020-11-30 06:47:46.314567+00	6392886167
1fef8b6f48b824433240c2c45a6b853647086666	2020-11-30 07:11:15.287118+00	8303902981
95c0aded4db89b7e3e537b14aae5a030d6af00b0	2020-11-30 09:34:26.879645+00	9140542655
f6d513941df4e380c09677f6236097ca917d6774	2020-11-30 15:53:10.180889+00	9696706036
18d9d406d7f89c6249689084d2cc092067e17060	2020-12-01 06:06:53.989098+00	9793656273
54cb73b67ebb2c752473b67c6dd26913e2a64967	2020-11-24 07:55:19.699121+00	8875309289
91409542f89ea9e6c3e21ea4bdd5b1ffa5093f42	2020-11-21 16:23:20.821672+00	9807211718
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2020-08-29 06:57:32.522+00	Z7uN_EOEqbzXajrW6TttwQ	Post object (Z7uN_EOEqbzXajrW6TttwQ)	3		10	insight_master
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
1	contenttypes	0001_initial	2020-11-09 08:52:20.907347+00
2	contenttypes	0002_remove_content_type_name	2020-11-09 08:52:20.932436+00
3	auth	0001_initial	2020-11-09 08:52:20.977655+00
4	auth	0002_alter_permission_name_max_length	2020-11-09 08:52:21.030567+00
5	auth	0003_alter_user_email_max_length	2020-11-09 08:52:21.047322+00
6	auth	0004_alter_user_username_opts	2020-11-09 08:52:21.061921+00
7	auth	0005_alter_user_last_login_null	2020-11-09 08:52:21.072775+00
8	auth	0006_require_contenttypes_0002	2020-11-09 08:52:21.076711+00
9	auth	0007_alter_validators_add_error_messages	2020-11-09 08:52:21.08892+00
10	auth	0008_alter_user_username_max_length	2020-11-09 08:52:21.099986+00
11	auth	0009_alter_user_last_name_max_length	2020-11-09 08:52:21.111955+00
12	auth	0010_alter_group_name_max_length	2020-11-09 08:52:21.129034+00
13	auth	0011_update_proxy_permissions	2020-11-09 08:52:21.144824+00
14	insight	0001_initial	2020-11-09 08:52:21.798478+00
15	admin	0001_initial	2020-11-09 08:52:22.032017+00
16	admin	0002_logentry_remove_auto_add	2020-11-09 08:52:22.07261+00
17	admin	0003_logentry_add_action_flag_choices	2020-11-09 08:52:22.114863+00
18	authtoken	0001_initial	2020-11-09 08:52:22.151379+00
19	authtoken	0002_auto_20160226_1747	2020-11-09 08:52:22.26902+00
20	insight	0002_auto_20201101_1731	2020-11-09 08:52:22.638588+00
21	insight	0003_auto_20201102_1726	2020-11-09 08:52:23.147896+00
22	insight	0004_auto_20201105_1617	2020-11-09 08:52:23.430217+00
23	insight	0005_auto_20201106_0959	2020-11-09 08:52:23.807168+00
24	sessions	0001_initial	2020-11-09 08:52:23.823458+00
25	insight	0006_auto_20201117_1240	2020-11-17 19:21:51.220985+00
26	insight	0007_auto_20201117_1921	2020-11-17 19:21:51.489347+00
27	insight	0008_auto_20201119_1516	2020-11-19 15:18:00.80004+00
28	insight	0009_auto_20201119_1517	2020-11-19 15:18:01.112726+00
29	insight	0007_auto_20201118_0536	2020-11-22 05:28:43.744138+00
30	insight	0008_auto_20201119_1003	2020-11-22 05:28:44.483622+00
31	insight	0009_auto_20201120_1844	2020-11-22 05:28:45.007445+00
32	insight	0010_auto_20201122_0459	2020-11-22 05:28:45.860034+00
33	insight	0011_merge_20201122_0511	2020-11-22 05:28:45.869946+00
34	insight	0011_auto_20201130_0953	2020-11-30 10:14:05.271462+00
35	insight	0012_auto_20201201_1811	2020-12-01 18:11:29.683037+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
1seeptgfw790pwla3dxgddczpwb6k1vh	YmRiZTdkOWE5MWZjODIxNjFkMDgxOTEzYjkzN2I2ZTQ0MTkxNGExMTp7Il9hdXRoX3VzZXJfaWQiOiJpbnNpZ2h0X21hc3RlciIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNGY2N2ZiYzk2NzFlYjc3MDg2NDI5NzlhNjYxNjFhMDMyNjlhZTI5YiJ9	2020-09-11 14:34:47.151+00
8q6i6c49129xu4ezw4al32yg2te43z6z	YmRiZTdkOWE5MWZjODIxNjFkMDgxOTEzYjkzN2I2ZTQ0MTkxNGExMTp7Il9hdXRoX3VzZXJfaWQiOiJpbnNpZ2h0X21hc3RlciIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNGY2N2ZiYzk2NzFlYjc3MDg2NDI5NzlhNjYxNjFhMDMyNjlhZTI5YiJ9	2020-10-12 19:16:05.916+00
gqouxt32kbwiogst3cqp24mpxvrxx4vs	MjI5ZDc0YmMyODJmZThkMDVkMzFlMDVkMDVlYWE4Y2U0NGRhNTM2YTp7Il9hdXRoX3VzZXJfaWQiOiJpbnNpZ2h0X21hc3RlciIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMTA5NDQ0YzNlYWNhODRiNjQxMGJlNWZjZGU3OTk4YWM0YTdmYjY4NCJ9	2020-09-02 20:18:46.629+00
hm2q2xwcy9sqpsvdkb2ozu32n8eca2ii	MjI5ZDc0YmMyODJmZThkMDVkMzFlMDVkMDVlYWE4Y2U0NGRhNTM2YTp7Il9hdXRoX3VzZXJfaWQiOiJpbnNpZ2h0X21hc3RlciIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiMTA5NDQ0YzNlYWNhODRiNjQxMGJlNWZjZGU3OTk4YWM0YTdmYjY4NCJ9	2020-09-06 10:46:17.678+00
xqvrqyve9yt8d69971qm2jhmo9tgleex	YmRiZTdkOWE5MWZjODIxNjFkMDgxOTEzYjkzN2I2ZTQ0MTkxNGExMTp7Il9hdXRoX3VzZXJfaWQiOiJpbnNpZ2h0X21hc3RlciIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiNGY2N2ZiYzk2NzFlYjc3MDg2NDI5NzlhNjYxNjFhMDMyNjlhZTI5YiJ9	2020-11-05 08:20:04.677+00
\.


--
-- Data for Name: insight_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_account (password, last_login, account_id, id_type, joined_at, username, first_name, last_name, is_staff, is_superuser, is_active, details, comfort_zones_text, activity_coords, avatar, places, hobby_map, primary_hobby, primary_weight, follower_count, following_count, description, following, current_coord, new_notification, country_code) FROM stdin;
pbkdf2_sha256$180000$WFzmm42c5CyF$n7scyW6VxbCjD9Tj3BNS4SdAGZri+gQ8g1nfumjQoHc=	\N	6306416908	PHONE	2020-09-24	Harshit Gupta	Harshit	Gupta	f	f	t	{"email": "guptaharshit0417@gmail.com", "phone_number": "6306416908"}	{}	{}		{}	{"photography625": 0.2, "graphicsdesign250": 0.2}	graphicsdesign250	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$ppNCFPt81IJx$kEe7MT+h7xUEYziZLDFq+xkEi2bQ1sSzdvej19waERw=	\N	6307900213	PHONE	2020-08-28	Vinayak shukla	Vinayak	Shukla	f	f	t	{"email": "Shuklavinayakshukla@gmail.com", "phone_number": "6307900213"}	{}	{}		{}	{"thoughts525": 1.25}	thoughts525	5.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$6UjIuLUawo3m$8aKC4cUHpRhBs9OIfgm8k6Y4VAdxgQF0VdyTal+PvO8=	\N	6386240651	PHONE	2020-08-28	Anuptiwari2001	Anupam	Tiwari	f	f	t	{"email": "anupamt980@gmail.com", "phone_number": "6386240651"}	{}	{}		{}	{"poetry550": 0.8999999999999999, "quotes500": 0.5, "thoughts525": 0.25, "photography625": 3.8500000000000005, "graphicsdesign250": 0.5}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$32yjFV2e073f$JSEq+3scTDOWr9DnpLi9azShWWMgpoEaDrxEQIi7wV4=	\N	6387284707	PHONE	2020-08-28	Anubhav@123	Anubhav	Singh	f	f	t	{"email": "anubhavsingh9517@gmail.com", "phone_number": "6387284707"}	{}	{}		{}	{"thoughts525": 2.25, "photography625": 0.75}	thoughts525	5.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$PDauR0q6xTp1$ttbALYpfO4Geu+VL8ROe+HFy3gaxR/TDAYO5YcKpMKc=	\N	6387348945	PHONE	2020-08-28	timus1	Sumit 	Singh	f	f	t	{"email": "singhsumitbizz@gmail.com", "phone_number": "6387348945"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FESELa4yx3rCYjSnbLHDtLtLP4FnlNSAO.jpeg?alt=media&token=b13ae2b4-0c1f-4c68-a051-72bd1a9581ad	{}	{"poetry550": 1.5999999999999999, "quotes500": 2.0, "cooking925": 1.5, "computer125": 0.5, "thoughts525": 2.5, "astronomy325": 0.7, "gardening950": 1.5, "sketching425": 1.4, "photography625": 21.899999999999984, "videography650": 0.8999999999999999, "graphicsdesign250": 1.0}	graphicsdesign250	21.70	0	1		{7007257972}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$XxT3w0jKcj6m$G9a9iVI9loPgKGCiiPVpDZrvQ0kM5I6LkNE5VltjPk8=	\N	6387466037	PHONE	2020-08-28	Shivansh@123	Shivansh	Pandey	f	f	t	{"email": "140shivanshpandey@gmail.com", "phone_number": "6387466037"}	{}	{}		{}	{"thoughts525": 0.25, "photography625": 0.25, "graphicsdesign250": 0.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$L8fI5JlLQ4Y2$5AZCWPGhD1VeiwxX1xWz3SbZ/UfgbtibflcOLMv+AeQ=	\N	6391857675	PHONE	2020-08-28	anubhavpatel	Anubhav 	Patel	f	f	t	{"email": "anubhavpatel6391@gmail.com", "phone_number": "6391857675"}	{}	{}		{}	{"poetry550": 3.2, "cooking925": 0.2, "thoughts525": 0.8, "gardening950": 0.2, "photography625": 3.300000000000001, "graphicsdesign250": 1.05}	poetry550	5.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$tv9gqjoYctfc$2GzKCm91TwbiSpt4KseQN8FjItdem3oH4xBpP/Ji7Pw=	\N	6394094664	PHONE	2020-08-28	Mritunjay singh	Mritunjay	Singh	f	f	t	{"email": "mritunjai2000@gmail.com", "phone_number": "6394094664"}	{}	{}		{}	{"poetry550": 1.25, "photography625": 1.5, "graphicsdesign250": 0.75}	photography625	6.25	0	1	freelancer makeup artist	{8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$pu8wkUbfTwwG$NG+Q1M9meqXtvtPy2tBk2xMaZyKGQJqkQWlWCp/GgMs=	\N	6398301356	PHONE	2020-08-29	Samaksh	Sam 	U	f	f	t	{"email": "ujjwalsamaksh@gmail.com", "phone_number": "6398301356"}	{}	{}		{}	{"photography625": 0.6000000000000001, "videography650": 1.7999999999999998}	videography650	6.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$exCVGgq2ObMJ$Pd7KH70XqXjxMjtxfguTXHxo/hjTa/GUtrdFfEUBNGs=	\N	6855849137	PHONE	2020-09-24	Sonali	Sonali	Singh	f	f	t	{"email": "snbsjsis@gmail.com", "phone_number": "6855849137"}	{}	{}		{}	{"photography625": 0.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$7MwFFBWFt0Y4$Ofk3O7DbgprS8foxFn9pd+REok7mWlYR1K8wAm6cSOU=	\N	7006332683	PHONE	2020-08-28	Kanhaiya_24	Kanhaiya	Mahajan	f	f	t	{"email": "Kanhaiyagupta2407@gmail.com", "phone_number": "7006332683"}	{}	{}		{}	{"photography625": 1.75}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$99oFy5YjEw9F$Xhj93vi8ivEztZ72Bx1+o8fAlnwRHV7eNuttAYG/Zs4=	\N	7905806732	PHONE	2020-09-24	Pawan Saroj	Pawan 	Saroj 	f	f	t	{"email": "Pawan2000saroj@gmail.com ", "phone_number": "7905806732"}	{}	{}		{}	{"poetry550": 0.2, "photography625": 0.2}	poetry550	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$ZyyfSH8UgPwu$NJVtTN2OGItz8Jyft81+Q7w1RIi99H5SUGzhyES4Grk=	\N	6394694324	PHONE	2020-08-29	Santripti Verma	Santripti	Verma	f	f	t	{"email": "santriptiverma@gmail.com", "phone_number": "6394694324"}	{}	{}		{}	{"poetry550": 1.3, "quotes500": 0.7, "cooking925": 4.6, "computer125": 0.2, "astronomy325": 1.5, "gardening950": 3.2, "photography625": 6.0, "videography650": 0.2}	photography625	6.00	1	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$4f19XDeAfivM$hCOW48j5RkAn1flipLccm6eoZPYTFx5Dj7UL/cDe2CE=	\N	7012345699	PHONE	2020-08-29	James bond	James	Bond	f	f	t	{"email": "p@gmail.com", "phone_number": "7012345699"}	{}	{}		{}	{"poetry550": 1.0, "cooking925": 0.2, "photography625": 1.5}	poetry550	5.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$yfHiwGHOTj5a$KZn3CMW9Ol6E1oWiJL2c+6n7mCM6ygAUYtAFU8M3oeI=	\N	7052200095	PHONE	2020-08-29	Dark night	Bholu	Rai	f	f	t	{"email": "raj.meer0095@gmail.com ", "phone_number": "7052200095"}	{}	{}		{}	{"poetry550": 0.5, "cooking925": 0.5, "gardening950": 0.4, "photography625": 3.9000000000000012, "videography650": 0.8}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$ksqsrDlu4y37$MNEJbS4MowIQzS06lTw1mYy+FmeGef1ElaC9K0CISC4=	\N	7052546269	PHONE	2020-08-28	Harshitaa	Harshita	Srivastava	f	f	t	{"email": "harshita1012@rediffmail.con", "phone_number": "7052546269"}	{}	{}		{}	{"poetry550": 0.7, "quotes500": 1.2, "thoughts525": 0.5, "gardening950": 0.5, "photography625": 3.150000000000001, "videography650": 1.2, "graphicsdesign250": 0.8500000000000001}	graphicsdesign250	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$4J5WmqKPNMHO$bvqhd3QwfyOG5ENeCCFcZibM93x2/KA8KlFVC6AqoEA=	\N	7054548210	PHONE	2020-08-29	Servendra	Servendra	Tiwari	f	f	t	{"email": "tiwariservendra99@gmail.com", "phone_number": "7054548210"}	{}	{}		{}	{"thoughts525": 0.2, "gardening950": 0.2, "photography625": 2.3000000000000003, "graphicsdesign250": 0.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$kZ7fRpy7G3r0$/WRrbo06p51mqkPKLlC+T/nqsqKPUBjCpN6baxME+B8=	\N	7081878499	PHONE	2020-08-28	jaiswal	Piyush 	Jaiswal 	f	f	t	{"email": "iampiyushjaiswal103@gmail.com ", "phone_number": "7081878499"}	{}	{}		{}	{"poetry550": 0.7, "quotes500": 0.45, "cooking925": 2.7, "gardening950": 0.25, "photography625": 9.05, "videography650": 1.0999999999999999, "graphicsdesign250": 0.8500000000000001}	graphicsdesign250	6.45	0	1		{8953643577}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$nJjLRCRy7MwX$hJphgJhdGG0YcfGivHCBn2+nGT/EBrqOgWZj+46sWs8=	\N	7234840507	PHONE	2020-08-29	Pg@0711	Prashant	Kumar giri	f	f	t	{"email": "prashantgiri0711@gmail.com", "phone_number": "7234840507"}	{}	{}		{}	{"cooking925": 0.4, "computer125": 0.2, "gardening950": 0.4, "sketching425": 0.2, "photography625": 0.6000000000000001, "videography650": 0.2}	cooking925	9.25	1	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$jELt3gFwlkfa$9iqWq9Nafu3Q2/pZ6vAmPPQZeBMDGCDp3yvyCsV2SP4=	\N	7310207098	PHONE	2020-08-29	ROHAN SHUKLA	ROHAN	SHUKLA	f	f	t	{"email": "rohanshuklabiker2000@gmail.com", "phone_number": "7310207098"}	{}	{}		{}	{"videography650": 2.1999999999999997}	videography650	6.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$q7KPiuzmRYkq$i1xSvrCuDJqMJZ08uI2j+Ta3hlQxhI4BqHTeWj5mMFQ=	\N	7317537460	PHONE	2020-08-31	SanaAfreen	Sana	Afreen	f	f	t	{"email": "sanaafreen775@gmail.com", "phone_number": "7317537460"}	{}	{}		{}	{"photography625": 0.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$pbuxOpGtJRRg$DaDmeEb+GKsEHi5UEpByxkVT73rUSrcV1v9zbHZ+ZzY=	\N	7317544896	PHONE	2020-08-28	basti123	Ekagra 	Agrawal 	f	f	t	{"email": "akagraagarwal89@gmail.com ", "phone_number": "7317544896"}	{}	{}		{}	{"thoughts525": 0.25, "photography625": 1.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$5r8O2AA11CKt$/vRbnJfOSrVhDy8Jp441a6r2ZfUjDC9gUDT/a2bMfBU=	\N	7394029339	PHONE	2020-08-28	dwivedi.ashutosh	Ashutosh	Dwivedi	f	f	t	{"email": "dwivedi.ash007@gmail.com", "phone_number": "7394029339"}	{}	{}		{}	{"cooking925": 2.75, "photography625": 1.0}	cooking925	9.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$3jouqmrBqWuz$fnojo1lPFOETh87nw2BqaYmXRlyCTF6GuV25XUbh2AA=	\N	7007436997	PHONE	2020-08-28	The_lone_wolf	Shaquib	Khan	f	f	t	{"email": "mohammadshaquib4@gmail.com", "phone_number": "7007436997"}	{}	{}		{}	{"poetry550": 7.950000000000002, "quotes500": 1.95, "cooking925": 7.950000000000001, "computer125": 0.7, "thoughts525": 2.3999999999999995, "astronomy325": 1.9, "gardening950": 3.6500000000000004, "sketching425": 0.8999999999999999, "photography625": 52.500000000000064, "videography650": 6.650000000000003, "graphicsdesign250": 9.850000000000001}	graphicsdesign250	42.30	9	4		{8953643577,7347753366,9026457979,7518894470}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$bCb9W7tdg8Kv$XVCpo9KeOaEPmu2lNv/x1r0/doomcYQKhJ/utyVJxyI=	\N	7618806480	PHONE	2020-08-29	arpit555chaurasiya@gmail.com	7618806480	Arpit123	f	f	t	{"email": "arpit555chaurasiya@gmail.com", "phone_number": "7618806480"}	{}	{}		{}	{"poetry550": 0.2, "cooking925": 0.6000000000000001, "gardening950": 0.4, "sketching425": 0.2, "photography625": 0.8, "videography650": 0.2}	cooking925	9.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$kJzesz7RQ6k1$nE4NU72wz9amTxCfCdLyEM6X9D3YSzsP2KP3SY6YIHc=	\N	7651892854	PHONE	2020-08-29	ashcroft	Adarsh	Gupta	f	f	t	{"email": "iadarshgupta@gmail.com", "phone_number": "7651892854"}	{}	{}		{}	{"poetry550": 0.4, "quotes500": 0.5, "cooking925": 0.6000000000000001, "astronomy325": 0.4, "gardening950": 0.2, "sketching425": 0.2, "photography625": 1.4999999999999998, "videography650": 0.2, "graphicsdesign250": 0.2}	photography625	6.25	0	2		{8005089340,9026457979}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$IR8knf2c1Ukw$XnKhqbbZcumJWeKxj4g0xljmlcr8TAJjHqIZQhr2efY=	\N	7705078595	PHONE	2020-09-24	amitrajaug24@	Amit	Raj	f	f	t	{"email": "amitrajaug24@gmail.com", "phone_number": "7705078595"}	{}	{}		{}	{"quotes500": 0.5, "photography625": 0.2}	quotes500	6.25	0	1		{8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$jnkzeXtVkk9i$AHLUuNtOoPdwQg5qQYcbPJ5cPeaDBYQT/H69vEHLDdU=	\N	7753966074	PHONE	2020-09-24	Lavkush Gupta	Lavkush	Gupta	f	f	t	{"email": "lavkushgupta609@gmail.com", "phone_number": "7753966074"}	{}	{}		{}	{"photography625": 0.2}	photography625	6.25	0	1		{8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$ycsEtpO91Sir$Kr90CtdNKusPR5rViXr1GCmQ2gkiqrOiAB1qaaSrLBE=	\N	7755830359	PHONE	2020-08-29	Arnika	Arnika	Kaithwas 	f	f	t	{"email": "arnikakaithwas1@gmail.com", "phone_number": "7755830359"}	{}	{}		{}	{"photography625": 0.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$jnZjVW3T3fAC$N0hGhvX5BBkDq9lFICzdmz1f0k8JmCMDiNcQvxT9d2A=	\N	7860080923	PHONE	2020-08-29	Ankit Shahi	Ankit	Shahi	f	f	t	{"email": "ankitshahi225@gmail.com", "phone_number": "7860080923"}	{}	{}		{}	{"quotes500": 0.2, "cooking925": 0.2, "photography625": 0.4}	photography625	6.25	0	1		{8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$OmF0LYGtNv8F$w9mzSsK6hW2dWiun9vd2eQ2Y9KYtEZrAr7S9QV+tXsM=	\N	7895706226	PHONE	2020-08-28	Brutal 	Sparsh 	Kumar 	f	f	t	{"email": "sparsh4748@gmail.com ", "phone_number": "7895706226"}	{}	{}		{}	{"photography625": 1.0}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$U2f1v2zUJu5j$Ata+0uzIFS7Ep9V1j+igtTsGN8U7ykzckz/3a1dl2lg=	\N	7905124622	PHONE	2020-08-28	Balram yadav	Balram	yadav	f	f	t	{"email": "by353357@gmail.com", "phone_number": "7905124622"}	{}	{}		{}	{"photography625": 2.35}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$dwJqBfo8cia9$As/tMpnpWdBICnbUrh/CPCCe1rRsNpMFzePU+C1nzqQ=	\N	7905305951	PHONE	2020-08-28	Yatendra	Yatendra B	Pal	f	f	t	{"email": "ankitpalgkp20@gmail.com ", "phone_number": "7905305951"}	{}	{}		{}	{"poetry550": 0.25, "cooking925": 0.25, "gardening950": 1.0, "photography625": 1.2, "graphicsdesign250": 0.5}	gardening950	9.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$gk1Q1tLRgcPT$by0dCVyYLtbWasLbB+ZI34+AqLSt5CzRHNV02ijQHZI=	\N	7905547721	PHONE	2020-08-29	Rohan shukla	Rohan shukla	Rohan shukla	f	f	t	{"email": "rohanshuklabiker2000@gmail.com", "phone_number": "7905547721"}	{}	{}		{}	{"photography625": 1.9999999999999998, "videography650": 0.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$LyxoZE14jv6N$ECIz/TRJChyBtfjcXrZ1rjDQe93gTyHdoxtQbiOhPAs=	\N	7737102386	PHONE	2020-08-28	@aman@_	Aman	Tiwari	f	f	t	{"email": "Amantiwariald18@gmail.com ", "phone_number": "7737102386"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F7CrBPaEo27aaj06cgHZuQ5uOcLBGv1M2.jpeg?alt=media&token=45081ec4-aa15-4d3e-805d-6022e84bb2f0	{}	{"poetry550": 8.000000000000002, "quotes500": 2.95, "cooking925": 4.550000000000001, "computer125": 0.7, "thoughts525": 7.8500000000000005, "astronomy325": 1.7, "gardening950": 1.8, "sketching425": 1.0, "photography625": 60.75000000000012, "videography650": 2.4, "graphicsdesign250": 10.95}	graphicsdesign250	54.45	11	6		{7007257972,8429089691,7518894470,8756636544,9026457979,9120759992}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$rPGUnXH9uigk$MDnGNJ/BKdwpE1NOz4Ap1vMElK0eCl8ivioJcGlstuY=	\N	7906800363	PHONE	2020-08-28	aaharshit87	Harshit	Gupta	f	f	t	{"email": "aaharshitgupta87@gmail.com", "phone_number": "7906800363"}	{}	{}		{}	{"photography625": 0.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$WJckMlrajVB2$qbMFse3E+sH2KAhBuHD81/4381RJHS1OmLtHjHDpn9k=	\N	8081842052	PHONE	2020-08-29	Ankitsingh	ankit	Singh	f	f	t	{"email": "ankitsinghmau002@gmail.com", "phone_number": "8081842052"}	{}	{}		{}	{"cooking925": 0.2, "gardening950": 0.2, "photography625": 3.800000000000001, "videography650": 0.7}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$pwMxKNdbOWgK$DmLIwQ8PQem19dQZJ7i/v0XI8L1Ay2OfO4JdApsb7v0=	\N	8082091408	PHONE	2020-08-28	Ashikp	Ashirvad kar	Pathak	f	f	t	{"email": "ashirvadkp33@gmail.com", "phone_number": "8082091408"}	{}	{}		{}	{"poetry550": 1.2, "quotes500": 0.5, "cooking925": 0.5, "thoughts525": 0.75, "gardening950": 0.5, "photography625": 4.25, "videography650": 0.5, "graphicsdesign250": 0.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$YYDTVg6vEmLj$ZZqPIBfZA3PjEyOM+tApbfn5SLGCy7Y+PnGXW+Vw2z8=	\N	8127581701	PHONE	2020-09-24	Chandramani Mishra	Chandramani	Mishra	f	f	t	{"email": "Chandramanimishra8853@gmail.com", "phone_number": "8127581701"}	{}	{}		{}	{"poetry550": 0.2, "cooking925": 0.2, "astronomy325": 0.2, "gardening950": 0.5, "sketching425": 0.2, "photography625": 2.900000000000001, "videography650": 0.2, "graphicsdesign250": 0.7}	poetry550	6.25	0	2		{8005089340,8756516916}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$O3ErjhsAERzS$9UY4tRLCyGuYFiPLLxEJ4XsRWoH3vLlrDHaTfZnb83k=	\N	8303307214	PHONE	2020-08-28	Divya1328	Divya	Sharma	f	f	t	{"email": "bhattakanksha81@gmail.com", "phone_number": "8303307214"}	{}	{}		{}	{"photography625": 0.5}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$nsw1ZNcpAqHC$D3k6S912bU8Z0TXpV8L+v0UBRpVh/YaTcAoYR1IrmVg=	\N	8400032481	PHONE	2020-08-28	divyanshi9	Divyanshi	Mishra	f	f	t	{"email": "divyanshi2102@gmail.com", "phone_number": "8400032481"}	{}	{}		{}	{"photography625": 1.0}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$yoDtZWTHqbHQ$iBvAu4UVD5TLqS6tbeSYQ/GESIZ077MvJPRJbV1bpEA=	\N	8400735434	PHONE	2020-08-28	Prakash Pandey	Prakash	Pandey	f	f	t	{"email": "prakash1682001pandey@gmail.com", "phone_number": "8400735434"}	{}	{}		{}	{"poetry550": 0.75, "cooking925": 0.25, "photography625": 1.65, "graphicsdesign250": 0.25}	photography625	6.25	0	1		{7007436997}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$qzCLuDUTfx3P$3ezowrEJPw81W73ofKDi9Uvhbp62NKvf0IOlhi0IV44=	\N	8416970886	PHONE	2020-08-29	Pk_mishra	Prashant 	Mishra	f	f	t	{"email": "pm7487912@gmail.com", "phone_number": "8416970886"}	{}	{}		{}	{"cooking925": 0.2, "computer125": 0.2, "sketching425": 0.2, "photography625": 1.0}	computer125	1.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$NIG8HK077FRU$3UEAY8l1qrv35zWrsrlgymEfb1kVnPoE6yebMDBWZmo=	\N	8473638494	PHONE	2020-08-28	Sam123	Sam	singh	f	f	t	{"email": "sjja@gmail.com", "phone_number": "8473638494"}	{}	{}		{}	{"photography625": 0.5}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$89TmVUW2Ttka$C/93Odgdt1gJASQX+u3KM7ENw5kSZ5UkfjFv1peE4/M=	\N	8303263859	PHONE	2020-08-29	Trapti	Trapti	Gangwar	f	f	t	{"email": "Twar705@gmail.com", "phone_number": "8303263859"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FwRqmL3nqbW4deudCWz41Yr2fS8Q1mJhX.jpeg?alt=media&token=8c1a4ab4-07f4-4ee8-b06c-ab30ac8393f3	{}	{"poetry550": 2.2, "quotes500": 0.5, "cooking925": 3.2, "computer125": 0.2, "astronomy325": 0.7, "gardening950": 2.5, "sketching425": 6.000000000000003, "photography625": 13.499999999999998}	photography625	13.30	1	1		{8953643577}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$lq3e5eokyNk1$Sh+Rzu+3yw8UBEc8WdjuDUgEqD+Z2pcBQCssue5/FS4=	\N	8429089691	PHONE	2020-08-28	Shivamyadav	Shivam	Yadav	f	f	t	{"email": "shivamsdlv42@gmail.com", "phone_number": "8429089691"}	{}	{}		{}	{"poetry550": 0.5, "quotes500": 1.2, "cooking925": 1.7, "thoughts525": 2.75, "photography625": 16.7, "graphicsdesign250": 6.65}	graphicsdesign250	16.50	6	5		{8005089340,7007257972,8756636544,8955118758,7737102386}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$OBKotmlzmgOA$zz00mvGiyxUr/3NfC4f0hayMJNvjAc0dFO97jw6izms=	\N	8685809251	PHONE	2020-08-28	Dishant Yadav	Dishant	Yadav	f	f	t	{"email": "dishantyadav612@gmail.com", "phone_number": "8685809251"}	{}	{}		{}	{"photography625": 2.65}	photography625	6.25	4	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$8KAIXOgVJIyv$gceQ5jiPyC+hd0ppKfCwiNW4IdTHY87GsfrkkuCzvVI=	\N	9838712221	PHONE	2020-11-27	TheStarkster	Abhijit	Dhar	f	f	t	{"email": "abhijit10102000@gmail.com", "phone_number": "9838712221"}	{}	{}		{}	{}	thoughts525	0.00	2	3	Can you look at Me without any BIASES??\n•••\nMedicos⚕️, Photon💥, Sarcastic🙃, Replicator🔄, Neuroticछोकरा🎭, Biomimic🦋	{8756516916,8303902981,9140542655}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$8v3idU6qjuF0$wPQAdQoQbN3RNFdlv2wEwFLAPWs316oFQY7ttJ3rypU=	\N	8851709477	PHONE	2020-08-29	tiwarishankar	Shankar	Tiwari	f	f	t	{"email": "tiwarishankar587@gmail.com", "phone_number": "8851709477"}	{}	{}		{}	{"sketching425": 0.4, "photography625": 2.1999999999999997, "videography650": 0.5}	photography625	6.25	0	1		{7737102386}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$L3010RROKnhE$ZrX6rrrkJlCMQQB0/CqQjfI1WG2I6F6+cgDv7ZEbLOw=	\N	8881989296	PHONE	2020-08-29	Siddharth Shukla	Alok	Shukla 	f	f	t	{"email": "sidalok3002@gmail.com ", "phone_number": "8881989296"}	{}	{}		{}	{"computer125": 2.1, "sketching425": 1.7999999999999998, "photography625": 0.2, "videography650": 0.2}	sketching425	4.25	1	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$IgAe5HW7fDVv$WVCRCs8VgQZuYlrp7tmzbWFwyXEt3KZC2Mpet61hOwc=	\N	8957115191	PHONE	2020-08-28	Napolean	Shubham	Kumar	f	f	t	{"email": "shubham150602@gmail.com", "phone_number": "8957115191"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FL22F7G0RibxLg3pjeZhSngGLMcVBL5Kc.jpeg?alt=media&token=f10bb26c-de32-45c7-93c2-d1e1f6be89b5	{}	{"poetry550": 0.5, "quotes500": 1.25, "thoughts525": 1.75, "photography625": 14.5, "graphicsdesign250": 4.75}	photography625	14.50	0	5		{7737102386,8756636544,7007257972,8955118758,8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$YuPPqE8SGs9V$D1np56vpf22CrItvVOuzI6nm3sxVIknn1X8B3T335Ow=	\N	9084970825	PHONE	2020-08-29	ag742757@gmail.com	Abhishek	Gupta	f	f	t	{"email": "ag742757@gmail.com", "phone_number": "9084970825"}	{}	{}		{}	{"photography625": 0.4}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$TTGqylPRGPqt$4r6SN1NFSRMHEKk9gXnmlWGcdVzkRsmchwQIU+t2YFI=	\N	8756636544	PHONE	2020-08-28	KingShivam	Shivam	Gupta	f	f	t	{"email": "sg505867@gmail.com", "phone_number": "8756636544"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FKqQwzE2d382n0zuRdqQ4XAkvutNYKKYy.jpeg?alt=media&token=c9464055-9cab-4ddf-ab73-38c76157bc19	{}	{"thoughts525": 1.4, "photography625": 1.75}	photography625	6.25	3	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$5swAciI3vmBK$j9hVnf7qe7Hlppbtw7Tqb0aL2UjDgecUFKPqikKnIQE=	\N	8953643577	PHONE	2020-08-28	Shruti	Shruti	Singh	f	f	t	{"email": "shruti.singh2601@gmail.com", "phone_number": "8953643577"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FXyHiS27rXMCBHvRm7ZUbJeL0f0svabLK.jpeg?alt=media&token=04634b4e-1899-4b78-9fff-8cb7b4231357	{}	{"poetry550": 2.15, "cooking925": 4.8500000000000005, "computer125": 0.2, "gardening950": 6.6000000000000005, "sketching425": 1.4999999999999998, "photography625": 26.399999999999984, "graphicsdesign250": 0.45}	photography625	26.40	9	6	Livsnjutare	{8429089691,7007436997,7347753366,7518894470,7007257972,8303263859}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$rOwj7jF05hm1$48rr4WUWT3iwO6uQ9Bdt5qZehWzddQc5oTPP3CrI4AI=	\N	8955118758	PHONE	2020-08-28	Sanjeet45	Sanjeet	Maurya	f	f	t	{"email": "skmaurya436@gmail.com", "phone_number": "8955118758"}	{}	{}		{}	{"thoughts525": 1.0, "graphicsdesign250": 1.65}	graphicsdesign250	2.50	5	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$wOdsmVIcsjNo$l5p44y7c8ZHFVbuLTZO9oBULN63OV7I3VdHtgiUpbcY=	\N	8737942594	PHONE	2020-08-28	Nitesh	Neetesh	Kumar	f	f	t	{"email": "neetesh1412002@gmail.com", "phone_number": "8737942594"}	{}	{}		{}	{"poetry550": 1.7499999999999998, "cooking925": 1.2, "gardening950": 0.75, "photography625": 6.900000000000001, "graphicsdesign250": 0.2}	graphicsdesign250	6.25	1	6		{7518894470,7007436997,7737102386,8685809251,8429089691,7007257972}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$TeoM4Gs92OC6$QqWaQID93z2geVvhTV8CHcYgfQCddJvSJJp+DqTOHbI=	\N	8932081360	PHONE	2020-08-29	amit8932@	Amit 	Kumar	f	f	t	{"email": "golukumaramit001@gmail.com", "phone_number": "8932081360"}	{}	{}		{}	{"quotes500": 0.2, "cooking925": 0.2, "photography625": 1.5}	photography625	6.25	1	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$zDJsXQwqYCZc$xxjfuwZ/gpIshNS3HKmud4lFXcXPDch5O2LpTNhAIuw=	\N	9118733514	PHONE	2020-08-28	tiwariu643	Utkarsh	Tiwari	f	f	t	{"email": "tiwariu643@gmail.com", "phone_number": "9118733514"}	{}	{}		{}	{"poetry550": 0.5, "quotes500": 0.5, "thoughts525": 0.5, "astronomy325": 0.2, "photography625": 1.25, "videography650": 0.6000000000000001, "graphicsdesign250": 0.75}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$0zImfKkL7AyN$VhJCrI7HvaxmKhk4hScjjOPB7CT71kximeLp6vf3jjs=	\N	9119143495	PHONE	2020-09-24	Fareha	Fareha	Siddiqui	f	f	t	{"email": "Siddiquifareha5@gmail.com ", "phone_number": "9119143495"}	{}	{}		{}	{"photography625": 0.2}	photography625	6.25	1	1		{8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$yOML1Bpgi71E$aSNiq9MTv8z3o9EQlxowieohqkN9IMdPuPq82PpwD7I=	\N	9120759992	PHONE	2020-08-29	_chailover_	Shivang	Sharma	f	f	t	{"email": "shivangsharma6786@gmail.com", "phone_number": "9120759992"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F93FXpJuWQXWKjmHSuQMGgWFt7tznl6zZ.jpeg?alt=media&token=7d64de9e-4f60-488e-a025-fd41fe8e0006	{}	{"poetry550": 2.5, "quotes500": 0.2, "astronomy325": 0.2, "sketching425": 1.2, "photography625": 1.9}	photography625	6.25	3	2		{6392886167,6392886167}	0101000020E610000000000000000000000000000000000000	t	+91
pbkdf2_sha256$180000$kpjiVb1GeVb0$FBBDj/ayALM+xJmvRJFZaOTNz5LRkdjho2j9o2jnlDE=	\N	9140471417	PHONE	2020-08-28	Kamakshi#66	Kamakshi	Gupta	f	f	t	{"email": "kamakshigupta262@gmail.com", "phone_number": "9140471417"}	{}	{}		{}	{"photography625": 0.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$wdjf4a0nqHIu$iHatrIvnK0yjWY5oHkBSRPCiyLfeWp/knEVJYFNVy0U=	\N	9177914130	PHONE	2020-09-06	Rishabh	Rishabh	Palnesto	f	f	t	{"email": "rishabhhurshan1@gmail.com", "phone_number": "9177914130"}	{}	{}		{}	{"poetry550": 0.2, "photography625": 0.2, "graphicsdesign250": 1.1}	poetry550	5.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$155L8UheLHyn$hyZ4zN+DL6/LUEjLDM0MHs8FicDShz5VXxThf+Gs8wM=	\N	9193075476	PHONE	2020-08-28	Lakki_00_01	Lakshayveer	Baliyan	f	f	t	{"email": "Veer.baliyan.01@gmail.com", "phone_number": "9193075476"}	{}	{}		{}	{"photography625": 1.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$pOFhJGxC68H8$jJaKOeTJVnrDuCTiemT/Wj2kKAROnkDNg7oWW75aBNo=	\N	9198572009	PHONE	2020-10-02	Amarnath	Amarnath	Nishad	f	f	t	{"email": "amarnathnishad03953@gmail.com", "phone_number": "9198572009"}	{}	{}		{}	{"photography625": 0.8, "graphicsdesign250": 0.4}	graphicsdesign250	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$cyGV68ldHVGd$r4eXJieW2iroo4GQ2XebsgURzkr/VVeNTvjqRCF3Pz8=	\N	9336394079	PHONE	2020-09-24	Shivii	Sandy	Dhuriya	f	f	t	{"email": "shivi2001dhuriya4321@gmail.com", "phone_number": "9336394079"}	{}	{}		{}	{"cooking925": 0.2, "photography625": 1.7999999999999998, "graphicsdesign250": 0.2}	graphicsdesign250	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$vCUklb9Nv5G9$4AH+jNdBFX46BKWcuqyZRfkZAhh6yi7YY+Nw48i8rSs=	\N	9368732941	PHONE	2020-08-28	Little Princess 	Taniya 	Agarwal	f	f	t	{"email": "agarwaltaniya49@gmail.com", "phone_number": "9368732941"}	{}	{}		{}	{"cooking925": 0.5, "gardening950": 1.25}	cooking925	9.25	0	1		{8953643577}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$WceZgJQsmW44$CPdtGzRz7KLNbG+ISte3Mnghpc8FoLpUR1zDFAKvf+U=	\N	9517505550	PHONE	2020-08-28	sarvesh	Sarvesh	Dubey	f	f	t	{"email": "sarveshkumardubey552@gmail.com", "phone_number": "9517505550"}	{}	{}		{}	{"photography625": 0.5}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$ZALV23U6C5aQ$QTdxJcl/FhbT7VjeLuPFB37R9rvJDkVDmfIwoGlMQKA=	\N	9555782418	PHONE	2020-09-24	@saroj	Ashish	Saroj	f	f	t	{"email": "ashishkumarsaroj1262000@gmail.com", "phone_number": "9555782418"}	{}	{}		{}	{"photography625": 0.8999999999999999, "graphicsdesign250": 0.2}	graphicsdesign250	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$VzAfdZU7pN6c$kEVdfDCQDEKjULcKww6WY26nbNSISyQXKtrlyLb2l/4=	\N	9598239351	PHONE	2020-09-24	Ratnakar shukla	Ratnakar	Shukla	f	f	t	{"email": "ratnakarshukla987@gmail.com", "phone_number": "9598239351"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FO0Bte0DbpK5YnPmGxZFGHx5VSY8Ej2m3.jpeg?alt=media&token=54c3f0e3-7457-4ddb-a9ad-64b013f136aa	{}	{"poetry550": 0.2, "quotes500": 0.2, "cooking925": 0.4, "astronomy325": 0.8999999999999999, "sketching425": 0.2, "photography625": 0.6000000000000001, "graphicsdesign250": 0.2}	graphicsdesign250	6.25	0	2		{8756516916,8005089340}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$QhxUdIPS99ZU$u2J9s/2fUZfLFyGVGp5/CISS10bk9k3R5+dNbE355hU=	\N	9660808647	PHONE	2020-08-29	mayur_sh_07	Mayurdhwaj	Singh	f	f	t	{"email": "mayurdhwajs94@gmail.com", "phone_number": "9660808647"}	{}	{}		{}	{"cooking925": 0.2, "sketching425": 1.0}	sketching425	4.25	0	1		{8953643577}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$eABbuikpcZLc$/zB0ua8CEn9sK9QsjOge2oDaT3J5/VfanFPzVsYnZn0=	\N	9696109124	PHONE	2020-08-29	Prakhar singh	Prakhar	Singh	f	f	t	{"email": "Prakhar Singh", "phone_number": "9696109124"}	{}	{}		{}	{"quotes500": 0.2, "photography625": 0.6000000000000001, "videography650": 1.0}	videography650	6.50	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$awhXeiIhiN3v$rhmyTcfxK39HteA9bRLoEp/W1iibCa5PiB9z7kXUNi0=	\N	9721528613	PHONE	2020-08-28	Aditisin16@@	Aditi	Singh	f	f	t	{"email": "aditisingh16nov@gmail.com", "phone_number": "9721528613"}	{}	{}		{}	{"cooking925": 0.25}	cooking925	9.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$yE4SVm8rEQD8$JXFHvYO5BFfuGCucQCOpd9yF2sPLKgsylsLtRxNVJv4=	\N	9772110330	PHONE	2020-08-28	akashtiwari232	Akash	Tiwari	f	f	t	{"email": "akashtiwari232@gmail.com", "phone_number": "9772110330"}	{}	{}		{}	{"photography625": 1.0}	photography625	6.25	0	1		{7737102386}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$a2Nl0yoDxPZA$/00FZksIVxId8RwX/55MBBWGcLt1uk1pnpGF6+WcHW8=	\N	9793816217	PHONE	2020-08-28	Shukla Vlogs	Ankit 	Shukla 	f	f	t	{"email": "as8055823@gmail.com", "phone_number": "9793816217"}	{}	{}		{}	{"photography625": 0.5}	photography625	6.25	0	1		{7737102386}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$t9IDFi8J1xsD$QCyrQSsFFYjkn/N7F47nJ+tWgbU6+xznccpOO/2GNIU=	\N	9871966890	PHONE	2020-08-28	Amirkhan9871	Amir	Khan	f	f	t	{"email": "Fearlessvoice97@gmail.com ", "phone_number": "9871966890"}	{}	{}		{}	{"cooking925": 0.75}	cooking925	9.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$Vr7qQiwH8IA7$NnUCFcg0GxQy/uJKTAsEmt4iCYVP0mdNblIJ5uEBVZw=	\N	9889024257	PHONE	2020-08-29	Shiv@ngi	Shivangi	Singh	f	f	t	{"email": "kiranlatasingh12345@gmail.com", "phone_number": "9889024257"}	{}	{}		{}	{"photography625": 1.2}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$MbtQKwAvQpPU$VWxZm3Rvls8VYkYk/tw+UUArfTRskbl6/zY+laDTrjw=	\N	9918751848	PHONE	2020-08-28	Mushab Rahman	Mushab	Rahman	f	f	t	{"email": "mushabrahman02@gmail.com", "phone_number": "9918751848"}	{}	{}		{}	{"thoughts525": 2.75, "photography625": 4.95, "graphicsdesign250": 0.25}	photography625	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$JgugZFJWW9m3$RhgafxtDs+HdRivfd2ehFUK08bqnX51skO01QWaSQC0=	\N	9935682117	PHONE	2020-09-24	Ankur yadav	Ankur 	Yadav	f	f	t	{"email": "Ankuryadavspdpf@gmail.com", "phone_number": "9935682117"}	{}	{}		{}	{"poetry550": 0.2, "astronomy325": 0.2, "photography625": 0.6000000000000001}	poetry550	6.25	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
	\N	account_id	PHONE	2020-08-21	djfliwweifer			f	f	f	{}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$kfkzCmawHMPr$z48CtshFyu33Nox9SL9xhtl5U/jl6HZHnbRtuznrd3Y=	2020-10-22 08:20:04.673+00	insight_master	PHONE	2020-08-28				t	t	t	{}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$XYo0uUCHrErL$j9q8ERp9UfLlKlKY1Jj8en8mPJCrjXj9nS5dyKih1Uc=	\N	7007320787	PHONE	2020-11-09	Avij007	Abhishek	Singh	f	f	t	{"email": "avinash5345aa@gmail.com", "phone_number": "7007320787"}	{}	{}		{}	{"photography625": 0.191, "graphicsdesign250": 0.05}	photography625	0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$W86YJFmtqBZ4$xEoHW7ZSeB+RCTDqJatRLSLLqMA1Et3dqx5x+/mev0c=	\N	8875309289	PHONE	2020-11-15	Shaquib	Shaquib	Khan	f	f	t	{"email": "Khanshaquib21@gmail.com ", "phone_number": "8875309289"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$gfYcwWursrJy$IbHqJ3Nwchc0WlnxTV6qbAKgkXeohq5KJqrjL52gNrc=	\N	8005089340	PHONE	2020-08-28	Prashant	Prashant	Chaurasia	f	f	t	{"email": "pkc5683@gmail.com", "phone_number": "8005089340"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FEqnQY3t8hNQo5nuNquDchXZZXmdbkAD1.jpeg?alt=media&token=8e2bdc69-68f2-43eb-93f0-66b0c13bf244	{}	{"astronomy325": 4.226, "photography625": 2.4989999999999997}	photography625	58.85	16	7	Creator of #freaquish	{7007257972,9120759992,7007436997,9119143495,9026457979,8756516916,6392886167}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$1qGUb3T39Y97$BhRMMGe/kSPGKH869ukfXc+7IUO7nKtwWBQr9/IuK2Q=	\N	7080588884	PHONE	2020-11-15	Wenimes	Roger	Black	f	f	t	{"email": "Myname@gmail.com", "phone_number": "7080588884"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$qdaUqgmV2cXc$NC0X75dOaiupr6V4/G6ZKZy8xabD2d466GccZvo9YUY=	\N	7347753366	PHONE	2020-08-28	Poonam	Verma 	Verma 	f	f	t	{"email": "pv278020@gmail.com", "phone_number": "7347753366"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FPWG4LafB7tFZxOCwg4YKbaVw2YYceUoa.jpeg?alt=media&token=a2fabf17-6f29-4fd8-bb24-e5e1ffcaaec4	{}	{"poetry550": 0.5, "cooking925": 3.0, "gardening950": 3.25, "photography625": 7.9}	cooking925	9.25	3	7	Want to do lot of things \nBut don't want to do anything 🙄🙄	{8953643577,7007436997,7737102386,8685809251,8429089691,8955118758,7007257972}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$A48CoXEbXQCt$u0TkQxCkGw1XxzT5ODqUPegoh8i1r3KOzvVoSQJYkgI=	\N	9807211718	PHONE	2020-11-19	Yogivishu221	Vishwajeet kumar 	Chaurasia	f	f	t	{"email": "yogivishu221@gmail.com", "phone_number": "9807211718"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$I0T2cdDKioxx$RE+h6ks7TmZ/jI2IYoxmiCPGGWRKzLPfQIr9WEaIyLs=	\N	7619963044	PHONE	2020-08-28	Shangupta	Prateek 	Gupta	f	f	t	{"email": "gprateek233@gmail.com", "phone_number": "7619963044"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FYMhxPYLDcsbsYKrZgNIiiyWhhvtduQ3F.jpeg?alt=media&token=a73148dc-a435-433e-a13d-c05e0f65d35f	{}	{"poetry550": 1.5, "quotes500": 0.5, "cooking925": 0.8999999999999999, "computer125": 0.2, "thoughts525": 1.0, "gardening950": 0.5, "photography625": 14.7, "videography650": 1.0, "graphicsdesign250": 1.0}	photography625	14.70	0	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$9ILpfMmRigKR$LFWEseiOajVdtaB7D6ngo8zBjeR6yLjAKkaSQ2BEI1M=	\N	7007257972	PHONE	2020-08-28	Inzamam	Inzamamul	Haque	f	f	t	{"email": "inzamamu55@gmail.com", "phone_number": "7007257972"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FFjPxS7UCvHturp1CHrDy4v1OwB39JH2i.jpeg?alt=media&token=c914058b-018d-4ed2-bfcb-1ed6c463f52e	{}	{"poetry550": 6.300000000000001, "quotes500": 4.050000000000001, "cooking925": 1.2, "computer125": 0.2, "thoughts525": 6.6000000000000005, "astronomy325": 0.2, "sketching425": 0.5, "photography625": 14.099999999999993, "videography650": 0.6000000000000001, "graphicsdesign250": 3.7}	graphicsdesign250	11.50	10	8		{8005089340,8429089691,8955118758,7737102386,8953643577,7007436997,7518894470,6394694324}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$WO0vNiMnPO9y$6Kg7DfOUld4fPYZ7CbvWimV6ielcuUNJXd4UlUrJQbs=	\N	7518894470	PHONE	2020-08-28	ratnakarchaurasiya	Mr.	RAVAN🔥	f	f	t	{"email": "ratnakarchaurasiya8@gmail.com", "phone_number": "7518894470"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FMe5rHvoZCi5rjrGym2hSRW9ineetc1LR.jpeg?alt=media&token=4b532c54-a404-4236-996b-742b31fe9c55	{}	{"poetry550": 3.25, "quotes500": 1.45, "cooking925": 1.65, "thoughts525": 1.0, "astronomy325": 0.2, "gardening950": 1.9, "sketching425": 1.5, "photography625": 22.199999999999992, "videography650": 2.15, "graphicsdesign250": 2.95}	graphicsdesign250	21.00	5	10		{7347753366,8953643577,7007436997,7737102386,8685809251,8429089691,7007257972,8955118758,8005089340,8737942594}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$6FpLdSp98j7h$Qv01+BEwR9NWUHjF+ted4SGAoo8ERaNhm943JXpDCus=	\N	9026457979	PHONE	2020-08-28	suyashmadhesia	Suyash	Maddhessiya	f	f	t	{"email": "Suyashmadhesia@gmail.com", "phone_number": "9026457979"}	{}	{}		{}	{"photography625": 0.21900000000000003, "graphicsdesign250": 16.876}	graphicsdesign250	39.70	6	5	Creator of Freaquish 	{7737102386,8005089340,8756516916,6392886167,7007436997}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$g6dxaKHAqHVU$WN2gDxmcnCVId37xIPOrVpJCOZZtGQLkSEIagUX+DZo=	\N	8173047441	PHONE	2020-11-27	Kshitij Verma	Kshitij 	Verma	f	f	t	{"email": "kshitijv365@gmail ", "phone_number": "8173047441"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$SQZKroqas4TD$Wbg8as7p+sdtBA7WiecRHtjUXz2GGCoblA/On2CvHDw=	\N	9653010765	PHONE	2020-11-27	Deepak Pandey	Deepak		f	f	t	{"email": "singhpandey123467@gmail.com", "phone_number": "9653010765"}	{}	{}		{}	{}		0.00	0	0	Kabhi kabhi hawayein bhi bata deti hai manzil ka rasta kidhr hai 	{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$dDgS7UMyN521$jxdAbnbo7Q+40Lrkn+4/tO1CKkG6v8M7dv9hQx9w0QY=	\N	7860626143	PHONE	2020-11-27	sakshi.singh19_	Sakshi	Singh	f	f	t	{"email": "singhsakshi1920@gmail.com", "phone_number": "7860626143"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$SP8z394kqFlx$rZ/9vus7Wm+meuPKeZcStHxgiyU9uo/fJU5sRiXamvo=	\N	8756516916	PHONE	2020-08-28	Shubhranshu IAS	Shubhranshu	Srivastava	f	f	t	{"email": "srivastavadivyanshu71@gmail.com", "phone_number": "8756516916"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FjUw9Gku58VlzE9aoRQ5Dyy73Tc2ZePS4.jpeg?alt=media&token=cd9f08d7-e900-443c-8a72-7ef8faf40e95	{}	{"poetry550": 1.4, "quotes500": 0.5, "cooking925": 2.1, "computer125": 0.5, "thoughts525": 0.75, "astronomy325": 4.800000000000001, "gardening950": 1.2, "sketching425": 0.2, "photography625": 15.749999999999991, "videography650": 0.2, "graphicsdesign250": 3.5500000000000007}	graphicsdesign250	7.95	7	5		{8005089340,9026457979,8881989296,9120759992,9838712221}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$3kcwXWN5iCEf$VaGgt37ZH9f8PpbjEnroqEnjcEM3nTTO5XG5bv9ZmHA=	\N	7881168249	PHONE	2020-11-27	Amantr6	Aman	Tripathi	f	f	t	{"email": "amantr6@gmail.com", "phone_number": "7881168249"}	{}	{}		{}	{}		0.00	0	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$CvgmWSSq3zTu$J6eUhDQdG3iDIp2bia0CVFj3bQLX0vLAgtMtuWhvWtk=	\N	8303902981	PHONE	2020-11-27	Deeksha	Deeksha	Mishra	f	f	t	{"email": "deekshamishra206@gmail.com", "phone_number": "8303902981"}	{}	{}		{}	{}		0.00	1	0		{}	0101000020E610000000000000000000000000000000000000	f	+91
pbkdf2_sha256$180000$02rnaq83BbdH$sv8HwXa1Owiz9oJyYosE5pV82AydDRltrsiLzoie1qA=	\N	9140542655	PHONE	2020-11-27	sonali	sonali	giri	f	f	t	{"email": "sonaligiri112233@gmail.com", "phone_number": "9140542655"}	{}	{}		{}	{}		0.00	1	0		{}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$Rx5M7ijhcSPC$5XWkEkYhLU1B05bZOIFwswAuiMgdEjWxXDwVh1BjWvs=	\N	9696706036	PHONE	2020-11-30	marshmallo	Navneet	Dhar Dubey	f	f	t	{"email": "navneetboss009@gmail.com", "phone_number": "9696706036"}	{}	{}		{}	{}	electronicgames175	0.00	0	1		{9838712221}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$qG8vGw9wZjMK$PnCYWlbzg0+DWki4I0uVIeFXPI0aOBu1NMiG0B2Ag2c=	\N	9793656273	PHONE	2020-11-30	BkArtist	Brijesh	Maurya	f	f	t	{"email": "bkartist8174@gmal.com", "phone_number": "9793656273"}	{}	{}		{}	{}		0.00	0	3		{8756516916,8005089340,8932081360}	0101000020E610000000000000000000000000000000000000	f	91
pbkdf2_sha256$180000$TjGNzX00LxNw$tFSUwuGrD/joXQwG4EoXckqTY203L8DeVzjMpHZlHkw=	\N	6392886167	PHONE	2020-08-28	jarden103	Piyush	Jaiswal	f	f	t	{"email": "iampiyushjaiswal103@gmail.com ", "phone_number": "6392886167"}	{}	{}	https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeoA8AnzE0ZyqvUbXW1CndoD5wI6ENtQT.png?alt=media&token=a8e76476-04c8-4b1d-aba8-87abc25cb522	{}	{"photography625": 0.21900000000000003, "graphicsdesign250": 8.458}	photography625	16.10	4	9	Creator of freaquish Homosapien #life	{8953643577,7007436997,7737102386,8685809251,7007257972,7234840507,8005089340,8756516916,9026457979}	0101000020E610000000000000000000000000000000000000	f	+91
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
-- Data for Name: insight_actionstore; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_actionstore (id, account_id, post_id, loved, loved_at, viewed, viewed_at, shared, saved, commented, up_voted, down_voted) FROM stdin;
1	6392886167	cB5tvLTn8wn26MyJTw2XkQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
2	8005089340	cB5tvLTn8wn26MyJTw2XkQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
3	8005089340	ip6a3djUFgBAz1tz0x5g4A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
4	6392886167	ip6a3djUFgBAz1tz0x5g4A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
5	6392886167	MQsfvt5zuRLC2VRELCNhKg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
6	8005089340	MQsfvt5zuRLC2VRELCNhKg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
7	8005089340	A_PRaPgtvDx3T8Xk0o0u2Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
8	9026457979	MQsfvt5zuRLC2VRELCNhKg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
9	9026457979	A_PRaPgtvDx3T8Xk0o0u2Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
10	9026457979	cB5tvLTn8wn26MyJTw2XkQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
11	9026457979	ip6a3djUFgBAz1tz0x5g4A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
12	6392886167	A_PRaPgtvDx3T8Xk0o0u2Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
13	9026457979	-0_1SJkekSLjTeZIscnZkA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
14	8005089340	-0_1SJkekSLjTeZIscnZkA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
15	9026457979	0Zu0FymIHgKMmze7pBx72g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
16	9026457979	RdAGy6lx6fQacb5GFNS1XA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
17	8005089340	0Zu0FymIHgKMmze7pBx72g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
18	8005089340	ibyTUZ8gzJazHWkVrBcX7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
19	8005089340	RdAGy6lx6fQacb5GFNS1XA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
20	6392886167	RdAGy6lx6fQacb5GFNS1XA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
21	6392886167	ibyTUZ8gzJazHWkVrBcX7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
22	6392886167	0Zu0FymIHgKMmze7pBx72g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
23	6392886167	-0_1SJkekSLjTeZIscnZkA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
24	9026457979	ibyTUZ8gzJazHWkVrBcX7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
25	9026457979	qOIWOLFFweJr5E8o9AykbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
26	8005089340	qOIWOLFFweJr5E8o9AykbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
27	6392886167	FoTh680eAsfwfP2z40piTg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
28	8005089340	GRXbdJp28QfWHexpS4c8Eg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
29	8005089340	V_JDDOYFiPjd64RWqxVFAQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
30	9026457979	V_JDDOYFiPjd64RWqxVFAQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
31	6392886167	GRXbdJp28QfWHexpS4c8Eg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
32	8005089340	sbKfqKPzLLfu-XAReww8XQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
33	9026457979	sbKfqKPzLLfu-XAReww8XQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
34	9026457979	FoTh680eAsfwfP2z40piTg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
35	6392886167	msM0im9HVuv3H94v8n3LjA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
36	8005089340	a92T3BKe-XCDVoc20q6TPQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
37	8005089340	UmzIb6g24UKoMGh55xJw8w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
38	9026457979	UmzIb6g24UKoMGh55xJw8w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
39	9026457979	a92T3BKe-XCDVoc20q6TPQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
40	9026457979	msM0im9HVuv3H94v8n3LjA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
41	6392886167	H3vLq7JLwWgp6PtmOITgPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
42	6392886167	N8TWakoW8SCWKgf-PZOAgw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
43	6392886167	7zmcxOJ8_S6Ddqt3BkPe5g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
44	6392886167	B_wrthc78E3xQITdPePplA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
45	8005089340	N8TWakoW8SCWKgf-PZOAgw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
46	8005089340	B_wrthc78E3xQITdPePplA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
47	8005089340	7zmcxOJ8_S6Ddqt3BkPe5g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
48	8005089340	H3vLq7JLwWgp6PtmOITgPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
49	8005089340	dMrkP6TnvSANQTZmmlE-Qw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
50	8005089340	-XZXB73j3hxGkaWFFp_WbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
51	8005089340	4pJ2UQt9ie2rkoHS2fkyCw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
52	9026457979	dMrkP6TnvSANQTZmmlE-Qw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
53	9026457979	4pJ2UQt9ie2rkoHS2fkyCw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
54	9026457979	-XZXB73j3hxGkaWFFp_WbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	t	f	t	f	f
55	8005089340	C0kIngxVtKhWf714n1Vudg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
56	8005089340	dy83_WRz8ss95GERSrZGWA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
57	8005089340	dctFJVZYPT8YORsxf_LXRQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
58	8005089340	msM0im9HVuv3H94v8n3LjA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
59	6392886167	C0kIngxVtKhWf714n1Vudg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
60	6392886167	dy83_WRz8ss95GERSrZGWA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
61	6392886167	dctFJVZYPT8YORsxf_LXRQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
62	6392886167	4pJ2UQt9ie2rkoHS2fkyCw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
63	6392886167	dMrkP6TnvSANQTZmmlE-Qw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
64	6392886167	-XZXB73j3hxGkaWFFp_WbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
65	6392886167	a92T3BKe-XCDVoc20q6TPQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
66	6392886167	UmzIb6g24UKoMGh55xJw8w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
67	6392886167	sbKfqKPzLLfu-XAReww8XQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
68	8005089340	jRmZX1xOetthIbCavcFUbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
69	9026457979	jRmZX1xOetthIbCavcFUbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
70	9026457979	C0kIngxVtKhWf714n1Vudg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
71	9026457979	N8TWakoW8SCWKgf-PZOAgw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
72	9026457979	H3vLq7JLwWgp6PtmOITgPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
73	9026457979	dy83_WRz8ss95GERSrZGWA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
74	9026457979	dctFJVZYPT8YORsxf_LXRQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
75	9026457979	7zmcxOJ8_S6Ddqt3BkPe5g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
76	9026457979	B_wrthc78E3xQITdPePplA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
77	6392886167	jRmZX1xOetthIbCavcFUbQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
78	9026457979	fMP4CfhaCKYHVmLFvKyz0A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
79	9026457979	L5OPcFJhsO0lSkabqEX9rA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
80	9026457979	mzTTgCFqwvq1JAtAyUBOJw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
81	9026457979	TMRnW9pJeIGcAivjRqbRag	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
82	9026457979	ULTz1uAe1ccOcum2GQ1Opg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
83	6392886167	ULTz1uAe1ccOcum2GQ1Opg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
84	6392886167	fMP4CfhaCKYHVmLFvKyz0A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
85	6392886167	L5OPcFJhsO0lSkabqEX9rA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
86	6392886167	mzTTgCFqwvq1JAtAyUBOJw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
87	8005089340	ULTz1uAe1ccOcum2GQ1Opg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
88	8005089340	mzTTgCFqwvq1JAtAyUBOJw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
89	8005089340	L5OPcFJhsO0lSkabqEX9rA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
90	8005089340	fMP4CfhaCKYHVmLFvKyz0A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
91	8005089340	TMRnW9pJeIGcAivjRqbRag	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
92	8005089340	50nr2Fn4TyL1uAgHhku3gQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
93	6392886167	50nr2Fn4TyL1uAgHhku3gQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
94	6392886167	pAoxo3O4aldZuetuxmJdMQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
95	6392886167	TMRnW9pJeIGcAivjRqbRag	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
96	9026457979	pAoxo3O4aldZuetuxmJdMQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
97	9026457979	50nr2Fn4TyL1uAgHhku3gQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
98	8005089340	pAoxo3O4aldZuetuxmJdMQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
99	6392886167	UAApTq0xaIiDWmFX7z-tsg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
100	8005089340	UAApTq0xaIiDWmFX7z-tsg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
101	8005089340	FoTh680eAsfwfP2z40piTg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
102	6392886167	zoqXHFouknZZTPBexhoEpA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
103	7737102386	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
104	6392886167	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
106	8881989296	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
107	6392886167	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
108	7737102386	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
109	7737102386	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
110	8881989296	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
111	9026457979	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
112	9026457979	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 12:10:09.311+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
113	9026457979	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
114	9026457979	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
115	7737102386	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
116	7007436997	ABt-aZVrRebN3JvYPet3HQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
117	7007436997	hFQieKb9LmfG9M-ow8H4Fw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
118	7007436997	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
119	7007436997	Z3N8wXLg5fl-qTeEHtYmlw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
120	7007436997	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
121	7007436997	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
122	7007436997	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
123	7007436997	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
124	7007436997	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
125	7737102386	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
126	7007436997	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
127	7007436997	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
128	7007436997	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
129	7007436997	YNJwxQxDzexGn_BipWMK-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
130	7007436997	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
131	7007436997	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
132	7007436997	wU13FH-lxct68TgtOM-Wzw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
134	8303263859	bu5UqrnnxuK61T4lIJx-7w	t	2020-10-25 17:14:35.083+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
135	8303263859	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
136	9026457979	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
137	8005089340	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
138	8005089340	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
139	8303263859	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
140	8005089340	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
141	8303263859	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
142	8005089340	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
143	8005089340	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
144	8005089340	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
145	7737102386	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
146	7737102386	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
147	7737102386	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
148	7737102386	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
149	7737102386	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
150	7737102386	Z3N8wXLg5fl-qTeEHtYmlw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
151	7737102386	ETRqZ1JfHxV6UHaIAAlThQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
152	7737102386	LBR4VzdfJ8w_fbc3ku7DsA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
153	7737102386	XH3vTr6CYwOdJvtwNx76Fg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
154	7737102386	wU13FH-lxct68TgtOM-Wzw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
155	7737102386	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
156	7737102386	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
157	7737102386	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
158	7737102386	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
159	7737102386	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
160	7737102386	NW8pZiMI1if3FCeZtutsAA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
161	7737102386	hFQieKb9LmfG9M-ow8H4Fw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
162	7737102386	YNJwxQxDzexGn_BipWMK-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
133	8005089340	7SsWTtJSKuO5Fg06hiCs7A	t	2020-11-21 17:57:17.471019+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
163	7737102386	ABt-aZVrRebN3JvYPet3HQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
164	6392886167	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
165	6392886167	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
166	6392886167	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
167	6392886167	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
168	7737102386	CO7vyv98Va88DNRwtOx3mw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
169	6392886167	XH3vTr6CYwOdJvtwNx76Fg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
170	7737102386	tMjprPvWBLiDKird-8Xw9Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
171	6392886167	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
172	6392886167	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
173	6392886167	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
174	7737102386	VhKJe0Id8bBeoLX1a3yBeQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
175	7737102386	6r1Ln5D5VXmefS2WJz9VKA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
176	7619963044	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
177	7619963044	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
178	7619963044	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
179	7619963044	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
180	7619963044	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
181	7619963044	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
182	6392886167	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
183	6392886167	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
184	8416970886	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
185	8416970886	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
186	8416970886	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
187	8416970886	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
188	8416970886	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
189	8416970886	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
190	8416970886	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
191	7737102386	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
192	8416970886	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
193	7007436997	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
194	7007436997	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
195	7007436997	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
196	7007436997	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
197	7007436997	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
198	7007436997	NW8pZiMI1if3FCeZtutsAA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
199	7007436997	LBR4VzdfJ8w_fbc3ku7DsA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
200	7007436997	tMjprPvWBLiDKird-8Xw9Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
201	7007436997	CO7vyv98Va88DNRwtOx3mw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
202	7007436997	XH3vTr6CYwOdJvtwNx76Fg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
203	6394694324	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
204	6394694324	ABt-aZVrRebN3JvYPet3HQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
205	6394694324	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
206	6394694324	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
207	7007257972	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
208	7007257972	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
209	8953643577	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
210	9026457979	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
211	9026457979	ABt-aZVrRebN3JvYPet3HQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
212	9026457979	XH3vTr6CYwOdJvtwNx76Fg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
213	9026457979	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
214	9026457979	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
215	9026457979	LBR4VzdfJ8w_fbc3ku7DsA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
216	9026457979	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
217	9026457979	ETRqZ1JfHxV6UHaIAAlThQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
218	9026457979	tMjprPvWBLiDKird-8Xw9Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
219	9026457979	YNJwxQxDzexGn_BipWMK-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
220	9026457979	hFQieKb9LmfG9M-ow8H4Fw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
221	9026457979	wU13FH-lxct68TgtOM-Wzw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
222	6392886167	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
223	7052200095	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
224	6394694324	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
225	6394694324	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
226	8005089340	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
227	8005089340	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
228	6394694324	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
229	8005089340	ETRqZ1JfHxV6UHaIAAlThQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
230	8005089340	hFQieKb9LmfG9M-ow8H4Fw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
231	8005089340	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
232	8005089340	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
233	8005089340	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
234	8005089340	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
235	9026457979	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
236	8005089340	NW8pZiMI1if3FCeZtutsAA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
237	8005089340	YNJwxQxDzexGn_BipWMK-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
238	8005089340	ABt-aZVrRebN3JvYPet3HQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
239	8005089340	XH3vTr6CYwOdJvtwNx76Fg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
240	8005089340	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
241	8005089340	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
242	6394694324	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
243	9026457979	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
244	9026457979	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
245	9026457979	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
246	9026457979	NW8pZiMI1if3FCeZtutsAA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
247	9026457979	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
248	9026457979	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
249	9026457979	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
250	9026457979	Z3N8wXLg5fl-qTeEHtYmlw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
251	9026457979	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
252	9026457979	VhKJe0Id8bBeoLX1a3yBeQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
253	9026457979	6r1Ln5D5VXmefS2WJz9VKA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
254	8005089340	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
255	9026457979	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
256	9026457979	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
257	9026457979	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
258	7007436997	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
259	7007436997	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
260	7007436997	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
261	6394694324	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
262	7618806480	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
263	7618806480	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
264	7618806480	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
265	7618806480	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
266	7618806480	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
267	7618806480	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
268	7618806480	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
269	7618806480	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
270	7618806480	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
271	7618806480	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
272	7618806480	QOuxw_71UkGCrnNOSrsL4Q	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
273	7007436997	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
274	7007436997	ETRqZ1JfHxV6UHaIAAlThQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
275	7007436997	6r1Ln5D5VXmefS2WJz9VKA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
276	8005089340	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
277	8005089340	wU13FH-lxct68TgtOM-Wzw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
278	8005089340	Z3N8wXLg5fl-qTeEHtYmlw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
279	8005089340	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
280	8005089340	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
281	8005089340	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
282	6392886167	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
283	7234840507	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
284	7234840507	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
285	7234840507	jOIVo_RoRNYlPyQCePYPYA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
286	7234840507	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
287	7234840507	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
288	7234840507	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
289	7234840507	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
290	7234840507	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
291	7234840507	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
292	7234840507	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
293	6392886167	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
294	8303263859	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 18:46:00.231+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
295	8303263859	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
296	8303263859	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 18:45:55.553+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
297	8303263859	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
298	8303263859	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
299	8303263859	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
300	8303263859	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
301	8303263859	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
302	8303263859	0Q-7CSIjd227wSsDUjr3Ug	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
303	8303263859	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
304	8303263859	wU13FH-lxct68TgtOM-Wzw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
305	8303263859	nrc6Zsk-w0_m5xr6JRkydg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
306	8303263859	P__sjRcj_ILGr3r6J88mFw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
307	8303263859	Z3N8wXLg5fl-qTeEHtYmlw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
308	8303263859	xlZkRqkHXXWBG9JCbSEcDA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
309	8303263859	-4ZTNt9kLbvmYvs2UGsRrw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
310	8303263859	ETRqZ1JfHxV6UHaIAAlThQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
311	9026457979	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
312	6392886167	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
313	9026457979	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
314	6394694324	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
315	7007436997	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
316	7007436997	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
317	7007257972	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
318	7007257972	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
319	9660808647	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
320	9026457979	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
321	8005089340	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
322	7007436997	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
323	6392886167	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
324	7737102386	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
325	7737102386	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
326	7737102386	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
327	7737102386	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
328	7737102386	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
329	7737102386	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
330	7737102386	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
331	9120759992	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
332	9120759992	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
333	7052546269	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
335	8005089340	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
336	8005089340	CO7vyv98Va88DNRwtOx3mw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
337	8005089340	LBR4VzdfJ8w_fbc3ku7DsA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
338	8005089340	6r1Ln5D5VXmefS2WJz9VKA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
339	9696109124	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
340	8429089691	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
341	8429089691	4k36LN3aSBh1E-EivBjWuw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
342	8429089691	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
343	8429089691	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
344	8429089691	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
345	8429089691	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
346	7737102386	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
347	7007436997	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
348	7860080923	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
349	7860080923	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
350	7860080923	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
351	7860080923	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
352	6387348945	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
353	6387348945	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
354	6387348945	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
355	6394694324	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
356	6394694324	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
357	6387348945	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
358	6387348945	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
359	9026457979	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
360	7007257972	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
361	7007257972	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
362	7007257972	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
363	7007257972	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
364	8005089340	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
365	6387348945	Pn39SEESymig1qthsHBCiQ	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
366	8932081360	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
367	8932081360	NA5AnQXktdXOiGmKVN-Vfg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
368	8932081360	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
369	8932081360	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
370	8932081360	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
371	8756516916	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
372	8756516916	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
373	8932081360	lepWVk7U8vcVL6K1PaOTPw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
374	8932081360	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
375	8756516916	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
376	8756516916	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
377	8756516916	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
378	7007257972	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
379	8737942594	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
380	8737942594	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
381	8737942594	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
382	7651892854	t7qQpdlOSO4buwmTRvjd_A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
383	7651892854	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
384	7651892854	y5QT4wUXGykRS2IrBGl5tw	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
385	7651892854	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
386	7651892854	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
387	7651892854	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
388	7651892854	MT3230F-vAoiFnOcUWGq_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
389	7651892854	bu5UqrnnxuK61T4lIJx-7w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
390	7737102386	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
391	6387348945	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
392	6387348945	mfwX-rApctnwYnWNs1aF-w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
393	6387348945	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
394	6387348945	7SsWTtJSKuO5Fg06hiCs7A	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
395	6387348945	31nvDJU6ba7I8E7Fq9LoOA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
396	6387348945	buEIaJZo-Eq_Phnvw744OA	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
397	7651892854	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
398	8303263859	FgtbRU_OBpGEoKObzY0L2w	f	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
399	8303263859	t7qQpdlOSO4buwmTRvjd_A	f	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
400	8303263859	cjE85vs4DUvXUNVFqpdUiw	f	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
401	8303263859	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
402	8303263859	iRcCI8btV9zcyqVWdjpa_g	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
403	6392886167	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
404	7007436997	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
405	7007436997	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
406	6392886167	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
407	7737102386	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 02:28:59.905+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
408	7054548210	NA5AnQXktdXOiGmKVN-Vfg	f	2020-08-29 07:57:59.124+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
409	6394694324	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 09:26:23.138+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
410	7651892854	o1ztqUTZnHrXJxQMKTAATg	f	2020-08-29 07:57:59.072+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
411	7651892854	4k36LN3aSBh1E-EivBjWuw	f	2020-08-29 07:57:59.124+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
412	8932081360	o1ztqUTZnHrXJxQMKTAATg	f	2020-08-29 07:57:59.072+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
413	6387348945	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 15:53:51.049+00	t	2020-08-31 07:06:04.33+00	f	f	t	f	f
414	6387348945	cjE85vs4DUvXUNVFqpdUiw	t	2020-08-31 07:06:19.402+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
416	6394694324	FgtbRU_OBpGEoKObzY0L2w	t	2020-08-31 09:26:40.525+00	f	2020-08-31 06:03:20.971+00	f	f	t	f	f
417	6392886167	t7qQpdlOSO4buwmTRvjd_A	f	2020-08-31 06:03:20.971+00	t	2020-08-31 10:14:54.605+00	f	f	t	f	f
418	9026457979	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 10:28:34.351+00	t	2020-08-31 10:23:35.39+00	f	f	t	f	f
420	9026457979	FgtbRU_OBpGEoKObzY0L2w	t	2020-09-04 04:54:15.874+00	t	2020-08-31 10:28:44.643+00	f	f	t	f	f
421	6392886167	9MBbQ__Y9mrn1rUQYaj44g	t	2020-08-31 11:38:52.59+00	t	2020-08-31 11:36:07.663+00	f	f	t	f	f
422	6392886167	CO7vyv98Va88DNRwtOx3mw	f	2020-08-31 06:03:20.975+00	t	2020-08-31 11:37:49.525+00	f	f	t	f	f
423	6392886167	ABt-aZVrRebN3JvYPet3HQ	f	2020-08-31 06:03:20.975+00	t	2020-08-31 11:40:06.722+00	f	f	t	f	f
424	6392886167	hFQieKb9LmfG9M-ow8H4Fw	f	2020-08-31 06:03:20.967+00	t	2020-08-31 11:40:11.876+00	f	f	t	f	f
425	6392886167	ETRqZ1JfHxV6UHaIAAlThQ	f	2020-08-31 06:03:20.975+00	t	2020-08-31 11:40:11.886+00	f	f	t	f	f
426	6392886167	wU13FH-lxct68TgtOM-Wzw	f	2020-08-31 06:03:20.971+00	t	2020-08-31 11:40:13.27+00	f	f	t	f	f
427	6392886167	xlZkRqkHXXWBG9JCbSEcDA	f	2020-08-31 06:03:20.975+00	t	2020-08-31 11:40:13.465+00	f	f	t	f	f
428	6392886167	NW8pZiMI1if3FCeZtutsAA	f	2020-08-31 06:03:20.971+00	t	2020-08-31 11:40:13.687+00	f	f	t	f	f
429	6392886167	LBR4VzdfJ8w_fbc3ku7DsA	f	2020-08-31 06:03:20.975+00	t	2020-08-31 11:40:13.825+00	f	f	t	f	f
430	6392886167	tMjprPvWBLiDKird-8Xw9Q	f	2020-08-31 06:03:20.967+00	t	2020-08-31 11:40:13.848+00	f	f	t	f	f
431	6392886167	6r1Ln5D5VXmefS2WJz9VKA	f	2020-08-31 06:03:20.971+00	t	2020-08-31 11:40:14.037+00	f	f	t	f	f
432	8005089340	tMjprPvWBLiDKird-8Xw9Q	f	2020-08-31 06:03:20.971+00	t	2020-08-31 11:45:52.956+00	f	f	t	f	f
433	9120759992	o1ztqUTZnHrXJxQMKTAATg	f	2020-08-31 06:03:20.967+00	t	2020-08-31 16:13:55.661+00	f	f	t	f	f
434	8737942594	o1ztqUTZnHrXJxQMKTAATg	f	2020-08-31 06:03:20.967+00	t	2020-08-31 16:47:40.672+00	f	f	t	f	f
435	8303263859	o1ztqUTZnHrXJxQMKTAATg	t	2020-08-31 18:44:53.044+00	t	2020-08-31 18:44:47.906+00	f	f	t	f	f
436	8756516916	o1ztqUTZnHrXJxQMKTAATg	t	2020-09-05 06:00:40.845+00	t	2020-09-01 02:51:02.574+00	f	f	t	f	f
437	8756516916	mfwX-rApctnwYnWNs1aF-w	t	2020-09-01 02:52:12.466+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
438	8756516916	y5QT4wUXGykRS2IrBGl5tw	t	2020-09-01 02:52:16.156+00	t	2020-09-03 09:35:57.35+00	f	f	t	f	f
439	8756516916	4k36LN3aSBh1E-EivBjWuw	t	2020-09-01 02:52:18.405+00	t	2020-09-03 09:33:21.33+00	f	f	t	f	f
440	8756516916	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-02 07:53:28.9+00	t	2020-09-01 03:14:36.465+00	f	f	t	f	f
441	6392886167	I9ufVQhFCOTAFtEre0KmFw	f	2020-08-31 06:03:20.971+00	t	2020-09-01 04:17:30.922+00	f	f	t	f	f
442	8756516916	FgtbRU_OBpGEoKObzY0L2w	f	2020-08-31 06:03:20.971+00	t	2020-09-01 04:47:12.703+00	f	f	t	f	f
443	8756516916	9MBbQ__Y9mrn1rUQYaj44g	t	2020-09-03 09:32:02.528+00	t	2020-09-01 04:48:19.96+00	f	f	t	f	f
444	8005089340	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-01 06:47:05.119+00	t	2020-09-01 06:45:29.767+00	f	f	t	f	f
445	8005089340	VhKJe0Id8bBeoLX1a3yBeQ	f	2020-08-31 06:03:20.967+00	t	2020-09-01 06:46:33.559+00	f	f	t	f	f
446	9918751848	NW8pZiMI1if3FCeZtutsAA	f	2020-08-31 06:03:20.975+00	t	2020-09-01 07:57:16.805+00	f	f	t	f	f
447	7737102386	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-01 13:16:10.642+00	t	2020-09-01 13:15:50.038+00	f	f	t	f	f
448	7347753366	I9ufVQhFCOTAFtEre0KmFw	f	2020-08-31 06:03:20.971+00	t	2020-09-01 14:01:51.051+00	f	f	t	f	f
449	7317537460	I9ufVQhFCOTAFtEre0KmFw	f	2020-08-31 06:03:20.975+00	t	2020-09-01 14:16:20.097+00	f	f	t	f	f
450	7007436997	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-01 16:46:44.474+00	t	2020-09-01 16:46:23.547+00	f	f	t	f	f
451	8737942594	I9ufVQhFCOTAFtEre0KmFw	f	2020-08-31 06:03:20.967+00	t	2020-09-02 05:43:17.492+00	f	f	t	f	f
452	7007257972	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-02 07:13:04.774+00	t	2020-09-02 07:12:58.696+00	f	f	t	f	f
453	7007257972	MT3230F-vAoiFnOcUWGq_g	f	2020-08-31 06:03:20.967+00	t	2020-09-02 07:13:33.308+00	f	f	t	f	f
454	7007257972	jOIVo_RoRNYlPyQCePYPYA	f	2020-08-31 06:03:20.967+00	t	2020-09-02 07:13:37.574+00	f	f	t	f	f
455	7007257972	FgtbRU_OBpGEoKObzY0L2w	f	2020-08-31 06:03:20.971+00	t	2020-09-02 07:13:42.035+00	f	f	t	f	f
456	8756516916	babjCt2f9XQ_tGSEflV92Q	t	2020-09-03 09:30:49.576+00	t	2020-09-02 07:46:48.341+00	f	f	t	f	f
457	8756516916	5vri0VOejjc-b_XyHicdDg	t	2020-09-03 09:30:51.735+00	t	2020-09-02 07:52:05.809+00	f	f	t	f	f
458	8756516916	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-03 09:30:53.224+00	t	2020-09-02 07:55:41.113+00	f	f	t	f	f
459	9118733514	i0jkXqQU4vcfpRB4_qCXew	f	2020-08-31 06:03:20.971+00	t	2020-09-02 09:39:42.952+00	f	f	t	f	f
460	9118733514	t7qQpdlOSO4buwmTRvjd_A	t	2020-09-02 09:39:59.986+00	f	2020-08-31 06:03:20.971+00	f	f	t	f	f
461	6392886167	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-02 09:44:20.082+00	t	2020-09-02 09:44:02.102+00	f	f	t	f	f
462	6392886167	5vri0VOejjc-b_XyHicdDg	t	2020-09-02 09:44:10.033+00	t	2020-09-02 17:19:16.876+00	f	f	t	f	f
463	6392886167	babjCt2f9XQ_tGSEflV92Q	t	2020-09-02 09:44:17.059+00	t	2020-09-02 15:21:13.348+00	f	f	t	f	f
464	7737102386	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-02 12:06:15.448+00	t	2020-09-02 12:06:05.646+00	f	f	t	f	f
465	7737102386	5vri0VOejjc-b_XyHicdDg	t	2020-09-02 12:06:13.931+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
466	7737102386	babjCt2f9XQ_tGSEflV92Q	t	2020-09-02 12:06:19.583+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
467	8303263859	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-02 18:05:54.857+00	t	2020-09-02 18:05:47.525+00	f	f	t	f	f
468	7007436997	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-03 03:07:30.094+00	t	2020-09-03 03:07:18.758+00	f	f	t	f	f
469	7007436997	5vri0VOejjc-b_XyHicdDg	t	2020-09-03 03:07:31.859+00	t	2020-10-09 09:56:17.195+00	f	f	t	f	f
470	7007436997	babjCt2f9XQ_tGSEflV92Q	t	2020-09-03 03:07:36.615+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
472	8005089340	5vri0VOejjc-b_XyHicdDg	t	2020-09-04 07:44:51.752+00	t	2020-09-03 06:32:43.851+00	f	f	t	f	f
473	8756516916	Pn39SEESymig1qthsHBCiQ	t	2020-09-03 09:32:10.893+00	t	2020-09-03 09:33:20.908+00	f	f	t	f	f
474	8756516916	iRcCI8btV9zcyqVWdjpa_g	t	2020-09-03 09:32:13.776+00	f	2020-08-31 06:03:20.967+00	f	f	t	f	f
475	8756516916	IHZAIpwm8Vo2Tv7rUjcXEw	t	2020-09-03 09:32:40.846+00	t	2020-10-03 11:15:57.298+00	f	f	t	f	f
476	8756516916	JdiJ3qHCQXZgYz2FsqyrIA	t	2020-09-03 09:33:02.494+00	t	2020-10-03 11:15:57.366+00	f	f	t	f	f
477	8756516916	NA5AnQXktdXOiGmKVN-Vfg	t	2020-09-03 09:33:05.302+00	t	2020-10-03 11:16:05.031+00	f	f	t	f	f
478	8756516916	31nvDJU6ba7I8E7Fq9LoOA	t	2020-09-03 09:33:07.426+00	t	2020-09-03 09:35:57.228+00	f	f	t	f	f
479	8756516916	6r1Ln5D5VXmefS2WJz9VKA	t	2020-09-03 09:35:32.678+00	f	2020-08-31 06:03:20.975+00	f	f	t	f	f
480	8756516916	-4ZTNt9kLbvmYvs2UGsRrw	f	2020-08-31 06:03:20.975+00	t	2020-09-03 09:35:52.886+00	f	f	t	f	f
481	8756516916	ETRqZ1JfHxV6UHaIAAlThQ	f	2020-08-31 06:03:20.967+00	t	2020-09-03 09:35:53.971+00	f	f	t	f	f
482	8756516916	wU13FH-lxct68TgtOM-Wzw	f	2020-08-31 06:03:20.971+00	t	2020-09-03 09:35:56.412+00	f	f	t	f	f
483	8756516916	0Q-7CSIjd227wSsDUjr3Ug	f	2020-08-31 06:03:20.967+00	t	2020-09-03 09:35:56.536+00	f	f	t	f	f
484	9120759992	i0jkXqQU4vcfpRB4_qCXew	f	2020-08-31 06:03:20.971+00	t	2020-09-03 11:59:16.28+00	f	f	t	f	f
485	6392886167	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-03 14:51:42.084+00	t	2020-09-03 14:51:25.763+00	f	f	t	f	f
486	9026457979	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-24 06:39:16.895+00	t	2020-09-03 14:51:45.653+00	f	f	t	f	f
471	8005089340	i0jkXqQU4vcfpRB4_qCXew	f	2020-11-21 17:57:27.529772+00	t	2020-09-03 06:32:36.865+00	t	f	t	f	f
419	8005089340	FgtbRU_OBpGEoKObzY0L2w	f	2020-11-21 17:57:29.246519+00	t	2020-08-31 10:28:17.388+00	f	f	t	f	f
487	8005089340	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-04 07:44:58.99+00	t	2020-09-03 14:52:29.882+00	f	f	t	f	f
488	7737102386	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-03 15:09:27.293+00	t	2020-09-03 15:09:23.693+00	f	f	t	f	f
489	7618806480	DLN5GxgEr1yBAeXwNHAyyw	f	2020-08-31 06:03:20.975+00	t	2020-09-04 03:11:06.544+00	f	f	t	f	f
490	9120759992	DLN5GxgEr1yBAeXwNHAyyw	f	2020-08-31 06:03:20.975+00	t	2020-09-04 03:11:14.258+00	f	f	t	f	f
491	6387348945	DLN5GxgEr1yBAeXwNHAyyw	f	2020-08-31 06:03:20.967+00	t	2020-09-04 06:33:12.215+00	f	f	t	f	f
492	6387348945	5vri0VOejjc-b_XyHicdDg	t	2020-09-04 06:33:26.677+00	t	2020-09-12 06:55:06.174+00	f	f	t	f	f
493	8005089340	babjCt2f9XQ_tGSEflV92Q	t	2020-09-04 07:44:53.771+00	t	2020-09-04 07:47:49.75+00	f	f	t	f	f
494	9026457979	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-04 19:07:13.318+00	t	2020-09-15 01:41:51.229+00	f	f	t	f	f
495	8756516916	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-05 06:00:01.887+00	t	2020-09-05 05:59:43.32+00	f	f	t	f	f
496	7007257972	DLN5GxgEr1yBAeXwNHAyyw	f	2020-08-31 06:03:20.971+00	t	2020-09-05 16:28:57.531+00	f	f	t	f	f
497	7007257972	5vri0VOejjc-b_XyHicdDg	f	2020-08-31 06:03:20.967+00	t	2020-09-05 16:29:25.767+00	f	f	t	f	f
498	6394694324	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-06 08:09:24.359+00	t	2020-09-06 08:09:17.339+00	f	f	t	f	f
499	6394694324	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-06 08:09:27.422+00	f	2020-09-06 06:30:47.726+00	f	f	t	f	f
500	6394694324	5vri0VOejjc-b_XyHicdDg	t	2020-09-06 08:09:29.094+00	f	2020-09-06 06:30:47.723+00	f	f	t	f	f
501	6394694324	babjCt2f9XQ_tGSEflV92Q	t	2020-09-06 08:09:30.327+00	f	2020-09-06 06:30:47.726+00	f	f	t	f	f
502	6394694324	I9ufVQhFCOTAFtEre0KmFw	t	2020-09-06 08:09:32.177+00	t	2020-09-06 08:09:34.013+00	f	f	t	f	f
503	9026457979	5vri0VOejjc-b_XyHicdDg	t	2020-09-06 13:26:07.369+00	t	2020-09-24 06:39:42.577+00	f	f	t	f	f
504	9026457979	i0jkXqQU4vcfpRB4_qCXew	t	2020-09-06 13:26:12.316+00	t	2020-10-10 16:03:50.381+00	f	f	t	f	f
505	7007436997	DLN5GxgEr1yBAeXwNHAyyw	t	2020-09-07 04:25:46.314+00	t	2020-09-06 13:48:30.968+00	f	f	t	f	f
506	8737942594	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-06 11:40:59.479+00	t	2020-09-09 10:22:47.208+00	f	f	t	f	f
507	7081878499	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-06 11:40:59.479+00	t	2020-09-10 09:13:07.871+00	f	f	t	f	f
508	7651892854	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-06 11:40:59.487+00	t	2020-09-11 17:34:52.002+00	f	f	t	f	f
509	7651892854	IHZAIpwm8Vo2Tv7rUjcXEw	f	2020-09-06 11:40:59.472+00	t	2020-09-11 17:36:22.352+00	f	f	t	f	f
510	7651892854	0Q-7CSIjd227wSsDUjr3Ug	f	2020-09-06 11:40:59.487+00	t	2020-09-11 17:36:37.452+00	f	f	t	f	f
511	6387348945	4k36LN3aSBh1E-EivBjWuw	t	2020-09-12 06:55:31.698+00	f	2020-09-06 11:40:59.479+00	f	f	t	f	f
512	8303263859	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-06 11:40:59.472+00	t	2020-09-12 10:07:33.187+00	f	f	t	f	f
513	9026457979	babjCt2f9XQ_tGSEflV92Q	f	2020-09-06 11:40:59.487+00	t	2020-09-15 17:51:16.462+00	f	f	t	f	f
514	9177914130	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-06 11:40:59.472+00	t	2020-09-17 09:34:24.68+00	f	f	t	f	f
515	9177914130	FgtbRU_OBpGEoKObzY0L2w	f	2020-09-06 11:40:59.472+00	t	2020-09-17 09:34:42.953+00	f	f	t	f	f
516	9177914130	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-06 11:40:59.472+00	t	2020-09-17 09:36:31.013+00	f	f	t	f	f
517	7737102386	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-18 05:43:13.113+00	t	2020-09-18 05:42:43.87+00	f	f	t	f	f
518	8756516916	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-24 06:31:35.069+00	t	2020-09-18 07:01:43.963+00	f	f	t	f	f
519	9026457979	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-19 06:19:52.677+00	t	2020-09-19 03:48:20.771+00	f	f	t	f	f
520	7007436997	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-19 16:05:15.257+00	t	2020-09-19 16:04:34.458+00	f	f	t	f	f
521	7651892854	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-06 11:40:59.487+00	t	2020-09-20 10:43:51.626+00	f	f	t	f	f
522	7651892854	babjCt2f9XQ_tGSEflV92Q	f	2020-09-06 11:40:59.487+00	t	2020-09-20 10:44:26.355+00	f	f	t	f	f
523	7651892854	5vri0VOejjc-b_XyHicdDg	f	2020-09-06 11:40:59.479+00	t	2020-09-20 10:44:26.864+00	f	f	t	f	f
524	6392886167	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-23 17:44:04.102+00	t	2020-09-22 21:01:30.648+00	f	f	t	f	f
525	6392886167	MT3230F-vAoiFnOcUWGq_g	f	2020-09-22 21:08:14.598+00	t	2020-09-22 21:20:30.735+00	f	f	t	f	f
527	8756516916	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-24 11:59:48.118+00	t	2020-09-24 06:29:47.403+00	f	f	t	f	f
528	9026457979	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-24 06:39:12.952+00	t	2020-09-24 06:37:46.926+00	f	f	t	f	f
529	6392886167	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-24 06:53:19.094+00	t	2020-09-24 06:53:00.135+00	f	f	t	f	f
530	7905124622	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.543+00	t	2020-09-24 06:57:12.273+00	f	f	t	f	f
531	7905124622	t7qQpdlOSO4buwmTRvjd_A	f	2020-09-23 21:07:08.543+00	t	2020-09-24 06:57:48.291+00	f	f	t	f	f
532	7905124622	I9ufVQhFCOTAFtEre0KmFw	f	2020-09-23 21:07:08.539+00	t	2020-09-24 06:57:56.528+00	f	f	t	f	f
533	8005089340	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-29 20:51:19.705+00	t	2020-09-24 06:58:45.921+00	f	f	t	f	f
534	7052546269	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.543+00	t	2020-09-24 09:33:30.659+00	f	f	t	f	f
535	7705078595	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.543+00	t	2020-09-24 13:54:35.19+00	f	f	t	f	f
536	7705078595	cjE85vs4DUvXUNVFqpdUiw	t	2020-09-24 13:55:23.373+00	f	2020-09-23 21:07:08.546+00	f	f	t	f	f
537	9598239351	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.543+00	t	2020-09-24 14:38:56.72+00	f	f	t	f	f
538	9598239351	5vri0VOejjc-b_XyHicdDg	t	2020-09-24 14:39:30.191+00	t	2020-09-24 14:44:42.612+00	f	f	t	f	f
539	9598239351	i0jkXqQU4vcfpRB4_qCXew	f	2020-09-23 21:07:08.539+00	t	2020-09-24 14:40:00.27+00	f	f	t	f	f
540	9598239351	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-23 21:07:08.543+00	t	2020-09-24 14:40:00.58+00	f	f	t	f	f
541	9598239351	bu5UqrnnxuK61T4lIJx-7w	f	2020-09-23 21:07:08.543+00	t	2020-09-24 14:44:26.123+00	f	f	t	f	f
542	9598239351	jOIVo_RoRNYlPyQCePYPYA	f	2020-09-23 21:07:08.543+00	t	2020-09-24 14:44:39.715+00	f	f	t	f	f
543	9598239351	NA5AnQXktdXOiGmKVN-Vfg	f	2020-09-23 21:07:08.546+00	t	2020-09-24 14:44:39.721+00	f	f	t	f	f
544	9598239351	y5QT4wUXGykRS2IrBGl5tw	f	2020-09-23 21:07:08.539+00	t	2020-09-24 14:44:39.755+00	f	f	t	f	f
545	9598239351	cjE85vs4DUvXUNVFqpdUiw	f	2020-09-23 21:07:08.543+00	t	2020-09-24 14:44:39.901+00	f	f	t	f	f
546	9598239351	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-23 21:07:08.539+00	t	2020-09-24 14:44:42.811+00	f	f	t	f	f
547	9598239351	4k36LN3aSBh1E-EivBjWuw	f	2020-09-23 21:07:08.546+00	t	2020-09-24 14:44:44.584+00	f	f	t	f	f
548	8005089340	ErlbT3s5RVymkVDFebUW6A	t	2020-09-25 15:05:48.5+00	t	2020-09-25 10:09:14.34+00	t	f	t	f	f
549	7007436997	ErlbT3s5RVymkVDFebUW6A	f	2020-09-28 15:31:53.688+00	t	2020-09-25 23:00:42.972+00	f	f	t	f	f
550	7007436997	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-28 15:31:50.958+00	t	2020-09-25 23:00:47.762+00	f	f	t	f	f
551	9026457979	ErlbT3s5RVymkVDFebUW6A	t	2020-10-01 19:09:52.055+00	t	2020-09-27 09:45:26.852+00	f	f	t	f	f
552	8756516916	ErlbT3s5RVymkVDFebUW6A	t	2020-09-27 13:17:38.523+00	t	2020-09-27 13:17:16.183+00	f	f	t	f	f
553	7007436997	VhKJe0Id8bBeoLX1a3yBeQ	f	2020-09-23 21:07:08.539+00	t	2020-09-28 02:53:41.312+00	f	f	t	f	f
554	7518894470	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.543+00	t	2020-09-28 02:53:50.833+00	f	f	t	f	f
555	7905806732	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.546+00	t	2020-09-28 07:36:10.421+00	f	f	t	f	f
556	7905806732	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-23 21:07:08.539+00	t	2020-09-28 07:36:33.036+00	f	f	t	f	f
557	9935682117	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.539+00	t	2020-09-28 08:03:37.039+00	f	f	t	f	f
558	9935682117	FgtbRU_OBpGEoKObzY0L2w	f	2020-09-23 21:07:08.539+00	t	2020-09-28 08:04:35.782+00	f	f	t	f	f
559	9935682117	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.546+00	t	2020-09-28 08:04:36.315+00	f	f	t	f	f
560	9935682117	babjCt2f9XQ_tGSEflV92Q	f	2020-09-23 21:07:08.539+00	t	2020-09-28 08:05:11.836+00	f	f	t	f	f
561	9935682117	i0jkXqQU4vcfpRB4_qCXew	f	2020-09-23 21:07:08.543+00	t	2020-09-28 08:05:11.836+00	f	f	t	f	f
562	9935682117	DLN5GxgEr1yBAeXwNHAyyw	f	2020-09-23 21:07:08.543+00	t	2020-09-28 08:05:12.177+00	f	f	t	f	f
563	6306416908	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.546+00	t	2020-09-28 08:50:52.601+00	f	f	t	f	f
564	6306416908	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-23 21:07:08.539+00	t	2020-09-28 08:51:35.839+00	f	f	t	f	f
565	9555782418	ErlbT3s5RVymkVDFebUW6A	t	2020-09-28 09:18:32.189+00	t	2020-09-28 09:15:13.112+00	f	f	t	f	f
566	9555782418	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.546+00	t	2020-09-28 09:19:36.03+00	f	f	t	f	f
567	9555782418	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:19:36.087+00	f	f	t	f	f
568	8127581701	ErlbT3s5RVymkVDFebUW6A	t	2020-09-28 09:29:16+00	t	2020-09-28 09:28:45.409+00	f	f	t	f	f
569	8127581701	Pn39SEESymig1qthsHBCiQ	t	2020-09-28 09:29:40.231+00	f	2020-09-23 21:07:08.539+00	f	f	t	f	f
570	8127581701	IHZAIpwm8Vo2Tv7rUjcXEw	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:29:43.365+00	f	f	t	f	f
571	8127581701	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-28 09:30:24.414+00	f	2020-09-23 21:07:08.546+00	f	f	t	f	f
572	8127581701	PRcDcdhFL5-_DPQpLGUyhw	t	2020-09-28 09:30:27.346+00	f	2020-09-23 21:07:08.539+00	f	f	t	f	f
573	8127581701	0Q-7CSIjd227wSsDUjr3Ug	t	2020-09-28 09:31:01.371+00	f	2020-09-23 21:07:08.539+00	f	f	t	f	f
574	8127581701	xlZkRqkHXXWBG9JCbSEcDA	f	2020-09-23 21:07:08.543+00	t	2020-09-28 09:31:05.341+00	f	f	t	f	f
575	8127581701	P__sjRcj_ILGr3r6J88mFw	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:31:07.341+00	f	f	t	f	f
576	8127581701	i0jkXqQU4vcfpRB4_qCXew	f	2020-09-23 21:07:08.543+00	t	2020-09-28 09:31:10.097+00	f	f	t	f	f
577	8127581701	FgtbRU_OBpGEoKObzY0L2w	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:31:10.815+00	f	f	t	f	f
578	8127581701	mfwX-rApctnwYnWNs1aF-w	f	2020-09-23 21:07:08.546+00	t	2020-09-28 09:31:11.191+00	f	f	t	f	f
579	8127581701	bu5UqrnnxuK61T4lIJx-7w	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:31:11.505+00	f	f	t	f	f
580	8127581701	MT3230F-vAoiFnOcUWGq_g	f	2020-09-23 21:07:08.543+00	t	2020-09-28 09:31:11.829+00	f	f	t	f	f
581	8127581701	buEIaJZo-Eq_Phnvw744OA	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:31:12.141+00	f	f	t	f	f
582	8127581701	ETRqZ1JfHxV6UHaIAAlThQ	f	2020-09-23 21:07:08.543+00	t	2020-09-28 09:31:12.674+00	f	f	t	f	f
583	8127581701	XH3vTr6CYwOdJvtwNx76Fg	f	2020-09-23 21:07:08.539+00	t	2020-09-28 09:31:13.484+00	f	f	t	f	f
584	8127581701	VhKJe0Id8bBeoLX1a3yBeQ	f	2020-09-23 21:07:08.543+00	t	2020-09-28 09:31:13.805+00	f	f	t	f	f
585	9119143495	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.539+00	t	2020-09-28 13:52:25.289+00	f	f	t	f	f
586	7753966074	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.546+00	t	2020-09-28 15:04:42.377+00	f	f	t	f	f
587	6392886167	ErlbT3s5RVymkVDFebUW6A	t	2020-09-28 19:15:19.937+00	t	2020-09-28 16:02:17.131+00	t	f	t	f	f
588	6855849137	ErlbT3s5RVymkVDFebUW6A	f	2020-09-23 21:07:08.546+00	t	2020-09-28 18:17:43.017+00	f	f	t	f	f
589	9336394079	ErlbT3s5RVymkVDFebUW6A	t	2020-09-29 00:55:58.262+00	t	2020-09-29 00:55:46.131+00	f	f	t	f	f
590	9336394079	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-29 00:56:04.413+00	f	2020-09-23 21:07:08.539+00	f	f	t	f	f
591	9336394079	o1ztqUTZnHrXJxQMKTAATg	f	2020-09-23 21:07:08.539+00	t	2020-09-29 00:56:27.733+00	f	f	t	f	f
592	9336394079	4k36LN3aSBh1E-EivBjWuw	f	2020-09-23 21:07:08.539+00	t	2020-09-29 00:56:31.071+00	f	f	t	f	f
593	9336394079	PRcDcdhFL5-_DPQpLGUyhw	f	2020-09-23 21:07:08.539+00	t	2020-09-29 00:56:38.439+00	f	f	t	f	f
594	9336394079	FgtbRU_OBpGEoKObzY0L2w	f	2020-09-23 21:07:08.543+00	t	2020-09-29 00:56:39.357+00	f	f	t	f	f
595	9336394079	t7qQpdlOSO4buwmTRvjd_A	f	2020-09-23 21:07:08.546+00	t	2020-09-29 00:56:39.514+00	f	f	t	f	f
596	7081878499	ErlbT3s5RVymkVDFebUW6A	t	2020-09-29 14:29:26.27+00	t	2020-09-29 14:29:07.581+00	f	f	t	f	f
597	7081878499	FgtbRU_OBpGEoKObzY0L2w	f	2020-09-23 21:07:08.539+00	t	2020-09-29 14:29:50.701+00	f	f	t	f	f
598	7081878499	t7qQpdlOSO4buwmTRvjd_A	f	2020-09-23 21:07:08.543+00	t	2020-09-29 14:29:51.374+00	f	f	t	f	f
599	7081878499	cjE85vs4DUvXUNVFqpdUiw	f	2020-09-23 21:07:08.546+00	t	2020-09-29 14:29:51.791+00	f	f	t	f	f
600	7081878499	4k36LN3aSBh1E-EivBjWuw	f	2020-09-23 21:07:08.543+00	t	2020-09-29 14:29:52.142+00	f	f	t	f	f
601	7081878499	mfwX-rApctnwYnWNs1aF-w	f	2020-09-23 21:07:08.539+00	t	2020-09-29 14:29:58.237+00	f	f	t	f	f
602	7081878499	o1ztqUTZnHrXJxQMKTAATg	f	2020-09-23 21:07:08.546+00	t	2020-09-29 14:29:58.616+00	f	f	t	f	f
603	6392886167	iRcCI8btV9zcyqVWdjpa_g	f	2020-09-23 21:07:08.546+00	t	2020-09-29 14:43:22.753+00	f	f	t	f	f
604	7081878499	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-09-23 21:07:08.543+00	t	2020-09-29 14:44:02.539+00	f	f	t	f	f
605	6392886167	YNJwxQxDzexGn_BipWMK-w	f	2020-09-29 20:35:57.883+00	t	2020-09-29 20:39:11.004+00	f	f	t	f	f
606	6392886167	P__sjRcj_ILGr3r6J88mFw	f	2020-09-29 20:35:57.987+00	t	2020-09-29 20:39:37.223+00	f	f	t	f	f
607	6392886167	Z3N8wXLg5fl-qTeEHtYmlw	f	2020-09-29 20:35:57.991+00	t	2020-09-29 20:39:37.224+00	f	f	t	f	f
608	6392886167	Pn39SEESymig1qthsHBCiQ	t	2020-09-29 20:49:56.661+00	f	2020-09-29 20:35:57.991+00	f	f	t	f	f
609	9026457979	7zFsxvON_CK3iybolc7v-Q	f	2020-09-30 08:23:25.4+00	t	2020-09-30 08:22:21.632+00	f	f	t	f	f
610	6387348945	7zFsxvON_CK3iybolc7v-Q	f	2020-09-29 22:03:44.706+00	t	2020-09-30 08:25:21.63+00	f	f	t	f	f
611	7007436997	7zFsxvON_CK3iybolc7v-Q	f	2020-09-30 08:58:19.585+00	t	2020-09-30 08:57:53.863+00	f	f	t	f	f
613	7737102386	7zFsxvON_CK3iybolc7v-Q	t	2020-09-30 09:17:45.806+00	t	2020-09-30 09:16:19.034+00	f	f	t	f	f
614	7737102386	u11aqfFI4Q7GrP6O2qNTwQ	t	2020-09-30 09:17:57.273+00	f	2020-09-29 22:03:44.699+00	f	f	t	f	f
615	7737102386	ErlbT3s5RVymkVDFebUW6A	t	2020-09-30 09:21:11.42+00	t	2020-10-05 06:33:53.004+00	f	f	t	f	f
616	6392886167	7zFsxvON_CK3iybolc7v-Q	t	2020-10-01 12:58:35.169+00	t	2020-09-30 15:23:27.347+00	f	f	t	f	f
617	8756516916	7zFsxvON_CK3iybolc7v-Q	t	2020-10-01 12:20:24.793+00	t	2020-10-01 12:18:43.07+00	f	f	t	f	f
618	9026457979	iQ_vARSYwUHeRtZaT-0WfQ	t	2020-10-01 19:18:18.336+00	t	2020-10-01 19:14:11.929+00	f	f	t	f	f
619	6392886167	iQ_vARSYwUHeRtZaT-0WfQ	t	2020-10-01 19:45:22.351+00	t	2020-10-01 19:45:16.345+00	f	f	t	f	f
621	6392886167	978BX-b6-3-asupLjtefQw	f	2020-10-01 21:18:50.739+00	t	2020-10-01 20:39:00.698+00	f	f	t	f	f
622	8005089340	baK0jkr-tsfAjNsUPOoO3Q	t	2020-10-01 20:43:33.614+00	t	2020-10-01 20:41:38.955+00	f	f	t	f	f
623	8005089340	978BX-b6-3-asupLjtefQw	f	2020-10-01 17:16:31.894+00	t	2020-10-01 20:41:49.155+00	f	f	t	f	f
624	6392886167	baK0jkr-tsfAjNsUPOoO3Q	t	2020-10-01 21:19:01.514+00	t	2020-10-01 21:18:55.494+00	f	f	t	f	f
625	6392886167	auhqqzyE-eCjqUGpgVtVsQ	t	2020-10-01 22:01:13.049+00	t	2020-10-01 22:00:52.716+00	f	f	t	f	f
626	8005089340	auhqqzyE-eCjqUGpgVtVsQ	f	2020-10-01 21:55:41.551+00	t	2020-10-02 04:15:19.22+00	f	f	t	f	f
627	9026457979	auhqqzyE-eCjqUGpgVtVsQ	f	2020-10-01 21:55:41.536+00	t	2020-10-02 07:41:23.692+00	f	f	t	f	f
628	9026457979	baK0jkr-tsfAjNsUPOoO3Q	f	2020-10-01 21:55:41.551+00	t	2020-10-02 08:03:27.024+00	f	f	t	f	f
629	9198572009	auhqqzyE-eCjqUGpgVtVsQ	f	2020-10-01 21:55:41.543+00	t	2020-10-02 08:04:20.054+00	f	f	t	f	f
630	9198572009	978BX-b6-3-asupLjtefQw	f	2020-10-01 21:55:41.543+00	t	2020-10-02 08:04:27.305+00	f	f	t	f	f
631	9198572009	u11aqfFI4Q7GrP6O2qNTwQ	f	2020-10-01 21:55:41.551+00	t	2020-10-02 08:04:29.456+00	f	f	t	f	f
632	9198572009	7zFsxvON_CK3iybolc7v-Q	f	2020-10-01 21:55:41.551+00	t	2020-10-02 08:06:25.589+00	f	f	t	f	f
633	9026457979	978BX-b6-3-asupLjtefQw	f	2020-10-01 21:55:41.543+00	t	2020-10-02 08:06:37.776+00	f	f	t	f	f
634	8005089340	x8CyIOD389nfRak4EE6U4Q	t	2020-10-30 14:30:10.633+00	t	2020-10-02 16:26:37.549+00	f	f	t	f	f
635	8005089340	vf8orZs86q1pLPLRInihlg	t	2020-10-03 12:27:57.309+00	t	2020-10-02 16:32:00.84+00	f	f	t	f	f
636	9026457979	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.543+00	t	2020-10-02 17:02:14.629+00	f	f	t	f	f
637	9026457979	Axs64rjC3C9q7svcPOSIxw	t	2020-10-02 17:02:32.57+00	f	2020-10-01 21:55:41.552+00	f	f	t	f	f
638	9198572009	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-02 18:14:59.358+00	f	f	t	f	f
639	6392886167	vf8orZs86q1pLPLRInihlg	t	2020-10-05 18:36:08.22+00	t	2020-10-02 18:23:45.653+00	f	f	t	f	f
640	7007436997	vf8orZs86q1pLPLRInihlg	t	2020-10-09 09:54:46.688+00	t	2020-10-03 02:43:36.802+00	f	f	t	f	f
641	7007436997	978BX-b6-3-asupLjtefQw	t	2020-10-03 08:30:00.658+00	t	2020-10-03 02:45:50.23+00	f	f	t	f	f
642	7007436997	baK0jkr-tsfAjNsUPOoO3Q	t	2020-10-03 08:30:21.911+00	t	2020-10-03 02:47:14.927+00	f	f	t	f	f
643	7007436997	auhqqzyE-eCjqUGpgVtVsQ	t	2020-10-03 08:30:19.238+00	t	2020-10-03 02:51:36.458+00	f	f	t	f	f
644	7007436997	Axs64rjC3C9q7svcPOSIxw	t	2020-10-03 08:30:11.053+00	t	2020-10-03 02:51:37.778+00	f	f	t	f	f
645	8005089340	Axs64rjC3C9q7svcPOSIxw	t	2020-10-30 14:30:01.641+00	t	2020-10-03 06:33:04.637+00	f	f	t	f	f
646	7007436997	iQ_vARSYwUHeRtZaT-0WfQ	t	2020-10-03 08:29:46.146+00	f	2020-10-01 21:55:41.536+00	f	f	t	f	f
647	7007436997	x8CyIOD389nfRak4EE6U4Q	t	2020-10-03 08:30:16.852+00	f	2020-10-01 21:55:41.543+00	f	f	t	f	f
648	8756516916	vf8orZs86q1pLPLRInihlg	t	2020-10-03 11:06:04.863+00	t	2020-10-03 11:04:51.055+00	f	f	t	f	f
612	8005089340	7zFsxvON_CK3iybolc7v-Q	f	2020-11-21 17:57:32.681172+00	t	2020-09-30 08:58:44.104+00	f	f	t	f	f
649	8756516916	Axs64rjC3C9q7svcPOSIxw	t	2020-10-03 11:05:53.078+00	t	2020-10-03 11:05:49.829+00	f	f	t	f	f
650	8756516916	x8CyIOD389nfRak4EE6U4Q	t	2020-10-10 03:25:55.214+00	t	2020-10-03 11:05:49.819+00	f	f	t	f	f
651	8756516916	baK0jkr-tsfAjNsUPOoO3Q	t	2020-10-03 11:06:14.414+00	t	2020-10-03 11:15:05.336+00	f	f	t	f	f
652	8756516916	auhqqzyE-eCjqUGpgVtVsQ	t	2020-10-03 11:06:17.679+00	t	2020-10-05 18:34:24.871+00	f	f	t	f	f
653	8756516916	978BX-b6-3-asupLjtefQw	t	2020-10-03 11:06:23.36+00	t	2020-10-03 11:11:20.782+00	f	f	t	f	f
654	8756516916	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-10-01 21:55:41.536+00	t	2020-10-03 11:11:08.934+00	f	f	t	f	f
655	8756516916	QOuxw_71UkGCrnNOSrsL4Q	f	2020-10-01 21:55:41.551+00	t	2020-10-03 11:15:57.525+00	f	f	t	f	f
656	7737102386	vf8orZs86q1pLPLRInihlg	t	2020-10-05 06:31:27.758+00	t	2020-10-05 06:30:55.794+00	f	f	t	f	f
657	7737102386	x8CyIOD389nfRak4EE6U4Q	t	2020-10-05 06:32:01.191+00	t	2020-10-05 06:34:39.329+00	f	f	t	f	f
658	7737102386	auhqqzyE-eCjqUGpgVtVsQ	t	2020-10-05 06:32:09.945+00	t	2020-10-05 06:34:38.878+00	f	f	t	f	f
659	7737102386	baK0jkr-tsfAjNsUPOoO3Q	t	2020-10-05 06:32:15.385+00	f	2020-10-01 21:55:41.552+00	f	f	t	f	f
660	7737102386	978BX-b6-3-asupLjtefQw	t	2020-10-05 06:32:25.192+00	f	2020-10-01 21:55:41.543+00	f	f	t	f	f
661	7737102386	iQ_vARSYwUHeRtZaT-0WfQ	t	2020-10-05 06:32:41.031+00	t	2020-10-05 06:33:53.795+00	f	f	t	f	f
662	7737102386	Axs64rjC3C9q7svcPOSIxw	t	2020-10-05 06:33:53.205+00	f	2020-10-01 21:55:41.536+00	f	f	t	f	f
663	7007257972	vf8orZs86q1pLPLRInihlg	t	2020-10-05 14:35:43.012+00	t	2020-10-05 14:35:07.015+00	f	f	t	f	f
664	7007257972	auhqqzyE-eCjqUGpgVtVsQ	t	2020-10-05 14:35:52.398+00	t	2020-10-11 15:31:51.822+00	f	f	t	f	f
665	7007257972	7zFsxvON_CK3iybolc7v-Q	t	2020-10-05 14:36:00.242+00	f	2020-10-01 21:55:41.543+00	f	f	t	f	f
666	6392886167	Axs64rjC3C9q7svcPOSIxw	f	2020-10-01 21:55:41.551+00	t	2020-10-05 17:49:19.413+00	f	f	t	f	f
667	6392886167	x8CyIOD389nfRak4EE6U4Q	f	2020-10-01 21:55:41.536+00	t	2020-10-05 17:53:44.899+00	t	f	t	f	f
668	9026457979	x8CyIOD389nfRak4EE6U4Q	f	2020-10-01 21:55:41.543+00	t	2020-10-10 15:58:42.874+00	f	f	t	f	f
669	7081878499	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-10 16:06:19.176+00	f	f	t	f	f
670	7081878499	x8CyIOD389nfRak4EE6U4Q	f	2020-10-01 21:55:41.536+00	t	2020-10-10 16:06:27+00	f	f	t	f	f
671	7081878499	baK0jkr-tsfAjNsUPOoO3Q	f	2020-10-01 21:55:41.543+00	t	2020-10-10 16:06:38.157+00	f	f	t	f	f
672	7081878499	978BX-b6-3-asupLjtefQw	f	2020-10-01 21:55:41.536+00	t	2020-10-10 16:06:49.697+00	f	f	t	f	f
673	7081878499	7zFsxvON_CK3iybolc7v-Q	t	2020-10-10 16:07:04.338+00	t	2020-10-10 16:06:50.878+00	f	f	t	f	f
674	7007257972	x8CyIOD389nfRak4EE6U4Q	f	2020-10-01 21:55:41.551+00	t	2020-10-11 15:31:51.773+00	f	f	t	f	f
675	9198572009	baK0jkr-tsfAjNsUPOoO3Q	f	2020-10-01 21:55:41.536+00	t	2020-10-17 04:41:31.448+00	f	f	t	f	f
676	7052546269	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-18 18:45:59.878+00	f	f	t	f	f
677	7052546269	7zFsxvON_CK3iybolc7v-Q	f	2020-10-01 21:55:41.536+00	t	2020-10-18 18:47:04.34+00	f	f	t	f	f
678	7052546269	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-10-01 21:55:41.551+00	t	2020-10-18 18:47:10.396+00	f	f	t	f	f
679	7052546269	baK0jkr-tsfAjNsUPOoO3Q	f	2020-10-01 21:55:41.551+00	t	2020-10-18 18:47:20.868+00	f	f	t	f	f
680	7052546269	Axs64rjC3C9q7svcPOSIxw	f	2020-10-01 21:55:41.551+00	t	2020-10-18 18:47:30.535+00	f	f	t	f	f
681	7052546269	Pn39SEESymig1qthsHBCiQ	t	2020-10-18 18:47:55.727+00	f	2020-10-01 21:55:41.536+00	f	f	t	f	f
682	7052546269	JdiJ3qHCQXZgYz2FsqyrIA	f	2020-10-01 21:55:41.543+00	t	2020-10-18 18:48:09.997+00	f	f	t	f	f
683	7052546269	x8CyIOD389nfRak4EE6U4Q	f	2020-10-01 21:55:41.543+00	t	2020-10-18 18:48:11.534+00	f	f	t	f	f
684	7518894470	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:32:22.937+00	f	f	t	f	f
685	7518894470	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:33:01.846+00	f	f	t	f	f
686	7518894470	Axs64rjC3C9q7svcPOSIxw	f	2020-10-01 21:55:41.543+00	t	2020-10-22 08:35:37.448+00	f	f	t	f	f
687	7518894470	cjE85vs4DUvXUNVFqpdUiw	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:38:34.081+00	f	f	t	f	f
688	7518894470	iRcCI8btV9zcyqVWdjpa_g	f	2020-10-01 21:55:41.536+00	t	2020-10-22 08:39:03.914+00	f	f	t	f	f
689	7518894470	Pn39SEESymig1qthsHBCiQ	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:39:04.062+00	f	f	t	f	f
690	7518894470	9MBbQ__Y9mrn1rUQYaj44g	f	2020-10-01 21:55:41.543+00	t	2020-10-22 08:39:04.225+00	f	f	t	f	f
691	7518894470	mfwX-rApctnwYnWNs1aF-w	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:39:04.261+00	f	f	t	f	f
692	7518894470	y5QT4wUXGykRS2IrBGl5tw	f	2020-10-01 21:55:41.536+00	t	2020-10-22 08:39:04.4+00	f	f	t	f	f
693	7518894470	4k36LN3aSBh1E-EivBjWuw	f	2020-10-01 21:55:41.543+00	t	2020-10-22 08:39:04.461+00	f	f	t	f	f
694	7518894470	t7qQpdlOSO4buwmTRvjd_A	f	2020-10-01 21:55:41.536+00	t	2020-10-22 08:39:04.595+00	f	f	t	f	f
695	7518894470	i0jkXqQU4vcfpRB4_qCXew	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:39:04.653+00	f	f	t	f	f
696	7518894470	FgtbRU_OBpGEoKObzY0L2w	f	2020-10-01 21:55:41.551+00	t	2020-10-22 08:40:37.749+00	f	f	t	f	f
697	7518894470	o1ztqUTZnHrXJxQMKTAATg	f	2020-10-01 21:55:41.543+00	t	2020-10-22 08:40:37.765+00	f	f	t	f	f
698	7518894470	MT3230F-vAoiFnOcUWGq_g	t	2020-10-22 08:43:52.63+00	f	2020-10-01 21:55:41.543+00	f	f	t	f	f
699	9598239351	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-25 09:23:44.828+00	f	f	t	f	f
700	9598239351	Axs64rjC3C9q7svcPOSIxw	f	2020-10-01 21:55:41.536+00	t	2020-10-25 09:23:49.945+00	f	f	t	f	f
701	8303263859	vf8orZs86q1pLPLRInihlg	f	2020-10-01 21:55:41.551+00	t	2020-10-25 17:14:24.109+00	f	f	t	f	f
702	8737942594	vf8orZs86q1pLPLRInihlg	t	2020-10-30 15:39:59.945+00	t	2020-10-29 05:23:16.191+00	f	f	t	f	f
703	8737942594	7zFsxvON_CK3iybolc7v-Q	f	2020-10-28 15:36:47.271+00	t	2020-10-30 15:40:25.024+00	f	f	t	f	f
704	8737942594	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-10-28 15:36:47.269+00	t	2020-10-30 15:40:25.034+00	f	f	t	f	f
705	8429089691	vf8orZs86q1pLPLRInihlg	f	2020-10-28 15:36:47.271+00	t	2020-10-31 13:01:13.003+00	f	f	t	f	f
706	8005089340	-cXERyo0mztEecOopTbFDg	t	2020-11-01 10:48:11.5+00	t	2020-11-01 10:48:09.879+00	f	f	t	f	f
707	6392886167	-cXERyo0mztEecOopTbFDg	t	2020-11-01 11:24:35.567+00	t	2020-11-01 11:24:04.483+00	f	f	t	f	f
708	8756516916	-cXERyo0mztEecOopTbFDg	f	2020-10-28 15:36:47.271+00	t	2020-11-02 10:40:55.729+00	f	f	t	f	f
709	8756516916	oLSA5AyHX7_REShThZqOPA	f	2020-10-28 15:36:47.269+00	t	2020-11-02 10:45:58.117+00	f	f	t	f	f
711	7007257972	oLSA5AyHX7_REShThZqOPA	t	2020-11-04 01:21:54.093+00	t	2020-11-04 01:21:38.641+00	f	f	t	f	f
712	6392886167	oLSA5AyHX7_REShThZqOPA	f	2020-10-28 15:36:47.265+00	t	2020-11-04 05:54:45.245+00	f	f	t	f	f
713	9026457979	oLSA5AyHX7_REShThZqOPA	t	2020-11-04 06:01:04.461+00	t	2020-11-04 05:59:44.153+00	f	f	t	f	f
714	9026457979	-cXERyo0mztEecOopTbFDg	f	2020-10-28 15:36:47.269+00	t	2020-11-04 06:00:02.809+00	f	f	t	f	f
710	8005089340	oLSA5AyHX7_REShThZqOPA	f	2020-11-21 17:57:38.134148+00	t	2020-11-02 12:05:34.976+00	f	f	t	f	f
716	7007320787	iBSICg_5KqoY3EoSQRaZzA	f	2020-11-09 08:56:02.956122+00	t	2020-11-11 08:36:39.112001+00	f	f	f	f	f
717	7007320787	-cXERyo0mztEecOopTbFDg	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:36:39.242546+00	f	f	f	f	f
718	7007320787	oLSA5AyHX7_REShThZqOPA	f	2020-11-09 08:56:02.942401+00	t	2020-11-11 08:36:39.259351+00	f	f	f	f	f
719	7007320787	7zFsxvON_CK3iybolc7v-Q	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:36:46.640755+00	f	f	f	f	f
720	7007320787	ErlbT3s5RVymkVDFebUW6A	f	2020-11-09 08:56:02.942401+00	t	2020-11-11 08:36:48.683408+00	f	f	f	f	f
721	7007320787	i0jkXqQU4vcfpRB4_qCXew	f	2020-11-09 08:56:02.942401+00	t	2020-11-11 08:39:12.688339+00	f	f	f	f	f
722	7007320787	o1ztqUTZnHrXJxQMKTAATg	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:39:13.444973+00	f	f	f	f	f
723	7007320787	FgtbRU_OBpGEoKObzY0L2w	f	2020-11-09 08:56:02.956122+00	t	2020-11-11 08:39:13.461741+00	f	f	f	f	f
724	7007320787	y5QT4wUXGykRS2IrBGl5tw	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:39:13.95191+00	f	f	f	f	f
725	7007320787	PRcDcdhFL5-_DPQpLGUyhw	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:39:22.676118+00	f	f	f	f	f
726	7007320787	x8CyIOD389nfRak4EE6U4Q	f	2020-11-09 08:56:02.942401+00	t	2020-11-11 08:39:23.624137+00	f	f	f	f	f
727	7007320787	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-11-09 08:56:02.956122+00	t	2020-11-11 08:39:23.642836+00	f	f	f	f	f
728	7007320787	Axs64rjC3C9q7svcPOSIxw	f	2020-11-09 08:56:03.021792+00	t	2020-11-11 08:40:31.776381+00	f	f	f	f	f
715	6392886167	iBSICg_5KqoY3EoSQRaZzA	t	2020-11-12 21:24:42.725075+00	t	2020-11-09 20:06:32.735392+00	f	f	f	f	f
729	9026457979	iBSICg_5KqoY3EoSQRaZzA	f	2020-11-09 08:56:02.942401+00	t	2020-11-12 10:49:49.033681+00	f	f	f	f	f
105	6392886167	7SsWTtJSKuO5Fg06hiCs7A	t	2020-11-12 16:53:02.910861+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
732	6392886167	Z6ymAwIeJzbN91jL6LLTGw	f	2020-11-13 20:37:19.37887+00	t	2020-11-13 20:37:34.01549+00	f	f	f	f	f
731	6392886167	jcwmLzYQ5guXoH7AUMHCzg	t	2020-11-13 20:37:46.252572+00	t	2020-11-13 20:37:33.359956+00	f	f	f	f	f
734	9026457979	Z6ymAwIeJzbN91jL6LLTGw	f	2020-11-13 20:37:19.224448+00	t	2020-11-14 08:22:44.708391+00	f	f	f	f	f
735	9026457979	XOBXUqnreGJS49wHY45dDw	f	2020-11-13 20:37:19.37887+00	t	2020-11-14 08:22:46.742141+00	f	f	f	f	f
733	9026457979	jcwmLzYQ5guXoH7AUMHCzg	t	2020-11-14 08:23:47.37601+00	t	2020-11-14 08:22:44.589352+00	f	f	f	f	f
736	6392886167	LULr1WDSdFe7cZyrN3uSdw	t	2020-11-19 14:58:50.202243+00	t	2020-11-19 14:58:39.296885+00	f	f	f	f	f
334	8005089340	y5QT4wUXGykRS2IrBGl5tw	t	2020-11-21 17:49:28.41185+00	t	2020-08-31 06:02:35.12+00	f	f	t	f	f
730	8005089340	XOBXUqnreGJS49wHY45dDw	f	2020-11-21 17:57:08.395899+00	t	2020-11-12 17:10:40.033761+00	f	f	f	f	f
415	8005089340	o1ztqUTZnHrXJxQMKTAATg	f	2020-11-21 17:57:25.987498+00	t	2020-08-31 07:20:55.703+00	f	f	t	f	f
526	8005089340	PRcDcdhFL5-_DPQpLGUyhw	f	2020-11-21 17:57:31.392886+00	t	2020-09-24 05:57:45.115+00	f	f	t	f	f
620	8005089340	iQ_vARSYwUHeRtZaT-0WfQ	f	2020-11-21 17:57:35.196155+00	t	2020-10-01 20:19:39.116+00	f	f	t	f	f
\.


--
-- Data for Name: insight_hobby; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_hobby (code_name, name, editors, limits, weight) FROM stdin;
acting875	Acting	{custom_editor,type_writer}	{}	8.750
animation225	Animation	{custom_editor}	{}	2.250
bodybuilding825	Body Building	{custom_editor,type_writer}	{}	8.250
calligraphy575	Calligraphy	{custom_editor}	{}	5.750
dance850	Dance	{custom_editor}	{}	8.500
digitalarts275	Digital Arts	{custom_editor}	{}	2.750
dj700	DJ	{custom_editor}	{}	7.000
drawing400	Drawing	{custom_editor}	{}	4.000
electronicgames175	Electronic Games	{custom_editor}	{}	1.750
fashion1075	Fashion	{custom_editor,type_writer}	{}	10.750
gardening950	Gardening	{custom_editor}	{}	9.500
knitting1050	Knitting	{custom_editor}	{}	10.500
makeup1000	Makeup	{custom_editor}	{}	10.000
nailart1025	Nail Art	{custom_editor}	{}	10.250
painting375	Painting	{custom_editor}	{}	3.750
poetry550	Poetry	{custom_editor,type_writer}	{}	5.500
puzzles150	Puzzles	{custom_editor,type_writer}	{}	1.500
rapping750	Rapping	{custom_editor,type_writer}	{}	7.500
singing725	Singing	{custom_editor,type_writer}	{}	7.250
sketching425	Sketching	{custom_editor,type_writer}	{}	4.250
sports800	Sports	{custom_editor,type_writer}	{}	8.000
story475	Story	{type_writer}	{}	4.750
thoughts525	Thoughts	{type_writer}	{}	5.250
videography650	Videography	{custom_editor}	{}	6.500
quotes500	Quotes	{type_writer}	{}	5.000
cooking925	Cooking	{custom_editor,type_writer}	{}	9.250
computer125	Computer	{custom_editor,type_writer}	{}	1.250
graphicsdesign250	Graphics Design	{custom_editor}	{}	2.500
astronomy325	Astronomy	{custom_editor,type_writer}	{}	3.250
photography625	Photography	{custom_editor,type_writer}	{}	6.250
\.


--
-- Data for Name: insight_hobbyreport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_hobbyreport (id, views, loves, shares, comments, communities_involved, competition_participated, competition_hosted, account_id, hobby_id, posts) FROM stdin;
1	0	0	0	0	0	0	0	8005089340	photography625	1
2	0	0	0	0	0	0	0	6392886167	quotes500	1
75	3	3	0	0	0	0	0	7618806480	cooking925	0
76	4	4	0	0	0	0	0	7618806480	photography625	0
3	0	0	0	0	0	0	0	8005089340	graphicsdesign250	3
4	1	0	0	0	0	0	0	6306416908	graphicsdesign250	0
5	1	0	0	0	0	0	0	6306416908	photography625	0
6	2	2	0	0	0	0	0	6387348945	gardening950	0
7	1	0	0	0	0	0	0	6387348945	poetry550	0
8	1	1	0	0	0	0	0	6387348945	sketching425	0
9	0	1	0	0	0	0	0	6387348945	quotes500	0
10	2	3	0	0	0	0	0	6387348945	cooking925	0
11	1	1	0	0	0	0	0	6387348945	computer125	0
12	1	1	0	0	0	0	0	6387348945	astronomy325	0
13	8	7	0	0	0	0	0	6387348945	photography625	0
14	2	2	0	0	0	0	0	6394694324	gardening950	0
15	1	1	0	0	0	0	0	6394694324	poetry550	0
16	1	1	0	0	0	0	0	6394694324	quotes500	0
17	3	3	0	0	0	0	0	6394694324	cooking925	0
18	1	1	0	0	0	0	0	6394694324	computer125	0
19	0	3	0	0	0	0	0	6394694324	astronomy325	0
20	7	8	0	0	0	0	0	6394694324	photography625	0
21	1	0	0	0	0	0	0	6855849137	photography625	0
22	1	0	0	0	0	0	0	7905806732	poetry550	0
23	1	0	0	0	0	0	0	7905806732	photography625	0
24	1	0	0	0	0	0	0	7007257972	poetry550	0
25	1	1	0	0	0	0	0	7007257972	sketching425	0
26	1	0	0	0	0	0	0	7007257972	videography650	0
27	1	1	0	0	0	0	0	7007257972	quotes500	0
28	3	3	0	0	0	0	0	7007257972	cooking925	0
29	1	1	0	0	0	0	0	7007257972	computer125	0
30	1	0	0	0	0	0	0	7007257972	graphicsdesign250	0
31	1	0	0	0	0	0	0	7007257972	astronomy325	0
32	9	8	0	0	0	0	0	7007257972	photography625	0
33	3	3	0	0	0	0	0	7007436997	gardening950	0
34	4	3	0	0	0	0	0	7007436997	poetry550	0
35	1	1	0	0	0	0	0	7007436997	sketching425	0
36	2	2	0	0	0	0	0	7007436997	thoughts525	0
37	1	1	0	0	0	0	0	7007436997	videography650	0
38	2	2	0	0	0	0	0	7007436997	quotes500	0
39	4	4	0	0	0	0	0	7007436997	cooking925	0
40	1	1	0	0	0	0	0	7007436997	computer125	0
41	5	7	0	0	0	0	0	7007436997	graphicsdesign250	0
42	2	3	0	0	0	0	0	7007436997	astronomy325	0
43	27	25	0	0	0	0	0	7007436997	photography625	0
44	1	1	0	0	0	0	0	7052200095	photography625	0
45	0	1	0	0	0	0	0	7052546269	gardening950	0
46	1	0	0	0	0	0	0	7052546269	poetry550	0
47	1	1	0	0	0	0	0	7052546269	quotes500	0
48	3	0	0	0	0	0	0	7052546269	graphicsdesign250	0
49	4	0	0	0	0	0	0	7052546269	photography625	0
50	1	0	0	0	0	0	0	7054548210	photography625	0
51	1	0	0	0	0	0	0	7081878499	poetry550	0
52	1	0	0	0	0	0	0	7081878499	quotes500	0
53	1	0	0	0	0	0	0	7081878499	cooking925	0
54	3	0	0	0	0	0	0	7081878499	graphicsdesign250	0
55	8	2	0	0	0	0	0	7081878499	photography625	0
56	2	2	0	0	0	0	0	7234840507	gardening950	0
57	1	1	0	0	0	0	0	7234840507	sketching425	0
58	1	1	0	0	0	0	0	7234840507	videography650	0
59	2	2	0	0	0	0	0	7234840507	cooking925	0
60	1	1	0	0	0	0	0	7234840507	computer125	0
61	3	3	0	0	0	0	0	7234840507	photography625	0
62	1	0	0	0	0	0	0	7317537460	photography625	0
63	1	0	0	0	0	0	0	7347753366	photography625	0
64	2	0	0	0	0	0	0	7518894470	gardening950	0
65	0	1	0	0	0	0	0	7518894470	videography650	0
66	1	0	0	0	0	0	0	7518894470	quotes500	0
67	3	0	0	0	0	0	0	7518894470	cooking925	0
68	1	0	0	0	0	0	0	7518894470	graphicsdesign250	0
69	1	0	0	0	0	0	0	7518894470	astronomy325	0
70	7	0	0	0	0	0	0	7518894470	photography625	0
71	2	2	0	0	0	0	0	7618806480	gardening950	0
72	1	0	0	0	0	0	0	7618806480	poetry550	0
73	1	1	0	0	0	0	0	7618806480	sketching425	0
74	1	1	0	0	0	0	0	7618806480	videography650	0
77	1	1	0	0	0	0	0	7619963044	poetry550	0
78	1	1	0	0	0	0	0	7619963044	videography650	0
79	1	1	0	0	0	0	0	7619963044	computer125	0
80	3	3	0	0	0	0	0	7619963044	photography625	0
81	1	1	0	0	0	0	0	7651892854	gardening950	0
82	2	1	0	0	0	0	0	7651892854	poetry550	0
83	1	1	0	0	0	0	0	7651892854	sketching425	0
84	1	1	0	0	0	0	0	7651892854	videography650	0
85	1	1	0	0	0	0	0	7651892854	quotes500	0
86	3	2	0	0	0	0	0	7651892854	cooking925	0
87	1	0	0	0	0	0	0	7651892854	graphicsdesign250	0
88	2	0	0	0	0	0	0	7651892854	astronomy325	0
89	5	2	0	0	0	0	0	7651892854	photography625	0
90	0	1	0	0	0	0	0	7705078595	quotes500	0
91	1	0	0	0	0	0	0	7705078595	photography625	0
92	3	3	0	0	0	0	0	7737102386	gardening950	0
93	4	4	0	0	0	0	0	7737102386	poetry550	0
94	1	1	0	0	0	0	0	7737102386	sketching425	0
95	2	2	0	0	0	0	0	7737102386	thoughts525	0
96	1	1	0	0	0	0	0	7737102386	videography650	0
97	2	2	0	0	0	0	0	7737102386	quotes500	0
98	4	4	0	0	0	0	0	7737102386	cooking925	0
99	1	1	0	0	0	0	0	7737102386	computer125	0
100	5	7	0	0	0	0	0	7737102386	graphicsdesign250	0
101	1	3	0	0	0	0	0	7737102386	astronomy325	0
102	25	27	0	0	0	0	0	7737102386	photography625	0
103	1	0	0	0	0	0	0	7753966074	photography625	0
104	1	1	0	0	0	0	0	7860080923	quotes500	0
105	1	1	0	0	0	0	0	7860080923	cooking925	0
106	2	2	0	0	0	0	0	7860080923	photography625	0
107	3	0	0	0	0	0	0	7905124622	photography625	0
108	0	1	0	0	0	0	0	8127581701	gardening950	0
109	1	0	0	0	0	0	0	8127581701	poetry550	0
110	1	0	0	0	0	0	0	8127581701	sketching425	0
111	1	0	0	0	0	0	0	8127581701	videography650	0
112	1	0	0	0	0	0	0	8127581701	cooking925	0
113	1	1	0	0	0	0	0	8127581701	graphicsdesign250	0
114	1	0	0	0	0	0	0	8127581701	astronomy325	0
115	7	3	0	0	0	0	0	8127581701	photography625	0
116	3	3	0	0	0	0	0	8303263859	gardening950	0
117	3	2	0	0	0	0	0	8303263859	poetry550	0
118	1	1	0	0	0	0	0	8303263859	sketching425	0
119	1	0	0	0	0	0	0	8303263859	quotes500	0
120	4	4	0	0	0	0	0	8303263859	cooking925	0
121	1	1	0	0	0	0	0	8303263859	computer125	0
122	1	1	0	0	0	0	0	8303263859	astronomy325	0
123	16	13	0	0	0	0	0	8303263859	photography625	0
124	1	1	0	0	0	0	0	8416970886	sketching425	0
125	1	1	0	0	0	0	0	8416970886	cooking925	0
126	1	1	0	0	0	0	0	8416970886	computer125	0
127	5	5	0	0	0	0	0	8416970886	photography625	0
128	1	1	0	0	0	0	0	8429089691	quotes500	0
129	3	3	0	0	0	0	0	8429089691	cooking925	0
130	3	2	0	0	0	0	0	8429089691	photography625	0
131	1	0	0	0	0	0	0	8737942594	poetry550	0
132	2	2	0	0	0	0	0	8737942594	cooking925	0
133	1	0	0	0	0	0	0	8737942594	graphicsdesign250	0
134	5	2	0	0	0	0	0	8737942594	photography625	0
135	1	1	0	0	0	0	0	8881989296	sketching425	0
136	1	1	0	0	0	0	0	8881989296	computer125	0
137	1	1	0	0	0	0	0	8932081360	quotes500	0
138	1	1	0	0	0	0	0	8932081360	cooking925	0
140	1	1	0	0	0	0	0	8953643577	computer125	0
141	1	2	0	0	0	0	0	8756516916	gardening950	0
142	2	2	0	0	0	0	0	8756516916	poetry550	0
143	1	1	0	0	0	0	0	8756516916	sketching425	0
144	1	1	0	0	0	0	0	8756516916	videography650	0
145	1	1	0	0	0	0	0	8756516916	quotes500	0
146	3	3	0	0	0	0	0	8756516916	cooking925	0
147	1	1	0	0	0	0	0	8756516916	computer125	0
148	5	4	0	0	0	0	0	8756516916	graphicsdesign250	0
149	3	3	0	0	0	0	0	8756516916	astronomy325	0
150	20	14	0	4	0	0	0	8756516916	photography625	0
151	1	0	0	0	0	0	0	9118733514	astronomy325	0
152	0	1	0	0	0	0	0	9118733514	photography625	0
153	1	0	0	0	0	0	0	9119143495	photography625	0
154	2	1	0	0	0	0	0	9120759992	poetry550	0
155	1	1	0	0	0	0	0	9120759992	quotes500	0
156	1	0	0	0	0	0	0	9120759992	astronomy325	0
157	1	0	0	0	0	0	0	9120759992	photography625	0
158	1	0	0	0	0	0	0	9177914130	poetry550	0
159	1	0	0	0	0	0	0	9177914130	graphicsdesign250	0
160	1	0	0	0	0	0	0	9177914130	photography625	0
161	2	0	0	0	0	0	0	9198572009	graphicsdesign250	0
162	4	0	0	0	0	0	0	9198572009	photography625	0
163	1	0	0	0	0	0	0	9336394079	cooking925	0
164	1	0	0	0	0	0	0	9336394079	graphicsdesign250	0
165	4	2	0	0	0	0	0	9336394079	photography625	0
166	1	0	0	0	0	0	0	9555782418	graphicsdesign250	0
167	2	1	0	0	0	0	0	9555782418	photography625	0
168	1	0	0	0	0	0	0	9598239351	poetry550	0
169	1	0	0	0	0	0	0	9598239351	sketching425	0
170	1	0	0	0	0	0	0	9598239351	quotes500	0
171	2	0	0	0	0	0	0	9598239351	cooking925	0
172	1	0	0	0	0	0	0	9598239351	graphicsdesign250	0
173	2	1	0	0	0	0	0	9598239351	astronomy325	0
174	5	0	0	0	0	0	0	9598239351	photography625	0
175	1	1	0	0	0	0	0	9660808647	cooking925	0
176	1	1	0	0	0	0	0	9696109124	quotes500	0
177	1	0	0	0	0	0	0	9918751848	photography625	0
178	1	0	0	0	0	0	0	9935682117	poetry550	0
179	2	0	0	0	0	0	0	9935682117	astronomy325	0
180	3	0	0	0	0	0	0	9935682117	photography625	0
181	1	0	0	0	0	0	0	7007320787	cooking925	0
182	3	0	0	0	0	0	0	7007320787	graphicsdesign250	0
183	1	0	0	0	0	0	0	7007320787	astronomy325	0
184	8	0	0	0	0	0	0	7007320787	photography625	0
185	3	3	0	0	0	0	0	8005089340	gardening950	0
186	4	3	0	1	0	0	0	8005089340	poetry550	0
187	1	1	0	0	0	0	0	8005089340	sketching425	0
188	2	1	0	0	0	0	0	8005089340	thoughts525	0
189	1	1	0	0	0	0	0	8005089340	videography650	0
190	3	2	0	0	0	0	0	8005089340	quotes500	0
191	4	4	0	0	0	0	0	8005089340	cooking925	0
192	1	1	0	0	0	0	0	8005089340	computer125	0
193	7	4	0	1	0	0	0	8005089340	graphicsdesign250	0
194	3	2	1	0	0	0	0	8005089340	astronomy325	0
195	29	24	1	3	0	0	0	8005089340	photography625	0
196	3	3	0	0	0	0	0	9026457979	gardening950	0
197	4	4	0	0	0	0	0	9026457979	poetry550	0
198	1	1	0	0	0	0	0	9026457979	sketching425	0
199	2	2	0	0	0	0	0	9026457979	thoughts525	0
200	1	1	0	0	0	0	0	9026457979	videography650	0
201	2	1	0	0	0	0	0	9026457979	quotes500	0
202	4	4	0	0	0	0	0	9026457979	cooking925	0
203	1	1	0	0	0	0	0	9026457979	computer125	0
204	9	5	0	2	0	0	0	9026457979	graphicsdesign250	0
205	3	2	0	0	0	0	0	9026457979	astronomy325	0
207	2	2	0	0	0	0	0	6392886167	gardening950	0
208	3	2	0	0	0	0	0	6392886167	poetry550	0
209	1	1	0	0	0	0	0	6392886167	sketching425	0
210	2	0	0	0	0	0	0	6392886167	thoughts525	0
211	1	0	0	0	0	0	0	6392886167	videography650	0
212	2	1	0	0	0	0	0	6392886167	quotes500	0
213	4	3	0	0	0	0	0	6392886167	cooking925	0
214	1	1	0	0	0	0	0	6392886167	computer125	0
215	10	6	1	6	0	0	0	6392886167	graphicsdesign250	0
216	3	3	0	0	0	0	0	6392886167	astronomy325	0
217	30	19	1	4	0	0	0	6392886167	photography625	0
218	0	0	0	0	0	0	0	9026457979	painting375	0
206	29	25	0	4	0	0	0	9026457979	photography625	1
219	0	0	0	0	0	0	0	9838712221	thoughts525	1
220	0	0	0	0	0	0	0	9838712221	videography650	1
221	0	0	0	0	0	0	0	9653010765	digitalarts275	1
223	0	0	0	0	0	0	0	9696706036	electronicgames175	1
139	6	5	0	0	0	0	0	8932081360	photography625	1
222	0	0	0	0	0	0	0	9838712221	astronomy325	2
\.


--
-- Data for Name: insight_places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_places (id, place_name, city, coordinates) FROM stdin;
\.


--
-- Data for Name: insight_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post (post_id, assets, caption, hastags, atags, coordinates, action_count, created_at, rank, is_global, account_id, hobby_id, freshness_score, last_modified, net_score, score) FROM stdin;
7SsWTtJSKuO5Fg06hiCs7A	{"text": {"data": "Hi I am Siddharth Shukla ", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}}	Siddharth Shukla 	{}	{}	\N	{"love": 4, "save": 0, "view": 18, "share": 0, "comment": 0}	2020-08-29 07:56:27.332+00	0	t	8881989296	computer125	0.8000	2020-11-24 11:37:12.090052+00	0.8675	0.0675
0Q-7CSIjd227wSsDUjr3Ug	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fe1e50kKrmoDnhX0alO4UYK9O83tTFrCM.jpeg?alt=media&token=a697744b-4a09-4549-b7ed-aa6f43b45df6"]}	Shoot for the moon\nEven if you fall\nYou'll land on stars!❤	{}	{}	\N	{"love": 20, "save": 0, "view": 55, "share": 0, "comment": 0}	2020-08-28 17:34:04.701+00	19	t	8953643577	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8375	0.0375
Axs64rjC3C9q7svcPOSIxw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FxjgUlmfJZx73OHLW5FGmZSDvxqWxQOzw.jpeg?alt=media&token=d8c230a2-ee28-4116-b2e7-28c9a97983b3"]}		{}	{}	\N	{"love": 5, "save": 0, "view": 8, "share": 0, "comment": 1}	2020-10-02 16:28:34.4+00	0	t	8005089340	photography625	0.8000	2020-11-23 13:06:39.293653+00	0.8285	0.0285
bu5UqrnnxuK61T4lIJx-7w	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FOvD5t9jSZCAwHV0u6RxiXbWvLZRIe7HB.jpeg?alt=media&token=b4ff09d6-a3ec-46ff-ba42-c556ab79f0fc"]}		{}	{}	\N	{"love": 14, "save": 0, "view": 74, "share": 0, "comment": 0}	2020-08-29 06:29:12.926+00	0	t	8303263859	sketching425	0.8000	2020-11-23 12:32:24.595325+00	0.8660	0.0660
ABt-aZVrRebN3JvYPet3HQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FJgC1It8CT30tkaPxXxmoL5rgp82KJmIq.jpeg?alt=media&token=7d8feea8-02a1-42b8-9cbf-48dfcbc9540b"]}	A new beginning is always good😁 #life #sun	{#life,#sun}	{#life,#sun}	\N	{"love": 14, "save": 0, "view": 84, "share": 0, "comment": 0}	2020-08-28 15:09:42.422+00	21	t	7007257972	photography625	0.8000	2020-11-24 12:59:04.573069+00	0.8255	0.0255
9MBbQ__Y9mrn1rUQYaj44g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FSwRzmMOCHXq0dqV3041o8kG21fjBsk4U.jpeg?alt=media&token=2f0bb0d5-d6fe-41e1-b4fb-ccebcebbcea8"]}	❤️	{}	{}	\N	{"love": 9, "save": 0, "view": 11, "share": 0, "comment": 0}	2020-08-29 10:45:02.532+00	0	t	6394694324	cooking925	0.8000	2020-12-01 06:09:18.027406+00	0.8690	0.0690
978BX-b6-3-asupLjtefQw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FhSw3l2D68sCyv1fi2qh2w4enC5UwS4cs.jpeg?alt=media&token=37930ac1-5258-45cb-9f72-b2f8d842b609"]}	#cyborg	{#cyborg}	{#cyborg}	\N	{"love": 7, "save": 0, "view": 7, "share": 0, "comment": 3}	2020-10-01 20:38:32.753+00	0	t	6392886167	graphicsdesign250	0.8000	2020-11-26 14:19:46.767418+00	0.8225	0.0225
auhqqzyE-eCjqUGpgVtVsQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FUZu1PO0F42bnqWmfA2DVqNJCDvKIDnZW.jpeg?alt=media&token=579c8a48-a3e6-47a3-a694-357eca32fd72"]}	#imagination	{#imagination}	{#imagination}	\N	{"love": 5, "save": 0, "view": 8, "share": 0, "comment": 0}	2020-10-01 22:00:40.35+00	0	t	6392886167	photography625	0.8000	2020-11-26 14:20:00.131035+00	0.8300	0.0300
5vri0VOejjc-b_XyHicdDg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FgsRoZiAEgglNRuJeNPGX5QYtaJmluuWc.jpeg?alt=media&token=6bc853a8-2173-4443-8a11-447890d6d65f"]}	This is what I like about astronomy 😘🥰	{}	{}	\N	{"love": 9, "save": 0, "view": 9, "share": 0, "comment": 0}	2020-09-02 07:51:11.067+00	1	t	8756516916	astronomy325	0.8000	2020-11-30 14:39:05.194631+00	0.8420	0.0420
6r1Ln5D5VXmefS2WJz9VKA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fpl0Wl0Bissp8cXt9MeT98Q7HylVwfohb.png?alt=media&token=9c9d4a0d-cce7-4078-8133-47dbd4298f5d"]}	#welcome all of you @freaquish	{#welcome}	{#welcome}	\N	{"love": 20, "save": 0, "view": 45, "share": 0, "comment": 0}	2020-08-28 14:51:40.103+00	15	t	8005089340	photography625	0.8000	2020-11-24 12:59:05.240274+00	0.8240	0.0240
31nvDJU6ba7I8E7Fq9LoOA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FbStYzKO8nYlkhjaho7fLdc6O7kmgz8al.jpeg?alt=media&token=f724d0ff-4250-4a9e-82ec-1ecf63434c35"]}	Sunset 🌅🌄🌞☁️	{}	{}	\N	{"love": 26, "save": 0, "view": 37, "share": 0, "comment": 0}	2020-08-29 02:50:21.076+00	17	t	7737102386	photography625	0.8000	2020-11-26 14:23:24.786083+00	0.8600	0.0600
baK0jkr-tsfAjNsUPOoO3Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FdYie8sBcpj0BQijql7aFSxpphLnRwXF7.jpeg?alt=media&token=e00cb9e2-aae7-4b6f-931d-05ccc64fc4b7"]}		{}	{}	\N	{"love": 5, "save": 0, "view": 8, "share": 0, "comment": 3}	2020-10-01 20:41:33.097+00	0	t	8005089340	graphicsdesign250	0.8000	2020-11-18 05:36:48.960928+00	0.8270	0.0270
babjCt2f9XQ_tGSEflV92Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FEdu8uj6Igd0Hdfp90YSfVuf11Wb195K3.jpeg?alt=media&token=8f4df77e-5a39-4744-8615-b0f481513cdb"]}	Space shuttle leaving earth🌎🚀	{}	{}	\N	{"love": 6, "save": 0, "view": 6, "share": 0, "comment": 0}	2020-09-02 07:45:42.819+00	0	t	8756516916	astronomy325	0.8000	2020-12-01 06:54:18.297989+00	0.8345	0.0345
-4ZTNt9kLbvmYvs2UGsRrw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FCorWOfw2ruCMRBbbGC8uQtiGplJQssg6.jpeg?alt=media&token=7677e72d-83b4-4310-aeae-9e461300f401"]}	RD 	{}	{}	\N	{"love": 13, "save": 0, "view": 55, "share": 0, "comment": 0}	2020-08-28 16:50:28.659+00	14	t	8685809251	photography625	0.8000	2020-11-24 12:54:00.081271+00	0.8315	0.0315
FgtbRU_OBpGEoKObzY0L2w	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FBIDJMfLFfPBQslmJCgoopfbGQjwoRoYb.jpeg?alt=media&token=3bd907a5-865e-4bbb-98a7-67758f934f6f"]}	This type of evening ❤...	{}	{}	\N	{"love": 5, "save": 0, "view": 17, "share": 0, "comment": 0}	2020-08-30 13:48:39.969+00	1	t	9026457979	photography625	0.8000	2020-11-24 08:01:53.436602+00	0.8480	0.0480
iQ_vARSYwUHeRtZaT-0WfQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FymuREYavLkgRI6ycnNwYtMH6BArr5VrW.jpeg?alt=media&token=e9155162-c458-4663-8f84-745d694b00cc"]}	Scifi scene blender creation.......	{}	{}	\N	{"love": 4, "save": 0, "view": 9, "share": 0, "comment": 2}	2020-10-01 19:14:04.35+00	0	t	9026457979	graphicsdesign250	0.8000	2020-11-18 05:36:48.960928+00	0.8255	0.0255
IHZAIpwm8Vo2Tv7rUjcXEw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FBXu0Z9UyZ3mRAOZzgh3V3L8oieaPnu48.jpeg?alt=media&token=a739ac8e-4698-42e4-a900-e6c20ea10b91"]}	Evening view	{}	{}	\N	{"love": 20, "save": 0, "view": 33, "share": 0, "comment": 0}	2020-08-29 05:57:02.497+00	13	t	9026457979	photography625	0.8000	2020-11-26 14:21:56.33277+00	0.8585	0.0585
i0jkXqQU4vcfpRB4_qCXew	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FB8fAGamX9Zt0VtdKZPqdKjkgWyejPYoF.jpeg?alt=media&token=222cb5ff-51a9-432e-9e45-c91fdc35c99b"]}	Seen from it's natural satellite 🌕🌕	{}	{}	\N	{"love": 7, "save": 0, "view": 14, "share": 1, "comment": 0}	2020-09-02 07:55:28.971+00	2	t	8756516916	astronomy325	0.8000	2020-11-30 08:10:00.214065+00	0.8530	0.0530
CO7vyv98Va88DNRwtOx3mw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F9nKHk1yA5t7U9UR5glde1HF9ug5kbcmB.jpeg?alt=media&token=7650f4a1-a6a2-4dea-8a0c-b818220b6760"]}	The reality is changing every moment🙄	{}	{}	\N	{"love": 20, "save": 0, "view": 25, "share": 0, "comment": 0}	2020-08-28 15:06:58.958+00	1	t	7007257972	quotes500	0.8000	2020-12-01 06:36:25.534433+00	0.8165	0.0165
buEIaJZo-Eq_Phnvw744OA	{"audio": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FxoHpl1vTdjuUB06psqME8ZBj7RiHlQTi.?alt=media&token=0dc46b62-2065-4978-9c9d-156caa1c6499", "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FhFmftEKKlfEt6kXenuZGyFuZyqnvHkPc.jpeg?alt=media&token=ccb89f82-3389-4705-bf36-f60e4fc916fd"]}		{}	{}	\N	{"love": 7, "save": 0, "view": 17, "share": 0, "comment": 0}	2020-08-28 17:30:43.162+00	8	t	7347753366	photography625	0.8000	2020-11-24 12:59:01.384074+00	0.8390	0.0390
DLN5GxgEr1yBAeXwNHAyyw	{"text": {"data": "🖋🖋🖋", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}, "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FaYvt6N4X8ULXRJSPn5kpX8OTWjV1M7dD.jpeg?alt=media&token=1a58afd9-eefe-42fc-9dd7-c7cf6fa7259a"]}	🖋🖋🖋	{}	{}	\N	{"love": 7, "save": 0, "view": 19, "share": 0, "comment": 1}	2020-09-03 12:00:12.738+00	1	t	9120759992	poetry550	0.8000	2020-11-22 15:23:14.265777+00	0.8495	0.0495
cjE85vs4DUvXUNVFqpdUiw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FNpSNXRqhwHHdzL9D6b0xgoQGC9jyIjOm.jpeg?alt=media&token=a41e5f86-d44e-447f-bab3-23727b36e184"]}	#shairy of ❤️	{#shairy}	{#shairy}	\N	{"love": 10, "save": 0, "view": 15, "share": 0, "comment": 0}	2020-08-29 16:41:18.396+00	0	t	8005089340	quotes500	0.8000	2020-11-24 07:55:20.931382+00	0.8810	0.0810
hFQieKb9LmfG9M-ow8H4Fw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F34J5WqOwfYLWM5K5ngJFmKlf4KkZ9F3R.jpeg?alt=media&token=5b50f2d6-bc6d-461e-9d76-b5665ef29afb"]}		{}	{}	\N	{"love": 12, "save": 0, "view": 35, "share": 0, "comment": 0}	2020-08-28 16:36:53.889+00	11	t	8429089691	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8195	0.0195
I9ufVQhFCOTAFtEre0KmFw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F4FUXyBHzaJx8LW3h80HZ5VNoIffMkeQf.jpeg?alt=media&token=a0f2ebb5-3e21-4cd2-8db1-4f7aa83a4a15"]}	I want this type of astronomical click one day😘🥰	{}	{}	\N	{"love": 7, "save": 0, "view": 12, "share": 0, "comment": 0}	2020-09-01 03:14:17.025+00	4	t	8756516916	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8390	0.0390
iRcCI8btV9zcyqVWdjpa_g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FIT6obaJgHw6bY7VRpGIvqgPN4xx1Tqx3.jpeg?alt=media&token=ce19668b-0695-4258-812a-9dac03bf9568"]}	🌺	{}	{}	\N	{"love": 6, "save": 0, "view": 8, "share": 0, "comment": 0}	2020-08-29 10:36:46.165+00	0	t	6394694324	gardening950	0.8000	2020-11-29 06:07:37.543905+00	0.8525	0.0525
JdiJ3qHCQXZgYz2FsqyrIA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FRF1DTWTMuzpI5CvADbzK0YFJPsQYjC3M.jpeg?alt=media&token=a1ec0423-542d-4060-a51c-81df0bf07b1f"]}	🖋🖋🖋	{}	{}	\N	{"love": 13, "save": 0, "view": 43, "share": 0, "comment": 0}	2020-08-29 04:25:14.974+00	0	t	9120759992	poetry550	0.8000	2020-11-18 05:36:48.960928+00	0.8465	0.0465
ErlbT3s5RVymkVDFebUW6A	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fxquo382dhbkaVpqop6IpP6ew5Cxy96Am.jpeg?alt=media&token=4d7c0afe-6527-4c2e-805f-8b2567bfd9d6"]}	The #nature halfway	{#nature}	{#nature}	\N	{"love": 9, "save": 0, "view": 18, "share": 2, "comment": 2}	2020-09-25 10:09:11.497+00	0	t	8005089340	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8640	0.0640
PRcDcdhFL5-_DPQpLGUyhw	{"text": {"data": "Heloooooo", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}}	I am new here 	{}	{}	\N	{"love": 6, "save": 0, "view": 13, "share": 0, "comment": 1}	2020-09-17 09:35:29.273+00	0	t	9177914130	graphicsdesign250	0.8000	2020-11-18 05:36:48.960928+00	0.8375	0.0375
NW8pZiMI1if3FCeZtutsAA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FfW1ysnSnUZitrNkjhTrC1234hk70sA4n.jpeg?alt=media&token=e4896bbf-9483-42bb-804b-c546ccab7003"]}	Flowers 🌸🌺	{}	{}	\N	{"love": 46, "save": 0, "view": 210, "share": 0, "comment": 0}	2020-08-28 15:44:10.715+00	23	t	7737102386	photography625	0.8000	2020-11-26 14:23:35.321005+00	0.8225	0.0225
oLSA5AyHX7_REShThZqOPA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FbtjQe9wvUX56ROTHejqil7AaFCsZASMN.jpeg?alt=media&token=f4e3a020-6048-4553-8f0c-703a69930cc3"]}	Jai Hind 🇮🇳	{}	{}	\N	{"love": 2, "save": 0, "view": 6, "share": 0, "comment": 0}	2020-11-02 10:43:23.494+00	0	t	8756516916	photography625	0.8018	2020-12-01 06:09:15.634882+00	0.8213	0.0195
jOIVo_RoRNYlPyQCePYPYA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F5bWzB7eiFu6yKYox3KiPQQL00nPH0J9G.jpeg?alt=media&token=ae8f331e-8145-4e4a-a55d-295afc5f5ce0"]}	Nature love	{}	{}	\N	{"love": 24, "save": 0, "view": 151, "share": 0, "comment": 0}	2020-08-28 17:47:05.527+00	22	t	8737942594	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8390	0.0390
LBR4VzdfJ8w_fbc3ku7DsA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fr3uHQsDHU7Phav3Ql1HRSL1wOb12Dg6b.jpeg?alt=media&token=c8a716c7-764f-4bd9-9bca-d20a3c82863b"]}	Shivam Yadav\n\n	{}	{}	\N	{"love": 22, "save": 0, "view": 39, "share": 0, "comment": 0}	2020-08-28 15:03:17.448+00	1	t	8429089691	graphicsdesign250	0.8000	2020-11-18 05:36:48.960928+00	0.8195	0.0195
lepWVk7U8vcVL6K1PaOTPw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fr1XQOUkkdsYZDhaFNWxcjhgIx96j5SzX.jpeg?alt=media&token=d15c3248-5392-41d3-b5f4-b81a458cd20d"]}	✨✨	{}	{}	\N	{"love": 11, "save": 0, "view": 90, "share": 0, "comment": 0}	2020-08-28 17:34:46.109+00	18	t	7347753366	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8360	0.0360
NA5AnQXktdXOiGmKVN-Vfg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F3yp3fky3UMjZxzXiaT4JxtA2i1AA3jpV.jpeg?alt=media&token=0a5ec8a9-f0a1-4316-969a-651a7f7af28a"]}		{}	{}	\N	{"love": 12, "save": 0, "view": 89, "share": 0, "comment": 0}	2020-08-29 03:08:19.1+00	20	t	7619963044	photography625	0.8000	2020-11-23 12:32:54.018528+00	0.8525	0.0525
MvVk9jKcxAgm3liaSXH7Ig	{}		{}	{}	\N	{"love": 1, "save": 0, "view": 41, "share": 0, "comment": 0}	2020-08-28 16:37:30.344+00	7	t	8429089691	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8000	0.0000
mfwX-rApctnwYnWNs1aF-w	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FPQjfvKrEg0A6a0cZzbMQlkj17OUHxzyg.jpeg?alt=media&token=630cb841-e198-4395-b6ed-9189236903bf"]}	🌇🌅	{}	{}	\N	{"love": 10, "save": 0, "view": 12, "share": 0, "comment": 0}	2020-08-29 10:47:16.994+00	3	t	6394694324	photography625	0.8000	2020-11-24 12:56:09.855072+00	0.8675	0.0675
nrc6Zsk-w0_m5xr6JRkydg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F2mx9W8C2EpmJnDe11JxrzRO4LKrGweZK.jpeg?alt=media&token=a2d263e9-0bb4-4bf0-92af-f4660b8011a5"]}	Scorching heat\nAsks to accept defeat\nBut the sunflowers \nBloom and repeat!	{}	{}	\N	{"love": 20, "save": 0, "view": 67, "share": 0, "comment": 0}	2020-08-28 17:20:37.513+00	2	t	8953643577	gardening950	0.8000	2020-11-18 05:36:48.960928+00	0.8270	0.0270
t7qQpdlOSO4buwmTRvjd_A	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FLPG8eGXL7kZOE3SJwzcB2Va57bzAhXbF.jpeg?alt=media&token=5fa3e87e-a56f-4a13-b21f-697599fe84e2"]}	Orcha fort 	{}	{}	\N	{"love": 7, "save": 0, "view": 17, "share": 0, "comment": 0}	2020-08-30 04:06:14.114+00	5	t	7737102386	photography625	0.8000	2020-11-26 14:23:59.497682+00	0.8660	0.0660
Pn39SEESymig1qthsHBCiQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FjyIsgMDUn6WHyqXXNzXkqLFEue5UpHVh.jpeg?alt=media&token=a9b30a41-ac18-4ef9-9ab8-6a9a90bf4bd8"]}	🌹	{}	{}	\N	{"love": 12, "save": 0, "view": 7, "share": 0, "comment": 0}	2020-08-29 10:38:27.32+00	1	t	6394694324	gardening950	0.8000	2020-11-24 06:05:33.984978+00	0.8570	0.0570
P__sjRcj_ILGr3r6J88mFw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F2uJk2UsPXpe0HiZhyucDuEfIKxDCNdx9.jpeg?alt=media&token=e52eb29f-5942-4d3c-b878-4f723628a2f9"]}	Its all about youtube and time!❤	{}	{}	\N	{"love": 19, "save": 0, "view": 113, "share": 0, "comment": 0}	2020-08-28 17:01:28.025+00	3	t	8953643577	cooking925	0.8000	2020-11-18 05:36:48.960928+00	0.8300	0.0300
QOuxw_71UkGCrnNOSrsL4Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FlJN9ZKoj05eyY5PYz9d3rBct3Q2XrHSF.jpeg?alt=media&token=66181a18-fb12-4520-86f7-a02a3395c0fd"]}	Speaker	{}	{}	\N	{"love": 15, "save": 0, "view": 50, "share": 0, "comment": 0}	2020-08-28 17:43:18.883+00	9	t	7518894470	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8330	0.0330
-SgglZWcuV7gdONk5Il6zw	{}		{}	{}	\N	{"love": 1, "save": 0, "view": 9, "share": 0, "comment": 0}	2020-08-28 16:37:22.249+00	2	t	8429089691	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8000	0.0000
MT3230F-vAoiFnOcUWGq_g	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FhFoMsf37VMOwkzG1mp5l0HWhcrPWsbh5.mp4?alt=media&token=198ebd61-a9a3-41d9-9491-53bad33fc8e8"}		{}	{}	\N	{"love": 18, "save": 0, "view": 99, "share": 0, "comment": 0}	2020-08-28 17:52:27.032+00	0	t	7518894470	videography650	0.8000	2020-11-30 08:10:49.870101+00	0.8495	0.0495
-cXERyo0mztEecOopTbFDg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F55Vdcr4bPnAhtdFiA4Kz9nJjOfkLbdNc.jpeg?alt=media&token=b8569f04-e548-42bc-a600-d6fd801d8e49"]}		{}	{}	\N	{"love": 2, "save": 0, "view": 5, "share": 0, "comment": 0}	2020-11-01 10:47:54.56+00	0	t	8005089340	photography625	0.8064	2020-11-25 05:36:58.374841+00	0.8229	0.0165
VhKJe0Id8bBeoLX1a3yBeQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FOoJUrOoDy1RBdwL5mliNszpTCPwXmW9T.jpeg?alt=media&token=7f88730e-156d-4394-9fae-f901c672796f"]}	  Desires are the biggest enemy😁	{}	{}	\N	{"love": 23, "save": 0, "view": 27, "share": 0, "comment": 0}	2020-08-28 15:00:14.885+00	2	t	7007257972	poetry550	0.8000	2020-11-28 18:50:48.34004+00	0.8165	0.0165
7zFsxvON_CK3iybolc7v-Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FbZmKhPGzJvDjkffdGhVeuNyiLssX5pXp.jpeg?alt=media&token=90958755-5fb0-4f3e-bf4d-ddefee36a076"]}	Feels like I am living on another planet....❤❤❤	{}	{}	\N	{"love": 5, "save": 0, "view": 12, "share": 0, "comment": 10}	2020-09-30 08:22:13.207+00	0	t	9026457979	photography625	0.8000	2020-11-22 10:05:09.925559+00	0.8330	0.0330
y5QT4wUXGykRS2IrBGl5tw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FRZhsD6BmNb6jb5GzXz7lYm41W1gPzmxR.jpeg?alt=media&token=e9edf381-6bba-4d30-817c-9551573d1a34"]}	😋	{}	{}	\N	{"love": 9, "save": 0, "view": 11, "share": 0, "comment": 0}	2020-08-29 11:54:00.428+00	1	t	6394694324	cooking925	0.8000	2020-11-24 07:57:12.823342+00	0.8825	0.0825
u11aqfFI4Q7GrP6O2qNTwQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FKF5pyhATiqJvNH39En4f5f5ViP58XLQU.jpeg?alt=media&token=363b4c9b-e5dd-440e-ba7a-f1f0ebff9d74"]}	Congratulations 🎉 to all the frequishians to have leaderboard in this to show your standings..🥰😊	{}	{}	\N	{"love": 8, "save": 0, "view": 13, "share": 0, "comment": 2}	2020-09-24 06:29:13.497+00	0	t	8756516916	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8435	0.0435
vf8orZs86q1pLPLRInihlg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FVCG3veuyHs0zTZ9qYiDFuEebx5xfVIVs.jpeg?alt=media&token=593dcc1a-1d83-4a81-9cab-26c8900a90b9"]}		{}	{}	\N	{"love": 18, "save": 0, "view": 15, "share": 0, "comment": 0}	2020-10-02 16:30:32.067+00	0	t	8005089340	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8435	0.0435
YNJwxQxDzexGn_BipWMK-w	{"text": {"data": "🔥🔥🔥🔥", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}, "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FKOkL3nnKDXU7kodDBK8QCS9Lq16ATHBA.jpeg?alt=media&token=5616d034-5272-47d7-9a06-0a6d99eec4f9"]}		{}	{}	\N	{"love": 13, "save": 0, "view": 89, "share": 0, "comment": 0}	2020-08-28 15:13:36.005+00	1	t	8756636544	thoughts525	0.8000	2020-11-29 05:14:04.852237+00	0.8210	0.0210
wU13FH-lxct68TgtOM-Wzw	{"audio": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FP6VKfXQwXnm18h9dqju29rQuNZlQnTo7.?alt=media&token=77fe4ffc-c920-4271-adce-0c90391cffd2", "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FlIhD5WVcowu6SvWTVISOZo47MUHA8fU9.jpeg?alt=media&token=1a3c538c-7379-4719-8b1b-fc9f5abbfbdb"]}		{}	{}	\N	{"love": 6, "save": 0, "view": 21, "share": 0, "comment": 0}	2020-08-28 17:30:30.354+00	10	t	7347753366	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8255	0.0255
iBSICg_5KqoY3EoSQRaZzA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F2dsRrPnrQa7CNyWcliH6ITdF0ygUNLPS.png?alt=media&token=9c212fe2-88ee-4367-a46e-77806913e241"]}		{}	{}	\N	{"love": 1, "save": 0, "view": 3, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-09 11:14:20.087532+00	0	t	8005089340	photography625	0.8173	2020-11-29 06:07:33.87608+00	0.8263	0.0090
X_-iiiKDdgT-loEi3YzaTw	{}		{}	{}	\N	{"love": 1, "save": 0, "view": 3, "share": 0, "comment": 0}	2020-08-28 16:37:11.645+00	0	t	8429089691	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8000	0.0000
XH3vTr6CYwOdJvtwNx76Fg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FV2JbiUpLLgKBRjzCDd4WEnhTRmKs0UOs.jpeg?alt=media&token=fdd2675e-b98d-41e5-95ee-39b99c2abb28"]}	\n\n\n	{}	{}	\N	{"love": 17, "save": 0, "view": 72, "share": 0, "comment": 0}	2020-08-28 15:07:07.466+00	2	t	8955118758	graphicsdesign250	0.8000	2020-11-24 12:59:04.732813+00	0.8255	0.0255
tMjprPvWBLiDKird-8Xw9Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FTkIeAs5qOvlqORsYxb9PbXHyUtTYD2Xa.jpeg?alt=media&token=2669405e-40e3-4ccd-abd6-389402c2542d"]}	Listen to others only if you are willing to help them just turning your ears is not called curtesy.🙄	{}	{}	\N	{"love": 21, "save": 0, "view": 24, "share": 0, "comment": 0}	2020-08-28 15:02:31.752+00	0	t	7007257972	thoughts525	0.8000	2020-11-29 05:14:04.869087+00	0.8195	0.0195
Z3N8wXLg5fl-qTeEHtYmlw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FpwWaS4ZHoePamBu3wWFqBoeEpaBpCcma.jpeg?alt=media&token=4e20fd3e-66c3-4c4a-9493-a8d8253a4f03"]}	#ummeed	{#ummeed}	{#ummeed}	\N	{"love": 23, "save": 0, "view": 50, "share": 0, "comment": 0}	2020-08-28 16:57:40.908+00	3	t	7007436997	poetry550	0.8000	2020-11-18 05:36:48.960928+00	0.8240	0.0240
xlZkRqkHXXWBG9JCbSEcDA	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeBfcAHzwV15mh9tsO6ZP0MFDqWVA2kFg.jpeg?alt=media&token=757b6003-3a6f-40f7-ae38-78142050760c"]}	The sky ☁️😱🌌	{}	{}	\N	{"love": 15, "save": 0, "view": 61, "share": 0, "comment": 0}	2020-08-28 16:56:35.235+00	16	t	7737102386	photography625	0.8000	2020-11-26 14:27:04.674654+00	0.8315	0.0315
Qfu4WT4PRq4yX4OuYLLiJg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FGcxHyRHbVIoPvhcIkpDR6zB6P1FhrUOf.jpeg?alt=media&token=fa4cbc21-2e47-4036-a4f3-6dab858c1cab"]}	Every thing is connected.....	{}	{}	\N	{}	2020-11-23 13:08:39.048563+00	0	t	9026457979	painting375	1.5358	2020-11-27 14:47:59.349695+00	1.5418	0.0060
NYX2T1Ad937_7N0EV9a8TQ	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FrI0Py7I73hNxXokujwIPxxnqefH8RkiF.jpeg?alt=media&token=71ae80f7-4899-4256-a123-8bd4fd7c7a0b"]}	🥰🥰	{}	{}	\N	{}	2020-11-24 12:57:45.996932+00	0	t	8756516916	photography625	1.2463	2020-12-01 06:54:15.747341+00	1.2613	0.0150
o1ztqUTZnHrXJxQMKTAATg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FALG5nKwHstK4kN9OihimewTwwzt5gNpM.jpeg?alt=media&token=f245dac0-81b1-4148-b69a-0fa9105e09c2"]}	#dhundh	{#dhundh}	{#dhundh}	\N	{"love": 7, "save": 0, "view": 17, "share": 0, "comment": 0}	2020-08-30 17:55:05.328+00	6	t	7007436997	photography625	0.8000	2020-11-22 10:05:54.711877+00	0.8495	0.0495
4k36LN3aSBh1E-EivBjWuw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F7VyBYGnvfatXbWggrf7IjuMeGBb8UI47.jpeg?alt=media&token=e02b56f1-4b55-41c2-808f-f14ffc206b17", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F1SDpfWv8zUZoQJ2Ysw8E7oDAFLU3Mjwv.jpeg?alt=media&token=ccba8647-a7bc-4f42-9c24-2df00b875c7a"]}	😋	{}	{}	\N	{"love": 9, "save": 0, "view": 17, "share": 0, "comment": 0}	2020-08-29 11:55:16.698+00	2	t	6394694324	cooking925	0.8000	2020-11-24 07:55:21.070731+00	0.8705	0.0705
Z6ymAwIeJzbN91jL6LLTGw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fl2oEeUNltfjyGaSjpYjGdDjefBuWAR8m.png?alt=media&token=e091bf3b-2c1e-4434-8b49-a355c07455b8"]}	Black hole	{}	{}	\N	{"love": 0, "save": 0, "view": 2, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-13 11:02:55.114347+00	0	t	8005089340	graphicsdesign250	0.8470	2020-11-28 18:49:43.790109+00	0.8530	0.0060
ETRqZ1JfHxV6UHaIAAlThQ	{"audio": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FxuWmusJcWUcceac7xq9EASDj3qgSXmD7.mpeg?alt=media&token=01a2fb14-4205-4c02-be04-8042165b4198", "images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FsQStOQVpiCylWI4Z3bshw6B1gDKixSxe.jpeg?alt=media&token=40875a23-7954-43cc-80d4-5f1771feef3c"]}	Sometimes thorns are meant to protect!	{}	{}	\N	{"love": 13, "save": 0, "view": 42, "share": 0, "comment": 0}	2020-08-28 16:47:07.214+00	12	t	8953643577	photography625	0.8000	2020-11-18 05:36:48.960928+00	0.8270	0.0270
x8CyIOD389nfRak4EE6U4Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fhq7OHaCXL32SeSj30cbQxg9y57TqmCfN.png?alt=media&token=a57b20d5-93e9-4e63-b0d4-be27adc4a14d", "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fwq1Cf7ToQl4GCcjURfukZ7ZWPtZ8qHOr.png?alt=media&token=a389e5f9-faa6-4f22-ac87-2e26982d2f96"]}		{}	{}	\N	{"love": 4, "save": 0, "view": 9, "share": 1, "comment": 0}	2020-10-02 16:25:56.116+00	0	t	8005089340	graphicsdesign250	0.8000	2020-11-18 05:36:48.960928+00	0.8305	0.0305
XOBXUqnreGJS49wHY45dDw	{"text": {"data": "Ethics are more valuable", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}}		{}	{}	\N	{"love": 0, "save": 0, "view": 2, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-12 17:09:57.039889+00	0	t	6392886167	quotes500	0.8366	2020-11-29 06:07:33.871208+00	0.8486	0.0120
LULr1WDSdFe7cZyrN3uSdw	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F5blgRsAAbkEn1a98MWwqMlC7SKFXDYIc.png?alt=media&token=708e502f-350a-4223-85ae-9cf6936a62f5"]}	#self edited	{#self}	{}	\N	{"love": 1, "save": 0, "view": 1, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-19 14:44:30.631484+00	0	t	8005089340	graphicsdesign250	0.9279	2020-12-01 06:54:18.452961+00	0.9444	0.0165
jcwmLzYQ5guXoH7AUMHCzg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FeqKBBRLrLQLyDrfaCuBPuDyzU7His1Ig.png?alt=media&token=eaaad70e-0000-40f6-9ba3-bf86e6ef6188"]}	#game_corner	{#game}	{}	\N	{"love": 2, "save": 0, "view": 2, "share": 0, "comment": 0, "up_vote": 0, "down_vote": 0}	2020-11-13 11:00:42.927563+00	0	t	8005089340	graphicsdesign250	0.9279	2020-11-24 12:59:08.251477+00	0.9384	0.0105
QXr8_PbFKwcRq-itqKGy-g	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FEiIaYfL5BpQeFb8pRlSPIUh19b1dgeTQ.png?alt=media&token=8f76e05f-3a3e-41a1-ac2d-8976d48302a3"]}	#TIME, as I understand (psychological), is mere a mental construction to hold on to the illusion of your self-narrative, in time....⏳\n#Introspection... 💫💫	{}	{}	\N	{}	2020-11-29 05:14:03.212346+00	0	t	9838712221	thoughts525	2.0131	2020-12-01 11:31:37.289631+00	2.0266	0.0135
pTxMOS0yRgq-tHrsFUANZg	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F3aundYAAIjvCKLQEG9FJn6krhFwyGghN.mp4?alt=media&token=d2bcb88b-bc44-4c12-a060-da6752e19d78"}	I have recreated STRANGER THINGS intro animation....😎	{}	{}	\N	{}	2020-11-24 11:36:41.286899+00	0	t	9026457979	graphicsdesign250	1.5358	2020-11-29 06:00:19.719829+00	1.5573	0.0215
r0cIJojii-KSZYKZ6gRHow	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FSftjcshkWgGqTjhhpVsZl4T6XeSdFt0d.jpeg?alt=media&token=6f53a395-e476-4b43-ada0-13dcd5368f96"]}	Retro ... 	{}	{}	\N	{}	2020-11-25 05:38:21.080649+00	0	t	9026457979	photography625	1.2463	2020-12-01 06:07:51.109115+00	1.2598	0.0135
aAo3oIT9ZI2CGZ-ONJ-tYA	{"text": {"data": "No one can defeat you if you are stable with your success comfort zone ", "bgColor": "#FFFFFF", "fontName": "Lato", "fontColor": "#000000"}}	Writer hoon jo bhi likhta hoon dil se..... 	{}	{}	\N	{}	2020-11-30 06:47:52.681275+00	0	t	9653010765	digitalarts275	2.8000	2020-11-30 19:57:47.814355+00	2.8060	0.0060
LEEReMdYP9gB1BlGm_9KdQ	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FzxM7nss1bOfVifaBU8ZdB4JPcJGQ8k2A.mp4?alt=media&token=50e8b888-489e-40c7-94d8-5ac58265cfee"}	\n\n#Cymatics (Cymatics, from Ancient Greek: κύμα, meanin'\n'Wave', is a subset of modal vibrational phenomena. \nIt's also the study of visible sound. The term was coined by Hans Jenny)\n.\n#universeASvibration 🌪️🔱🎶\n#greek #schumannresonance #water #huygensprinciple  #holigraphicuniverse #waves #wavelets #nonlinearresonance #spacetime #spacememory #complexnumbers #vortex #tesla #shiva #zeropointenergy #fractals #strangeattractors #matter #solids #chaostheory #complexitytheory #kantianwholes #dimensions #gravity #time #perception\n🎥 & 🎶: #NigelStanford\n.\nFor more info. search\n"Cymatics" on #YouTube™	{}	{}	\N	{}	2020-11-29 06:23:16.600046+00	0	t	9838712221	videography650	2.3576	2020-11-30 15:57:06.900352+00	2.3761	0.0185
rhLs3hN0xW8rBy8xVkg0Kg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FS0aC2FsKDEfNHxwSUbtRKw17EkuzlYwV.jpeg?alt=media&token=eed27f87-84f9-4c09-98eb-5fd58fb0cac1"]}		{}	{}	\N	{}	2020-12-01 06:07:50.162381+00	0	t	8932081360	photography625	2.8000	2020-12-01 06:47:52.655722+00	2.8090	0.0090
9E_HU18hpX__oysTRzGlfg	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FoHs5YdOZCHEHpCkouqYuv5TJPSXhaevI.png?alt=media&token=06de37b1-2f4b-421a-b1d5-cad6a1d06fa1"]}	Be +ve	{}	{}	\N	{}	2020-11-30 15:54:19.935041+00	0	t	9696706036	electronicgames175	2.8000	2020-11-30 19:57:28.063756+00	2.8060	0.0060
Swl4oGSwZzqJE0BKfDDnjA	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2F0ilKd7ddGdjgUQKHb6taLtqIrrjnXHXu.mp4?alt=media&token=b8126705-b3d3-4c20-b59b-269b3de3fd2d"}	Yes, it's the structure of the universe once you add in various different kinds of information, includin' cosmic background radiation, dark matter, etc.\nThe last image features Cosmic Microwave Background Radiation (CMBR) of individual galaxies. To see how these visualizations were constructed, watch George Smoot's talk.\nWhat strikes Me about these images is how organic the universe seems. Indeed, if you watch the talk, you'll get a glimpse of how the structure of the universe emerges via principles that are similar to (if not identical) to how organic life form emerge...🔭🌠🌏🌌👨🏻‍🚀🚀🛸⏳💫⚛️\n🎥 Credit: Max Planck Institute for Astronomy\n•••\n#spacetime #universe #astrophotography #darkmatter #blackholes #quantumphysics #organic #tedxtalks #astronomy #GeorgeSmoot #CMBR #maxplanck #cosmicradiation #resonance #nonlinear #galaxies #stars	{}	{}	\N	{}	2020-11-30 19:18:09.207656+00	0	t	9838712221	astronomy325	2.8000	2020-12-01 05:25:32.192915+00	2.8090	0.0090
6OvBZUxjKJBCf7Ki7SFN3A	{"video": "https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2Fui1bXMdaQ3QEGRupftrVuIM1noQa6lsK.mp4?alt=media&token=2d54e9fd-0d98-4bab-9619-ff8020b80210"}	#TheTesseract...\n(8 (4.4.4) Hexahedron)\nThis strangely reminds Me of👇\n'Allegory of the Cave' #Plato .\n{p.s. In geomectory, the Tesseract is the 4th Dimensional analogue of the Cube; the Tesseract is to Cube as the Cube is to the Square.\nJust as the surface of the cube consists of 6 square faces, the hypersurface of the Tesseract consists of 8 cubical shells. The Tesseract is one of the 6 Convex regular 4-polytopes.}\n.\nHave a Genius-Feel wala Good Morning...❤🙏🌪🌏\n.\n#thecube #hexahedron #fourthdimension #square #polytopes #physics #weirdmath	{}	{}	\N	{}	2020-11-30 08:07:45.838987+00	0	t	9838712221	astronomy325	2.8000	2020-12-01 07:04:05.5651+00	2.8150	0.0150
ncMzVXG81V5pLq90rL3i8Q	{"images": ["https://firebasestorage.googleapis.com/v0/b/social-express-103904.appspot.com/o/assets%2FUxMY7wxYpfFOtdDdMoIRoK0VRyjvxzSF.png?alt=media&token=1080bf91-0187-4721-aa8d-32189cf863b3"]}	#TheStarryNight\nBy: Vincent van Gogh	{}	{}	\N	{}	2020-12-01 13:12:14.234062+00	0	t	9838712221	astronomy325	2.8000	2020-12-01 17:31:51.902643+00	2.8030	0.0030
\.


--
-- Data for Name: insight_post_a_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_a_tags (id, post_id, tags_id) FROM stdin;
\.


--
-- Data for Name: insight_post_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_comments (id, post_id, userpostcomment_id) FROM stdin;
1	978BX-b6-3-asupLjtefQw	17
2	978BX-b6-3-asupLjtefQw	18
3	978BX-b6-3-asupLjtefQw	14
4	baK0jkr-tsfAjNsUPOoO3Q	26
5	baK0jkr-tsfAjNsUPOoO3Q	19
6	baK0jkr-tsfAjNsUPOoO3Q	20
7	Axs64rjC3C9q7svcPOSIxw	22
8	DLN5GxgEr1yBAeXwNHAyyw	5
9	ErlbT3s5RVymkVDFebUW6A	21
10	ErlbT3s5RVymkVDFebUW6A	13
11	iQ_vARSYwUHeRtZaT-0WfQ	10
12	iQ_vARSYwUHeRtZaT-0WfQ	12
13	PRcDcdhFL5-_DPQpLGUyhw	27
14	u11aqfFI4Q7GrP6O2qNTwQ	4
15	u11aqfFI4Q7GrP6O2qNTwQ	23
16	7zFsxvON_CK3iybolc7v-Q	1
17	7zFsxvON_CK3iybolc7v-Q	2
18	7zFsxvON_CK3iybolc7v-Q	3
19	7zFsxvON_CK3iybolc7v-Q	6
20	7zFsxvON_CK3iybolc7v-Q	7
21	7zFsxvON_CK3iybolc7v-Q	8
22	7zFsxvON_CK3iybolc7v-Q	9
23	7zFsxvON_CK3iybolc7v-Q	11
24	7zFsxvON_CK3iybolc7v-Q	24
25	7zFsxvON_CK3iybolc7v-Q	25
26	pTxMOS0yRgq-tHrsFUANZg	30
27	pTxMOS0yRgq-tHrsFUANZg	31
28	pTxMOS0yRgq-tHrsFUANZg	32
29	r0cIJojii-KSZYKZ6gRHow	33
30	LEEReMdYP9gB1BlGm_9KdQ	34
31	LEEReMdYP9gB1BlGm_9KdQ	35
32	LEEReMdYP9gB1BlGm_9KdQ	36
33	i0jkXqQU4vcfpRB4_qCXew	37
34	rhLs3hN0xW8rBy8xVkg0Kg	38
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
4	978BX-b6-3-asupLjtefQw	cyborg
5	jcwmLzYQ5guXoH7AUMHCzg	game
6	LULr1WDSdFe7cZyrN3uSdw	self
7	QXr8_PbFKwcRq-itqKGy-g	Introspection
8	LEEReMdYP9gB1BlGm_9KdQ	complexnumbers
9	LEEReMdYP9gB1BlGm_9KdQ	strangeattractors
10	LEEReMdYP9gB1BlGm_9KdQ	tesla
11	LEEReMdYP9gB1BlGm_9KdQ	matter
12	LEEReMdYP9gB1BlGm_9KdQ	dimensions
13	LEEReMdYP9gB1BlGm_9KdQ	greek
14	LEEReMdYP9gB1BlGm_9KdQ	huygensprinciple
15	LEEReMdYP9gB1BlGm_9KdQ	spacememory
16	LEEReMdYP9gB1BlGm_9KdQ	zeropointenergy
17	LEEReMdYP9gB1BlGm_9KdQ	universeASvibration
18	LEEReMdYP9gB1BlGm_9KdQ	wavelets
19	LEEReMdYP9gB1BlGm_9KdQ	shiva
20	LEEReMdYP9gB1BlGm_9KdQ	schumannresonance
21	LEEReMdYP9gB1BlGm_9KdQ	YouTube
22	LEEReMdYP9gB1BlGm_9KdQ	holigraphicuniverse
23	LEEReMdYP9gB1BlGm_9KdQ	complexitytheory
24	LEEReMdYP9gB1BlGm_9KdQ	gravity
25	LEEReMdYP9gB1BlGm_9KdQ	waves
26	LEEReMdYP9gB1BlGm_9KdQ	water
27	LEEReMdYP9gB1BlGm_9KdQ	time
28	LEEReMdYP9gB1BlGm_9KdQ	chaostheory
29	LEEReMdYP9gB1BlGm_9KdQ	spacetime
30	LEEReMdYP9gB1BlGm_9KdQ	perception
31	LEEReMdYP9gB1BlGm_9KdQ	NigelStanford
32	LEEReMdYP9gB1BlGm_9KdQ	vortex
33	LEEReMdYP9gB1BlGm_9KdQ	nonlinearresonance
34	LEEReMdYP9gB1BlGm_9KdQ	solids
35	LEEReMdYP9gB1BlGm_9KdQ	fractals
36	LEEReMdYP9gB1BlGm_9KdQ	kantianwholes
\.


--
-- Data for Name: insight_post_loves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_loves (id, post_id, account_id) FROM stdin;
1	0Q-7CSIjd227wSsDUjr3Ug	7007436997
2	0Q-7CSIjd227wSsDUjr3Ug	8127581701
3	0Q-7CSIjd227wSsDUjr3Ug	8005089340
4	0Q-7CSIjd227wSsDUjr3Ug	6394694324
5	0Q-7CSIjd227wSsDUjr3Ug	9026457979
6	0Q-7CSIjd227wSsDUjr3Ug	7737102386
7	0Q-7CSIjd227wSsDUjr3Ug	6392886167
8	0Q-7CSIjd227wSsDUjr3Ug	8303263859
9	31nvDJU6ba7I8E7Fq9LoOA	7618806480
10	31nvDJU6ba7I8E7Fq9LoOA	8416970886
11	31nvDJU6ba7I8E7Fq9LoOA	7007436997
12	31nvDJU6ba7I8E7Fq9LoOA	8005089340
13	31nvDJU6ba7I8E7Fq9LoOA	6387348945
14	31nvDJU6ba7I8E7Fq9LoOA	9026457979
15	31nvDJU6ba7I8E7Fq9LoOA	7737102386
16	31nvDJU6ba7I8E7Fq9LoOA	6392886167
17	31nvDJU6ba7I8E7Fq9LoOA	8303263859
18	31nvDJU6ba7I8E7Fq9LoOA	8932081360
19	31nvDJU6ba7I8E7Fq9LoOA	7619963044
20	31nvDJU6ba7I8E7Fq9LoOA	7234840507
21	31nvDJU6ba7I8E7Fq9LoOA	8756516916
22	4k36LN3aSBh1E-EivBjWuw	7618806480
23	4k36LN3aSBh1E-EivBjWuw	7007257972
24	4k36LN3aSBh1E-EivBjWuw	9660808647
25	4k36LN3aSBh1E-EivBjWuw	7007436997
26	4k36LN3aSBh1E-EivBjWuw	8005089340
27	4k36LN3aSBh1E-EivBjWuw	6387348945
28	4k36LN3aSBh1E-EivBjWuw	6394694324
29	4k36LN3aSBh1E-EivBjWuw	8429089691
30	4k36LN3aSBh1E-EivBjWuw	7737102386
31	4k36LN3aSBh1E-EivBjWuw	9026457979
32	4k36LN3aSBh1E-EivBjWuw	8303263859
33	4k36LN3aSBh1E-EivBjWuw	6392886167
34	4k36LN3aSBh1E-EivBjWuw	7234840507
35	4k36LN3aSBh1E-EivBjWuw	8756516916
36	-4ZTNt9kLbvmYvs2UGsRrw	7007436997
37	-4ZTNt9kLbvmYvs2UGsRrw	8005089340
38	-4ZTNt9kLbvmYvs2UGsRrw	9026457979
39	-4ZTNt9kLbvmYvs2UGsRrw	7737102386
40	-4ZTNt9kLbvmYvs2UGsRrw	6392886167
41	-4ZTNt9kLbvmYvs2UGsRrw	8303263859
42	5vri0VOejjc-b_XyHicdDg	9598239351
43	5vri0VOejjc-b_XyHicdDg	7007436997
44	5vri0VOejjc-b_XyHicdDg	8005089340
45	5vri0VOejjc-b_XyHicdDg	6387348945
46	5vri0VOejjc-b_XyHicdDg	6394694324
47	5vri0VOejjc-b_XyHicdDg	9026457979
48	5vri0VOejjc-b_XyHicdDg	7737102386
49	5vri0VOejjc-b_XyHicdDg	6392886167
50	5vri0VOejjc-b_XyHicdDg	8756516916
51	6r1Ln5D5VXmefS2WJz9VKA	7007436997
52	6r1Ln5D5VXmefS2WJz9VKA	8005089340
53	6r1Ln5D5VXmefS2WJz9VKA	9026457979
54	6r1Ln5D5VXmefS2WJz9VKA	7737102386
55	6r1Ln5D5VXmefS2WJz9VKA	8756516916
56	978BX-b6-3-asupLjtefQw	7737102386
57	978BX-b6-3-asupLjtefQw	7007436997
58	978BX-b6-3-asupLjtefQw	8756516916
59	9MBbQ__Y9mrn1rUQYaj44g	7618806480
60	9MBbQ__Y9mrn1rUQYaj44g	7007257972
61	9MBbQ__Y9mrn1rUQYaj44g	7007436997
62	9MBbQ__Y9mrn1rUQYaj44g	8005089340
63	9MBbQ__Y9mrn1rUQYaj44g	6387348945
64	9MBbQ__Y9mrn1rUQYaj44g	7651892854
65	9MBbQ__Y9mrn1rUQYaj44g	6394694324
66	9MBbQ__Y9mrn1rUQYaj44g	8429089691
67	9MBbQ__Y9mrn1rUQYaj44g	7737102386
68	9MBbQ__Y9mrn1rUQYaj44g	9026457979
69	9MBbQ__Y9mrn1rUQYaj44g	8303263859
70	9MBbQ__Y9mrn1rUQYaj44g	8737942594
71	9MBbQ__Y9mrn1rUQYaj44g	6392886167
72	9MBbQ__Y9mrn1rUQYaj44g	8756516916
73	ABt-aZVrRebN3JvYPet3HQ	7007436997
74	ABt-aZVrRebN3JvYPet3HQ	8005089340
75	ABt-aZVrRebN3JvYPet3HQ	6394694324
76	ABt-aZVrRebN3JvYPet3HQ	9026457979
77	ABt-aZVrRebN3JvYPet3HQ	7737102386
78	auhqqzyE-eCjqUGpgVtVsQ	7007257972
79	auhqqzyE-eCjqUGpgVtVsQ	7007436997
80	auhqqzyE-eCjqUGpgVtVsQ	7737102386
81	auhqqzyE-eCjqUGpgVtVsQ	6392886167
82	auhqqzyE-eCjqUGpgVtVsQ	8756516916
83	babjCt2f9XQ_tGSEflV92Q	7007436997
84	babjCt2f9XQ_tGSEflV92Q	8005089340
85	babjCt2f9XQ_tGSEflV92Q	6394694324
86	babjCt2f9XQ_tGSEflV92Q	7737102386
87	babjCt2f9XQ_tGSEflV92Q	6392886167
88	babjCt2f9XQ_tGSEflV92Q	8756516916
89	baK0jkr-tsfAjNsUPOoO3Q	7007436997
90	baK0jkr-tsfAjNsUPOoO3Q	8005089340
91	baK0jkr-tsfAjNsUPOoO3Q	7737102386
92	baK0jkr-tsfAjNsUPOoO3Q	6392886167
93	baK0jkr-tsfAjNsUPOoO3Q	8756516916
94	bu5UqrnnxuK61T4lIJx-7w	7618806480
95	bu5UqrnnxuK61T4lIJx-7w	8416970886
96	bu5UqrnnxuK61T4lIJx-7w	7007257972
97	bu5UqrnnxuK61T4lIJx-7w	7007436997
98	bu5UqrnnxuK61T4lIJx-7w	8005089340
99	bu5UqrnnxuK61T4lIJx-7w	6387348945
100	bu5UqrnnxuK61T4lIJx-7w	7651892854
101	bu5UqrnnxuK61T4lIJx-7w	8881989296
102	bu5UqrnnxuK61T4lIJx-7w	7737102386
103	bu5UqrnnxuK61T4lIJx-7w	9026457979
104	bu5UqrnnxuK61T4lIJx-7w	8303263859
105	bu5UqrnnxuK61T4lIJx-7w	6392886167
106	bu5UqrnnxuK61T4lIJx-7w	7234840507
107	bu5UqrnnxuK61T4lIJx-7w	8756516916
108	Axs64rjC3C9q7svcPOSIxw	7007436997
109	Axs64rjC3C9q7svcPOSIxw	8005089340
110	Axs64rjC3C9q7svcPOSIxw	9026457979
111	Axs64rjC3C9q7svcPOSIxw	7737102386
112	Axs64rjC3C9q7svcPOSIxw	8756516916
113	7SsWTtJSKuO5Fg06hiCs7A	8416970886
114	7SsWTtJSKuO5Fg06hiCs7A	7007257972
115	7SsWTtJSKuO5Fg06hiCs7A	7007436997
116	7SsWTtJSKuO5Fg06hiCs7A	8005089340
117	7SsWTtJSKuO5Fg06hiCs7A	6387348945
118	7SsWTtJSKuO5Fg06hiCs7A	6394694324
119	7SsWTtJSKuO5Fg06hiCs7A	8881989296
120	7SsWTtJSKuO5Fg06hiCs7A	7737102386
121	7SsWTtJSKuO5Fg06hiCs7A	8953643577
122	7SsWTtJSKuO5Fg06hiCs7A	8303263859
123	7SsWTtJSKuO5Fg06hiCs7A	9026457979
124	7SsWTtJSKuO5Fg06hiCs7A	6392886167
125	7SsWTtJSKuO5Fg06hiCs7A	7619963044
126	7SsWTtJSKuO5Fg06hiCs7A	7234840507
127	7SsWTtJSKuO5Fg06hiCs7A	8756516916
128	buEIaJZo-Eq_Phnvw744OA	7007436997
129	buEIaJZo-Eq_Phnvw744OA	8005089340
130	buEIaJZo-Eq_Phnvw744OA	6387348945
131	buEIaJZo-Eq_Phnvw744OA	9026457979
132	buEIaJZo-Eq_Phnvw744OA	7737102386
133	buEIaJZo-Eq_Phnvw744OA	6392886167
134	buEIaJZo-Eq_Phnvw744OA	8303263859
135	buEIaJZo-Eq_Phnvw744OA	8932081360
136	CO7vyv98Va88DNRwtOx3mw	7737102386
137	CO7vyv98Va88DNRwtOx3mw	7007436997
138	CO7vyv98Va88DNRwtOx3mw	8005089340
139	DLN5GxgEr1yBAeXwNHAyyw	7007436997
140	DLN5GxgEr1yBAeXwNHAyyw	8005089340
141	DLN5GxgEr1yBAeXwNHAyyw	6394694324
142	DLN5GxgEr1yBAeXwNHAyyw	9026457979
143	DLN5GxgEr1yBAeXwNHAyyw	7737102386
144	DLN5GxgEr1yBAeXwNHAyyw	6392886167
145	DLN5GxgEr1yBAeXwNHAyyw	8756516916
146	ETRqZ1JfHxV6UHaIAAlThQ	7007436997
147	ETRqZ1JfHxV6UHaIAAlThQ	8005089340
148	ETRqZ1JfHxV6UHaIAAlThQ	9026457979
149	ETRqZ1JfHxV6UHaIAAlThQ	7737102386
150	ETRqZ1JfHxV6UHaIAAlThQ	8303263859
151	hFQieKb9LmfG9M-ow8H4Fw	7737102386
152	hFQieKb9LmfG9M-ow8H4Fw	7007436997
153	hFQieKb9LmfG9M-ow8H4Fw	8005089340
154	hFQieKb9LmfG9M-ow8H4Fw	9026457979
155	I9ufVQhFCOTAFtEre0KmFw	7007257972
156	I9ufVQhFCOTAFtEre0KmFw	7007436997
157	I9ufVQhFCOTAFtEre0KmFw	8005089340
158	I9ufVQhFCOTAFtEre0KmFw	6394694324
159	I9ufVQhFCOTAFtEre0KmFw	9026457979
160	I9ufVQhFCOTAFtEre0KmFw	7737102386
161	I9ufVQhFCOTAFtEre0KmFw	8756516916
162	iRcCI8btV9zcyqVWdjpa_g	7618806480
163	iRcCI8btV9zcyqVWdjpa_g	7007436997
164	iRcCI8btV9zcyqVWdjpa_g	8005089340
165	iRcCI8btV9zcyqVWdjpa_g	6387348945
166	iRcCI8btV9zcyqVWdjpa_g	7651892854
167	iRcCI8btV9zcyqVWdjpa_g	6394694324
168	iRcCI8btV9zcyqVWdjpa_g	9026457979
169	iRcCI8btV9zcyqVWdjpa_g	7737102386
170	iRcCI8btV9zcyqVWdjpa_g	8303263859
171	iRcCI8btV9zcyqVWdjpa_g	7234840507
172	iRcCI8btV9zcyqVWdjpa_g	8756516916
173	JdiJ3qHCQXZgYz2FsqyrIA	7007436997
174	JdiJ3qHCQXZgYz2FsqyrIA	8005089340
175	JdiJ3qHCQXZgYz2FsqyrIA	7651892854
176	JdiJ3qHCQXZgYz2FsqyrIA	9120759992
177	JdiJ3qHCQXZgYz2FsqyrIA	7737102386
178	JdiJ3qHCQXZgYz2FsqyrIA	9026457979
179	JdiJ3qHCQXZgYz2FsqyrIA	8303263859
180	JdiJ3qHCQXZgYz2FsqyrIA	6392886167
181	JdiJ3qHCQXZgYz2FsqyrIA	7619963044
182	JdiJ3qHCQXZgYz2FsqyrIA	8756516916
183	ErlbT3s5RVymkVDFebUW6A	8127581701
184	ErlbT3s5RVymkVDFebUW6A	9555782418
185	ErlbT3s5RVymkVDFebUW6A	8005089340
186	ErlbT3s5RVymkVDFebUW6A	7081878499
187	ErlbT3s5RVymkVDFebUW6A	7737102386
188	ErlbT3s5RVymkVDFebUW6A	9026457979
189	ErlbT3s5RVymkVDFebUW6A	6392886167
190	ErlbT3s5RVymkVDFebUW6A	8756516916
191	ErlbT3s5RVymkVDFebUW6A	9336394079
192	IHZAIpwm8Vo2Tv7rUjcXEw	8416970886
193	IHZAIpwm8Vo2Tv7rUjcXEw	7007257972
194	IHZAIpwm8Vo2Tv7rUjcXEw	7007436997
195	IHZAIpwm8Vo2Tv7rUjcXEw	8005089340
196	IHZAIpwm8Vo2Tv7rUjcXEw	6387348945
197	IHZAIpwm8Vo2Tv7rUjcXEw	8429089691
198	IHZAIpwm8Vo2Tv7rUjcXEw	7737102386
199	IHZAIpwm8Vo2Tv7rUjcXEw	9026457979
200	IHZAIpwm8Vo2Tv7rUjcXEw	8303263859
201	IHZAIpwm8Vo2Tv7rUjcXEw	6392886167
202	IHZAIpwm8Vo2Tv7rUjcXEw	7619963044
203	IHZAIpwm8Vo2Tv7rUjcXEw	8756516916
204	iQ_vARSYwUHeRtZaT-0WfQ	7737102386
205	iQ_vARSYwUHeRtZaT-0WfQ	6392886167
206	iQ_vARSYwUHeRtZaT-0WfQ	7007436997
207	iQ_vARSYwUHeRtZaT-0WfQ	9026457979
208	i0jkXqQU4vcfpRB4_qCXew	7007436997
209	i0jkXqQU4vcfpRB4_qCXew	6394694324
210	i0jkXqQU4vcfpRB4_qCXew	9026457979
211	i0jkXqQU4vcfpRB4_qCXew	7737102386
212	i0jkXqQU4vcfpRB4_qCXew	6392886167
213	i0jkXqQU4vcfpRB4_qCXew	8303263859
214	i0jkXqQU4vcfpRB4_qCXew	8756516916
215	cjE85vs4DUvXUNVFqpdUiw	7052546269
216	cjE85vs4DUvXUNVFqpdUiw	7007257972
217	cjE85vs4DUvXUNVFqpdUiw	7860080923
218	cjE85vs4DUvXUNVFqpdUiw	7007436997
219	cjE85vs4DUvXUNVFqpdUiw	8005089340
220	cjE85vs4DUvXUNVFqpdUiw	6387348945
221	cjE85vs4DUvXUNVFqpdUiw	7651892854
222	cjE85vs4DUvXUNVFqpdUiw	9696109124
223	cjE85vs4DUvXUNVFqpdUiw	6394694324
224	cjE85vs4DUvXUNVFqpdUiw	8429089691
225	cjE85vs4DUvXUNVFqpdUiw	7737102386
226	cjE85vs4DUvXUNVFqpdUiw	9120759992
227	cjE85vs4DUvXUNVFqpdUiw	9026457979
228	cjE85vs4DUvXUNVFqpdUiw	7705078595
229	cjE85vs4DUvXUNVFqpdUiw	6392886167
230	cjE85vs4DUvXUNVFqpdUiw	8932081360
231	cjE85vs4DUvXUNVFqpdUiw	8756516916
232	FgtbRU_OBpGEoKObzY0L2w	7007436997
233	FgtbRU_OBpGEoKObzY0L2w	6387348945
234	FgtbRU_OBpGEoKObzY0L2w	7651892854
235	FgtbRU_OBpGEoKObzY0L2w	6394694324
236	FgtbRU_OBpGEoKObzY0L2w	9026457979
237	FgtbRU_OBpGEoKObzY0L2w	7737102386
238	FgtbRU_OBpGEoKObzY0L2w	6392886167
239	jOIVo_RoRNYlPyQCePYPYA	7618806480
240	jOIVo_RoRNYlPyQCePYPYA	7007436997
241	jOIVo_RoRNYlPyQCePYPYA	8005089340
242	jOIVo_RoRNYlPyQCePYPYA	9026457979
243	jOIVo_RoRNYlPyQCePYPYA	7737102386
244	jOIVo_RoRNYlPyQCePYPYA	6392886167
245	jOIVo_RoRNYlPyQCePYPYA	8303263859
246	jOIVo_RoRNYlPyQCePYPYA	7234840507
247	LBR4VzdfJ8w_fbc3ku7DsA	7737102386
248	LBR4VzdfJ8w_fbc3ku7DsA	7007436997
249	LBR4VzdfJ8w_fbc3ku7DsA	8005089340
250	LBR4VzdfJ8w_fbc3ku7DsA	9026457979
251	lepWVk7U8vcVL6K1PaOTPw	8416970886
252	lepWVk7U8vcVL6K1PaOTPw	7007436997
253	lepWVk7U8vcVL6K1PaOTPw	8005089340
254	lepWVk7U8vcVL6K1PaOTPw	9026457979
255	lepWVk7U8vcVL6K1PaOTPw	7737102386
256	lepWVk7U8vcVL6K1PaOTPw	6392886167
257	lepWVk7U8vcVL6K1PaOTPw	8303263859
258	lepWVk7U8vcVL6K1PaOTPw	8932081360
259	mfwX-rApctnwYnWNs1aF-w	7618806480
260	mfwX-rApctnwYnWNs1aF-w	7007257972
261	mfwX-rApctnwYnWNs1aF-w	7860080923
262	mfwX-rApctnwYnWNs1aF-w	7007436997
263	mfwX-rApctnwYnWNs1aF-w	8005089340
264	mfwX-rApctnwYnWNs1aF-w	6387348945
265	mfwX-rApctnwYnWNs1aF-w	6394694324
266	mfwX-rApctnwYnWNs1aF-w	8429089691
267	mfwX-rApctnwYnWNs1aF-w	7737102386
268	mfwX-rApctnwYnWNs1aF-w	9026457979
269	mfwX-rApctnwYnWNs1aF-w	8303263859
270	mfwX-rApctnwYnWNs1aF-w	6392886167
271	mfwX-rApctnwYnWNs1aF-w	7234840507
272	mfwX-rApctnwYnWNs1aF-w	8756516916
273	MT3230F-vAoiFnOcUWGq_g	7618806480
274	MT3230F-vAoiFnOcUWGq_g	7007436997
275	MT3230F-vAoiFnOcUWGq_g	8005089340
276	MT3230F-vAoiFnOcUWGq_g	7518894470
277	MT3230F-vAoiFnOcUWGq_g	7651892854
278	MT3230F-vAoiFnOcUWGq_g	9026457979
279	MT3230F-vAoiFnOcUWGq_g	7737102386
280	MT3230F-vAoiFnOcUWGq_g	7619963044
281	MT3230F-vAoiFnOcUWGq_g	7234840507
282	MT3230F-vAoiFnOcUWGq_g	8756516916
283	NA5AnQXktdXOiGmKVN-Vfg	8416970886
284	NA5AnQXktdXOiGmKVN-Vfg	7007436997
285	NA5AnQXktdXOiGmKVN-Vfg	8005089340
286	NA5AnQXktdXOiGmKVN-Vfg	9026457979
287	NA5AnQXktdXOiGmKVN-Vfg	7737102386
288	NA5AnQXktdXOiGmKVN-Vfg	6392886167
289	NA5AnQXktdXOiGmKVN-Vfg	8303263859
290	NA5AnQXktdXOiGmKVN-Vfg	7052200095
291	NA5AnQXktdXOiGmKVN-Vfg	8932081360
292	NA5AnQXktdXOiGmKVN-Vfg	7619963044
293	NA5AnQXktdXOiGmKVN-Vfg	8756516916
294	nrc6Zsk-w0_m5xr6JRkydg	7007436997
295	nrc6Zsk-w0_m5xr6JRkydg	8005089340
296	nrc6Zsk-w0_m5xr6JRkydg	9026457979
297	nrc6Zsk-w0_m5xr6JRkydg	7737102386
298	nrc6Zsk-w0_m5xr6JRkydg	6392886167
299	nrc6Zsk-w0_m5xr6JRkydg	8303263859
300	NW8pZiMI1if3FCeZtutsAA	7737102386
301	NW8pZiMI1if3FCeZtutsAA	7007436997
302	NW8pZiMI1if3FCeZtutsAA	8005089340
303	NW8pZiMI1if3FCeZtutsAA	9026457979
304	Pn39SEESymig1qthsHBCiQ	7618806480
305	Pn39SEESymig1qthsHBCiQ	7052546269
306	Pn39SEESymig1qthsHBCiQ	7007436997
307	Pn39SEESymig1qthsHBCiQ	8127581701
308	Pn39SEESymig1qthsHBCiQ	8005089340
309	Pn39SEESymig1qthsHBCiQ	6387348945
310	Pn39SEESymig1qthsHBCiQ	6394694324
311	Pn39SEESymig1qthsHBCiQ	9026457979
312	Pn39SEESymig1qthsHBCiQ	7737102386
313	Pn39SEESymig1qthsHBCiQ	6392886167
314	Pn39SEESymig1qthsHBCiQ	8303263859
315	Pn39SEESymig1qthsHBCiQ	7234840507
316	Pn39SEESymig1qthsHBCiQ	8756516916
317	P__sjRcj_ILGr3r6J88mFw	8416970886
318	P__sjRcj_ILGr3r6J88mFw	7007436997
319	P__sjRcj_ILGr3r6J88mFw	8005089340
320	P__sjRcj_ILGr3r6J88mFw	9026457979
321	P__sjRcj_ILGr3r6J88mFw	7737102386
322	P__sjRcj_ILGr3r6J88mFw	8303263859
323	QOuxw_71UkGCrnNOSrsL4Q	7618806480
324	QOuxw_71UkGCrnNOSrsL4Q	8416970886
325	QOuxw_71UkGCrnNOSrsL4Q	7007436997
326	QOuxw_71UkGCrnNOSrsL4Q	8005089340
327	QOuxw_71UkGCrnNOSrsL4Q	9026457979
328	QOuxw_71UkGCrnNOSrsL4Q	7737102386
329	QOuxw_71UkGCrnNOSrsL4Q	6392886167
330	t7qQpdlOSO4buwmTRvjd_A	7007257972
331	t7qQpdlOSO4buwmTRvjd_A	7860080923
332	t7qQpdlOSO4buwmTRvjd_A	7007436997
333	t7qQpdlOSO4buwmTRvjd_A	8005089340
334	t7qQpdlOSO4buwmTRvjd_A	6387348945
335	t7qQpdlOSO4buwmTRvjd_A	7651892854
336	t7qQpdlOSO4buwmTRvjd_A	6394694324
337	t7qQpdlOSO4buwmTRvjd_A	9026457979
338	t7qQpdlOSO4buwmTRvjd_A	7737102386
339	t7qQpdlOSO4buwmTRvjd_A	8737942594
340	t7qQpdlOSO4buwmTRvjd_A	8932081360
341	t7qQpdlOSO4buwmTRvjd_A	8756516916
342	t7qQpdlOSO4buwmTRvjd_A	9118733514
343	PRcDcdhFL5-_DPQpLGUyhw	7007436997
344	PRcDcdhFL5-_DPQpLGUyhw	8127581701
345	PRcDcdhFL5-_DPQpLGUyhw	9026457979
346	PRcDcdhFL5-_DPQpLGUyhw	7737102386
347	PRcDcdhFL5-_DPQpLGUyhw	6392886167
348	PRcDcdhFL5-_DPQpLGUyhw	8756516916
349	oLSA5AyHX7_REShThZqOPA	7007257972
350	oLSA5AyHX7_REShThZqOPA	9026457979
351	tMjprPvWBLiDKird-8Xw9Q	7737102386
352	tMjprPvWBLiDKird-8Xw9Q	7007436997
353	tMjprPvWBLiDKird-8Xw9Q	9026457979
354	u11aqfFI4Q7GrP6O2qNTwQ	7007436997
355	u11aqfFI4Q7GrP6O2qNTwQ	8127581701
356	u11aqfFI4Q7GrP6O2qNTwQ	8005089340
357	u11aqfFI4Q7GrP6O2qNTwQ	9026457979
358	u11aqfFI4Q7GrP6O2qNTwQ	7737102386
359	u11aqfFI4Q7GrP6O2qNTwQ	6392886167
360	u11aqfFI4Q7GrP6O2qNTwQ	8756516916
361	u11aqfFI4Q7GrP6O2qNTwQ	9336394079
362	vf8orZs86q1pLPLRInihlg	7007257972
363	vf8orZs86q1pLPLRInihlg	7007436997
364	vf8orZs86q1pLPLRInihlg	8005089340
365	vf8orZs86q1pLPLRInihlg	7737102386
366	vf8orZs86q1pLPLRInihlg	6392886167
367	vf8orZs86q1pLPLRInihlg	8737942594
368	vf8orZs86q1pLPLRInihlg	8756516916
369	VhKJe0Id8bBeoLX1a3yBeQ	7737102386
370	VhKJe0Id8bBeoLX1a3yBeQ	9026457979
371	wU13FH-lxct68TgtOM-Wzw	7007436997
372	wU13FH-lxct68TgtOM-Wzw	8005089340
373	wU13FH-lxct68TgtOM-Wzw	9026457979
374	wU13FH-lxct68TgtOM-Wzw	7737102386
375	wU13FH-lxct68TgtOM-Wzw	8303263859
376	XH3vTr6CYwOdJvtwNx76Fg	7007436997
377	XH3vTr6CYwOdJvtwNx76Fg	8005089340
378	XH3vTr6CYwOdJvtwNx76Fg	9026457979
379	XH3vTr6CYwOdJvtwNx76Fg	7737102386
380	XH3vTr6CYwOdJvtwNx76Fg	6392886167
381	xlZkRqkHXXWBG9JCbSEcDA	7007436997
382	xlZkRqkHXXWBG9JCbSEcDA	8005089340
383	xlZkRqkHXXWBG9JCbSEcDA	6394694324
384	xlZkRqkHXXWBG9JCbSEcDA	9026457979
385	xlZkRqkHXXWBG9JCbSEcDA	7737102386
386	xlZkRqkHXXWBG9JCbSEcDA	8303263859
387	YNJwxQxDzexGn_BipWMK-w	7737102386
388	YNJwxQxDzexGn_BipWMK-w	7007436997
389	YNJwxQxDzexGn_BipWMK-w	8005089340
390	YNJwxQxDzexGn_BipWMK-w	9026457979
391	Z3N8wXLg5fl-qTeEHtYmlw	7007436997
392	Z3N8wXLg5fl-qTeEHtYmlw	8005089340
393	Z3N8wXLg5fl-qTeEHtYmlw	9026457979
394	Z3N8wXLg5fl-qTeEHtYmlw	7737102386
395	Z3N8wXLg5fl-qTeEHtYmlw	8303263859
396	-cXERyo0mztEecOopTbFDg	6392886167
397	-cXERyo0mztEecOopTbFDg	8005089340
398	y5QT4wUXGykRS2IrBGl5tw	7618806480
399	y5QT4wUXGykRS2IrBGl5tw	7007257972
400	y5QT4wUXGykRS2IrBGl5tw	7860080923
401	y5QT4wUXGykRS2IrBGl5tw	7007436997
402	y5QT4wUXGykRS2IrBGl5tw	8005089340
403	y5QT4wUXGykRS2IrBGl5tw	6387348945
404	y5QT4wUXGykRS2IrBGl5tw	7651892854
405	y5QT4wUXGykRS2IrBGl5tw	6394694324
406	y5QT4wUXGykRS2IrBGl5tw	8429089691
407	y5QT4wUXGykRS2IrBGl5tw	7737102386
408	y5QT4wUXGykRS2IrBGl5tw	9026457979
409	y5QT4wUXGykRS2IrBGl5tw	8303263859
410	y5QT4wUXGykRS2IrBGl5tw	8737942594
411	y5QT4wUXGykRS2IrBGl5tw	6392886167
412	y5QT4wUXGykRS2IrBGl5tw	8932081360
413	y5QT4wUXGykRS2IrBGl5tw	7234840507
414	y5QT4wUXGykRS2IrBGl5tw	8756516916
415	iBSICg_5KqoY3EoSQRaZzA	6392886167
416	7zFsxvON_CK3iybolc7v-Q	7007257972
417	7zFsxvON_CK3iybolc7v-Q	7081878499
418	7zFsxvON_CK3iybolc7v-Q	7737102386
419	7zFsxvON_CK3iybolc7v-Q	6392886167
420	7zFsxvON_CK3iybolc7v-Q	8756516916
421	x8CyIOD389nfRak4EE6U4Q	7737102386
422	x8CyIOD389nfRak4EE6U4Q	7007436997
423	x8CyIOD389nfRak4EE6U4Q	8005089340
424	x8CyIOD389nfRak4EE6U4Q	8756516916
425	jcwmLzYQ5guXoH7AUMHCzg	6392886167
426	jcwmLzYQ5guXoH7AUMHCzg	9026457979
427	o1ztqUTZnHrXJxQMKTAATg	7007436997
428	o1ztqUTZnHrXJxQMKTAATg	6387348945
429	o1ztqUTZnHrXJxQMKTAATg	6394694324
430	o1ztqUTZnHrXJxQMKTAATg	9026457979
431	o1ztqUTZnHrXJxQMKTAATg	7737102386
432	o1ztqUTZnHrXJxQMKTAATg	6392886167
433	o1ztqUTZnHrXJxQMKTAATg	8303263859
434	o1ztqUTZnHrXJxQMKTAATg	8756516916
435	LULr1WDSdFe7cZyrN3uSdw	6392886167
469	9MBbQ__Y9mrn1rUQYaj44g	8875309289
471	-4ZTNt9kLbvmYvs2UGsRrw	8756516916
474	pTxMOS0yRgq-tHrsFUANZg	6392886167
475	LULr1WDSdFe7cZyrN3uSdw	9026457979
476	NYX2T1Ad937_7N0EV9a8TQ	8005089340
477	XOBXUqnreGJS49wHY45dDw	9026457979
478	-cXERyo0mztEecOopTbFDg	9026457979
479	r0cIJojii-KSZYKZ6gRHow	8005089340
480	pTxMOS0yRgq-tHrsFUANZg	8005089340
481	oLSA5AyHX7_REShThZqOPA	8005089340
482	i0jkXqQU4vcfpRB4_qCXew	8005089340
483	978BX-b6-3-asupLjtefQw	8005089340
484	auhqqzyE-eCjqUGpgVtVsQ	8005089340
485	XOBXUqnreGJS49wHY45dDw	8005089340
501	Qfu4WT4PRq4yX4OuYLLiJg	6392886167
502	Z6ymAwIeJzbN91jL6LLTGw	6392886167
503	r0cIJojii-KSZYKZ6gRHow	6392886167
509	VhKJe0Id8bBeoLX1a3yBeQ	6392886167
510	QXr8_PbFKwcRq-itqKGy-g	8005089340
511	pTxMOS0yRgq-tHrsFUANZg	8756516916
512	LEEReMdYP9gB1BlGm_9KdQ	8005089340
515	QXr8_PbFKwcRq-itqKGy-g	6392886167
516	LEEReMdYP9gB1BlGm_9KdQ	6392886167
517	LULr1WDSdFe7cZyrN3uSdw	9653010765
519	i0jkXqQU4vcfpRB4_qCXew	9838712221
520	babjCt2f9XQ_tGSEflV92Q	9838712221
522	6OvBZUxjKJBCf7Ki7SFN3A	8005089340
523	aAo3oIT9ZI2CGZ-ONJ-tYA	8005089340
526	QXr8_PbFKwcRq-itqKGy-g	9696706036
528	LEEReMdYP9gB1BlGm_9KdQ	9696706036
529	6OvBZUxjKJBCf7Ki7SFN3A	9696706036
530	9E_HU18hpX__oysTRzGlfg	9838712221
531	6OvBZUxjKJBCf7Ki7SFN3A	6392886167
532	Swl4oGSwZzqJE0BKfDDnjA	6392886167
533	9E_HU18hpX__oysTRzGlfg	6392886167
534	aAo3oIT9ZI2CGZ-ONJ-tYA	6392886167
535	Swl4oGSwZzqJE0BKfDDnjA	8005089340
542	rhLs3hN0xW8rBy8xVkg0Kg	8005089340
551	6OvBZUxjKJBCf7Ki7SFN3A	9793656273
552	rhLs3hN0xW8rBy8xVkg0Kg	6392886167
553	LULr1WDSdFe7cZyrN3uSdw	9793656273
555	NYX2T1Ad937_7N0EV9a8TQ	9793656273
557	babjCt2f9XQ_tGSEflV92Q	9793656273
561	ncMzVXG81V5pLq90rL3i8Q	6392886167
\.


--
-- Data for Name: insight_post_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_post_shares (id, post_id, account_id) FROM stdin;
1	ErlbT3s5RVymkVDFebUW6A	6392886167
2	ErlbT3s5RVymkVDFebUW6A	8005089340
3	i0jkXqQU4vcfpRB4_qCXew	8005089340
4	x8CyIOD389nfRak4EE6U4Q	6392886167
5	pTxMOS0yRgq-tHrsFUANZg	6392886167
6	LEEReMdYP9gB1BlGm_9KdQ	6392886167
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
1	FgtbRU_OBpGEoKObzY0L2w	6392886167
2	7zFsxvON_CK3iybolc7v-Q	6392886167
3	o1ztqUTZnHrXJxQMKTAATg	6392886167
7	t7qQpdlOSO4buwmTRvjd_A	6392886167
8	IHZAIpwm8Vo2Tv7rUjcXEw	6392886167
9	cjE85vs4DUvXUNVFqpdUiw	6392886167
13	0Q-7CSIjd227wSsDUjr3Ug	7007436997
14	0Q-7CSIjd227wSsDUjr3Ug	8005089340
15	0Q-7CSIjd227wSsDUjr3Ug	7651892854
16	0Q-7CSIjd227wSsDUjr3Ug	6394694324
17	0Q-7CSIjd227wSsDUjr3Ug	9026457979
18	0Q-7CSIjd227wSsDUjr3Ug	7737102386
19	0Q-7CSIjd227wSsDUjr3Ug	6392886167
20	0Q-7CSIjd227wSsDUjr3Ug	8303263859
21	0Q-7CSIjd227wSsDUjr3Ug	8756516916
22	31nvDJU6ba7I8E7Fq9LoOA	7618806480
23	31nvDJU6ba7I8E7Fq9LoOA	8416970886
24	31nvDJU6ba7I8E7Fq9LoOA	7007436997
25	31nvDJU6ba7I8E7Fq9LoOA	8005089340
26	31nvDJU6ba7I8E7Fq9LoOA	6387348945
27	31nvDJU6ba7I8E7Fq9LoOA	9026457979
28	31nvDJU6ba7I8E7Fq9LoOA	7737102386
29	31nvDJU6ba7I8E7Fq9LoOA	6392886167
30	31nvDJU6ba7I8E7Fq9LoOA	8303263859
31	31nvDJU6ba7I8E7Fq9LoOA	8932081360
32	31nvDJU6ba7I8E7Fq9LoOA	7619963044
33	31nvDJU6ba7I8E7Fq9LoOA	7234840507
34	31nvDJU6ba7I8E7Fq9LoOA	8756516916
35	4k36LN3aSBh1E-EivBjWuw	7618806480
36	4k36LN3aSBh1E-EivBjWuw	7007257972
37	4k36LN3aSBh1E-EivBjWuw	9598239351
38	4k36LN3aSBh1E-EivBjWuw	7007436997
39	4k36LN3aSBh1E-EivBjWuw	9660808647
40	4k36LN3aSBh1E-EivBjWuw	8005089340
41	4k36LN3aSBh1E-EivBjWuw	7518894470
42	4k36LN3aSBh1E-EivBjWuw	7651892854
43	4k36LN3aSBh1E-EivBjWuw	6394694324
44	4k36LN3aSBh1E-EivBjWuw	7081878499
45	4k36LN3aSBh1E-EivBjWuw	7737102386
46	4k36LN3aSBh1E-EivBjWuw	8429089691
47	4k36LN3aSBh1E-EivBjWuw	8303263859
48	4k36LN3aSBh1E-EivBjWuw	9026457979
49	4k36LN3aSBh1E-EivBjWuw	6392886167
50	4k36LN3aSBh1E-EivBjWuw	7234840507
51	4k36LN3aSBh1E-EivBjWuw	8756516916
52	4k36LN3aSBh1E-EivBjWuw	9336394079
53	-4ZTNt9kLbvmYvs2UGsRrw	7007436997
54	-4ZTNt9kLbvmYvs2UGsRrw	8005089340
55	-4ZTNt9kLbvmYvs2UGsRrw	9026457979
56	-4ZTNt9kLbvmYvs2UGsRrw	7737102386
57	-4ZTNt9kLbvmYvs2UGsRrw	6392886167
58	-4ZTNt9kLbvmYvs2UGsRrw	8303263859
59	-4ZTNt9kLbvmYvs2UGsRrw	8756516916
60	5vri0VOejjc-b_XyHicdDg	7007257972
61	5vri0VOejjc-b_XyHicdDg	9598239351
62	5vri0VOejjc-b_XyHicdDg	7007436997
63	5vri0VOejjc-b_XyHicdDg	8005089340
64	5vri0VOejjc-b_XyHicdDg	6387348945
65	5vri0VOejjc-b_XyHicdDg	7651892854
66	5vri0VOejjc-b_XyHicdDg	9026457979
67	5vri0VOejjc-b_XyHicdDg	6392886167
68	5vri0VOejjc-b_XyHicdDg	8756516916
69	6r1Ln5D5VXmefS2WJz9VKA	7007436997
70	6r1Ln5D5VXmefS2WJz9VKA	8005089340
71	6r1Ln5D5VXmefS2WJz9VKA	9026457979
72	6r1Ln5D5VXmefS2WJz9VKA	7737102386
73	6r1Ln5D5VXmefS2WJz9VKA	6392886167
74	978BX-b6-3-asupLjtefQw	9198572009
75	978BX-b6-3-asupLjtefQw	7007436997
76	978BX-b6-3-asupLjtefQw	8005089340
77	978BX-b6-3-asupLjtefQw	7081878499
78	978BX-b6-3-asupLjtefQw	9026457979
79	978BX-b6-3-asupLjtefQw	6392886167
80	978BX-b6-3-asupLjtefQw	8756516916
81	9MBbQ__Y9mrn1rUQYaj44g	7618806480
82	9MBbQ__Y9mrn1rUQYaj44g	7007257972
83	9MBbQ__Y9mrn1rUQYaj44g	7007436997
84	9MBbQ__Y9mrn1rUQYaj44g	8005089340
85	9MBbQ__Y9mrn1rUQYaj44g	6387348945
86	9MBbQ__Y9mrn1rUQYaj44g	7518894470
87	9MBbQ__Y9mrn1rUQYaj44g	7651892854
88	9MBbQ__Y9mrn1rUQYaj44g	6394694324
89	9MBbQ__Y9mrn1rUQYaj44g	8429089691
90	9MBbQ__Y9mrn1rUQYaj44g	7737102386
91	9MBbQ__Y9mrn1rUQYaj44g	9026457979
92	9MBbQ__Y9mrn1rUQYaj44g	8303263859
93	9MBbQ__Y9mrn1rUQYaj44g	8737942594
94	9MBbQ__Y9mrn1rUQYaj44g	6392886167
95	9MBbQ__Y9mrn1rUQYaj44g	8756516916
96	ABt-aZVrRebN3JvYPet3HQ	7007436997
97	ABt-aZVrRebN3JvYPet3HQ	8005089340
98	ABt-aZVrRebN3JvYPet3HQ	6394694324
99	ABt-aZVrRebN3JvYPet3HQ	9026457979
100	ABt-aZVrRebN3JvYPet3HQ	7737102386
101	ABt-aZVrRebN3JvYPet3HQ	6392886167
102	auhqqzyE-eCjqUGpgVtVsQ	7007257972
103	auhqqzyE-eCjqUGpgVtVsQ	9198572009
104	auhqqzyE-eCjqUGpgVtVsQ	7007436997
105	auhqqzyE-eCjqUGpgVtVsQ	8005089340
106	auhqqzyE-eCjqUGpgVtVsQ	9026457979
107	auhqqzyE-eCjqUGpgVtVsQ	7737102386
108	auhqqzyE-eCjqUGpgVtVsQ	6392886167
109	auhqqzyE-eCjqUGpgVtVsQ	8756516916
110	babjCt2f9XQ_tGSEflV92Q	9935682117
111	babjCt2f9XQ_tGSEflV92Q	8005089340
112	babjCt2f9XQ_tGSEflV92Q	7651892854
113	babjCt2f9XQ_tGSEflV92Q	9026457979
114	babjCt2f9XQ_tGSEflV92Q	6392886167
115	babjCt2f9XQ_tGSEflV92Q	8756516916
116	baK0jkr-tsfAjNsUPOoO3Q	7052546269
117	baK0jkr-tsfAjNsUPOoO3Q	9198572009
118	baK0jkr-tsfAjNsUPOoO3Q	7007436997
119	baK0jkr-tsfAjNsUPOoO3Q	8005089340
120	baK0jkr-tsfAjNsUPOoO3Q	7081878499
121	baK0jkr-tsfAjNsUPOoO3Q	9026457979
122	baK0jkr-tsfAjNsUPOoO3Q	6392886167
123	baK0jkr-tsfAjNsUPOoO3Q	8756516916
124	bu5UqrnnxuK61T4lIJx-7w	7618806480
125	bu5UqrnnxuK61T4lIJx-7w	8416970886
126	bu5UqrnnxuK61T4lIJx-7w	7007257972
127	bu5UqrnnxuK61T4lIJx-7w	9598239351
128	bu5UqrnnxuK61T4lIJx-7w	7007436997
129	bu5UqrnnxuK61T4lIJx-7w	8127581701
130	bu5UqrnnxuK61T4lIJx-7w	8005089340
131	bu5UqrnnxuK61T4lIJx-7w	6387348945
132	bu5UqrnnxuK61T4lIJx-7w	7651892854
133	bu5UqrnnxuK61T4lIJx-7w	8881989296
134	bu5UqrnnxuK61T4lIJx-7w	7737102386
135	bu5UqrnnxuK61T4lIJx-7w	9026457979
136	bu5UqrnnxuK61T4lIJx-7w	8303263859
137	bu5UqrnnxuK61T4lIJx-7w	6392886167
138	bu5UqrnnxuK61T4lIJx-7w	7234840507
139	bu5UqrnnxuK61T4lIJx-7w	8756516916
140	Axs64rjC3C9q7svcPOSIxw	7052546269
141	Axs64rjC3C9q7svcPOSIxw	9598239351
142	Axs64rjC3C9q7svcPOSIxw	7007436997
143	Axs64rjC3C9q7svcPOSIxw	8005089340
144	Axs64rjC3C9q7svcPOSIxw	7518894470
145	Axs64rjC3C9q7svcPOSIxw	6392886167
146	Axs64rjC3C9q7svcPOSIxw	7007320787
147	Axs64rjC3C9q7svcPOSIxw	8756516916
148	7SsWTtJSKuO5Fg06hiCs7A	8416970886
149	7SsWTtJSKuO5Fg06hiCs7A	7007257972
150	7SsWTtJSKuO5Fg06hiCs7A	7007436997
151	7SsWTtJSKuO5Fg06hiCs7A	8005089340
152	7SsWTtJSKuO5Fg06hiCs7A	6387348945
153	7SsWTtJSKuO5Fg06hiCs7A	6394694324
154	7SsWTtJSKuO5Fg06hiCs7A	8881989296
155	7SsWTtJSKuO5Fg06hiCs7A	7737102386
156	7SsWTtJSKuO5Fg06hiCs7A	8953643577
157	7SsWTtJSKuO5Fg06hiCs7A	8303263859
158	7SsWTtJSKuO5Fg06hiCs7A	9026457979
159	7SsWTtJSKuO5Fg06hiCs7A	6392886167
160	7SsWTtJSKuO5Fg06hiCs7A	7619963044
161	7SsWTtJSKuO5Fg06hiCs7A	7234840507
162	7SsWTtJSKuO5Fg06hiCs7A	8756516916
163	buEIaJZo-Eq_Phnvw744OA	7007436997
164	buEIaJZo-Eq_Phnvw744OA	8127581701
165	buEIaJZo-Eq_Phnvw744OA	8005089340
166	buEIaJZo-Eq_Phnvw744OA	6387348945
167	buEIaJZo-Eq_Phnvw744OA	9026457979
168	buEIaJZo-Eq_Phnvw744OA	7737102386
169	buEIaJZo-Eq_Phnvw744OA	6392886167
170	buEIaJZo-Eq_Phnvw744OA	8303263859
171	buEIaJZo-Eq_Phnvw744OA	8932081360
172	CO7vyv98Va88DNRwtOx3mw	7737102386
173	CO7vyv98Va88DNRwtOx3mw	6392886167
174	CO7vyv98Va88DNRwtOx3mw	7007436997
175	CO7vyv98Va88DNRwtOx3mw	8005089340
176	DLN5GxgEr1yBAeXwNHAyyw	7618806480
177	DLN5GxgEr1yBAeXwNHAyyw	7007257972
178	DLN5GxgEr1yBAeXwNHAyyw	9598239351
179	DLN5GxgEr1yBAeXwNHAyyw	7007436997
180	DLN5GxgEr1yBAeXwNHAyyw	9935682117
181	DLN5GxgEr1yBAeXwNHAyyw	6387348945
182	DLN5GxgEr1yBAeXwNHAyyw	9120759992
183	DLN5GxgEr1yBAeXwNHAyyw	8303263859
184	DLN5GxgEr1yBAeXwNHAyyw	8005089340
185	DLN5GxgEr1yBAeXwNHAyyw	7651892854
186	DLN5GxgEr1yBAeXwNHAyyw	6394694324
187	DLN5GxgEr1yBAeXwNHAyyw	7737102386
188	DLN5GxgEr1yBAeXwNHAyyw	8756516916
189	DLN5GxgEr1yBAeXwNHAyyw	7081878499
190	DLN5GxgEr1yBAeXwNHAyyw	9026457979
191	DLN5GxgEr1yBAeXwNHAyyw	6392886167
192	DLN5GxgEr1yBAeXwNHAyyw	8737942594
193	DLN5GxgEr1yBAeXwNHAyyw	9177914130
194	DLN5GxgEr1yBAeXwNHAyyw	7905806732
195	ETRqZ1JfHxV6UHaIAAlThQ	7007436997
196	ETRqZ1JfHxV6UHaIAAlThQ	8127581701
197	ETRqZ1JfHxV6UHaIAAlThQ	8005089340
198	ETRqZ1JfHxV6UHaIAAlThQ	9026457979
199	ETRqZ1JfHxV6UHaIAAlThQ	7737102386
200	ETRqZ1JfHxV6UHaIAAlThQ	6392886167
201	ETRqZ1JfHxV6UHaIAAlThQ	8303263859
202	ETRqZ1JfHxV6UHaIAAlThQ	8756516916
203	hFQieKb9LmfG9M-ow8H4Fw	7007436997
204	hFQieKb9LmfG9M-ow8H4Fw	8005089340
205	hFQieKb9LmfG9M-ow8H4Fw	9026457979
206	hFQieKb9LmfG9M-ow8H4Fw	7737102386
207	hFQieKb9LmfG9M-ow8H4Fw	6392886167
208	I9ufVQhFCOTAFtEre0KmFw	7007257972
209	I9ufVQhFCOTAFtEre0KmFw	7007436997
210	I9ufVQhFCOTAFtEre0KmFw	8005089340
211	I9ufVQhFCOTAFtEre0KmFw	7905124622
212	I9ufVQhFCOTAFtEre0KmFw	6394694324
213	I9ufVQhFCOTAFtEre0KmFw	9026457979
214	I9ufVQhFCOTAFtEre0KmFw	7737102386
215	I9ufVQhFCOTAFtEre0KmFw	6392886167
216	I9ufVQhFCOTAFtEre0KmFw	8737942594
217	I9ufVQhFCOTAFtEre0KmFw	7347753366
218	I9ufVQhFCOTAFtEre0KmFw	7317537460
219	I9ufVQhFCOTAFtEre0KmFw	8756516916
220	iRcCI8btV9zcyqVWdjpa_g	7618806480
221	iRcCI8btV9zcyqVWdjpa_g	7007436997
222	iRcCI8btV9zcyqVWdjpa_g	8005089340
223	iRcCI8btV9zcyqVWdjpa_g	6387348945
224	iRcCI8btV9zcyqVWdjpa_g	7518894470
225	iRcCI8btV9zcyqVWdjpa_g	7651892854
226	iRcCI8btV9zcyqVWdjpa_g	6394694324
227	iRcCI8btV9zcyqVWdjpa_g	9026457979
228	iRcCI8btV9zcyqVWdjpa_g	7737102386
229	iRcCI8btV9zcyqVWdjpa_g	6392886167
230	iRcCI8btV9zcyqVWdjpa_g	8303263859
231	iRcCI8btV9zcyqVWdjpa_g	7234840507
232	JdiJ3qHCQXZgYz2FsqyrIA	7052546269
233	JdiJ3qHCQXZgYz2FsqyrIA	7007436997
234	JdiJ3qHCQXZgYz2FsqyrIA	8005089340
235	JdiJ3qHCQXZgYz2FsqyrIA	7651892854
236	JdiJ3qHCQXZgYz2FsqyrIA	9120759992
237	JdiJ3qHCQXZgYz2FsqyrIA	7737102386
238	JdiJ3qHCQXZgYz2FsqyrIA	9026457979
239	JdiJ3qHCQXZgYz2FsqyrIA	8303263859
240	JdiJ3qHCQXZgYz2FsqyrIA	6392886167
241	JdiJ3qHCQXZgYz2FsqyrIA	7619963044
242	JdiJ3qHCQXZgYz2FsqyrIA	8756516916
243	ErlbT3s5RVymkVDFebUW6A	9935682117
244	ErlbT3s5RVymkVDFebUW6A	7007436997
245	ErlbT3s5RVymkVDFebUW6A	8127581701
246	ErlbT3s5RVymkVDFebUW6A	7753966074
247	ErlbT3s5RVymkVDFebUW6A	9555782418
248	ErlbT3s5RVymkVDFebUW6A	8005089340
249	ErlbT3s5RVymkVDFebUW6A	7518894470
250	ErlbT3s5RVymkVDFebUW6A	6855849137
251	ErlbT3s5RVymkVDFebUW6A	7081878499
252	ErlbT3s5RVymkVDFebUW6A	7737102386
253	ErlbT3s5RVymkVDFebUW6A	9026457979
254	ErlbT3s5RVymkVDFebUW6A	6392886167
255	ErlbT3s5RVymkVDFebUW6A	7007320787
256	ErlbT3s5RVymkVDFebUW6A	7905806732
257	ErlbT3s5RVymkVDFebUW6A	9119143495
258	ErlbT3s5RVymkVDFebUW6A	6306416908
259	ErlbT3s5RVymkVDFebUW6A	8756516916
260	ErlbT3s5RVymkVDFebUW6A	9336394079
261	IHZAIpwm8Vo2Tv7rUjcXEw	8416970886
262	IHZAIpwm8Vo2Tv7rUjcXEw	7007257972
263	IHZAIpwm8Vo2Tv7rUjcXEw	7007436997
264	IHZAIpwm8Vo2Tv7rUjcXEw	8127581701
265	IHZAIpwm8Vo2Tv7rUjcXEw	8005089340
266	IHZAIpwm8Vo2Tv7rUjcXEw	6387348945
267	IHZAIpwm8Vo2Tv7rUjcXEw	7651892854
268	IHZAIpwm8Vo2Tv7rUjcXEw	8429089691
269	IHZAIpwm8Vo2Tv7rUjcXEw	7737102386
270	IHZAIpwm8Vo2Tv7rUjcXEw	9026457979
271	IHZAIpwm8Vo2Tv7rUjcXEw	8303263859
272	IHZAIpwm8Vo2Tv7rUjcXEw	7619963044
273	IHZAIpwm8Vo2Tv7rUjcXEw	8756516916
274	iQ_vARSYwUHeRtZaT-0WfQ	7052546269
275	iQ_vARSYwUHeRtZaT-0WfQ	8005089340
276	iQ_vARSYwUHeRtZaT-0WfQ	7518894470
277	iQ_vARSYwUHeRtZaT-0WfQ	9026457979
278	iQ_vARSYwUHeRtZaT-0WfQ	7737102386
279	iQ_vARSYwUHeRtZaT-0WfQ	6392886167
280	iQ_vARSYwUHeRtZaT-0WfQ	8737942594
281	iQ_vARSYwUHeRtZaT-0WfQ	7007320787
282	iQ_vARSYwUHeRtZaT-0WfQ	8756516916
283	i0jkXqQU4vcfpRB4_qCXew	9598239351
284	i0jkXqQU4vcfpRB4_qCXew	7007436997
285	i0jkXqQU4vcfpRB4_qCXew	8127581701
286	i0jkXqQU4vcfpRB4_qCXew	9935682117
287	i0jkXqQU4vcfpRB4_qCXew	8005089340
288	i0jkXqQU4vcfpRB4_qCXew	7518894470
289	i0jkXqQU4vcfpRB4_qCXew	9120759992
290	i0jkXqQU4vcfpRB4_qCXew	7737102386
291	i0jkXqQU4vcfpRB4_qCXew	9026457979
292	i0jkXqQU4vcfpRB4_qCXew	8303263859
293	i0jkXqQU4vcfpRB4_qCXew	6392886167
294	i0jkXqQU4vcfpRB4_qCXew	7007320787
295	i0jkXqQU4vcfpRB4_qCXew	8756516916
296	i0jkXqQU4vcfpRB4_qCXew	9118733514
297	cjE85vs4DUvXUNVFqpdUiw	7052546269
298	cjE85vs4DUvXUNVFqpdUiw	7007257972
299	cjE85vs4DUvXUNVFqpdUiw	7860080923
300	cjE85vs4DUvXUNVFqpdUiw	7007436997
301	cjE85vs4DUvXUNVFqpdUiw	9598239351
302	cjE85vs4DUvXUNVFqpdUiw	8005089340
303	cjE85vs4DUvXUNVFqpdUiw	7518894470
304	cjE85vs4DUvXUNVFqpdUiw	7651892854
305	cjE85vs4DUvXUNVFqpdUiw	9696109124
306	cjE85vs4DUvXUNVFqpdUiw	6394694324
307	cjE85vs4DUvXUNVFqpdUiw	7081878499
308	cjE85vs4DUvXUNVFqpdUiw	7737102386
309	cjE85vs4DUvXUNVFqpdUiw	8429089691
310	cjE85vs4DUvXUNVFqpdUiw	8303263859
311	cjE85vs4DUvXUNVFqpdUiw	9120759992
312	cjE85vs4DUvXUNVFqpdUiw	9026457979
313	cjE85vs4DUvXUNVFqpdUiw	8932081360
314	cjE85vs4DUvXUNVFqpdUiw	8756516916
315	FgtbRU_OBpGEoKObzY0L2w	7007257972
316	FgtbRU_OBpGEoKObzY0L2w	9935682117
317	FgtbRU_OBpGEoKObzY0L2w	7007436997
318	FgtbRU_OBpGEoKObzY0L2w	8127581701
319	FgtbRU_OBpGEoKObzY0L2w	8005089340
320	FgtbRU_OBpGEoKObzY0L2w	6387348945
321	FgtbRU_OBpGEoKObzY0L2w	7518894470
322	FgtbRU_OBpGEoKObzY0L2w	7651892854
323	FgtbRU_OBpGEoKObzY0L2w	7081878499
324	FgtbRU_OBpGEoKObzY0L2w	7737102386
325	FgtbRU_OBpGEoKObzY0L2w	9026457979
326	FgtbRU_OBpGEoKObzY0L2w	8303263859
327	FgtbRU_OBpGEoKObzY0L2w	7007320787
328	FgtbRU_OBpGEoKObzY0L2w	9177914130
329	FgtbRU_OBpGEoKObzY0L2w	8756516916
330	FgtbRU_OBpGEoKObzY0L2w	9336394079
331	jOIVo_RoRNYlPyQCePYPYA	7618806480
332	jOIVo_RoRNYlPyQCePYPYA	7007257972
333	jOIVo_RoRNYlPyQCePYPYA	9598239351
334	jOIVo_RoRNYlPyQCePYPYA	7007436997
335	jOIVo_RoRNYlPyQCePYPYA	8005089340
336	jOIVo_RoRNYlPyQCePYPYA	9026457979
337	jOIVo_RoRNYlPyQCePYPYA	7737102386
338	jOIVo_RoRNYlPyQCePYPYA	6392886167
339	jOIVo_RoRNYlPyQCePYPYA	8303263859
340	jOIVo_RoRNYlPyQCePYPYA	7234840507
341	LBR4VzdfJ8w_fbc3ku7DsA	7007436997
342	LBR4VzdfJ8w_fbc3ku7DsA	8005089340
343	LBR4VzdfJ8w_fbc3ku7DsA	9026457979
344	LBR4VzdfJ8w_fbc3ku7DsA	7737102386
345	LBR4VzdfJ8w_fbc3ku7DsA	6392886167
346	lepWVk7U8vcVL6K1PaOTPw	8416970886
347	lepWVk7U8vcVL6K1PaOTPw	7007436997
348	lepWVk7U8vcVL6K1PaOTPw	8005089340
349	lepWVk7U8vcVL6K1PaOTPw	9026457979
350	lepWVk7U8vcVL6K1PaOTPw	7737102386
351	lepWVk7U8vcVL6K1PaOTPw	6392886167
352	lepWVk7U8vcVL6K1PaOTPw	8303263859
353	lepWVk7U8vcVL6K1PaOTPw	8932081360
354	mfwX-rApctnwYnWNs1aF-w	7618806480
355	mfwX-rApctnwYnWNs1aF-w	7007257972
356	mfwX-rApctnwYnWNs1aF-w	7860080923
357	mfwX-rApctnwYnWNs1aF-w	7007436997
358	mfwX-rApctnwYnWNs1aF-w	8127581701
359	mfwX-rApctnwYnWNs1aF-w	8005089340
360	mfwX-rApctnwYnWNs1aF-w	6387348945
361	mfwX-rApctnwYnWNs1aF-w	7518894470
362	mfwX-rApctnwYnWNs1aF-w	6394694324
363	mfwX-rApctnwYnWNs1aF-w	7081878499
364	mfwX-rApctnwYnWNs1aF-w	7737102386
365	mfwX-rApctnwYnWNs1aF-w	8429089691
366	mfwX-rApctnwYnWNs1aF-w	8303263859
367	mfwX-rApctnwYnWNs1aF-w	9026457979
368	mfwX-rApctnwYnWNs1aF-w	6392886167
369	mfwX-rApctnwYnWNs1aF-w	7234840507
370	MT3230F-vAoiFnOcUWGq_g	7618806480
371	MT3230F-vAoiFnOcUWGq_g	7007257972
372	MT3230F-vAoiFnOcUWGq_g	7007436997
373	MT3230F-vAoiFnOcUWGq_g	8127581701
374	MT3230F-vAoiFnOcUWGq_g	8005089340
375	MT3230F-vAoiFnOcUWGq_g	7651892854
376	MT3230F-vAoiFnOcUWGq_g	9026457979
377	MT3230F-vAoiFnOcUWGq_g	7737102386
378	MT3230F-vAoiFnOcUWGq_g	6392886167
379	MT3230F-vAoiFnOcUWGq_g	7619963044
380	MT3230F-vAoiFnOcUWGq_g	7234840507
381	MT3230F-vAoiFnOcUWGq_g	8756516916
382	NA5AnQXktdXOiGmKVN-Vfg	8416970886
383	NA5AnQXktdXOiGmKVN-Vfg	9598239351
384	NA5AnQXktdXOiGmKVN-Vfg	7007436997
385	NA5AnQXktdXOiGmKVN-Vfg	8005089340
386	NA5AnQXktdXOiGmKVN-Vfg	9026457979
387	NA5AnQXktdXOiGmKVN-Vfg	7054548210
388	NA5AnQXktdXOiGmKVN-Vfg	7737102386
389	NA5AnQXktdXOiGmKVN-Vfg	8303263859
390	NA5AnQXktdXOiGmKVN-Vfg	6392886167
391	NA5AnQXktdXOiGmKVN-Vfg	7052200095
392	NA5AnQXktdXOiGmKVN-Vfg	8932081360
393	NA5AnQXktdXOiGmKVN-Vfg	7619963044
394	NA5AnQXktdXOiGmKVN-Vfg	8756516916
395	nrc6Zsk-w0_m5xr6JRkydg	7007436997
396	nrc6Zsk-w0_m5xr6JRkydg	8005089340
397	nrc6Zsk-w0_m5xr6JRkydg	9026457979
398	nrc6Zsk-w0_m5xr6JRkydg	7737102386
399	nrc6Zsk-w0_m5xr6JRkydg	6392886167
400	nrc6Zsk-w0_m5xr6JRkydg	8303263859
401	NW8pZiMI1if3FCeZtutsAA	7007436997
402	NW8pZiMI1if3FCeZtutsAA	8005089340
403	NW8pZiMI1if3FCeZtutsAA	9026457979
404	NW8pZiMI1if3FCeZtutsAA	7737102386
405	NW8pZiMI1if3FCeZtutsAA	6392886167
406	NW8pZiMI1if3FCeZtutsAA	9918751848
407	Pn39SEESymig1qthsHBCiQ	7618806480
408	Pn39SEESymig1qthsHBCiQ	7007436997
409	Pn39SEESymig1qthsHBCiQ	8005089340
410	Pn39SEESymig1qthsHBCiQ	6387348945
411	Pn39SEESymig1qthsHBCiQ	7518894470
412	Pn39SEESymig1qthsHBCiQ	6394694324
413	Pn39SEESymig1qthsHBCiQ	9026457979
414	Pn39SEESymig1qthsHBCiQ	7737102386
415	Pn39SEESymig1qthsHBCiQ	8303263859
416	Pn39SEESymig1qthsHBCiQ	7234840507
417	Pn39SEESymig1qthsHBCiQ	8756516916
418	P__sjRcj_ILGr3r6J88mFw	8416970886
419	P__sjRcj_ILGr3r6J88mFw	7007436997
420	P__sjRcj_ILGr3r6J88mFw	8127581701
421	P__sjRcj_ILGr3r6J88mFw	8005089340
422	P__sjRcj_ILGr3r6J88mFw	9026457979
423	P__sjRcj_ILGr3r6J88mFw	7737102386
424	P__sjRcj_ILGr3r6J88mFw	6392886167
425	P__sjRcj_ILGr3r6J88mFw	8303263859
426	QOuxw_71UkGCrnNOSrsL4Q	7618806480
427	QOuxw_71UkGCrnNOSrsL4Q	8416970886
428	QOuxw_71UkGCrnNOSrsL4Q	7007436997
429	QOuxw_71UkGCrnNOSrsL4Q	8005089340
430	QOuxw_71UkGCrnNOSrsL4Q	9026457979
431	QOuxw_71UkGCrnNOSrsL4Q	7737102386
432	QOuxw_71UkGCrnNOSrsL4Q	6392886167
433	QOuxw_71UkGCrnNOSrsL4Q	8756516916
434	t7qQpdlOSO4buwmTRvjd_A	7007257972
435	t7qQpdlOSO4buwmTRvjd_A	7860080923
436	t7qQpdlOSO4buwmTRvjd_A	7007436997
437	t7qQpdlOSO4buwmTRvjd_A	8005089340
438	t7qQpdlOSO4buwmTRvjd_A	6387348945
439	t7qQpdlOSO4buwmTRvjd_A	7905124622
440	t7qQpdlOSO4buwmTRvjd_A	7518894470
441	t7qQpdlOSO4buwmTRvjd_A	7651892854
442	t7qQpdlOSO4buwmTRvjd_A	6394694324
443	t7qQpdlOSO4buwmTRvjd_A	7081878499
444	t7qQpdlOSO4buwmTRvjd_A	7737102386
445	t7qQpdlOSO4buwmTRvjd_A	9026457979
446	t7qQpdlOSO4buwmTRvjd_A	8303263859
447	t7qQpdlOSO4buwmTRvjd_A	8737942594
448	t7qQpdlOSO4buwmTRvjd_A	8932081360
449	t7qQpdlOSO4buwmTRvjd_A	8756516916
450	t7qQpdlOSO4buwmTRvjd_A	9336394079
451	PRcDcdhFL5-_DPQpLGUyhw	9598239351
452	PRcDcdhFL5-_DPQpLGUyhw	7007436997
453	PRcDcdhFL5-_DPQpLGUyhw	9555782418
454	PRcDcdhFL5-_DPQpLGUyhw	8005089340
455	PRcDcdhFL5-_DPQpLGUyhw	7651892854
456	PRcDcdhFL5-_DPQpLGUyhw	9026457979
457	PRcDcdhFL5-_DPQpLGUyhw	7737102386
458	PRcDcdhFL5-_DPQpLGUyhw	6392886167
459	PRcDcdhFL5-_DPQpLGUyhw	7007320787
460	PRcDcdhFL5-_DPQpLGUyhw	9177914130
461	PRcDcdhFL5-_DPQpLGUyhw	6306416908
462	PRcDcdhFL5-_DPQpLGUyhw	8756516916
463	PRcDcdhFL5-_DPQpLGUyhw	9336394079
464	oLSA5AyHX7_REShThZqOPA	7007257972
465	oLSA5AyHX7_REShThZqOPA	8005089340
466	oLSA5AyHX7_REShThZqOPA	9026457979
467	oLSA5AyHX7_REShThZqOPA	6392886167
468	oLSA5AyHX7_REShThZqOPA	7007320787
469	oLSA5AyHX7_REShThZqOPA	8756516916
470	tMjprPvWBLiDKird-8Xw9Q	7007436997
471	tMjprPvWBLiDKird-8Xw9Q	8005089340
472	tMjprPvWBLiDKird-8Xw9Q	9026457979
473	tMjprPvWBLiDKird-8Xw9Q	7737102386
474	tMjprPvWBLiDKird-8Xw9Q	6392886167
475	u11aqfFI4Q7GrP6O2qNTwQ	7052546269
476	u11aqfFI4Q7GrP6O2qNTwQ	9198572009
477	u11aqfFI4Q7GrP6O2qNTwQ	7007436997
478	u11aqfFI4Q7GrP6O2qNTwQ	9555782418
479	u11aqfFI4Q7GrP6O2qNTwQ	9598239351
480	u11aqfFI4Q7GrP6O2qNTwQ	7905124622
481	u11aqfFI4Q7GrP6O2qNTwQ	9935682117
482	u11aqfFI4Q7GrP6O2qNTwQ	8005089340
483	u11aqfFI4Q7GrP6O2qNTwQ	7081878499
484	u11aqfFI4Q7GrP6O2qNTwQ	9026457979
485	u11aqfFI4Q7GrP6O2qNTwQ	6392886167
486	u11aqfFI4Q7GrP6O2qNTwQ	7705078595
487	u11aqfFI4Q7GrP6O2qNTwQ	8756516916
488	vf8orZs86q1pLPLRInihlg	7052546269
489	vf8orZs86q1pLPLRInihlg	7007257972
490	vf8orZs86q1pLPLRInihlg	9198572009
491	vf8orZs86q1pLPLRInihlg	7007436997
492	vf8orZs86q1pLPLRInihlg	9598239351
493	vf8orZs86q1pLPLRInihlg	8005089340
494	vf8orZs86q1pLPLRInihlg	7518894470
495	vf8orZs86q1pLPLRInihlg	7081878499
496	vf8orZs86q1pLPLRInihlg	7737102386
497	vf8orZs86q1pLPLRInihlg	8429089691
498	vf8orZs86q1pLPLRInihlg	8303263859
499	vf8orZs86q1pLPLRInihlg	8737942594
500	vf8orZs86q1pLPLRInihlg	9026457979
501	vf8orZs86q1pLPLRInihlg	6392886167
502	vf8orZs86q1pLPLRInihlg	8756516916
503	VhKJe0Id8bBeoLX1a3yBeQ	7007436997
504	VhKJe0Id8bBeoLX1a3yBeQ	8005089340
505	VhKJe0Id8bBeoLX1a3yBeQ	8127581701
506	VhKJe0Id8bBeoLX1a3yBeQ	9026457979
507	VhKJe0Id8bBeoLX1a3yBeQ	7737102386
508	wU13FH-lxct68TgtOM-Wzw	7007436997
509	wU13FH-lxct68TgtOM-Wzw	8005089340
510	wU13FH-lxct68TgtOM-Wzw	9026457979
511	wU13FH-lxct68TgtOM-Wzw	7737102386
512	wU13FH-lxct68TgtOM-Wzw	6392886167
513	wU13FH-lxct68TgtOM-Wzw	8303263859
514	wU13FH-lxct68TgtOM-Wzw	8756516916
515	XH3vTr6CYwOdJvtwNx76Fg	7007436997
516	XH3vTr6CYwOdJvtwNx76Fg	8005089340
517	XH3vTr6CYwOdJvtwNx76Fg	8127581701
518	XH3vTr6CYwOdJvtwNx76Fg	9026457979
519	XH3vTr6CYwOdJvtwNx76Fg	7737102386
520	XH3vTr6CYwOdJvtwNx76Fg	6392886167
521	xlZkRqkHXXWBG9JCbSEcDA	7007436997
522	xlZkRqkHXXWBG9JCbSEcDA	8127581701
523	xlZkRqkHXXWBG9JCbSEcDA	8005089340
524	xlZkRqkHXXWBG9JCbSEcDA	6394694324
525	xlZkRqkHXXWBG9JCbSEcDA	9026457979
526	xlZkRqkHXXWBG9JCbSEcDA	7737102386
527	xlZkRqkHXXWBG9JCbSEcDA	6392886167
528	xlZkRqkHXXWBG9JCbSEcDA	8303263859
529	YNJwxQxDzexGn_BipWMK-w	7007436997
530	YNJwxQxDzexGn_BipWMK-w	8005089340
531	YNJwxQxDzexGn_BipWMK-w	9026457979
532	YNJwxQxDzexGn_BipWMK-w	7737102386
533	YNJwxQxDzexGn_BipWMK-w	6392886167
534	Z3N8wXLg5fl-qTeEHtYmlw	7007436997
535	Z3N8wXLg5fl-qTeEHtYmlw	8005089340
536	Z3N8wXLg5fl-qTeEHtYmlw	9026457979
537	Z3N8wXLg5fl-qTeEHtYmlw	7737102386
538	Z3N8wXLg5fl-qTeEHtYmlw	6392886167
539	Z3N8wXLg5fl-qTeEHtYmlw	8303263859
540	-cXERyo0mztEecOopTbFDg	8005089340
541	-cXERyo0mztEecOopTbFDg	9026457979
542	-cXERyo0mztEecOopTbFDg	6392886167
543	-cXERyo0mztEecOopTbFDg	7007320787
544	-cXERyo0mztEecOopTbFDg	8756516916
545	y5QT4wUXGykRS2IrBGl5tw	7618806480
546	y5QT4wUXGykRS2IrBGl5tw	7007257972
547	y5QT4wUXGykRS2IrBGl5tw	9598239351
548	y5QT4wUXGykRS2IrBGl5tw	7007436997
549	y5QT4wUXGykRS2IrBGl5tw	6387348945
550	y5QT4wUXGykRS2IrBGl5tw	8303263859
551	y5QT4wUXGykRS2IrBGl5tw	8005089340
552	y5QT4wUXGykRS2IrBGl5tw	7651892854
553	y5QT4wUXGykRS2IrBGl5tw	6394694324
554	y5QT4wUXGykRS2IrBGl5tw	8429089691
555	y5QT4wUXGykRS2IrBGl5tw	7737102386
556	y5QT4wUXGykRS2IrBGl5tw	8756516916
557	y5QT4wUXGykRS2IrBGl5tw	7860080923
558	y5QT4wUXGykRS2IrBGl5tw	7518894470
559	y5QT4wUXGykRS2IrBGl5tw	9026457979
560	y5QT4wUXGykRS2IrBGl5tw	6392886167
561	y5QT4wUXGykRS2IrBGl5tw	8737942594
562	y5QT4wUXGykRS2IrBGl5tw	8932081360
563	y5QT4wUXGykRS2IrBGl5tw	7234840507
564	y5QT4wUXGykRS2IrBGl5tw	7007320787
565	iBSICg_5KqoY3EoSQRaZzA	6392886167
566	iBSICg_5KqoY3EoSQRaZzA	7007320787
567	iBSICg_5KqoY3EoSQRaZzA	9026457979
568	7zFsxvON_CK3iybolc7v-Q	7052546269
569	7zFsxvON_CK3iybolc7v-Q	9198572009
570	7zFsxvON_CK3iybolc7v-Q	7007436997
571	7zFsxvON_CK3iybolc7v-Q	8005089340
572	7zFsxvON_CK3iybolc7v-Q	6387348945
573	7zFsxvON_CK3iybolc7v-Q	7081878499
574	7zFsxvON_CK3iybolc7v-Q	7737102386
575	7zFsxvON_CK3iybolc7v-Q	9026457979
576	7zFsxvON_CK3iybolc7v-Q	8737942594
577	7zFsxvON_CK3iybolc7v-Q	7007320787
578	7zFsxvON_CK3iybolc7v-Q	8756516916
579	x8CyIOD389nfRak4EE6U4Q	7052546269
580	x8CyIOD389nfRak4EE6U4Q	7007257972
581	x8CyIOD389nfRak4EE6U4Q	8005089340
582	x8CyIOD389nfRak4EE6U4Q	7081878499
583	x8CyIOD389nfRak4EE6U4Q	7737102386
584	x8CyIOD389nfRak4EE6U4Q	9026457979
585	x8CyIOD389nfRak4EE6U4Q	6392886167
586	x8CyIOD389nfRak4EE6U4Q	7007320787
587	x8CyIOD389nfRak4EE6U4Q	8756516916
588	XOBXUqnreGJS49wHY45dDw	8005089340
589	XOBXUqnreGJS49wHY45dDw	9026457979
590	Z6ymAwIeJzbN91jL6LLTGw	6392886167
591	Z6ymAwIeJzbN91jL6LLTGw	9026457979
592	jcwmLzYQ5guXoH7AUMHCzg	6392886167
593	jcwmLzYQ5guXoH7AUMHCzg	9026457979
594	o1ztqUTZnHrXJxQMKTAATg	7007436997
595	o1ztqUTZnHrXJxQMKTAATg	8005089340
596	o1ztqUTZnHrXJxQMKTAATg	6387348945
597	o1ztqUTZnHrXJxQMKTAATg	7518894470
598	o1ztqUTZnHrXJxQMKTAATg	7651892854
599	o1ztqUTZnHrXJxQMKTAATg	6394694324
600	o1ztqUTZnHrXJxQMKTAATg	7081878499
601	o1ztqUTZnHrXJxQMKTAATg	7737102386
602	o1ztqUTZnHrXJxQMKTAATg	9120759992
603	o1ztqUTZnHrXJxQMKTAATg	8303263859
604	o1ztqUTZnHrXJxQMKTAATg	8737942594
605	o1ztqUTZnHrXJxQMKTAATg	7007320787
606	o1ztqUTZnHrXJxQMKTAATg	9026457979
607	o1ztqUTZnHrXJxQMKTAATg	8932081360
608	o1ztqUTZnHrXJxQMKTAATg	8756516916
609	o1ztqUTZnHrXJxQMKTAATg	9336394079
610	LULr1WDSdFe7cZyrN3uSdw	6392886167
611	CO7vyv98Va88DNRwtOx3mw	9026457979
612	Axs64rjC3C9q7svcPOSIxw	9026457979
613	Pn39SEESymig1qthsHBCiQ	6392886167
614	cjE85vs4DUvXUNVFqpdUiw	8875309289
615	y5QT4wUXGykRS2IrBGl5tw	8875309289
616	4k36LN3aSBh1E-EivBjWuw	8875309289
619	IHZAIpwm8Vo2Tv7rUjcXEw	8875309289
620	31nvDJU6ba7I8E7Fq9LoOA	8875309289
621	FgtbRU_OBpGEoKObzY0L2w	8875309289
622	Qfu4WT4PRq4yX4OuYLLiJg	8005089340
623	pTxMOS0yRgq-tHrsFUANZg	8005089340
626	mfwX-rApctnwYnWNs1aF-w	8756516916
627	buEIaJZo-Eq_Phnvw744OA	8756516916
628	xlZkRqkHXXWBG9JCbSEcDA	8756516916
629	ABt-aZVrRebN3JvYPet3HQ	8756516916
630	XH3vTr6CYwOdJvtwNx76Fg	8756516916
631	NW8pZiMI1if3FCeZtutsAA	8756516916
632	6r1Ln5D5VXmefS2WJz9VKA	8756516916
634	tMjprPvWBLiDKird-8Xw9Q	8756516916
635	jcwmLzYQ5guXoH7AUMHCzg	8756516916
636	NYX2T1Ad937_7N0EV9a8TQ	6392886167
637	pTxMOS0yRgq-tHrsFUANZg	6392886167
640	NYX2T1Ad937_7N0EV9a8TQ	7081878499
641	pTxMOS0yRgq-tHrsFUANZg	7081878499
644	NYX2T1Ad937_7N0EV9a8TQ	9026457979
646	NYX2T1Ad937_7N0EV9a8TQ	8005089340
648	NYX2T1Ad937_7N0EV9a8TQ	8932081360
649	XOBXUqnreGJS49wHY45dDw	8932081360
650	r0cIJojii-KSZYKZ6gRHow	8005089340
652	pTxMOS0yRgq-tHrsFUANZg	8756516916
653	r0cIJojii-KSZYKZ6gRHow	6392886167
654	LULr1WDSdFe7cZyrN3uSdw	9026457979
655	NYX2T1Ad937_7N0EV9a8TQ	7007257972
656	pTxMOS0yRgq-tHrsFUANZg	7007257972
657	r0cIJojii-KSZYKZ6gRHow	7007257972
658	Qfu4WT4PRq4yX4OuYLLiJg	6392886167
659	r0cIJojii-KSZYKZ6gRHow	8756516916
660	YNJwxQxDzexGn_BipWMK-w	9838712221
661	tMjprPvWBLiDKird-8Xw9Q	9838712221
662	QXr8_PbFKwcRq-itqKGy-g	8005089340
663	LULr1WDSdFe7cZyrN3uSdw	8756516916
664	XOBXUqnreGJS49wHY45dDw	8756516916
665	iBSICg_5KqoY3EoSQRaZzA	8756516916
666	iRcCI8btV9zcyqVWdjpa_g	8756516916
668	LEEReMdYP9gB1BlGm_9KdQ	8005089340
669	QXr8_PbFKwcRq-itqKGy-g	6392886167
670	LEEReMdYP9gB1BlGm_9KdQ	6392886167
673	LEEReMdYP9gB1BlGm_9KdQ	9026457979
674	QXr8_PbFKwcRq-itqKGy-g	9026457979
677	babjCt2f9XQ_tGSEflV92Q	9838712221
678	MT3230F-vAoiFnOcUWGq_g	9838712221
679	6OvBZUxjKJBCf7Ki7SFN3A	6392886167
682	6OvBZUxjKJBCf7Ki7SFN3A	8005089340
688	5vri0VOejjc-b_XyHicdDg	9838712221
689	Swl4oGSwZzqJE0BKfDDnjA	6392886167
690	Swl4oGSwZzqJE0BKfDDnjA	8005089340
691	r0cIJojii-KSZYKZ6gRHow	8932081360
693	oLSA5AyHX7_REShThZqOPA	8932081360
694	9MBbQ__Y9mrn1rUQYaj44g	8932081360
695	rhLs3hN0xW8rBy8xVkg0Kg	8005089340
696	rhLs3hN0xW8rBy8xVkg0Kg	6392886167
\.


--
-- Data for Name: insight_scoreboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_scoreboard (id, created_at, expires_on, retention, account_id, original_creation, down_votes, loves, shares, up_votes, views) FROM stdin;
48	2020-10-22	2020-10-29	0.00000	8756516916	2020-11-17 12:40:49.842537+00	0	0	0	0	0
12	2020-09-24	2020-09-24	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
18	2020-09-24	2020-09-24	0.00000	8303263859	2020-11-17 12:40:49.842537+00	0	0	0	0	0
14	2020-09-24	2020-09-24	0.00000	7007257972	2020-11-17 12:40:49.842537+00	0	0	0	0	0
26	2020-09-28	2020-10-05	0.00000	6394694324	2020-11-17 12:40:49.842537+00	0	0	0	0	0
32	2020-09-29	2020-10-06	0.00000	7007436997	2020-11-17 12:40:49.842537+00	0	0	0	0	0
22	2020-09-25	2020-10-02	0.00000	8756516916	2020-11-17 12:40:49.842537+00	0	0	0	0	0
27	2020-09-28	2020-10-05	0.00000	8953643577	2020-11-17 12:40:49.842537+00	0	0	0	0	0
23	2020-09-28	2020-10-05	0.00000	7007257972	2020-11-17 12:40:49.842537+00	0	0	0	0	0
8	2020-09-24	2020-09-24	0.00000	7737102386	2020-11-17 12:40:49.842537+00	0	0	0	0	0
54	2020-11-11	2020-11-15	0.00000	9026457979	2020-11-17 12:40:49.842537+00	0	0	0	0	0
24	2020-09-28	2020-10-05	0.00000	9120759992	2020-11-17 12:40:49.842537+00	0	0	0	0	0
19	2020-09-24	2020-09-24	0.00000	8955118758	2020-11-17 12:40:49.842537+00	0	0	0	0	0
13	2020-09-24	2020-09-24	0.00000	7619963044	2020-11-17 12:40:49.842537+00	0	0	0	0	0
29	2020-09-28	2020-10-05	0.00000	8303263859	2020-11-17 12:40:49.842537+00	0	0	0	0	0
2	2020-09-23	2020-09-30	0.00000	9177914130	2020-11-17 12:40:49.842537+00	0	0	0	0	0
11	2020-09-24	2020-09-24	0.00000	8685809251	2020-11-17 12:40:49.842537+00	0	0	0	0	0
16	2020-09-24	2020-09-24	0.00000	9120759992	2020-11-17 12:40:49.842537+00	0	0	0	0	0
44	2020-10-18	2020-10-25	0.00000	6394694324	2020-11-17 12:40:49.842537+00	0	0	0	0	0
25	2020-09-28	2020-10-05	0.00000	9026457979	2020-11-17 12:40:49.842537+00	0	0	0	0	0
42	2020-10-11	2020-10-18	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
41	2020-10-10	2020-10-17	0.00000	9026457979	2020-11-17 12:40:49.842537+00	0	0	0	0	0
40	2020-10-10	2020-10-17	0.00000	6392886167	2020-11-17 12:40:49.842537+00	0	0	0	0	0
30	2020-09-28	2020-10-05	0.00000	7347753366	2020-11-17 12:40:49.842537+00	0	0	0	0	0
46	2020-10-22	2020-10-29	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
43	2020-10-18	2020-10-25	0.00000	9026457979	2020-11-17 12:40:49.842537+00	0	0	0	0	0
53	2020-11-11	2020-11-15	0.00000	8756516916	2020-11-17 12:40:49.842537+00	0	0	0	0	0
55	2020-11-11	2020-11-15	0.00000	7007436997	2020-11-17 12:40:49.842537+00	0	0	0	0	0
7	2020-09-24	2020-09-24	0.00000	8756516916	2020-11-17 12:40:49.842537+00	0	0	0	0	0
4	2020-09-24	2020-09-24	0.00000	8953643577	2020-11-17 12:40:49.842537+00	0	0	0	0	0
34	2020-10-01	2020-10-08	0.00000	6392886167	2020-11-17 12:40:49.842537+00	0	0	0	0	0
51	2020-10-25	2020-11-01	0.00000	8303263859	2020-11-17 12:40:49.842537+00	0	0	0	0	0
10	2020-09-24	2020-09-24	0.00000	7347753366	2020-11-17 12:40:49.842537+00	0	0	0	0	0
35	2020-10-03	2020-10-10	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
9	2020-09-24	2020-09-24	0.00000	7007436997	2020-11-17 12:40:49.842537+00	0	0	0	0	0
45	2020-10-18	2020-10-25	0.00000	9120759992	2020-11-17 12:40:49.842537+00	0	0	0	0	0
21	2020-09-25	2020-10-02	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
38	2020-10-03	2020-10-10	0.00000	7619963044	2020-11-17 12:40:49.842537+00	0	0	0	0	0
6	2020-09-24	2020-09-24	0.00000	9026457979	2020-11-17 12:40:49.842537+00	0	0	0	0	0
15	2020-09-24	2020-09-24	0.00000	8737942594	2020-11-17 12:40:49.842537+00	0	0	0	0	0
39	2020-10-10	2020-10-17	0.00000	9177914130	2020-11-17 12:40:49.842537+00	0	0	0	0	0
49	2020-10-22	2020-10-29	0.00000	7007436997	2020-11-17 12:40:49.842537+00	0	0	0	0	0
47	2020-10-22	2020-10-29	0.00000	7737102386	2020-11-17 12:40:49.842537+00	0	0	0	0	0
3	2020-09-24	2020-09-24	0.00000	6394694324	2020-11-17 12:40:49.842537+00	0	0	0	0	0
17	2020-09-24	2020-09-24	0.00000	8756636544	2020-11-17 12:40:49.842537+00	0	0	0	0	0
28	2020-09-28	2020-10-05	0.00000	7737102386	2020-11-17 12:40:49.842537+00	0	0	0	0	0
37	2020-10-03	2020-10-10	0.00000	7518894470	2020-11-17 12:40:49.842537+00	0	0	0	0	0
20	2020-09-24	2020-09-24	0.00000	8881989296	2020-11-17 12:40:49.842537+00	0	0	0	0	0
33	2020-09-29	2020-10-06	0.00000	8756636544	2020-11-17 12:40:49.842537+00	0	0	0	0	0
1	2020-09-22	2020-09-29	0.00000	7518894470	2020-11-17 12:40:49.842537+00	0	0	0	0	0
5	2020-09-24	2020-09-24	0.00000	8429089691	2020-11-17 12:40:49.842537+00	0	0	0	0	0
36	2020-10-03	2020-10-10	0.00000	8756516916	2020-11-17 12:40:49.842537+00	0	0	0	0	0
31	2020-09-28	2020-10-05	0.00000	8955118758	2020-11-17 12:40:49.842537+00	0	0	0	0	0
50	2020-10-22	2020-10-29	0.00000	7518894470	2020-11-17 12:40:49.842537+00	0	0	0	0	0
74	2020-11-22	2020-11-22	0.00000	7619963044	2020-11-22 15:22:55.065685+00	0	11	0	0	13
72	2020-11-22	2020-11-22	0.00000	7518894470	2020-11-22 15:20:15.63821+00	0	10	0	0	13
95	2020-11-30	2020-12-06	0.00000	7518894470	2020-11-30 08:10:49.915924+00	0	10	0	0	13
64	2020-11-21	2020-11-22	0.00000	7007436997	2020-11-21 17:48:00.85507+00	0	8	0	0	17
85	2020-11-24	2020-11-29	0.00000	7347753366	2020-11-24 12:59:01.432837+00	0	8	0	0	10
84	2020-11-24	2020-11-29	0.00000	8685809251	2020-11-24 12:53:57.012339+00	0	7	0	0	7
75	2020-11-22	2020-11-22	0.00000	9120759992	2020-11-22 15:23:00.217327+00	0	7	0	0	19
86	2020-11-24	2020-11-29	0.00000	8955118758	2020-11-24 12:59:04.775184+00	0	5	0	0	7
89	2020-11-29	2020-11-29	0.00000	9838712221	2020-11-29 05:14:03.893959+00	0	4	1	0	6
90	2020-11-29	2020-11-29	0.00000	8756636544	2020-11-29 05:14:05.016977+00	0	4	0	0	6
57	2020-11-11	2020-11-15	0.00000	9177914130	2020-11-17 12:40:49.842537+00	0	0	0	0	0
56	2020-11-11	2020-11-15	0.00000	6394694324	2020-11-17 12:40:49.842537+00	0	0	0	0	0
58	2020-11-12	2020-11-15	0.00000	8881989296	2020-11-17 12:40:49.842537+00	0	0	0	0	0
68	2020-11-21	2020-11-22	0.00000	9177914130	2020-11-21 17:53:29.718799+00	0	0	0	0	0
52	2020-11-09	2020-11-15	0.00000	8005089340	2020-11-17 12:40:49.842537+00	0	0	0	0	0
63	2020-11-21	2020-11-22	0.00000	6392886167	2020-11-20 16:29:12.242405+00	0	0	0	0	0
66	2020-11-21	2020-11-22	0.00000	8756516916	2020-11-21 17:49:55.622868+00	0	0	0	0	0
59	2020-11-12	2020-11-15	0.00000	6392886167	2020-11-17 12:40:49.842537+00	0	0	0	0	0
76	2020-11-23	2020-11-29	0.00000	6394694324	2020-11-23 12:31:55.321257+00	0	84	0	0	97
65	2020-11-21	2020-11-22	0.00000	6394694324	2020-11-21 17:49:25.943413+00	0	60	0	0	72
83	2020-11-23	2020-11-29	0.00000	8005089340	2020-11-23 13:06:39.712652+00	0	37	0	0	52
78	2020-11-23	2020-11-29	0.00000	7737102386	2020-11-23 12:32:09.231499+00	0	36	0	0	48
70	2020-11-22	2020-11-22	0.00000	7737102386	2020-11-22 10:05:42.13883+00	0	26	0	0	32
94	2020-11-30	2020-12-06	0.22314	8756516916	2020-11-30 08:09:10.550645+00	0	18	1	0	22
93	2020-11-30	2020-12-06	0.00000	9653010765	2020-11-30 06:47:52.798836+00	0	2	0	0	0
92	2020-11-30	2020-12-06	0.00000	8005089340	2020-11-30 06:43:46.749213+00	0	7	0	0	3
91	2020-11-30	2020-12-06	0.22314	9838712221	2020-11-30 05:32:42.917502+00	0	20	1	0	7
80	2020-11-23	2020-11-29	0.00000	9026457979	2020-11-23 12:32:51.996789+00	0	25	1	0	44
67	2020-11-21	2020-11-22	0.00000	9026457979	2020-11-21 17:49:58.784136+00	0	24	0	0	45
71	2020-11-22	2020-11-22	0.00000	8005089340	2020-11-22 10:05:45.52541+00	0	17	0	0	20
77	2020-11-23	2020-11-29	0.00000	8881989296	2020-11-23 12:32:04.684982+00	0	15	0	0	15
69	2020-11-21	2020-11-22	0.00000	8881989296	2020-11-21 17:57:15.742217+00	0	15	0	0	15
79	2020-11-23	2020-11-29	0.00000	8303263859	2020-11-23 12:32:24.652776+00	0	14	0	0	16
73	2020-11-22	2020-11-22	0.00000	8303263859	2020-11-22 15:21:02.780812+00	0	14	0	0	16
82	2020-11-23	2020-11-29	0.00000	7007257972	2020-11-23 13:06:35.39908+00	0	14	0	0	24
87	2020-11-25	2020-11-29	0.00000	8756516916	2020-11-25 04:39:48.922612+00	0	13	1	0	26
88	2020-11-25	2020-11-29	0.00000	6392886167	2020-11-25 05:29:39.583468+00	0	12	0	0	19
81	2020-11-23	2020-11-29	0.00000	7619963044	2020-11-23 12:32:54.076763+00	0	11	0	0	13
\.


--
-- Data for Name: insight_scoreboard_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_scoreboard_posts (id, scoreboard_id, post_id) FROM stdin;
1	67	FgtbRU_OBpGEoKObzY0L2w
2	67	7zFsxvON_CK3iybolc7v-Q
3	64	o1ztqUTZnHrXJxQMKTAATg
7	70	t7qQpdlOSO4buwmTRvjd_A
8	67	IHZAIpwm8Vo2Tv7rUjcXEw
9	71	cjE85vs4DUvXUNVFqpdUiw
13	70	31nvDJU6ba7I8E7Fq9LoOA
14	72	MT3230F-vAoiFnOcUWGq_g
15	65	y5QT4wUXGykRS2IrBGl5tw
16	65	4k36LN3aSBh1E-EivBjWuw
17	69	7SsWTtJSKuO5Fg06hiCs7A
19	73	bu5UqrnnxuK61T4lIJx-7w
21	65	mfwX-rApctnwYnWNs1aF-w
24	65	9MBbQ__Y9mrn1rUQYaj44g
26	74	NA5AnQXktdXOiGmKVN-Vfg
27	75	DLN5GxgEr1yBAeXwNHAyyw
31	76	y5QT4wUXGykRS2IrBGl5tw
32	76	4k36LN3aSBh1E-EivBjWuw
33	77	7SsWTtJSKuO5Fg06hiCs7A
34	78	t7qQpdlOSO4buwmTRvjd_A
36	76	mfwX-rApctnwYnWNs1aF-w
40	79	bu5UqrnnxuK61T4lIJx-7w
41	76	9MBbQ__Y9mrn1rUQYaj44g
42	78	31nvDJU6ba7I8E7Fq9LoOA
43	80	IHZAIpwm8Vo2Tv7rUjcXEw
44	81	NA5AnQXktdXOiGmKVN-Vfg
45	82	CO7vyv98Va88DNRwtOx3mw
46	83	Axs64rjC3C9q7svcPOSIxw
47	76	Pn39SEESymig1qthsHBCiQ
50	83	cjE85vs4DUvXUNVFqpdUiw
58	80	FgtbRU_OBpGEoKObzY0L2w
61	80	Qfu4WT4PRq4yX4OuYLLiJg
62	80	pTxMOS0yRgq-tHrsFUANZg
65	84	-4ZTNt9kLbvmYvs2UGsRrw
69	85	buEIaJZo-Eq_Phnvw744OA
70	78	xlZkRqkHXXWBG9JCbSEcDA
71	82	ABt-aZVrRebN3JvYPet3HQ
72	86	XH3vTr6CYwOdJvtwNx76Fg
73	78	NW8pZiMI1if3FCeZtutsAA
74	83	6r1Ln5D5VXmefS2WJz9VKA
76	82	tMjprPvWBLiDKird-8Xw9Q
77	83	jcwmLzYQ5guXoH7AUMHCzg
78	87	NYX2T1Ad937_7N0EV9a8TQ
90	83	LULr1WDSdFe7cZyrN3uSdw
97	88	XOBXUqnreGJS49wHY45dDw
100	83	-cXERyo0mztEecOopTbFDg
101	80	r0cIJojii-KSZYKZ6gRHow
109	87	oLSA5AyHX7_REShThZqOPA
110	87	i0jkXqQU4vcfpRB4_qCXew
111	88	978BX-b6-3-asupLjtefQw
112	88	auhqqzyE-eCjqUGpgVtVsQ
135	83	Z6ymAwIeJzbN91jL6LLTGw
142	83	iBSICg_5KqoY3EoSQRaZzA
143	82	VhKJe0Id8bBeoLX1a3yBeQ
144	89	QXr8_PbFKwcRq-itqKGy-g
146	90	YNJwxQxDzexGn_BipWMK-w
153	76	iRcCI8btV9zcyqVWdjpa_g
155	89	LEEReMdYP9gB1BlGm_9KdQ
173	91	LEEReMdYP9gB1BlGm_9KdQ
174	92	LULr1WDSdFe7cZyrN3uSdw
176	93	aAo3oIT9ZI2CGZ-ONJ-tYA
178	94	i0jkXqQU4vcfpRB4_qCXew
180	94	babjCt2f9XQ_tGSEflV92Q
182	95	MT3230F-vAoiFnOcUWGq_g
183	91	6OvBZUxjKJBCf7Ki7SFN3A
197	94	5vri0VOejjc-b_XyHicdDg
198	91	QXr8_PbFKwcRq-itqKGy-g
199	91	Swl4oGSwZzqJE0BKfDDnjA
200	94	oLSA5AyHX7_REShThZqOPA
201	94	NYX2T1Ad937_7N0EV9a8TQ
202	91	ncMzVXG81V5pLq90rL3i8Q
\.


--
-- Data for Name: insight_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_tags (tag, created_at, first_used, tag_type) FROM stdin;
cyborg	2020-11-23 12:53:34.171137+00		HASH
game	2020-11-23 12:53:34.183325+00		HASH
self	2020-11-23 12:53:34.191961+00		HASH
TIME	2020-11-29 05:14:03.230075+00	QXr8_PbFKwcRq-itqKGy-g	HASH
Introspection	2020-11-29 05:14:03.230165+00	QXr8_PbFKwcRq-itqKGy-g	HASH
greek	2020-11-29 06:23:16.6163+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
complexitytheory	2020-11-29 06:23:16.616813+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
fractals	2020-11-29 06:23:16.616846+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
strangeattractors	2020-11-29 06:23:16.616867+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
time	2020-11-29 06:23:16.616887+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
shiva	2020-11-29 06:23:16.616906+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
spacememory	2020-11-29 06:23:16.616924+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
wavelets	2020-11-29 06:23:16.616941+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
perception	2020-11-29 06:23:16.616958+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
universeASvibration	2020-11-29 06:23:16.616975+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
waves	2020-11-29 06:23:16.616992+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
dimensions	2020-11-29 06:23:16.617008+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
NigelStanford	2020-11-29 06:23:16.617023+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
schumannresonance	2020-11-29 06:23:16.61704+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
Cymatics	2020-11-29 06:23:16.617055+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
water	2020-11-29 06:23:16.617071+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
complexnumbers	2020-11-29 06:23:16.617087+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
gravity	2020-11-29 06:23:16.617103+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
holigraphicuniverse	2020-11-29 06:23:16.617121+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
spacetime	2020-11-29 06:23:16.617137+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
matter	2020-11-29 06:23:16.617153+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
nonlinearresonance	2020-11-29 06:23:16.617169+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
tesla	2020-11-29 06:23:16.617185+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
vortex	2020-11-29 06:23:16.617201+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
chaostheory	2020-11-29 06:23:16.617216+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
solids	2020-11-29 06:23:16.617232+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
kantianwholes	2020-11-29 06:23:16.617248+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
huygensprinciple	2020-11-29 06:23:16.617264+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
zeropointenergy	2020-11-29 06:23:16.61728+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
YouTube	2020-11-29 06:23:16.617296+00	LEEReMdYP9gB1BlGm_9KdQ	HASH
weirdmaths	2020-11-30 08:04:57.231545+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
thecube	2020-11-30 08:04:57.231622+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
square	2020-11-30 08:04:57.231649+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
polytopes	2020-11-30 08:04:57.231673+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
physics	2020-11-30 08:04:57.231692+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
TheTesseract	2020-11-30 08:04:57.23171+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
fourthdimension	2020-11-30 08:04:57.231728+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
hexahedron	2020-11-30 08:04:57.231745+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
Plato	2020-11-30 08:04:57.231761+00	aWl8kKcp6SjFa8-N_ZPYuA	HASH
TheStarryNight	2020-12-01 13:12:14.243256+00	ncMzVXG81V5pLq90rL3i8Q	HASH
\.


--
-- Data for Name: insight_userpostcomment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insight_userpostcomment (id, post_id, comment, created_at, count, account_id) FROM stdin;
1	7zFsxvON_CK3iybolc7v-Q	Nice click bhai	2020-10-01 17:21:15.677+00	0	6392886167
2	7zFsxvON_CK3iybolc7v-Q	Osm pick	2020-10-01 17:56:39.204+00	0	8005089340
3	7zFsxvON_CK3iybolc7v-Q	Thanks bhai 	2020-10-01 18:36:26.96+00	0	9026457979
4	u11aqfFI4Q7GrP6O2qNTwQ	Nic one bhai	2020-10-01 18:39:56.05+00	0	6392886167
5	DLN5GxgEr1yBAeXwNHAyyw	Wah bhai wah	2020-10-01 18:43:02.646+00	0	8005089340
6	7zFsxvON_CK3iybolc7v-Q	Seems like lovers point	2020-10-01 18:59:53.645+00	0	8005089340
7	7zFsxvON_CK3iybolc7v-Q	yeah yeah, milli bobby brown, oH yeah!	2020-10-01 19:06:19.745+00	0	6392886167
8	7zFsxvON_CK3iybolc7v-Q	Yeah krispi.....	2020-10-01 19:07:16.955+00	0	9026457979
9	7zFsxvON_CK3iybolc7v-Q	😌	2020-10-01 19:16:55.481+00	0	9026457979
10	iQ_vARSYwUHeRtZaT-0WfQ	Bo yeah	2020-10-01 19:18:29.989+00	0	9026457979
11	7zFsxvON_CK3iybolc7v-Q	hi @you 	2020-10-01 19:28:43.4+00	0	6392886167
12	iQ_vARSYwUHeRtZaT-0WfQ	<span class="font-montserrat text-blue-700">@suyashmadhesia</span> thik thak hai	2020-10-01 20:23:13.672+00	0	6392886167
13	ErlbT3s5RVymkVDFebUW6A	@suyashmadhesia	2020-10-01 20:24:04.021+00	0	9026457979
14	978BX-b6-3-asupLjtefQw	😱	2020-10-01 20:43:14.499+00	0	8005089340
17	978BX-b6-3-asupLjtefQw	<a href="/profile/Prashant"><span class="font-montserrat text-blue-700">@Prashant</span></a> thanks bhai	2020-10-01 21:01:47.326+00	0	6392886167
18	978BX-b6-3-asupLjtefQw	<a href="/hastag/cyborg"><span class="font-montserrat text-blue-500">#cyborg</span></a> rocks	2020-10-01 21:03:00.824+00	0	6392886167
19	baK0jkr-tsfAjNsUPOoO3Q	abe humhi log ispe bhrr diya jaaye\nbhaad main jai duniya :) :)	2020-10-01 21:19:32.714+00	0	6392886167
20	baK0jkr-tsfAjNsUPOoO3Q	checkout <a href="/hastag/cyborg"><span class="font-montserrat text-blue-500">#cyborg</span></a>	2020-10-01 21:20:48.773+00	0	6392886167
21	ErlbT3s5RVymkVDFebUW6A	Yo bhai	2020-10-02 14:55:15.716+00	0	8005089340
22	Axs64rjC3C9q7svcPOSIxw	Are meri jaan😘	2020-10-03 11:05:44.035+00	0	8756516916
23	u11aqfFI4Q7GrP6O2qNTwQ	Thanks bhai	2020-10-03 11:08:27.009+00	0	8756516916
24	7zFsxvON_CK3iybolc7v-Q	Ohh yeah🤭🤭	2020-10-03 11:10:12.729+00	0	8756516916
25	7zFsxvON_CK3iybolc7v-Q	Prashant ko har jagah lover's point hi dikhta hai kyu meri jaan🥰	2020-10-03 11:10:43.414+00	0	8756516916
26	baK0jkr-tsfAjNsUPOoO3Q	hell	2020-10-05 17:51:22.395+00	0	6392886167
27	PRcDcdhFL5-_DPQpLGUyhw	Your most welcome here.....	2020-10-10 16:02:58.601+00	0	9026457979
28	7SsWTtJSKuO5Fg06hiCs7A	Hi	2020-11-24 11:37:12.070218+00	0	8005089340
29	31nvDJU6ba7I8E7Fq9LoOA	Beautiful	2020-11-24 11:42:40.893114+00	0	8005089340
30	pTxMOS0yRgq-tHrsFUANZg	Khub mrwa rhe ho blender se	2020-11-25 04:43:48.611415+00	0	6392886167
31	pTxMOS0yRgq-tHrsFUANZg	Blender ka maar rhe hai 	2020-11-25 05:12:57.44272+00	0	9026457979
32	pTxMOS0yRgq-tHrsFUANZg	Bde ache se maar rhe ho	2020-11-25 05:36:00.783672+00	0	8005089340
33	r0cIJojii-KSZYKZ6gRHow	What a beautiful sight	2020-11-25 06:10:47.238467+00	0	8005089340
34	LEEReMdYP9gB1BlGm_9KdQ	Cymatics is being used to decode the dolphine langugae and create the dolphine alphabets. Although we are no where close to done	2020-11-29 13:48:20.776416+00	0	6392886167
35	LEEReMdYP9gB1BlGm_9KdQ	Bhai discovery main cymatic se doodh main se gaadhi malai nikaal di thi 😁😁	2020-11-29 13:49:13.640136+00	0	6392886167
36	LEEReMdYP9gB1BlGm_9KdQ	Hahaha 	2020-11-30 05:32:42.836916+00	0	9838712221
37	i0jkXqQU4vcfpRB4_qCXew	They said Titan was destroyed in infinity war 😆😆	2020-11-30 08:10:00.195344+00	0	9838712221
38	rhLs3hN0xW8rBy8xVkg0Kg	Nyc look bro	2020-12-01 06:15:52.005264+00	0	8005089340
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

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 28, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 35, true);


--
-- Name: insight_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_account_groups_id_seq', 1, false);


--
-- Name: insight_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_account_user_permissions_id_seq', 1, false);


--
-- Name: insight_actionstore_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_actionstore_id_seq', 736, true);


--
-- Name: insight_hobbyreport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_hobbyreport_id_seq', 223, true);


--
-- Name: insight_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_places_id_seq', 1, false);


--
-- Name: insight_post_a_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_a_tags_id_seq', 2, true);


--
-- Name: insight_post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_comments_id_seq', 34, true);


--
-- Name: insight_post_down_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_down_votes_id_seq', 1, false);


--
-- Name: insight_post_hash_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_hash_tags_id_seq', 44, true);


--
-- Name: insight_post_loves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_loves_id_seq', 561, true);


--
-- Name: insight_post_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_shares_id_seq', 6, true);


--
-- Name: insight_post_up_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_up_votes_id_seq', 1, false);


--
-- Name: insight_post_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_post_views_id_seq', 697, true);


--
-- Name: insight_scoreboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_scoreboard_id_seq', 95, true);


--
-- Name: insight_scoreboard_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_scoreboard_posts_id_seq', 202, true);


--
-- Name: insight_userpostcomment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insight_userpostcomment_id_seq', 38, true);


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
-- Name: insight_actionstore insight_actionstore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insight_actionstore
    ADD CONSTRAINT insight_actionstore_pkey PRIMARY KEY (id);


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
-- Name: insight_actionstore_account_id_448a5592; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_actionstore_account_id_448a5592 ON public.insight_actionstore USING btree (account_id);


--
-- Name: insight_actionstore_account_id_448a5592_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_actionstore_account_id_448a5592_like ON public.insight_actionstore USING btree (account_id varchar_pattern_ops);


--
-- Name: insight_actionstore_post_id_6fb79ecb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_actionstore_post_id_6fb79ecb ON public.insight_actionstore USING btree (post_id);


--
-- Name: insight_actionstore_post_id_6fb79ecb_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX insight_actionstore_post_id_6fb79ecb_like ON public.insight_actionstore USING btree (post_id varchar_pattern_ops);


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

