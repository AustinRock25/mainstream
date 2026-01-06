--
-- PostgreSQL database dump
--

\restrict yVqph0gUKFFOsd38XzbEDQ9Mchef2MSfh0eRqGVPb1axKsiShtVy2CyBLk8rCKz

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.seasons_writers DROP CONSTRAINT IF EXISTS seasons_writers_writer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons_writers DROP CONSTRAINT IF EXISTS seasons_writers_show_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons DROP CONSTRAINT IF EXISTS seasons_show_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons_cast DROP CONSTRAINT IF EXISTS seasons_cast_show_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons_cast DROP CONSTRAINT IF EXISTS seasons_cast_actor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons_directors DROP CONSTRAINT IF EXISTS season_directors_show_id_fkey;
ALTER TABLE IF EXISTS ONLY public.seasons_directors DROP CONSTRAINT IF EXISTS season_directors_director_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_writers DROP CONSTRAINT IF EXISTS media_writers_writer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_writers DROP CONSTRAINT IF EXISTS media_writers_media_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_directors DROP CONSTRAINT IF EXISTS media_directors_media_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_directors DROP CONSTRAINT IF EXISTS media_directors_director_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_cast DROP CONSTRAINT IF EXISTS media_cast_media_id_fkey;
ALTER TABLE IF EXISTS ONLY public.media_cast DROP CONSTRAINT IF EXISTS media_cast_actor_id_fkey;
DROP INDEX IF EXISTS public.media_directors_idx;
DROP INDEX IF EXISTS public.media_cast_idx;
DROP INDEX IF EXISTS public.fki_media_writers_writer_id_fkey;
DROP INDEX IF EXISTS public.fki_media_writers_media_id_fkey;
DROP INDEX IF EXISTS public.fki_media_directors_director_id_fkey;
DROP INDEX IF EXISTS public.fki_media_cast_actor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.seasons_writers DROP CONSTRAINT IF EXISTS seasons_writers_pk;
ALTER TABLE IF EXISTS ONLY public.seasons DROP CONSTRAINT IF EXISTS seasons_pk;
ALTER TABLE IF EXISTS ONLY public.seasons_cast DROP CONSTRAINT IF EXISTS seasons_cast_pk;
ALTER TABLE IF EXISTS ONLY public.seasons_directors DROP CONSTRAINT IF EXISTS season_directors_pk;
ALTER TABLE IF EXISTS ONLY public.people DROP CONSTRAINT IF EXISTS people_pk;
ALTER TABLE IF EXISTS ONLY public.media_writers DROP CONSTRAINT IF EXISTS media_writers_pkey;
ALTER TABLE IF EXISTS ONLY public.media DROP CONSTRAINT IF EXISTS media_pk;
ALTER TABLE IF EXISTS ONLY public.media DROP CONSTRAINT IF EXISTS media_id_key;
ALTER TABLE IF EXISTS ONLY public.media_directors DROP CONSTRAINT IF EXISTS media_directors_pk;
ALTER TABLE IF EXISTS ONLY public.media_cast DROP CONSTRAINT IF EXISTS media_cast_pk;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.seasons_writers;
DROP TABLE IF EXISTS public.seasons_directors;
DROP TABLE IF EXISTS public.seasons_cast;
DROP TABLE IF EXISTS public.seasons;
DROP SEQUENCE IF EXISTS public.people_id_seq;
DROP TABLE IF EXISTS public.people;
DROP TABLE IF EXISTS public.media_writers;
DROP TABLE IF EXISTS public.media_temp;
DROP TABLE IF EXISTS public.media_directors;
DROP TABLE IF EXISTS public.media_cast;
DROP TABLE IF EXISTS public.media;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    title text NOT NULL,
    rating text,
    poster text NOT NULL,
    runtime integer,
    type text NOT NULL,
    id integer NOT NULL,
    release_date date,
    completed boolean,
    date_added timestamp with time zone,
    grade text
);


--
-- Name: media_cast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_cast (
    media_id integer NOT NULL,
    actor_id integer NOT NULL,
    ordering integer
);


--
-- Name: media_directors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_directors (
    media_id integer NOT NULL,
    director_id integer NOT NULL,
    ordering integer
);


--
-- Name: media_temp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_temp (
    rating text,
    title text,
    type text,
    year text
);


--
-- Name: media_writers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_writers (
    ordering integer NOT NULL,
    media_id integer NOT NULL,
    writer_id integer NOT NULL
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name text,
    birth_date date,
    death_date date
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons (
    season integer NOT NULL,
    show_id integer NOT NULL,
    episodes integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    date_added timestamp with time zone,
    runtime integer,
    grade text
);


--
-- Name: seasons_cast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons_cast (
    ordering integer NOT NULL,
    season integer NOT NULL,
    show_id integer NOT NULL,
    actor_id integer NOT NULL
);


--
-- Name: seasons_directors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons_directors (
    ordering integer,
    show_id integer NOT NULL,
    season integer NOT NULL,
    director_id integer NOT NULL
);


--
-- Name: seasons_writers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons_writers (
    ordering integer,
    show_id integer NOT NULL,
    season integer NOT NULL,
    writer_id integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    is_admin boolean DEFAULT false,
    email character varying(75) NOT NULL,
    password character varying(100) NOT NULL,
    rating_scale integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media (title, rating, poster, runtime, type, id, release_date, completed, date_added, grade) FROM stdin;
Echo	TV-MA	echo	\N	show	1182	\N	t	\N	\N
Daredevil	TV-MA	daredevil	\N	show	1487	\N	t	\N	\N
Supergirl	TV-14	supergirl	\N	show	1488	\N	f	\N	\N
She-Hulk: Attorney at Law	TV-14	she-hulk	\N	show	781	\N	t	\N	\N
The Punisher	TV-MA	the-punisher	\N	show	1495	\N	t	\N	\N
The Flash	TV-14	the-flash	\N	show	1486	\N	f	\N	\N
Hawkeye	TV-14	hawkeye	\N	show	972	\N	t	\N	\N
Daredevil: Born Again	TV-MA	daredevil-born-again	\N	show	1462	\N	f	\N	\N
Black Lightning	TV-14	black-lightning	\N	show	1497	\N	f	\N	\N
Jessica Jones	TV-MA	jessica-jones	\N	show	1489	\N	t	\N	\N
The Acolyte	TV-14	the-acolyte	\N	show	1295	\N	t	\N	\N
Obi-Wan Kenobi	TV-14	obi-wan-kenobi	\N	show	197	\N	t	\N	\N
Star Wars: The Bad Batch	TV-PG	star-wars-the-bad-batch	\N	show	609	\N	t	\N	\N
Star Wars: The Clone Wars	TV-PG	star-wars-the-clone-wars	\N	show	517	\N	t	\N	\N
Star Wars: Skeleton Crew	TV-PG	star-wars-skeleton-crew	\N	show	1377	\N	t	\N	\N
The Lord of the Rings: The Rings of Power	TV-14	the-lord-of-the-rings-the-rings-of-power	\N	show	783	\N	f	\N	\N
The Book of Boba Fett	TV-14	the-book-of-boba-fett	\N	show	130	\N	t	\N	\N
Creature Commandos	TV-MA	creature-commandos	\N	show	1373	\N	f	\N	\N
Dune: Prophecy	TV-MA	dune-prophecy	\N	show	1365	\N	f	\N	\N
Knuckles	TV-PG	knuckles	\N	show	1202	\N	t	\N	\N
Monarch: Legacy of Monsters	TV-14	monarch	\N	show	1185	\N	f	\N	\N
Andor	TV-14	andor	\N	show	807	\N	t	\N	\N
The Falcon and the Winter Soldier	TV-14	the-falcon-and-the-winter-soldier	\N	show	536	\N	t	\N	\N
Arcane	TV-14	arcane	\N	show	309	\N	t	\N	\N
Cobra Kai	TV-14	cobra-kai	\N	show	248	\N	f	\N	\N
Runaways	TV-14	runaways	\N	show	1496	\N	t	\N	\N
Ms. Marvel	TV-PG	ms-marvel	\N	show	601	\N	t	\N	\N
Fallout	TV-MA	fallout	\N	show	1250	\N	f	\N	\N
The Boys	TV-MA	the-boys	\N	show	529	\N	f	\N	\N
Invincible	TV-MA	invincible	\N	show	844	\N	f	\N	\N
Your Friendly Neighborhood Spider-Man	TV-PG	your-friendly-neighborhood-spider-man	\N	show	1432	\N	f	\N	\N
WandaVision	TV-14	wandavision	\N	show	583	\N	t	\N	\N
The Penguin	TV-MA	the-penguin	\N	show	1350	\N	t	\N	\N
Agatha All Along	TV-14	agatha-all-along	\N	show	1343	\N	t	\N	\N
Star Wars Rebels	TV-Y7 FV	star-wars-rebels	\N	show	167	\N	t	\N	\N
Moon Knight	TV-14	moon-knight	\N	show	453	\N	t	\N	\N
What If...?	TV-14	what-if	\N	show	104	\N	t	\N	\N
Percy Jackson and the Olympians	TV-PG	percy-jackson-and-the-olympians	\N	show	1198	\N	f	\N	\N
Loki	TV-14	loki	\N	show	423	\N	t	\N	\N
The Continental: From the World of John Wick	TV-MA	the-continental	\N	show	1502	\N	t	\N	\N
Ahsoka	TV-14	ahsoka	\N	show	1131	\N	f	\N	\N
Agents of S.H.I.E.L.D.	TV-14	agents-of-shield	\N	show	1485	\N	t	\N	\N
The Last of Us	TV-MA	the-last-of-us	\N	show	905	\N	f	\N	\N
Velma	TV-MA	velma	\N	show	1094	\N	f	\N	\N
House of the Dragon	TV-MA	house-of-the-dragon	\N	show	789	\N	f	\N	\N
The Bear	TV-MA	the-bear	\N	show	1512	\N	f	\N	\N
Halo	TV-14	halo	\N	show	1192	\N	f	\N	\N
Squid Game	TV-MA	squid-game	\N	show	740	\N	t	\N	\N
Stargirl	TV-14	stargirl	\N	show	1499	\N	f	\N	\N
Batwoman	TV-14	batwoman	\N	show	1498	\N	f	\N	\N
Legends of Tomorrow	TV-14	legends-of-tomorrow	\N	show	1490	\N	f	\N	\N
The Defenders	TV-MA	the-defenders	\N	show	1493	\N	t	\N	\N
Iron Fist	TV-MA	iron-fist	\N	show	1492	\N	t	\N	\N
Arrow	TV-14	arrow	\N	show	1484	\N	t	\N	\N
Game of Thrones	TV-MA	game-of-thrones	\N	show	364	\N	t	\N	\N
Inhumans	TV-14	inhumans	\N	show	1494	\N	t	\N	\N
Luke Cage	TV-MA	luke-cage	\N	show	1491	\N	t	\N	\N
Secret Invasion	TV-14	secret-invasion	\N	show	1075	\N	t	\N	\N
The Sandman	TV-MA	the-sandman	\N	show	736	\N	t	\N	\N
Ironheart	TV-14	ironheart	\N	show	1518	\N	t	\N	\N
Wednesday	TV-14	wednesday	\N	show	865	\N	f	\N	\N
Alien: Earth	TV-MA	alien-earth	\N	show	1577	\N	f	\N	\N
Eyes of Wakanda	TV-PG	eyes-of-wakanda	\N	show	1544	\N	t	\N	\N
Marvel Zombies	TV-MA	marvel-zombies	\N	show	1578	\N	t	\N	\N
Gen V	TV-MA	gen-v	\N	show	1149	\N	f	\N	\N
Snow White and the Seven Dwarfs	G	snow-white-and-the-seven-dwarfs	83	movie	803	1937-12-21	\N	\N	B+
Peacemaker	TV-MA	peacemaker	\N	show	466	\N	t	\N	\N
The Mandalorian	TV-14	the-mandalorian	\N	show	550	\N	t	\N	\N
The Flash	PG-13	the-flash	144	movie	1055	2023-06-16	\N	\N	B-
The Electric State	PG-13	the-electric-state	128	movie	1439	2025-03-14	\N	\N	C+
Hop	PG	hop	95	movie	145	2011-04-01	\N	\N	D+
Elf	PG	elf	97	movie	964	2003-11-07	\N	\N	B-
Saw IV	R	saw-4	93	movie	120	2007-10-26	\N	\N	C-
The Tomorrow War	PG-13	the-tomorrow-war	138	movie	565	2021-07-02	\N	\N	C+
RoboCop 2	R	robocop-2	117	movie	852	1990-06-22	\N	\N	D+
Friday the 13th	R	friday-the-13th-(2009)	97	movie	306	2009-02-13	\N	\N	C-
Blade II	R	blade-2	117	movie	14	2002-03-22	\N	\N	C+
The Santa Clause 3: The Escape Clause	G	the-santa-clause-3	97	movie	95	2006-11-03	\N	\N	D+
Saw V	R	saw-5	92	movie	488	2008-10-24	\N	\N	D+
The Curse of La Llorona	R	the-curse-of-la-llorona	93	movie	191	2019-04-19	\N	\N	D+
No Country for Old Men	R	no-country-for-old-men	122	movie	458	2007-11-09	\N	\N	C+
Rocky IV	PG	rocky-4	91	movie	69	1985-11-27	\N	\N	B-
Cinderella	G	cinderella-(1997)	88	movie	1290	1997-11-02	\N	\N	C+
Godzilla: King of the Monsters	PG-13	godzilla-king-of-the-monsters	132	movie	836	2019-05-31	\N	\N	C+
The Old Guard	R	the-old-guard	125	movie	723	2020-07-10	\N	\N	C+
Ouija: Origin of Evil	PG-13	ouija-origin-of-evil	99	movie	1132	2016-10-21	\N	\N	C+
The Equalizer 3	R	the-equalizer-3	109	movie	1189	2023-09-01	\N	\N	C+
Star Trek II: The Wrath of Khan	PG	star-trek-2	113	movie	165	1982-06-04	\N	\N	A-
Aladdin	G	aladdin-(1992)	90	movie	213	1992-11-11	\N	\N	A
It - Welcome to Derry	TV-MA	it-welcome-to-derry	\N	show	1637	\N	f	\N	\N
Spider-Man: Into the Spider-Verse	PG	spider-man-into-the-spider-verse	117	movie	613	2018-12-14	\N	\N	A+
The Empire Strikes Back	PG	the-empire-strikes-back	124	movie	614	1980-05-21	\N	\N	A+
Soul	PG	soul	100	movie	615	2020-12-25	\N	\N	A+
Pan's Labyrinth	R	pans-labyrinth	118	movie	616	2006-10-20	\N	\N	A+
The Dark Knight	PG-13	the-dark-knight	152	movie	617	2008-07-18	\N	\N	A+
Logan	R	logan	137	movie	618	2017-03-03	\N	\N	A+
The Lord of the Rings: The Fellowship of the Ring	PG-13	the-lord-of-the-rings-the-fellowship-of-the-ring	178	movie	625	2001-12-19	\N	\N	A+
The Lord of the Rings: The Two Towers	PG-13	the-lord-of-the-rings-the-two-towers	179	movie	626	2002-12-18	\N	\N	A+
The Lord of the Rings: The Return of the King	PG-13	the-lord-of-the-rings-the-return-of-the-king	201	movie	627	2003-12-17	\N	\N	A+
Coco	PG	coco	105	movie	668	2017-11-22	\N	\N	A+
Raiders of the Lost Ark	PG	raiders-of-the-lost-ark	115	movie	684	1981-06-12	\N	\N	A+
The Incredibles	PG	the-incredibles	115	movie	720	2004-11-05	\N	\N	A+
Everything Everywhere All at Once	R	everything-everywhere-all-at-once	139	movie	800	2022-03-25	\N	\N	A+
Spider-Man: Across the Spider-Verse	PG	spider-man-across-the-spider-verse	140	movie	1126	2023-06-02	\N	\N	A+
Her	R	her	126	movie	1249	2013-12-18	\N	\N	A+
Parasite	R	parasite	132	movie	1395	2019-05-30	\N	\N	A+
The Wild Robot	PG	the-wild-robot	102	movie	1416	2024-09-27	\N	\N	A+
A Christmas Carol	PG	a-christmas-carol-(2009)	96	movie	1	2009-11-06	\N	\N	C+
It	TV-14	it	\N	show	46	\N	t	\N	\N
A Nightmare on Elm Street	R	a-nightmare-on-elm-street-(2010)	95	movie	2	2010-04-30	\N	\N	D+
A Nightmare on Elm Street 3: Dream Warriors	R	a-nightmare-on-elm-street-3	96	movie	3	1987-02-27	\N	\N	C+
A Wrinkle in Time	PG	a-wrinkle-in-time	109	movie	4	2018-03-09	\N	\N	C+
Ad Astra	PG-13	ad-astra	123	movie	5	2019-09-20	\N	\N	C+
Aladdin	PG	aladdin-(2019)	128	movie	6	2019-05-24	\N	\N	C+
Angels & Demons	PG-13	angels-and-demons	138	movie	7	2009-05-15	\N	\N	B-
Aquaman	PG-13	aquaman	143	movie	8	2018-12-21	\N	\N	B
Austin Powers in Goldmember	PG-13	austin-powers-in-goldmember	94	movie	9	2002-07-26	\N	\N	C+
Austin Powers: The Spy Who Shagged Me	PG-13	austin-powers-the-spy-who-shagged-me	95	movie	10	1999-06-11	\N	\N	C+
Batman & Robin	PG-13	batman-and-robin	125	movie	11	1997-06-20	\N	\N	D
Batman v Superman: Dawn of Justice	PG-13	batman-v-superman	151	movie	12	2016-03-25	\N	\N	C+
Bill & Ted Face the Music	PG-13	bill-and-ted-face-the-music	91	movie	13	2020-08-28	\N	\N	B
Blade Runner 2049	R	blade-runner-2049	164	movie	15	2017-10-06	\N	\N	B
Captain Marvel	PG-13	captain-marvel	123	movie	16	2019-03-08	\N	\N	B
Cars	G	cars	117	movie	17	2006-06-09	\N	\N	B
Cars 3	G	cars-3	102	movie	18	2017-06-16	\N	\N	B-
Charlie and the Chocolate Factory	PG	charlie-and-the-chocolate-factory	115	movie	19	2005-07-15	\N	\N	C+
Christopher Robin	PG	christopher-robin	104	movie	20	2018-08-03	\N	\N	B
Descendants	TV-G	descendants	112	movie	21	2015-07-31	\N	\N	C+
Die Hard 2	R	die-hard-2	124	movie	22	1990-07-04	\N	\N	B
Donnie Darko	R	donnie-darko	113	movie	23	2001-10-26	\N	\N	B
Eternals	PG-13	eternals	156	movie	24	2021-11-05	\N	\N	C+
F9: The Fast Saga	PG-13	f9	143	movie	25	2021-06-25	\N	\N	C+
Fantastic Beasts and Where to Find Them	PG-13	fantastic-beasts-and-where-to-find-them	132	movie	26	2016-11-18	\N	\N	B
Fantastic Beasts: The Crimes of Grindelwald	PG-13	fantastic-beasts-the-crimes-of-grindelwald	134	movie	27	2018-11-16	\N	\N	C+
Fast & Furious 6	PG-13	fast-and-furious-6	130	movie	28	2013-05-24	\N	\N	B
Fast Five	PG-13	fast-five	130	movie	29	2011-04-29	\N	\N	B
Fear Street Part Three: 1666	R	fear-street-part-3	114	movie	30	2021-07-16	\N	\N	B
Five Feet Apart	PG-13	five-feet-apart	116	movie	31	2019-03-15	\N	\N	B
Friday the 13th	R	friday-the-13th-(1980)	95	movie	32	1980-05-09	\N	\N	B-
Friday the 13th Part VI: Jason Lives	R	friday-the-13th-part-6	86	movie	33	1986-08-01	\N	\N	C-
Friday the 13th Part VIII: Jason Takes Manhattan	R	friday-the-13th-part-8	100	movie	34	1989-07-28	\N	\N	D
Frozen II	PG	frozen-2	103	movie	35	2019-11-22	\N	\N	B
Furious 7	PG-13	furious-7	137	movie	36	2015-04-03	\N	\N	B
Ghostbusters	PG-13	ghostbusters-(2016)	117	movie	37	2016-07-15	\N	\N	C-
Ghostbusters II	PG	ghostbusters-2	108	movie	38	1989-06-16	\N	\N	C+
Godzilla	PG-13	godzilla-(2014)	123	movie	39	2014-05-16	\N	\N	B
Grease	PG	grease	110	movie	40	1978-06-16	\N	\N	B
Gremlins 2: The New Batch	PG-13	gremlins-2	106	movie	41	1990-06-15	\N	\N	B
Hitch	PG-13	hitch	118	movie	42	2005-02-11	\N	\N	C+
Home Alone 2: Lost in New York	PG	home-alone-2	120	movie	43	1992-11-20	\N	\N	B-
Hook	PG	hook	142	movie	44	1991-12-11	\N	\N	B
Iron Man 2	PG-13	iron-man-2	124	movie	45	2010-05-07	\N	\N	B
It Chapter Two	R	it-chapter-2	169	movie	47	2019-09-06	\N	\N	C+
Jumanji: The Next Level	PG-13	jumanji-the-next-level	123	movie	48	2019-12-13	\N	\N	B
Jurassic World	PG-13	jurassic-world	124	movie	49	2015-06-12	\N	\N	B-
Jurassic World: Fallen Kingdom	PG-13	jurassic-world-fallen-kingdom	128	movie	50	2018-06-22	\N	\N	C-
Mad Max Beyond Thunderdome	PG-13	mad-max-beyond-thunderdome	107	movie	51	1985-07-10	\N	\N	B
Monsters University	G	monsters-university	104	movie	52	2013-06-21	\N	\N	B
Wes Craven's New Nightmare	R	new-nightmare	112	movie	53	1994-10-14	\N	\N	B
Ocean's Eleven	PG-13	oceans-eleven	116	movie	54	2001-12-07	\N	\N	B-
Pacific Rim	PG-13	pacific-rim	131	movie	55	2013-07-12	\N	\N	B
Pacific Rim: Uprising	PG-13	pacific-rim-uprising	111	movie	56	2018-03-23	\N	\N	C+
Return to Never Land	G	return-to-never-land	72	movie	57	2002-02-15	\N	\N	C+
Pirates of the Caribbean: At World's End	PG-13	pirates-of-the-caribbean-at-worlds-end	169	movie	58	2007-05-25	\N	\N	C+
Pirates of the Caribbean: Dead Man's Chest	PG-13	pirates-of-the-caribbean-dead-mans-chest	151	movie	59	2006-07-07	\N	\N	B-
Power Rangers	PG-13	power-rangers	124	movie	60	2017-03-24	\N	\N	C+
Predator 2	R	predator-2	108	movie	61	1990-11-21	\N	\N	C+
Predators	R	predators	107	movie	62	2010-07-09	\N	\N	B
Puss in Boots	PG	puss-in-boots	90	movie	63	2011-10-28	\N	\N	B
Rambo III	R	rambo-3	102	movie	64	1988-05-25	\N	\N	C+
Rambo: First Blood Part II	R	first-blood-part-2	96	movie	65	1985-05-22	\N	\N	C+
Rambo: Last Blood	R	rambo-last-blood	89	movie	66	2019-09-20	\N	\N	C-
Rampage	PG-13	rampage	107	movie	67	2018-04-13	\N	\N	C+
Rocky III	PG	rocky-3	99	movie	68	1982-05-28	\N	\N	B
Scrooged	PG-13	scrooged	101	movie	70	1988-11-23	\N	\N	B
Secret Society of Second-Born Royals	TV-PG	secret-society-of-second-born-royals	99	movie	71	2020-09-25	\N	\N	D+
Sherlock Holmes: A Game of Shadows	PG-13	sherlock-holmes-a-game-of-shadows	129	movie	72	2011-12-16	\N	\N	B
Solo: A Star Wars Story	PG-13	solo	135	movie	73	2018-05-25	\N	\N	B-
Space Jam: A New Legacy	PG	space-jam-a-new-legacy	115	movie	74	2021-07-16	\N	\N	D+
Spider-Man 3	PG-13	spider-man-3	139	movie	75	2007-05-04	\N	\N	C+
Home Alone 4	TV-PG	home-alone-4	84	movie	1639	2002-11-03	\N	2025-12-18 16:55:05.149-05	D-
Star Trek III: The Search for Spock	PG	star-trek-3	105	movie	76	1984-06-01	\N	\N	B
Star Trek IV: The Voyage Home	PG	star-trek-4	119	movie	77	1986-11-26	\N	\N	B+
Star Trek VI: The Undiscovered Country	PG	star-trek-6	110	movie	78	1991-12-06	\N	\N	B-
Star Trek: Insurrection	PG	star-trek-insurrection	103	movie	79	1998-12-11	\N	\N	B-
Star Wars: The Rise of Skywalker	PG-13	star-wars-the-rise-of-skywalker	141	movie	80	2019-12-20	\N	\N	C+
Terminator Salvation	PG-13	terminator-salvation	115	movie	81	2009-05-21	\N	\N	C+
The BFG	PG	the-bfg	117	movie	82	2016-07-01	\N	\N	B
The Golden Compass	PG-13	the-golden-compass	113	movie	83	2007-12-07	\N	\N	C+
The Hobbit: An Unexpected Journey	PG-13	the-hobbit-an-unexpected-journey	169	movie	84	2012-12-14	\N	\N	B
The Hobbit: The Desolation of Smaug	PG-13	the-hobbit-the-desolation-of-smaug	161	movie	85	2013-12-13	\N	\N	B
The Hunger Games	PG-13	the-hunger-games	142	movie	86	2012-03-23	\N	\N	B
The Hunger Games: Mockingjay - Part 1	PG-13	the-hunger-games-mockingjay-part-1	123	movie	87	2014-11-21	\N	\N	C+
The Hunger Games: Mockingjay - Part 2	PG-13	the-hunger-games-mockingjay-part-2	137	movie	88	2015-11-20	\N	\N	C+
The Jungle Book	PG	the-jungle-book-(2016)	106	movie	89	2016-04-15	\N	\N	B+
The Karate Kid	PG	the-karate-kid-(2010)	140	movie	90	2010-06-11	\N	\N	B
The Matrix Reloaded	R	the-matrix-reloaded	138	movie	91	2003-05-15	\N	\N	B-
The New Mutants	PG-13	the-new-mutants	94	movie	92	2020-08-28	\N	\N	C+
The Sandlot	PG	the-sandlot	101	movie	93	1993-04-07	\N	\N	B
The Santa Clause	PG	the-santa-clause	97	movie	94	1994-11-11	\N	\N	B-
The Texas Chain Saw Massacre	R	the-texas-chain-saw-massacre	83	movie	96	1974-10-11	\N	\N	B
The Twilight Saga: Breaking Dawn - Part 2	PG-13	breaking-dawn-part-2	115	movie	97	2012-11-16	\N	\N	D+
The Wolverine	PG-13	the-wolverine	126	movie	98	2013-07-26	\N	\N	B
Transformers	PG-13	transformers	144	movie	99	2007-07-03	\N	\N	C+
Transformers: Age of Extinction	PG-13	transformers-age-of-extinction	165	movie	100	2014-06-27	\N	\N	D+
Tucker & Dale vs. Evil	R	tucker-and-dale-vs-evil	89	movie	101	2010-01-22	\N	\N	B
Venom	PG-13	venom	112	movie	102	2018-10-05	\N	\N	C+
Watchmen	R	watchmen	162	movie	103	2009-03-06	\N	\N	C+
X-Men Origins: Wolverine	PG-13	x-men-origins-wolverine	107	movie	105	2009-05-01	\N	\N	D+
Zombies	TV-G	zombies	94	movie	106	2018-02-16	\N	\N	C+
Lethal Weapon 2	R	lethal-weapon-2	114	movie	107	1989-07-07	\N	\N	B
Lethal Weapon 3	R	lethal-weapon-3	118	movie	108	1992-05-15	\N	\N	C+
Diary of a Wimpy Kid: Rodrick Rules	PG	diary-of-a-wimpy-kid-rodrick-rules	100	movie	109	2011-03-25	\N	\N	C-
Diary of a Wimpy Kid: Dog Days	PG	diary-of-a-wimpy-kid-dog-days	94	movie	110	2012-08-03	\N	\N	C-
Black Christmas	PG-13	black-christmas-(2019)	92	movie	111	2019-12-13	\N	\N	D+
The Amazing Spider-Man	PG-13	the-amazing-spider-man	136	movie	112	2012-07-03	\N	\N	B
The Amazing Spider-Man 2	PG-13	the-amazing-spider-man-2	142	movie	113	2014-05-02	\N	\N	C+
Miracle on 34th Street	PG	miracle-on-34th-street-(1994)	114	movie	114	1994-11-18	\N	\N	B
Scream 3	R	scream-3	116	movie	115	2000-02-04	\N	\N	C+
Bohemian Rhapsody	PG-13	bohemian-rhapsody	134	movie	116	2018-11-02	\N	\N	B
Mortal Kombat Legends: Battle of the Realms	R	mortal-kombat-legends-battle-of-the-realms	80	movie	117	2021-08-31	\N	\N	C+
Injustice	PR	injustice	78	movie	118	2021-10-19	\N	\N	C+
A Quiet Place Part II	PG-13	a-quiet-place-part-2	97	movie	119	2021-05-28	\N	\N	B
The Purge: Anarchy	R	the-purge-anarchy	103	movie	121	2014-07-18	\N	\N	C+
Saw VI	R	saw-6	90	movie	122	2009-10-23	\N	\N	C-
The Purge: Election Year	R	the-purge-election-year	108	movie	123	2016-07-01	\N	\N	C+
Saw: The Final Chapter	R	saw-the-final-chapter	90	movie	124	2010-10-29	\N	\N	D
Hotel Transylvania 2	PG	hotel-transylvania-2	89	movie	125	2015-09-25	\N	\N	C+
Ralph Breaks the Internet	PG	ralph-breaks-the-internet	112	movie	126	2018-11-21	\N	\N	B
Ice Age	PG	ice-age	81	movie	127	2002-03-15	\N	\N	B
Ice Age: The Meltdown	PG	ice-age-the-meltdown	91	movie	128	2006-03-31	\N	\N	C+
The Cabinet of Dr. Caligari	Not Rated	the-cabinet-of-dr-caligari	67	movie	129	1920-02-26	\N	\N	B
The Texas Chainsaw Massacre	R	the-texas-chainsaw-massacre	98	movie	131	2003-10-17	\N	\N	D+
The Texas Chainsaw Massacre: The Beginning	R	the-texas-chainsaw-massacre-the-beginning	91	movie	132	2006-10-06	\N	\N	D
Texas Chainsaw Massacre	R	texas-chainsaw-massacre	83	movie	133	2022-02-18	\N	\N	D+
Black Widow	PG-13	black-widow	134	movie	135	2021-07-09	\N	\N	B+
Child's Play	R	childs-play-(1988)	87	movie	136	1988-11-09	\N	\N	B
Cloverfield	PG-13	cloverfield	85	movie	137	2008-01-18	\N	\N	A-
Freddy vs. Jason	R	freddy-vs-jason	97	movie	138	2003-08-15	\N	\N	C-
Freddy's Dead: The Final Nightmare	R	freddys-dead	89	movie	139	1991-09-13	\N	\N	D+
Gone with the Wind	G	gone-with-the-wind	238	movie	140	1939-12-15	\N	\N	B+
Grease 2	PG	grease-2	115	movie	141	1982-06-11	\N	\N	C
Halloween	R	halloween-(2018)	106	movie	142	2018-10-19	\N	\N	B+
Halloweentown	TV-PG	halloweentown	84	movie	143	1998-10-17	\N	\N	D+
Hocus Pocus	PG	hocus-pocus	96	movie	144	1993-07-16	\N	\N	C
Incredibles 2	PG	incredibles-2	118	movie	146	2018-06-15	\N	\N	B+
Iron Man 3	PG-13	iron-man-3	130	movie	147	2013-05-03	\N	\N	B+
Jack and Jill	PG	jack-and-jill	91	movie	148	2011-11-11	\N	\N	D-
Kill Bill: Vol. 2	R	kill-bill-vol-2	137	movie	149	2004-04-16	\N	\N	B
Kirk Cameron's Saving Christmas	PG	saving-christmas	79	movie	150	2014-11-14	\N	\N	F
Kong: Skull Island	PG-13	kong-skull-island	118	movie	151	2017-03-10	\N	\N	B+
Maleficent: Mistress of Evil	PG	maleficent-mistress-of-evil	119	movie	152	2019-10-18	\N	\N	C
Mary Poppins Returns	PG	mary-poppins-returns	130	movie	153	2018-12-19	\N	\N	B
Alice Through the Looking Glass	PG	alice-through-the-looking-glass	113	movie	134	2016-05-27	\N	\N	C-
Mortal Kombat	PG-13	mortal-kombat-(1995)	101	movie	154	1995-08-18	\N	\N	C
Pan	PG	pan	111	movie	155	2015-10-09	\N	\N	C
Pirates of the Caribbean: Dead Men Tell No Tales	PG-13	pirates-of-the-caribbean-dead-men-tell-no-tales	129	movie	156	2017-05-26	\N	\N	C
Pirates of the Caribbean: On Stranger Tides	PG-13	pirates-of-the-caribbean-on-stranger-tides	137	movie	157	2011-05-20	\N	\N	C
Pirates of the Caribbean: The Curse of the Black Pearl	PG-13	pirates-of-the-caribbean-the-curse-of-the-black-pearl	143	movie	158	2003-07-09	\N	\N	A-
Rocky Balboa	PG	rocky-balboa	102	movie	159	2006-12-20	\N	\N	B+
Rocky II	PG	rocky-2	119	movie	160	1979-06-15	\N	\N	B+
Scoob!	PG	scoob	93	movie	161	2020-05-15	\N	\N	C
Sherlock Holmes	PG-13	sherlock-holmes	128	movie	162	2009-12-25	\N	\N	B+
Shrek 2	PG	shrek-2	93	movie	163	2004-05-19	\N	\N	A-
Spy Kids 2: Island of Lost Dreams	PG	spy-kids-2	100	movie	164	2002-08-07	\N	\N	C
Star Trek V: The Final Frontier	PG	star-trek-5	107	movie	166	1989-06-09	\N	\N	C
Superman IV: The Quest for Peace	PG	superman-4	90	movie	168	1987-07-24	\N	\N	F
Teen Wolf	PG	teen-wolf	91	movie	169	1985-08-23	\N	\N	C
Terminator Genisys	PG-13	terminator-genisys	126	movie	170	2015-07-01	\N	\N	C
The Big Lebowski	R	the-big-lebowski	117	movie	171	1998-03-06	\N	\N	A-
The Chronicles of Narnia: The Lion, the Witch and the Wardrobe	PG	the-chronicles-of-narnia-the-lion-the-witch-and-the-wardrobe	143	movie	172	2005-12-09	\N	\N	B+
The Chronicles of Narnia: The Voyage of the Dawn Treader	PG	the-chronicles-of-narnia-the-voyage-of-the-dawn-treader	113	movie	173	2010-12-10	\N	\N	C
The Day After Tomorrow	PG-13	the-day-after-tomorrow	124	movie	174	2004-05-28	\N	\N	C
The Divergent Series: Insurgent	PG-13	insurgent	119	movie	175	2015-03-20	\N	\N	C
The Exorcist	R	the-exorcist	122	movie	176	1973-12-26	\N	\N	B+
The First Purge	R	the-first-purge	97	movie	177	2018-07-04	\N	\N	C
The Forever Purge	R	the-forever-purge	103	movie	178	2021-07-02	\N	\N	C
The Grinch	PG	the-grinch	85	movie	179	2018-11-09	\N	\N	C
The Hunger Games: Catching Fire	PG-13	the-hunger-games-catching-fire	146	movie	180	2013-11-22	\N	\N	B+
The Lion King	PG	the-lion-king-(2019)	118	movie	181	2019-07-19	\N	\N	C-
The NeverEnding Story	PG	the-neverending-story	102	movie	182	1984-07-20	\N	\N	B+
The Purge	R	the-purge	85	movie	183	2013-06-07	\N	\N	C
The Santa Clause 2	G	the-santa-clause-2	104	movie	184	2002-11-01	\N	\N	C
The Space Between Us	PG-13	the-space-between-us	120	movie	185	2017-02-03	\N	\N	C
Thor	PG-13	thor	115	movie	186	2011-05-06	\N	\N	B+
Thor: The Dark World	PG-13	thor-the-dark-world	112	movie	187	2013-11-08	\N	\N	C+
Wrath of the Titans	PG-13	wrath-of-the-titans	99	movie	188	2012-03-30	\N	\N	C
X2: X-Men United	PG-13	x2	134	movie	189	2003-05-02	\N	\N	B+
Annabelle: Creation	R	annabelle-creation	109	movie	190	2017-08-11	\N	\N	C+
The Conjuring: The Devil Made Me Do It	R	the-conjuring-the-devil-made-me-do-it	112	movie	192	2021-06-04	\N	\N	C+
Halloween II	R	halloween-2-(1981)	92	movie	194	1981-10-30	\N	\N	C+
Halloween	R	halloween-(2007)	109	movie	195	2007-08-31	\N	\N	C-
Teen Beach Movie	TV-G	teen-beach-movie	110	movie	196	2013-07-19	\N	\N	C
The Secret Life of Pets 2	PG	the-secret-life-of-pets-2	86	movie	198	2019-06-07	\N	\N	C
Despicable Me	PG	despicable-me	95	movie	199	2010-07-09	\N	\N	B+
Despicable Me 2	PG	despicable-me-2	98	movie	200	2013-07-03	\N	\N	B
Sing 2	PG	sing-2	110	movie	201	2021-12-22	\N	\N	C+
Bright	TV-MA	bright	117	movie	202	2017-12-22	\N	\N	C-
Men in Black II	PG-13	men-in-black-2	88	movie	203	2002-07-03	\N	\N	C
Men in Black 3	PG-13	men-in-black-3	106	movie	204	2012-05-25	\N	\N	C+
10 Cloverfield Lane	PG-13	10-cloverfield-lane	103	movie	205	2016-03-11	\N	\N	A
A Monster Calls	PG-13	a-monster-calls	108	movie	206	2016-12-23	\N	\N	A
A Nightmare on Elm Street	R	a-nightmare-on-elm-street-(1984)	91	movie	207	1984-11-09	\N	\N	A
A Nightmare on Elm Street 2: Freddy's Revenge	R	a-nightmare-on-elm-street-2	87	movie	208	1985-11-01	\N	\N	C
A Quiet Place	PG-13	a-quiet-place	90	movie	209	2018-04-06	\N	\N	A-
A Star Is Born	R	a-star-is-born	136	movie	210	2018-10-05	\N	\N	B+
Adventures in Babysitting	PG-13	adventures-in-babysitting-(1987)	102	movie	211	1987-07-03	\N	\N	C+
Adventures in Babysitting	TV-G	adventures-in-babysitting-(2016)	105	movie	212	2016-06-24	\N	\N	C
Alien	R	alien	117	movie	215	1979-05-25	\N	\N	A-
Aliens	R	aliens	137	movie	216	1986-07-18	\N	\N	A
Alita: Battle Angel	PG-13	alita	122	movie	217	2019-02-14	\N	\N	A-
Annabelle	R	annabelle	99	movie	218	2014-10-03	\N	\N	C
Ant-Man	PG-13	ant-man	117	movie	219	2015-07-17	\N	\N	B+
Ant-Man and the Wasp	PG-13	ant-man-and-the-wasp	118	movie	220	2018-07-06	\N	\N	B+
Arthur Christmas	PG	arthur-christmas	97	movie	221	2011-11-23	\N	\N	A
Avatar	PG-13	avatar	162	movie	222	2009-12-18	\N	\N	A-
Avengers: Endgame	PG-13	avengers-endgame	181	movie	223	2019-04-26	\N	\N	A
Avengers: Infinity War	PG-13	avengers-infinity-war	149	movie	224	2018-04-27	\N	\N	A
Bad Boys	R	bad-boys	119	movie	225	1995-04-07	\N	\N	C
Batman Forever	PG-13	batman-forever	121	movie	226	1995-06-16	\N	\N	C
Batman Returns	PG-13	batman-returns	126	movie	227	1992-06-19	\N	\N	B+
Batman: Mask of the Phantasm	PG	batman-mask-of-the-phantasm	76	movie	228	1993-12-25	\N	\N	A-
Beauty and the Beast	G	beauty-and-the-beast-(1991)	84	movie	229	1991-11-22	\N	\N	A
Beowulf	PG-13	beowulf	115	movie	230	2007-11-16	\N	\N	B-
Big Hero 6	PG	big-hero-6	102	movie	231	2014-11-07	\N	\N	A
Bill & Ted's Excellent Adventure	PG	bill-and-teds-excellent-adventure	90	movie	232	1989-02-17	\N	\N	B+
Bird Box	R	bird-box	124	movie	233	2018-12-14	\N	\N	B-
Labyrinth	PG	labyrinth	101	movie	314	1986-06-27	\N	\N	B+
Alien: Covenant	R	alien-covenant	122	movie	193	2017-05-19	\N	\N	C+
Birds of Prey (And the Fantabulous Emancipation of One Harley Quinn)	R	birds-of-prey	109	movie	234	2020-02-07	\N	\N	B+
Black Christmas	R	black-christmas-(1974)	98	movie	235	1974-10-11	\N	\N	B
Black Panther	PG-13	black-panther	134	movie	236	2018-02-16	\N	\N	A-
Blade Runner	R	blade-runner	117	movie	237	1982-06-25	\N	\N	B+
Bram Stoker's Dracula	R	bram-stokers-dracula	128	movie	238	1992-11-13	\N	\N	B-
Brokeback Mountain	R	brokeback-mountain	134	movie	239	2005-12-09	\N	\N	B
Bumblebee	PG-13	bumblebee	114	movie	240	2018-12-21	\N	\N	A-
Captain America: Civil War	PG-13	captain-america-civil-war	147	movie	241	2016-05-06	\N	\N	A
Captain America: The First Avenger	PG-13	captain-america-the-first-avenger	124	movie	242	2011-07-22	\N	\N	A-
Captain America: The Winter Soldier	PG-13	captain-america-the-winter-soldier	136	movie	243	2014-04-04	\N	\N	A
Cars 2	G	cars-2	106	movie	244	2011-06-24	\N	\N	C
Children of the Corn	R	children-of-the-corn	92	movie	246	1984-03-09	\N	\N	C-
Chip 'n Dale: Rescue Rangers	PG	chip-n-dale	97	movie	247	2022-05-20	\N	\N	B+
Con Air	R	con-air	115	movie	249	1997-06-06	\N	\N	B+
Corpse Bride	PG	corpse-bride	77	movie	250	2005-09-23	\N	\N	A-
Crimson Peak	R	crimson-peak	119	movie	251	2015-10-16	\N	\N	A-
Deadpool	R	deadpool	108	movie	252	2016-02-12	\N	\N	A
Deadpool 2	R	deadpool-2	119	movie	253	2018-05-18	\N	\N	A-
Deck the Halls	PG	deck-the-halls	93	movie	254	2006-11-22	\N	\N	D+
Descendants 3	TV-G	descendants-3	106	movie	255	2019-08-02	\N	\N	C-
North by Northwest	Not Rated	north-by-northwest	136	movie	256	1959-07-01	\N	\N	A-
Dune: Part Two	PG-13	dune-part-2	166	movie	257	2024-03-01	\N	\N	A-
Split	PG-13	split	117	movie	258	2017-01-20	\N	\N	A-
Godzilla Minus One	PG-13	godzilla-minus-one	124	movie	259	2023-11-03	\N	\N	A
Hellboy II: The Golden Army	PG-13	hellboy-2	120	movie	260	2008-07-11	\N	\N	A-
South Park: Bigger, Longer & Uncut	R	south-park	81	movie	261	1999-06-30	\N	\N	A
Pearl	R	pearl	103	movie	262	2022-09-16	\N	\N	A-
Deadpool & Wolverine	R	deadpool-and-wolverine	128	movie	263	2024-07-26	\N	\N	A-
Anchorman: The Legend of Ron Burgundy	PG-13	anchorman	94	movie	264	2004-07-09	\N	\N	A-
Lilo & Stitch	PG	lilo-and-stitch-(2002)	85	movie	265	2002-06-21	\N	\N	A-
Don't Breathe	R	dont-breathe	88	movie	266	2016-08-26	\N	\N	A-
Upgrade	R	upgrade	100	movie	267	2018-06-01	\N	\N	A
Ben-Hur	G	ben-hur	212	movie	268	1959-11-18	\N	\N	A-
Smile 2	R	smile-2	127	movie	269	2024-10-18	\N	\N	A-
Speed	R	speed	116	movie	270	1994-06-10	\N	\N	A-
The Witch	R	the-witch	92	movie	271	2016-02-19	\N	\N	A-
The Northman	R	the-northman	136	movie	272	2022-04-22	\N	\N	A-
G.I. Joe: The Rise of Cobra	PG-13	gi-joe-the-rise-of-cobra	118	movie	273	2009-08-07	\N	\N	D+
Ouija	PG-13	ouija	89	movie	274	2014-10-24	\N	\N	C
Pet Sematary	R	pet-sematary-(2019)	100	movie	275	2019-04-05	\N	\N	C
The Mummy	PG-13	the-mummy-(2017)	110	movie	276	2017-06-09	\N	\N	D+
Valentine's Day	PG-13	valentines-day	125	movie	277	2010-02-12	\N	\N	C
Battle for the Planet of the Apes	G	battle-for-the-planet-of-the-apes	93	movie	278	1973-06-13	\N	\N	C
Bad Moms	R	bad-moms	100	movie	279	2016-07-29	\N	\N	C
The School for Good and Evil	PG-13	the-school-for-good-and-evil	147	movie	280	2022-10-19	\N	\N	C
Hellraiser III: Hell on Earth	R	hellraiser-3	93	movie	281	1992-09-11	\N	\N	C+
Escape Room: Tournament of Champions	PG-13	escape-room-tournament-of-champions	88	movie	282	2021-07-16	\N	\N	C
The Phantom of the Opera	PG-13	the-phantom-of-the-opera	143	movie	283	2004-12-22	\N	\N	B-
The Lord of the Rings	PG	the-lord-of-the-rings	133	movie	284	1978-11-15	\N	\N	C
Battle Royale	Not Rated	battle-royale	114	movie	285	2000-12-16	\N	\N	B
Chicken Little	G	chicken-little	81	movie	286	2005-11-04	\N	\N	C
I Now Pronounce You Chuck & Larry	PG-13	i-now-pronounce-you-chuck-and-larry	115	movie	287	2007-07-20	\N	\N	C-
Beverly Hills Cop III	R	beverly-hills-cop-3	104	movie	288	1994-05-25	\N	\N	C
Terrifier	Not Rated	terrifier	85	movie	289	2018-03-15	\N	\N	C
Terrifier 2	Not Rated	terrifier-2	138	movie	290	2022-10-06	\N	\N	B
Don't Breathe 2	R	dont-breathe-2	98	movie	291	2021-08-13	\N	\N	B-
Spawn	PG-13	spawn	96	movie	292	1997-08-01	\N	\N	D
Escape Room	PG-13	escape-room	100	movie	293	2019-01-04	\N	\N	C+
Tooth Fairy	PG	tooth-fairy	101	movie	294	2010-01-22	\N	\N	D
Red One	PG-13	red-one	123	movie	295	2024-11-15	\N	\N	C
The Last Airbender	PG	the-last-airbender	103	movie	296	2010-07-01	\N	\N	D+
The Mortal Instruments: City of Bones	PG-13	the-mortal-instruments	130	movie	297	2013-08-21	\N	\N	C-
Aliens vs. Predator: Requiem	R	aliens-vs-predator-requiem	94	movie	298	2007-12-25	\N	\N	D
Middle School: The Worst Years of My Life	PG	middle-school	92	movie	299	2016-10-07	\N	\N	C
A Christmas Story Christmas	PG	a-christmas-story-christmas	98	movie	300	2022-11-17	\N	\N	B-
Les Misérables	PG-13	les-miserables	158	movie	301	2012-12-25	\N	\N	B-
Scary Movie 3	PG-13	scary-movie-3	84	movie	302	2003-10-24	\N	\N	D
Us	R	us	116	movie	303	2019-03-22	\N	\N	A-
After Earth	PG-13	after-earth	100	movie	304	2013-05-31	\N	\N	D
The Mummy: Tomb of the Dragon Emperor	PG-13	the-mummy-tomb-of-the-dragon-emperor	112	movie	305	2008-08-01	\N	\N	D
How to Train Your Dragon: The Hidden World	PG	how-to-train-your-dragon-the-hidden-world	104	movie	307	2019-02-22	\N	\N	A-
Magic Mike's Last Dance	R	magic-mikes-last-dance	112	movie	308	2023-02-10	\N	\N	C
Catwoman	PG-13	catwoman	104	movie	310	2004-07-23	\N	\N	D
Elektra	PG-13	elektra	97	movie	311	2005-01-14	\N	\N	D+
Mission: Impossible - Dead Reckoning Part One	PG-13	mission-impossible-dead-reckoning-part-1	163	movie	312	2023-07-12	\N	\N	A-
Godzilla x Kong: The New Empire	PG-13	godzilla-x-kong-the-new-empire	115	movie	313	2024-03-29	\N	\N	C+
Unbreakable	PG-13	unbreakable	106	movie	315	2000-11-22	\N	\N	B+
Bad Boys for Life	R	bad-boys-for-life	124	movie	316	2020-01-17	\N	\N	C+
Team America: World Police	R	team-america	98	movie	317	2004-10-15	\N	\N	A-
Twisters	PG-13	twisters	122	movie	318	2024-07-19	\N	\N	B+
Warcraft	PG-13	warcraft	123	movie	319	2016-06-10	\N	\N	D+
Final Destination 5	R	final-destination-5	92	movie	320	2011-08-12	\N	\N	B-
Firestarter	R	firestarter-(2022)	94	movie	321	2022-05-13	\N	\N	C
Transformers One	PG	transformers-one	104	movie	322	2024-09-20	\N	\N	B+
Brother Bear	G	brother-bear	85	movie	323	2003-11-01	\N	\N	B-
Oz the Great and Powerful	PG	oz-the-great-and-powerful	130	movie	324	2013-03-08	\N	\N	C+
Kick-Ass	R	kick-ass	118	movie	325	2010-04-16	\N	\N	A-
Die Hard	R	die-hard	132	movie	326	1988-07-15	\N	\N	A
District 9	R	district-9	112	movie	327	2009-08-14	\N	\N	B+
Django Unchained	R	django-unchained	165	movie	328	2012-12-25	\N	\N	A-
Doctor Strange in the Multiverse of Madness	PG-13	doctor-strange-in-the-multiverse-of-madness	126	movie	329	2022-05-06	\N	\N	B+
Halloween: The Curse of Michael Myers	R	halloween-the-curse-of-michael-myers	87	movie	330	1995-09-29	\N	\N	D
Jason Goes to Hell: The Final Friday	R	jason-goes-to-hell	87	movie	331	1993-08-13	\N	\N	D-
Scooby-Doo	PG	scooby-doo	89	movie	332	2002-06-14	\N	\N	D-
Dragonball Evolution	PG	dragonball-evolution	85	movie	333	2009-04-10	\N	\N	F
Alone in the Dark	R	alone-in-the-dark	99	movie	334	2005-01-28	\N	\N	F
Mortal Kombat: Annihilation	PG-13	mortal-kombat-annihilation	95	movie	335	1997-11-21	\N	\N	F
Star Wars Holiday Special	TV-PG	the-star-wars-holiday-special	97	movie	336	1978-11-17	\N	\N	F
Billy Madison	PG-13	billy-madison	89	movie	337	1995-02-10	\N	\N	D+
Halloween 5: The Revenge of Michael Myers	R	halloween-5	96	movie	338	1989-10-13	\N	\N	D+
The Room	R	the-room	99	movie	339	2003-06-27	\N	\N	F
Hellbound: Hellraiser II	R	hellbound	97	movie	340	1988-12-23	\N	\N	C
Friday the 13th Part VII: The New Blood	R	friday-the-13th-part-7	88	movie	341	1988-05-13	\N	\N	D+
Leprechaun	R	leprechaun	92	movie	342	1993-01-08	\N	\N	D+
Super Mario Bros.	PG	super-mario-bros	104	movie	343	1993-05-28	\N	\N	D
Dungeons & Dragons	PG-13	dungeons-and-dragons	107	movie	344	2000-12-08	\N	\N	D-
Halloween 4: The Return of Michael Myers	R	halloween-4	88	movie	345	1988-10-21	\N	\N	C-
Hancock	PG-13	hancock	92	movie	346	2008-07-02	\N	\N	C
Music	PG-13	music	107	movie	347	2021-02-12	\N	\N	F
Signs	PG-13	signs	106	movie	348	2002-08-02	\N	\N	C-
Dracula	Not Rated	dracula	75	movie	349	1931-02-14	\N	\N	B
Dune	PG-13	dune-(2021)	155	movie	350	2021-10-22	\N	\N	A-
Encanto	PG	encanto	102	movie	351	2021-11-24	\N	\N	A
Evil Dead II	R	evil-dead-2	84	movie	352	1987-03-13	\N	\N	A
Ewoks: The Battle for Endor	TV-PG	ewoks-the-battle-for-endor	94	movie	353	1985-11-24	\N	\N	D
Face/Off	R	face-off	138	movie	354	1997-06-27	\N	\N	A-
Fargo	R	fargo	98	movie	355	1996-03-08	\N	\N	C+
Fear Street Part One: 1994	R	fear-street-part-1	107	movie	356	2021-07-02	\N	\N	B+
Fear Street Part Two: 1978	R	fear-street-part-2	109	movie	357	2021-07-09	\N	\N	B+
Finding Dory	PG	finding-dory	97	movie	358	2016-06-17	\N	\N	B+
First Blood	R	first-blood	93	movie	359	1982-10-22	\N	\N	A-
Friday the 13th: A New Beginning	R	friday-the-13th-a-new-beginning	92	movie	361	1985-03-22	\N	\N	D
Frozen	PG	frozen	102	movie	362	2013-11-27	\N	\N	A
Galaxy Quest	PG	galaxy-quest	102	movie	363	1999-12-25	\N	\N	A-
Get Out	R	get-out	104	movie	365	2017-02-24	\N	\N	A
Ghost Rider	PG-13	ghost-rider	110	movie	366	2007-02-16	\N	\N	D+
Ghostbusters	PG	ghostbusters-(1984)	105	movie	367	1984-06-08	\N	\N	A-
Glory	R	glory	122	movie	368	1989-12-15	\N	\N	B+
Godzilla	PG-13	godzilla-(1998)	139	movie	369	1998-05-20	\N	\N	D+
Gremlins	PG	gremlins	106	movie	370	1984-06-08	\N	\N	A-
Guardians of the Galaxy	PG-13	guardians-of-the-galaxy	121	movie	371	2014-08-01	\N	\N	A
Halloween	R	halloween-(1978)	91	movie	372	1978-10-24	\N	\N	A
Halloween H20: 20 Years Later	R	halloween-h20	86	movie	373	1998-08-05	\N	\N	C+
Halloween II	R	halloween-2-(2009)	105	movie	374	2009-08-28	\N	\N	D
Halloween III: Season of the Witch	R	halloween-3	98	movie	375	1982-10-22	\N	\N	C
Halloweentown High	TV-G	halloweentown-high	82	movie	376	2004-10-08	\N	\N	D
Harry Potter and the Deathly Hallows - Part 2	PG-13	harry-potter-and-the-deathly-hallows-part-2	130	movie	377	2011-07-15	\N	\N	A
Harry Potter and the Goblet of Fire	PG-13	harry-potter-and-the-goblet-of-fire	157	movie	378	2005-11-18	\N	\N	A
Harry Potter and the Half-Blood Prince	PG	harry-potter-and-the-half-blood-prince	153	movie	379	2009-07-15	\N	\N	A-
Harry Potter and the Order of the Phoenix	PG-13	harry-potter-and-the-order-of-the-phoenix	138	movie	380	2007-07-11	\N	\N	A-
The Notebook	PG-13	the-notebook	123	movie	892	2004-06-25	\N	\N	B-
Harry Potter and the Prisoner of Azkaban	PG	harry-potter-and-the-prisoner-of-azkaban	142	movie	381	2004-06-04	\N	\N	A
Harry Potter and the Sorcerer's Stone	PG	harry-potter-and-the-sorcerers-stone	152	movie	382	2001-11-16	\N	\N	A-
Home Alone	PG	home-alone	103	movie	383	1990-11-16	\N	\N	A-
Hotel Transylvania: Transformania	PG	hotel-transylvania-transformania	87	movie	384	2022-01-14	\N	\N	C-
How to Train Your Dragon	PG	how-to-train-your-dragon-(2010)	98	movie	385	2010-03-26	\N	\N	A
How to Train Your Dragon 2	PG	how-to-train-your-dragon-2	102	movie	386	2014-06-13	\N	\N	A
Hugo	PG	hugo	126	movie	387	2011-11-23	\N	\N	A-
Ice Age: Continental Drift	PG	ice-age-continental-drift	88	movie	388	2012-07-13	\N	\N	C
In the Heights	PG-13	in-the-heights	143	movie	389	2021-06-10	\N	\N	A-
Inception	PG-13	inception	148	movie	390	2010-07-16	\N	\N	A-
Indiana Jones and the Last Crusade	PG-13	indiana-jones-and-the-last-crusade	127	movie	391	1989-05-24	\N	\N	A
Indiana Jones and the Temple of Doom	PG	indiana-jones-and-the-temple-of-doom	118	movie	392	1984-05-23	\N	\N	A-
Inglourious Basterds	R	inglourious-basterds	153	movie	393	2009-08-21	\N	\N	A-
Caravan of Courage: An Ewok Adventure	TV-PG	caravan-of-courage	96	movie	394	1984-11-25	\N	\N	D
Jaws 3-D	PG	jaws-3	99	movie	395	1983-07-22	\N	\N	D+
Superman III	PG	superman-3	125	movie	396	1983-06-17	\N	\N	D
History of the World, Part I	R	history-of-the-world	92	movie	397	1981-06-12	\N	\N	C
Silent Night, Deadly Night Part 2	R	silent-night-deadly-night-part-2	88	movie	398	1987-04-10	\N	\N	F
Iron Man	PG-13	iron-man	126	movie	399	2008-05-02	\N	\N	A
It	R	it	135	movie	400	2017-09-08	\N	\N	A-
It Follows	R	it-follows	100	movie	401	2015-03-13	\N	\N	A-
Jaws	PG	jaws	124	movie	402	1975-06-20	\N	\N	A-
John Wick: Chapter 2	R	john-wick-chapter-2	122	movie	403	2017-02-10	\N	\N	A-
John Wick: Chapter 3 - Parabellum	R	john-wick-chapter-3	130	movie	404	2019-05-17	\N	\N	A-
Jojo Rabbit	PG-13	jojo-rabbit	108	movie	405	2019-10-18	\N	\N	B
Joker	R	joker	122	movie	406	2019-10-04	\N	\N	A-
Jumanji: Welcome to the Jungle	PG-13	jumanji-welcome-to-the-jungle	119	movie	407	2017-12-20	\N	\N	B+
Jupiter Ascending	PG-13	jupiter-ascending	127	movie	408	2015-02-06	\N	\N	D
Jurassic Park	PG-13	jurassic-park	127	movie	409	1993-06-11	\N	\N	A
A Clockwork Orange	R	a-clockwork-orange	136	movie	410	1972-02-02	\N	\N	A-
A Beautiful Day in the Neighborhood	PG	a-beautiful-day-in-the-neighborhood	109	movie	411	2019-11-22	\N	\N	A-
A Bug's Life	G	a-bugs-life	95	movie	412	1998-11-20	\N	\N	B+
A Christmas Story	PG	a-christmas-story	93	movie	413	1983-11-18	\N	\N	B+
Kill Bill: Vol. 1	R	kill-bill-vol-1	111	movie	414	2003-10-17	\N	\N	A
Killer Klowns from Outer Space	PG-13	killer-klowns-from-outer-space	88	movie	415	1988-05-27	\N	\N	C
Knives Out	PG-13	knives-out	130	movie	416	2019-11-27	\N	\N	A-
Lady Bird	R	lady-bird	94	movie	417	2017-11-03	\N	\N	B+
Lady and the Tramp	G	lady-and-the-tramp-(1955)	76	movie	418	1955-06-22	\N	\N	B+
Lara Croft: Tomb Raider - The Cradle of Life	PG-13	lara-croft-tomb-raider-the-cradle-of-life	117	movie	419	2003-07-25	\N	\N	C
Lara Croft: Tomb Raider	PG-13	lara-croft-tomb-raider	100	movie	420	2001-06-15	\N	\N	C
Lethal Weapon	R	lethal-weapon	109	movie	421	1987-03-06	\N	\N	A
Lethal Weapon 4	R	lethal-weapon-4	127	movie	422	1998-07-10	\N	\N	C
Love, Simon	PG-13	love-simon	110	movie	424	2018-03-16	\N	\N	B+
Luca	PG	luca	95	movie	425	2021-06-18	\N	\N	A
Mad Max	R	mad-max	91	movie	426	1979-04-12	\N	\N	A-
Mad Max: Fury Road	R	mad-max-fury-road	120	movie	427	2015-05-15	\N	\N	A-
Mary Poppins	G	mary-poppins	139	movie	428	1964-08-27	\N	\N	A
Men in Black	PG-13	men-in-black	98	movie	429	1997-07-02	\N	\N	A-
Sky High	PG	sky-high	100	movie	430	2005-07-29	\N	\N	B+
A Nightmare on Elm Street 4: The Dream Master	R	a-nightmare-on-elm-street-4	93	movie	431	1988-08-19	\N	\N	C
A Nightmare on Elm Street 5: The Dream Child	R	a-nightmare-on-elm-street-5	89	movie	432	1989-08-11	\N	\N	C
Army of the Dead	R	army-of-the-dead	148	movie	433	2021-05-14	\N	\N	C+
Avengers: Age of Ultron	PG-13	avengers-age-of-ultron	141	movie	434	2015-05-01	\N	\N	A-
Back to the Future Part II	PG	back-to-the-future-part-2	108	movie	435	1989-11-22	\N	\N	A-
Back to the Future Part III	PG	back-to-the-future-part-3	118	movie	436	1990-05-25	\N	\N	A-
Batman	PG-13	batman	126	movie	437	1989-06-23	\N	\N	A-
Batman Begins	PG-13	batman-begins	140	movie	438	2005-06-15	\N	\N	A-
Bedtime Stories	PG	bedtime-stories	99	movie	439	2008-12-25	\N	\N	C-
Clash of the Titans	PG-13	clash-of-the-titans-(2010)	106	movie	440	2010-04-02	\N	\N	C
Diary of a Wimpy Kid: The Long Haul	PG	diary-of-a-wimpy-kid-the-long-haul	91	movie	441	2017-05-19	\N	\N	D-
Event Horizon	R	event-horizon	96	movie	442	1997-08-15	\N	\N	C
Ghost Rider: Spirit of Vengeance	PG-13	ghost-rider-spirit-of-vengeance	96	movie	443	2012-02-17	\N	\N	D
How the Grinch Stole Christmas	PG	how-the-grinch-stole-christmas	104	movie	444	2000-11-17	\N	\N	C-
It's a Wonderful Life	PG	its-a-wonderful-life	130	movie	445	1946-12-20	\N	\N	A
Jaws 2	PG	jaws-2	116	movie	446	1978-06-16	\N	\N	C
Jem and the Holograms	PG	jem-and-the-holograms	118	movie	447	2015-10-23	\N	\N	C-
Jigsaw	R	jigsaw	92	movie	448	2017-10-27	\N	\N	C-
Jingle All the Way	PG	jingle-all-the-way	89	movie	449	1996-11-22	\N	\N	D+
John Wick	R	john-wick	101	movie	450	2014-10-24	\N	\N	A-
Miracle on 34th Street	Not Rated	miracle-on-34th-street-(1947)	96	movie	451	1947-06-11	\N	\N	A-
Moana	PG	moana	107	movie	452	2016-11-23	\N	\N	A
Mulan	G	mulan-(1998)	87	movie	454	1998-06-19	\N	\N	A-
National Lampoon's Christmas Vacation	PG-13	christmas-vacation	97	movie	455	1989-12-01	\N	\N	A-
National Treasure: Book of Secrets	PG	national-treasure-book-of-secrets	124	movie	456	2007-12-21	\N	\N	C
Night of the Living Dead	Not Rated	night-of-the-living-dead	96	movie	457	1968-10-04	\N	\N	B+
Nosferatu	Not Rated	nosferatu-(1922)	94	movie	459	1922-03-04	\N	\N	B
Ocean's Thirteen	PG-13	oceans-thirteen	122	movie	460	2007-06-08	\N	\N	C
Ocean's Twelve	PG-13	oceans-twelve	125	movie	461	2004-12-10	\N	\N	C
One Hundred and One Dalmatians	G	one-hundred-and-one-dalmatians	79	movie	462	1961-01-25	\N	\N	B+
Onward	PG	onward	102	movie	463	2020-03-06	\N	\N	B+
ParaNorman	PG	paranorman	92	movie	464	2012-08-17	\N	\N	A-
Paranormal Activity	R	paranormal-activity	86	movie	465	2009-09-25	\N	\N	C-
Pearl Harbor	PG-13	pearl-harbor	183	movie	467	2001-05-25	\N	\N	C
Percy Jackson: Sea of Monsters	PG	percy-jackson-sea-of-monsters	106	movie	468	2013-08-07	\N	\N	C
WarGames	PG	wargames	114	movie	469	1983-06-03	\N	\N	B-
Peter Pan	G	peter-pan-(1953)	77	movie	470	1953-02-05	\N	\N	A-
Phineas and Ferb the Movie: Across the 2nd Dimension	TV-G	phineas-and-ferb-the-movie-across-the-2nd-dimension	78	movie	471	2011-08-05	\N	\N	A-
Planes	PG	planes	91	movie	472	2013-08-09	\N	\N	C-
Platoon	R	platoon	120	movie	473	1986-12-19	\N	\N	A-
Poltergeist	PG	poltergeist	114	movie	474	1982-06-04	\N	\N	A-
Psycho	R	psycho	109	movie	475	1960-09-08	\N	\N	A-
Pulp Fiction	PG-13	pulp-fiction	154	movie	476	1994-10-14	\N	\N	A
Rain Man	R	rain-man	133	movie	477	1988-12-16	\N	\N	B+
Ratatouille	G	ratatouille	111	movie	478	2007-06-29	\N	\N	A
Raya and the Last Dragon	PG	raya-and-the-last-dragon	107	movie	479	2021-03-05	\N	\N	B+
Return to Oz	PG	return-to-oz	113	movie	480	1985-06-21	\N	\N	B-
RoboCop 3	PG-13	robocop-3	104	movie	481	1993-11-05	\N	\N	C
Rocketman	R	rocketman	121	movie	482	2019-05-31	\N	\N	A-
Rocky	PG	rocky	120	movie	483	1976-12-03	\N	\N	A
Rogue One: A Star Wars Story	PG-13	rogue-one	133	movie	484	2016-12-16	\N	\N	A-
Saving Mr. Banks	PG-13	saving-mr-banks	125	movie	485	2013-12-13	\N	\N	A-
Saw	R	saw	103	movie	486	2004-10-29	\N	\N	B-
Saw II	R	saw-2	93	movie	487	2005-10-28	\N	\N	C+
Schindler's List	R	schindlers-list	195	movie	489	1993-12-15	\N	\N	A-
Scooby-Doo 2: Monsters Unleashed	PG	scooby-doo-2	93	movie	490	2004-03-26	\N	\N	D
Home Alone 3	PG	home-alone-3	102	movie	491	1997-12-12	\N	\N	D
Scott Pilgrim vs. the World	PG-13	scott-pilgrim-vs-the-world	112	movie	492	2010-08-13	\N	\N	A
Scream	R	scream-(1996)	111	movie	493	1996-12-20	\N	\N	A
Scream	R	scream-(2022)	114	movie	494	2022-01-14	\N	\N	B+
Scream 2	R	scream-2	120	movie	495	1997-12-12	\N	\N	B
Shang-Chi and the Legend of the Ten Rings	PG-13	shang-chi-and-the-legend-of-the-ten-rings	132	movie	496	2021-09-03	\N	\N	A-
Sharknado	TV-14	sharknado	86	movie	497	2013-07-11	\N	\N	D
Sharknado 2: The Second One	TV-14	sharknado-2	95	movie	498	2014-07-30	\N	\N	D
Sharknado 3: Oh Hell No!	TV-14	sharknado-3	93	movie	499	2015-07-22	\N	\N	D
Sharknado: The 4th Awakens	TV-14	sharknado-the-4th-awakens	95	movie	500	2016-07-31	\N	\N	D
Sharknado 5: Global Swarming	TV-14	sharknado-5	93	movie	501	2017-08-06	\N	\N	D
Shazam!	PG-13	shazam	132	movie	502	2019-04-05	\N	\N	A
Shrek the Third	PG	shrek-the-third	93	movie	503	2007-05-18	\N	\N	C
Shutter Island	R	shutter-island	138	movie	504	2010-02-19	\N	\N	A-
Sin City	R	sin-city	124	movie	505	2005-04-01	\N	\N	B+
Sinister	R	sinister	110	movie	506	2012-10-12	\N	\N	B+
Sleeping Beauty	G	sleeping-beauty	75	movie	507	1959-01-29	\N	\N	B
Sleepy Hollow	R	sleepy-hollow	105	movie	508	1999-11-19	\N	\N	A-
Snowpiercer	R	snowpiercer	126	movie	509	2014-06-27	\N	\N	A
Spaceballs	PG	spaceballs	96	movie	510	1987-06-24	\N	\N	A-
Spider-Man 2	PG-13	spider-man-2	127	movie	511	2004-06-30	\N	\N	A-
Spider-Man: Far From Home	PG-13	spider-man-far-from-home	129	movie	512	2019-07-02	\N	\N	A-
Spider-Man: Homecoming	PG-13	spider-man-homecoming	133	movie	513	2017-07-07	\N	\N	A
Spider-Man: No Way Home	PG-13	spider-man-no-way-home	148	movie	514	2021-12-17	\N	\N	A
Spirited Away	PG	spirited-away	125	movie	515	2001-07-20	\N	\N	A-
Star Trek: First Contact	PG-13	star-trek-first-contact	111	movie	516	1996-11-22	\N	\N	A-
Sucker Punch	PG-13	sucker-punch	110	movie	518	2011-03-25	\N	\N	C-
Superman	PG	superman-(1978)	143	movie	519	1978-12-15	\N	\N	A-
Tangled	PG	tangled	100	movie	520	2010-11-24	\N	\N	A
Teen Beach 2	TV-G	teen-beach-2	104	movie	521	2015-06-26	\N	\N	C
Terminator 2: Judgment Day	R	terminator-2	137	movie	522	1991-07-03	\N	\N	A
Terminator 3: Rise of the Machines	R	terminator-3	109	movie	523	2003-07-02	\N	\N	C-
The Addams Family	PG-13	the-addams-family-(1991)	99	movie	524	1991-11-22	\N	\N	A-
The Adventures of Sharkboy and Lavagirl	PG	the-adventures-of-sharkboy-and-lavagirl	93	movie	525	2005-06-10	\N	\N	D
The Avengers	PG-13	the-avengers	143	movie	526	2012-05-04	\N	\N	A
The Batman	PG-13	the-batman	176	movie	527	2022-03-04	\N	\N	A-
The Boy	PG-13	the-boy	97	movie	528	2016-01-22	\N	\N	C-
The Cabin in the Woods	R	the-cabin-in-the-woods	95	movie	530	2012-04-13	\N	\N	B+
The Conjuring	R	the-conjuring	112	movie	531	2013-07-19	\N	\N	A-
The Croods	PG	the-croods	98	movie	532	2013-03-22	\N	\N	B+
The Dark Knight Rises	PG-13	the-dark-knight-rises	164	movie	533	2012-07-20	\N	\N	B+
The Disaster Artist	R	the-disaster-artist	104	movie	534	2017-12-01	\N	\N	A
The Evil Dead	NC-17	the-evil-dead	85	movie	535	1983-04-15	\N	\N	A
The Fault in Our Stars	PG-13	the-fault-in-our-stars	126	movie	537	2014-06-06	\N	\N	A-
The Fifth Element	PG-13	the-fifth-element	126	movie	538	1997-05-07	\N	\N	B+
The Godfather	R	the-godfather	175	movie	539	1972-03-24	\N	\N	A-
The Green Mile	R	the-green-mile	189	movie	540	1999-12-10	\N	\N	A-
Trick 'r Treat	R	trick-r-treat	82	movie	541	2009-10-06	\N	\N	A-
Arrival	PG-13	arrival	116	movie	542	2016-11-11	\N	\N	A
The Happening	R	the-happening	91	movie	543	2008-06-13	\N	\N	D
The Haunted Mansion	PG	the-haunted-mansion	99	movie	544	2003-11-26	\N	\N	C
The Iron Giant	PG	the-iron-giant	86	movie	545	1999-08-06	\N	\N	A
Napoleon Dynamite	PG	napoleon-dynamite	96	movie	1181	2004-06-11	\N	\N	C+
The Jungle Book	G	the-jungle-book-(1967)	78	movie	546	1967-10-18	\N	\N	B+
The Karate Kid	PG	the-karate-kid-(1984)	126	movie	547	1984-06-22	\N	\N	A-
BlacKkKlansman	R	blackkklansman	135	movie	895	2018-08-10	\N	\N	A
Green Book	PG-13	green-book	130	movie	896	2018-11-16	\N	\N	A-
Creed	PG-13	creed	133	movie	897	2015-11-25	\N	\N	A-
The Last Sharknado: It's About Time	TV-14	the-last-sharknado	86	movie	548	2018-08-19	\N	\N	D
The Lion King	G	the-lion-king-(1994)	88	movie	549	1994-06-24	\N	\N	A
The Matrix	R	the-matrix	136	movie	551	1999-03-31	\N	\N	A-
The Muppet Christmas Carol	G	the-muppet-christmas-carol	85	movie	552	1992-12-11	\N	\N	A-
The Nightmare Before Christmas	PG	the-nightmare-before-christmas	76	movie	553	1993-10-29	\N	\N	A-
The Nun	R	the-nun	96	movie	554	2018-09-07	\N	\N	C-
The Polar Express	G	the-polar-express	100	movie	555	2004-11-10	\N	\N	B
The Princess Bride	PG	the-princess-bride	98	movie	556	1987-09-25	\N	\N	A
The Ring	PG-13	the-ring	115	movie	557	2002-10-18	\N	\N	A-
The Secret Life of Pets	PG	the-secret-life-of-pets	87	movie	558	2016-07-08	\N	\N	C
2012	PG-13	2012	158	movie	820	2009-11-13	\N	\N	C
The Shawshank Redemption	R	the-shawshank-redemption	142	movie	559	1994-09-23	\N	\N	A
The Silence of the Lambs	R	the-silence-of-the-lambs	118	movie	560	1991-02-14	\N	\N	A-
The Sixth Sense	PG-13	the-sixth-sense	107	movie	561	1999-08-06	\N	\N	A-
The Social Network	PG-13	the-social-network	120	movie	562	2010-10-01	\N	\N	A-
The Suicide Squad	R	the-suicide-squad	132	movie	563	2021-08-06	\N	\N	A
The Terminator	R	the-terminator	107	movie	564	1984-10-26	\N	\N	A
The Wizard of Oz	G	the-wizard-of-oz	102	movie	566	1939-08-25	\N	\N	A
Thor: Ragnarok	PG-13	thor-ragnarok	130	movie	567	2017-11-03	\N	\N	A
Titanic	PG-13	titanic	194	movie	568	1997-12-19	\N	\N	A-
Top Gun: Maverick	PG-13	top-gun-maverick	130	movie	569	2022-05-27	\N	\N	A-
Total Recall	R	total-recall	113	movie	570	1990-06-01	\N	\N	A-
Starship Troopers	R	starship-troopers	129	movie	571	1997-11-07	\N	\N	B
Toy Story	G	toy-story	81	movie	572	1995-11-22	\N	\N	A
Toy Story 2	G	toy-story-2	92	movie	573	1999-11-24	\N	\N	A
Toy Story 3	G	toy-story-3	103	movie	574	2010-06-18	\N	\N	A
Toy Story 4	G	toy-story-4	100	movie	575	2019-06-21	\N	\N	A-
Transformers: The Last Knight	PG-13	transformers-the-last-knight	154	movie	576	2017-06-21	\N	\N	D
Transformers: Revenge of the Fallen	PG-13	transformers-revenge-of-the-fallen	149	movie	577	2009-06-24	\N	\N	D+
Transformers: Dark of the Moon	PG-13	transformers-dark-of-the-moon	154	movie	578	2011-06-29	\N	\N	C
Turning Red	PG	turning-red	100	movie	579	2022-03-11	\N	\N	A-
Uncut Gems	R	uncut-gems	135	movie	580	2019-12-13	\N	\N	A-
V for Vendetta	R	v-for-vendetta	132	movie	581	2006-03-17	\N	\N	A
WALL-E	G	wall-e	98	movie	582	2008-06-27	\N	\N	A
West Side Story	Not Rated	west-side-story-(1961)	153	movie	584	1961-10-18	\N	\N	A
West Side Story	PG-13	west-side-story-(2021)	156	movie	585	2021-12-10	\N	\N	A-
Who Framed Roger Rabbit	PG	who-framed-roger-rabbit	104	movie	586	1988-06-24	\N	\N	A
Willy Wonka & the Chocolate Factory	G	willy-wonka-and-the-chocolate-factory	100	movie	587	1971-06-30	\N	\N	A
Wonder Woman	PG-13	wonder-woman	141	movie	588	2017-06-02	\N	\N	A
Wreck-It Ralph	PG	wreck-it-ralph	101	movie	589	2012-11-02	\N	\N	B+
X-Men	PG-13	x-men	104	movie	590	2000-07-14	\N	\N	B+
X-Men: Days of Future Past	PG-13	x-men-days-of-future-past	132	movie	591	2014-05-23	\N	\N	A-
X-Men: First Class	PG-13	x-men-first-class	131	movie	592	2011-06-03	\N	\N	A
Zombies 2	TV-G	zombies-2	84	movie	593	2020-02-14	\N	\N	C
Zootopia	PG	zootopia	108	movie	594	2016-03-04	\N	\N	A
Cats	PG	cats	110	movie	595	2019-12-20	\N	\N	D-
Alien 3	R	alien-3	114	movie	596	1992-05-22	\N	\N	C
The Conjuring 2	R	the-conjuring-2	134	movie	597	2016-06-10	\N	\N	B+
Zombieland: Double Tap	R	zombieland-double-tap	99	movie	598	2019-10-18	\N	\N	B
Kung Fu Panda	PG	kung-fu-panda	92	movie	599	2008-06-06	\N	\N	A
Kung Fu Panda 2	PG	kung-fu-panda-2	90	movie	600	2011-05-26	\N	\N	A
Kung Fu Panda 3	PG	kung-fu-panda-3	95	movie	602	2016-01-29	\N	\N	B+
Megamind	PG	megamind	95	movie	603	2010-11-05	\N	\N	B
Bee Movie	PG	bee-movie	91	movie	604	2007-11-02	\N	\N	C
Zombies 3	TV-G	zombies-3	88	movie	605	2022-07-15	\N	\N	C
The Giver	PG-13	the-giver	97	movie	606	2014-08-15	\N	\N	C+
Ghostbusters: Afterlife	PG-13	ghostbusters-afterlife	124	movie	607	2021-11-19	\N	\N	B
Maze Runner: The Scorch Trials	PG-13	the-scorch-trials	131	movie	608	2015-09-18	\N	\N	C+
Mrs. Doubtfire	PG-13	mrs-doubtfire	125	movie	610	1993-11-24	\N	\N	B
Maze Runner: The Death Cure	PG-13	the-death-cure	143	movie	611	2018-01-26	\N	\N	C+
The Darkest Minds	PG-13	the-darkest-minds	104	movie	612	2018-08-03	\N	\N	C-
RoboCop	R	robocop-(1987)	102	movie	619	1987-07-17	\N	\N	A-
Predator	R	predator	107	movie	620	1987-06-12	\N	\N	A-
Phineas and Ferb the Movie: Candace Against the Universe	TV-G	phineas-and-ferb-the-movie-candace-against-the-universe	86	movie	621	2020-08-28	\N	\N	B+
Scary Movie 2	R	scary-movie-2	83	movie	622	2001-07-04	\N	\N	F
Ice Age: Collision Course	PG	ice-age-collision-course	94	movie	623	2016-07-22	\N	\N	C
I Still Know What You Did Last Summer	R	i-still-know-what-you-did-last-summer	100	movie	624	1998-11-13	\N	\N	C-
Jaws: The Revenge	PG-13	jaws-the-revenge	89	movie	628	1987-07-17	\N	\N	D+
Green Lantern	PG-13	green-lantern	114	movie	629	2011-06-17	\N	\N	D+
Jason X	R	jason-x	92	movie	630	2002-04-26	\N	\N	D+
A Good Day to Die Hard	R	a-good-day-to-die-hard	98	movie	631	2013-02-14	\N	\N	D+
Supergirl	PG	supergirl	124	movie	632	1984-07-19	\N	\N	D
Justice League: The Flashpoint Paradox	PG-13	justice-league-the-flashpoint-paradox	75	movie	633	2013-07-30	\N	\N	B+
Justice League: War	PG-13	justice-league-war	79	movie	634	2014-02-04	\N	\N	B
Son of Batman	PG-13	son-of-batman	74	movie	635	2014-04-22	\N	\N	B
Thor: Love and Thunder	PG-13	thor-love-and-thunder	118	movie	636	2022-07-08	\N	\N	B
Casablanca	PG	casablanca	102	movie	245	1942-11-26	\N	\N	A
Justice League: Throne of Atlantis	PG-13	justice-league-throne-of-atlantis	72	movie	637	2015-01-13	\N	\N	B
Batman: Bad Blood	PG-13	batman-bad-blood	72	movie	638	2016-01-20	\N	\N	B-
Justice League vs. Teen Titans	PG-13	justice-league-vs-teen-titans	78	movie	639	2016-03-29	\N	\N	B
Batman vs. Robin	PG-13	batman-vs-robin	80	movie	640	2015-04-07	\N	\N	B+
Teen Titans: The Judas Contract	PG-13	teen-titans-the-judas-contract	84	movie	641	2017-04-04	\N	\N	B+
Suicide Squad: Hell to Pay	R	suicide-squad-hell-to-pay	86	movie	642	2018-03-27	\N	\N	B
Constantine: City of Demons	R	constantine-city-of-demons	90	movie	643	2018-10-09	\N	\N	B
Batman: Hush	PG-13	batman-hush	81	movie	644	2019-07-20	\N	\N	B
Wonder Woman: Bloodlines	PG-13	wonder-woman-bloodlines	83	movie	645	2019-10-05	\N	\N	C+
Lightyear	PG	lightyear	105	movie	646	2022-06-17	\N	\N	C+
Alien vs. Predator	PG-13	alien-vs-predator	101	movie	647	2004-08-13	\N	\N	C
Blade: Trinity	R	blade-trinity	113	movie	648	2004-12-08	\N	\N	C-
Christmas with the Kranks	PG	christmas-with-the-kranks	99	movie	649	2004-11-24	\N	\N	D+
Skyscraper	PG-13	skyscraper	102	movie	650	2018-07-13	\N	\N	C
Space Jam	PG	space-jam	88	movie	651	1996-11-15	\N	\N	D+
Star Wars: The Clone Wars	PG	star-wars-the-clone-wars	98	movie	652	2008-08-15	\N	\N	C
Surviving Christmas	PG-13	surviving-christmas	91	movie	653	2004-10-22	\N	\N	D+
The Fast and the Furious: Tokyo Drift	PG-13	the-fast-and-the-furious-tokyo-drift	104	movie	654	2006-06-16	\N	\N	C-
The Grudge	PG-13	the-grudge	91	movie	655	2004-10-22	\N	\N	C-
The NeverEnding Story II: The Next Chapter	PG	the-neverending-story-2	90	movie	656	1991-02-08	\N	\N	D+
The Next Karate Kid	PG	the-next-karate-kid	107	movie	657	1994-09-09	\N	\N	C
The Nutcracker and the Four Realms	PG	the-nutcracker-and-the-four-realms	99	movie	658	2018-11-02	\N	\N	C-
The Twilight Saga: Breaking Dawn - Part 1	PG-13	breaking-dawn-part-1	117	movie	659	2011-11-18	\N	\N	D+
The Twilight Saga: Eclipse	PG-13	eclipse	124	movie	660	2010-06-30	\N	\N	D+
The Twilight Saga: New Moon	PG-13	new-moon	130	movie	661	2009-11-20	\N	\N	D+
The Village	PG-13	the-village	108	movie	662	2004-07-30	\N	\N	C
Alice in Wonderland	PG	alice-in-wonderland-(2010)	108	movie	663	2010-03-05	\N	\N	C
The Divergent Series: Allegiant	PG-13	allegiant	120	movie	664	2016-03-18	\N	\N	C-
Beauty and the Beast	PG	beauty-and-the-beast-(2017)	129	movie	665	2017-03-17	\N	\N	C+
Clash of the Titans	PG	clash-of-the-titans-(1981)	118	movie	666	1981-06-12	\N	\N	C+
Cloud Atlas	R	cloud-atlas	172	movie	667	2012-10-26	\N	\N	B
Avatar: The Way of Water	PG-13	avatar-the-way-of-water	192	movie	669	2022-12-16	\N	\N	B+
Warm Bodies	PG-13	warm-bodies	98	movie	670	2013-02-01	\N	\N	B+
Little Shop of Horrors	PG-13	little-shop-of-horrors	94	movie	671	1986-12-19	\N	\N	A-
Dear Evan Hansen	PG-13	dear-evan-hansen	137	movie	672	2021-09-24	\N	\N	C+
Despicable Me 3	PG	despicable-me-3	89	movie	673	2017-06-30	\N	\N	C
Diary of a Wimpy Kid	PG	diary-of-a-wimpy-kid	94	movie	674	2010-03-19	\N	\N	D+
Dumbo	G	dumbo-(1941)	64	movie	675	1941-10-23	\N	\N	B-
Dumbo	PG	dumbo-(2019)	112	movie	676	2019-03-29	\N	\N	C+
Fantastic Beasts: The Secrets of Dumbledore	PG-13	fantastic-beasts-the-secrets-of-dumbledore	142	movie	677	2022-04-15	\N	\N	C+
Fast & Furious	PG-13	fast-and-furious	107	movie	678	2009-04-03	\N	\N	C+
Finding Nemo	PG	finding-nemo	100	movie	679	2003-05-30	\N	\N	A
Geostorm	PG-13	geostorm	109	movie	680	2017-10-20	\N	\N	C-
Halloween Kills	R	halloween-kills	105	movie	681	2021-10-15	\N	\N	C+
Halloween: Resurrection	R	halloween-resurrection	90	movie	682	2002-07-12	\N	\N	D+
Ice Age: Dawn of the Dinosaurs	PG	ice-age-dawn-of-the-dinosaurs	94	movie	683	2009-07-01	\N	\N	B-
Inside Out	PG	inside-out	95	movie	685	2015-06-19	\N	\N	A
Jurassic Park III	PG-13	jurassic-park-3	92	movie	686	2001-07-18	\N	\N	C
Justice League	PG-13	justice-league	120	movie	687	2017-11-17	\N	\N	C
Justice League Dark	R	justice-league-dark	75	movie	688	2017-01-24	\N	\N	B
Lady and the Tramp	PG	lady-and-the-tramp-(2019)	111	movie	689	2019-11-12	\N	\N	C+
Man of Steel	PG-13	man-of-steel	143	movie	690	2013-06-14	\N	\N	B-
Monsters, Inc.	G	monsters-inc	92	movie	691	2001-11-02	\N	\N	A
Mulan	PG-13	mulan-(2020)	115	movie	692	2020-09-04	\N	\N	C+
Percy Jackson & the Olympians: The Lightning Thief	PG	percy-jackson-and-the-olympians-the-lightning-thief	118	movie	693	2010-02-12	\N	\N	C+
Rambo	R	rambo	92	movie	694	2008-01-25	\N	\N	C-
Real Steel	PG-13	real-steel	127	movie	695	2011-10-07	\N	\N	B+
Reign of the Supermen	PG-13	reign-of-the-supermen	87	movie	696	2019-01-29	\N	\N	B
Rocky V	PG-13	rocky-5	104	movie	697	1990-11-16	\N	\N	C+
Shrek	PG	shrek	90	movie	698	2001-05-18	\N	\N	B+
Sing	PG	sing	108	movie	699	2016-12-21	\N	\N	C+
Star Trek: Nemesis	PG-13	star-trek-nemesis	116	movie	700	2002-12-13	\N	\N	B
Star Trek: Generations	PG	star-trek-generations	118	movie	701	1994-11-18	\N	\N	B
Star Trek: The Motion Picture	PG	star-trek-the-motion-picture	143	movie	702	1979-12-07	\N	\N	C+
Return of the Jedi	PG	return-of-the-jedi	131	movie	704	1983-05-25	\N	\N	A
Star Wars: The Force Awakens	PG-13	star-wars-the-force-awakens	138	movie	705	2015-12-18	\N	\N	A-
Star Wars: The Last Jedi	PG-13	star-wars-the-last-jedi	152	movie	706	2017-12-15	\N	\N	B+
Suicide Squad	PG-13	suicide-squad	123	movie	707	2016-08-05	\N	\N	C
Super 8	PG-13	super-8	112	movie	708	2011-06-10	\N	\N	B+
Superman II	PG	superman-2	127	movie	709	1981-06-19	\N	\N	B
Superman Returns	PG-13	superman-returns	154	movie	710	2006-06-28	\N	\N	C+
Terminator: Dark Fate	R	terminator-dark-fate	128	movie	711	2019-11-01	\N	\N	B-
The Adam Project	PG-13	the-adam-project	106	movie	712	2022-03-11	\N	\N	B+
The Bye Bye Man	PG-13	the-bye-bye-man	96	movie	713	2017-01-13	\N	\N	D+
The Christmas Chronicles	PG	the-christmas-chronicles	104	movie	714	2018-11-22	\N	\N	B
The Da Vinci Code	PG-13	the-da-vinci-code	149	movie	715	2006-05-19	\N	\N	C+
The Godfather Part III	R	the-godfather-part-3	162	movie	716	1990-12-25	\N	\N	B
The Good Dinosaur	PG	the-good-dinosaur	93	movie	717	2015-11-25	\N	\N	C+
The Great Gatsby	PG-13	the-great-gatsby	143	movie	718	2013-05-10	\N	\N	B
The Greatest Showman	PG	the-greatest-showman	105	movie	719	2017-12-20	\N	\N	B
The Lost World: Jurassic Park	PG-13	the-lost-world	129	movie	721	1997-05-23	\N	\N	C+
The Matrix Revolutions	R	the-matrix-revolutions	129	movie	722	2003-11-05	\N	\N	C+
The Patriot	R	the-patriot	165	movie	724	2000-06-30	\N	\N	B-
The Producers	PG-13	the-producers	134	movie	725	2005-12-16	\N	\N	B+
The Rock	R	the-rock	136	movie	726	1996-06-07	\N	\N	B
Troll 2	PG-13	troll-2	95	movie	727	1990-10-12	\N	\N	F
Twilight	PG-13	twilight	122	movie	728	2008-11-21	\N	\N	D+
Underworld	R	underworld	121	movie	729	2003-09-19	\N	\N	C+
Underworld: Evolution	R	underworld-evolution	106	movie	730	2006-01-20	\N	\N	C-
Underworld: Rise of the Lycans	R	underworld-rise-of-the-lycans	92	movie	731	2009-01-23	\N	\N	C
Wonder Woman 1984	PG-13	wonder-woman-1984	151	movie	732	2020-12-25	\N	\N	C+
World War Z	PG-13	world-war-z	116	movie	733	2013-06-21	\N	\N	C+
Zack Snyder's Justice League	R	zack-snyders-justice-league	242	movie	734	2021-03-18	\N	\N	B
A League of Their Own	PG	a-league-of-their-own	128	movie	735	1992-07-01	\N	\N	A-
Alien Resurrection	R	alien-resurrection	109	movie	738	1997-11-26	\N	\N	C-
Daredevil	PG-13	daredevil	103	movie	739	2003-02-14	\N	\N	D+
Hulk	PG-13	hulk	138	movie	741	2003-06-20	\N	\N	C
Goodfellas	R	goodfellas	145	movie	742	1990-09-18	\N	\N	A
Antz	PG	antz	83	movie	743	1998-10-02	\N	\N	B+
The Expendables	R	the-expendables	103	movie	744	2010-08-13	\N	\N	C+
The Expendables 3	PG-13	the-expendables-3	126	movie	745	2014-08-15	\N	\N	C+
Samaritan	PG-13	samaritan	102	movie	746	2022-08-26	\N	\N	C+
Fast Times at Ridgemont High	R	fast-times-at-ridgemont-high	90	movie	747	1982-08-13	\N	\N	B+
The Breakfast Club	R	the-breakfast-club	97	movie	748	1985-02-15	\N	\N	A
Ferris Bueller's Day Off	PG-13	ferris-buellers-day-off	103	movie	749	1986-06-11	\N	\N	B+
Clueless	PG-13	clueless	97	movie	750	1995-07-19	\N	\N	B
Mean Girls	PG-13	mean-girls-(2004)	97	movie	751	2004-04-30	\N	\N	A-
Elvis	PG-13	elvis	159	movie	752	2022-06-24	\N	\N	B+
Mars Needs Moms	PG	mars-needs-moms	88	movie	753	2011-03-11	\N	\N	D+
Pinocchio	G	pinocchio-(1940)	88	movie	754	1940-02-23	\N	\N	A-
Pinocchio	PG	pinocchio-(2022)	105	movie	755	2022-09-08	\N	\N	C-
Cinderella	G	cinderella-(1950)	74	movie	756	1950-03-04	\N	\N	B+
Clerks	R	clerks	92	movie	757	1994-10-19	\N	\N	A
The Muppet Movie	G	the-muppet-movie	95	movie	758	1979-06-22	\N	\N	A
The Great Muppet Caper	G	the-great-muppet-caper	97	movie	759	1981-06-26	\N	\N	B+
The Muppets Take Manhattan	G	the-muppets-take-manhattan	94	movie	760	1984-07-13	\N	\N	B+
Muppet Treasure Island	G	muppet-treasure-island	99	movie	761	1996-02-16	\N	\N	B+
Muppets from Space	G	muppets-from-space	87	movie	762	1999-07-14	\N	\N	C+
The Muppets	PG	the-muppets	120	movie	763	2011-11-23	\N	\N	A
Muppets Most Wanted	PG	muppets-most-wanted	107	movie	764	2014-03-21	\N	\N	B
Coraline	PG	coraline	100	movie	765	2009-02-06	\N	\N	A
Monster House	PG	monster-house	91	movie	766	2006-07-21	\N	\N	B-
The Addams Family 2	PG	the-addams-family-2	93	movie	767	2021-10-01	\N	\N	D+
Hellraiser	R	hellraiser-(1987)	94	movie	768	1987-09-10	\N	\N	A-
The Blair Witch Project	R	the-blair-witch-project	81	movie	769	1999-07-14	\N	\N	B-
Hocus Pocus 2	PG	hocus-pocus-2	103	movie	770	2022-09-30	\N	\N	C+
The Mummy	Not Rated	the-mummy-(1932)	73	movie	771	1932-12-22	\N	\N	B
The Invisible Man	Not Rated	the-invisible-man-(1933)	71	movie	772	1933-10-31	\N	\N	B+
The Wolf Man	Not Rated	the-wolf-man	70	movie	773	1941-12-09	\N	\N	B
Creature from the Black Lagoon	G	creature-from-the-black-lagoon	79	movie	774	1954-02-12	\N	\N	B
Spiral: From the Book of Saw	R	spiral	93	movie	775	2021-05-14	\N	\N	C
Hellraiser	R	hellraiser-(2022)	121	movie	776	2022-10-07	\N	\N	B
Candyman	R	candyman-(1992)	99	movie	777	1992-10-16	\N	\N	A-
Candyman	R	candyman-(2021)	91	movie	778	2021-08-27	\N	\N	B+
Birdemic: Shock and Terror	Not Rated	birdemic	105	movie	779	2010-02-27	\N	\N	F
Jurassic World Dominion	PG-13	jurassic-world-dominion	147	movie	780	2022-06-10	\N	\N	C-
The Black Phone	R	the-black-phone	103	movie	782	2022-06-24	\N	\N	B+
The Mist	R	the-mist	126	movie	784	2007-11-21	\N	\N	B-
Carrie	R	carrie-(1976)	98	movie	785	1976-11-03	\N	\N	A
Misery	R	misery	107	movie	786	1990-11-30	\N	\N	A
Morbius	PG-13	morbius	104	movie	787	2022-04-01	\N	\N	C
Beetlejuice	PG	beetlejuice	92	movie	788	1988-03-30	\N	\N	A-
Edward Scissorhands	PG-13	edward-scissorhands	105	movie	790	1990-12-07	\N	\N	A
Sweeney Todd: The Demon Barber of Fleet Street	R	sweeney-todd	116	movie	791	2007-12-21	\N	\N	B+
Black Adam	PG-13	black-adam	125	movie	792	2022-10-21	\N	\N	C+
Dark Shadows	PG-13	dark-shadows	113	movie	793	2012-05-11	\N	\N	C+
Wendell & Wild	PG-13	wendell-and-wild	105	movie	794	2022-10-21	\N	\N	B
Seven	R	seven	127	movie	795	1995-09-22	\N	\N	A
Zodiac	R	zodiac	157	movie	796	2007-03-02	\N	\N	B+
Halloween Ends	R	halloween-ends	111	movie	797	2022-10-14	\N	\N	C
Enola Holmes	PG-13	enola-holmes	123	movie	798	2020-09-23	\N	\N	B+
Enola Holmes 2	PG-13	enola-holmes-2	129	movie	799	2022-11-04	\N	\N	B+
Full Metal Jacket	R	full-metal-jacket	116	movie	801	1987-06-26	\N	\N	B+
Saving Private Ryan	R	saving-private-ryan	169	movie	802	1998-07-24	\N	\N	A
The Princess and the Frog	G	the-princess-and-the-frog	97	movie	804	2009-12-11	\N	\N	A-
Enchanted	PG	enchanted	107	movie	805	2007-11-21	\N	\N	A-
Tron	PG	tron	96	movie	806	1982-07-09	\N	\N	B+
Willow	PG	willow	126	movie	808	1988-05-20	\N	\N	B-
Klaus	PG	klaus	96	movie	809	2019-11-08	\N	\N	A
A Christmas Prince	TV-PG	a-christmas-prince	92	movie	810	2017-11-17	\N	\N	C
Nope	R	nope	130	movie	811	2022-07-22	\N	\N	B+
Strange World	PG	strange-world	102	movie	812	2022-11-23	\N	\N	B
The Unbearable Weight of Massive Talent	R	the-unbearable-weight-of-massive-talent	107	movie	813	2022-04-22	\N	\N	B+
Bullet Train	R	bullet-train	127	movie	814	2022-08-05	\N	\N	B+
The Expendables 2	R	the-expendables-2	103	movie	815	2012-08-17	\N	\N	C+
Lawrence of Arabia	PG	lawrence-of-arabia	227	movie	816	1962-12-10	\N	\N	A-
Mortal Kombat Legends: Snow Blind	R	mortal-kombat-legends-snow-blind	82	movie	817	2022-10-09	\N	\N	B-
2 Fast 2 Furious	PG-13	2-fast-2-furious	107	movie	818	2003-06-06	\N	\N	C
2001: A Space Odyssey	G	2001	149	movie	819	1968-04-03	\N	\N	B
A Christmas Prince: The Royal Baby	TV-PG	a-christmas-prince-the-royal-baby	84	movie	821	2019-12-05	\N	\N	D+
Bill & Ted's Bogus Journey	PG	bill-and-teds-bogus-journey	93	movie	822	1991-07-19	\N	\N	B+
Black Panther: Wakanda Forever	PG-13	black-panther-wakanda-forever	161	movie	823	2022-11-11	\N	\N	B+
Bride of Frankenstein	Not Rated	bride-of-frankenstein	75	movie	824	1935-04-20	\N	\N	B+
Cinderella	PG	cinderella-(2015)	105	movie	825	2015-03-13	\N	\N	B-
Citizen Kane	PG	citizen-kane	119	movie	826	1941-09-05	\N	\N	B+
Descendants 2	TV-G	descendants-2	111	movie	827	2017-07-21	\N	\N	C
Die Hard with a Vengeance	R	die-hard-with-a-vengeance	128	movie	828	1995-05-19	\N	\N	B+
Doctor Sleep	R	doctor-sleep	152	movie	829	2019-11-08	\N	\N	B+
Dune	PG-13	dune-(1984)	137	movie	830	1984-12-14	\N	\N	C
E.T. the Extra-Terrestrial	PG	et	115	movie	831	1982-06-11	\N	\N	B+
Free Guy	PG-13	free-guy	115	movie	832	2021-08-13	\N	\N	B+
Game Night	R	game-night	100	movie	833	2018-02-23	\N	\N	B+
Glass Onion: A Knives Out Mystery	PG-13	glass-onion	139	movie	834	2022-11-23	\N	\N	A-
Godzilla vs. Kong	PG-13	godzilla-vs-kong	113	movie	835	2021-03-31	\N	\N	C+
Guillermo del Toro's Pinocchio	PG	guillermo-del-toros-pinocchio	117	movie	837	2022-11-09	\N	\N	A-
Hacksaw Ridge	R	hacksaw-ridge	139	movie	838	2016-11-04	\N	\N	B+
Halloweentown II: Kalabar's Revenge	TV-PG	halloweentown-2	81	movie	839	2001-10-12	\N	\N	C-
Harry Potter and the Chamber of Secrets	PG	harry-potter-and-the-chamber-of-secrets	161	movie	840	2002-11-15	\N	\N	B+
Harry Potter and the Deathly Hallows - Part 1	PG-13	harry-potter-and-the-deathly-hallows-part-1	146	movie	841	2010-11-19	\N	\N	B+
I Know What You Did Last Summer	R	i-know-what-you-did-last-summer-(1997)	101	movie	842	1997-10-17	\N	\N	C+
Inferno	PG-13	inferno	121	movie	843	2016-10-28	\N	\N	C
Juno	PG-13	juno	96	movie	845	2007-12-05	\N	\N	B+
Justice League Dark: Apokolips War	R	justice-league-dark-apokolips-war	90	movie	846	2020-05-05	\N	\N	B+
Maleficent	PG	maleficent	97	movie	847	2014-05-30	\N	\N	C+
National Treasure	PG	national-treasure	131	movie	848	2004-11-19	\N	\N	B-
Night at the Museum: Battle of the Smithsonian	PG	night-at-the-museum-battle-of-the-smithsonian	105	movie	849	2009-05-22	\N	\N	C
Ocean's Eight	PG-13	oceans-eight	110	movie	850	2018-06-08	\N	\N	C
Pokémon: Detective Pikachu	PG	detective-pikachu	104	movie	851	2019-05-10	\N	\N	B+
Saw III	R	saw-3	108	movie	853	2006-10-27	\N	\N	C
Spider-Man	PG-13	spider-man	121	movie	854	2002-05-03	\N	\N	B+
Spy Kids 3-D: Game Over	PG	spy-kids-3	84	movie	855	2003-07-25	\N	\N	D+
Star Wars: Episode I - The Phantom Menace	PG	star-wars-episode-1	136	movie	856	1999-05-19	\N	\N	C
Star Wars: Episode II - Attack of the Clones	PG	star-wars-episode-2	142	movie	857	2002-05-16	\N	\N	C
Star Wars: Episode III - Revenge of the Sith	PG-13	star-wars-episode-3	140	movie	858	2005-05-19	\N	\N	B-
The Christmas Chronicles Part Two	PG	the-christmas-chronicles-2	112	movie	859	2020-11-25	\N	\N	B-
The Death of Superman	PG-13	the-death-of-superman	81	movie	860	2018-07-24	\N	\N	B+
The Godfather Part II	R	the-godfather-part-2	202	movie	861	1974-12-20	\N	\N	B+
The Meg	PG-13	the-meg	113	movie	862	2018-08-10	\N	\N	C
Mad Max 2	R	mad-max-2	96	movie	863	1981-12-24	\N	\N	B
Up	PG	up	96	movie	864	2009-05-29	\N	\N	A-
White Christmas	Not Rated	white-christmas	120	movie	866	1954-10-14	\N	\N	B+
Once Upon a Time in... Hollywood	R	once-upon-a-time-in-hollywood	161	movie	867	2019-07-26	\N	\N	A-
The Bourne Identity	PG-13	the-bourne-identity	119	movie	868	2002-06-14	\N	\N	A-
The Bourne Supremacy	PG-13	the-bourne-supremacy	108	movie	869	2004-07-23	\N	\N	B+
The Bourne Legacy	PG-13	the-bourne-legacy	135	movie	870	2012-08-10	\N	\N	B-
Extraction	R	extraction	116	movie	871	2020-04-24	\N	\N	C+
A Haunting in Venice	PG-13	a-haunting-in-venice	103	movie	872	2023-09-15	\N	\N	B-
Mortal Kombat Legends: Cage Match	R	mortal-kombat-legends-cage-match	76	movie	873	2023-10-17	\N	\N	C+
Saw X	R	saw-x	118	movie	874	2023-09-29	\N	\N	B-
Kung Fu Panda 4	PG	kung-fu-panda-4	94	movie	875	2024-03-08	\N	\N	B
Migration	PG	migration	83	movie	876	2023-12-22	\N	\N	C+
Plan 9 From Outer Space	Not Rated	plan-9-from-outer-space	80	movie	877	1957-03-15	\N	\N	D-
Unfriended	R	unfriended	83	movie	878	2015-04-17	\N	\N	B-
Jason Bourne	PG-13	jason-bourne	123	movie	879	2016-07-29	\N	\N	C+
Taken	PG-13	taken	90	movie	880	2008-02-27	\N	\N	B+
Taken 2	PG-13	taken-2	92	movie	881	2012-10-05	\N	\N	C
Taken 3	PG-13	taken-3	108	movie	882	2015-01-09	\N	\N	C-
The Prince of Egypt	PG	the-prince-of-egypt	99	movie	883	1998-12-18	\N	\N	A
Star Trek	PG-13	star-trek	127	movie	884	2009-05-08	\N	\N	A
Star Trek Beyond	PG-13	star-trek-beyond	122	movie	885	2016-07-22	\N	\N	B+
Bruce Almighty	PG-13	bruce-almighty	101	movie	886	2003-05-23	\N	\N	C+
Magic Mike XXL	R	magic-mike-xxl	115	movie	887	2015-07-01	\N	\N	C+
Matilda	PG	matilda	98	movie	888	1996-08-02	\N	\N	B+
The Mighty Ducks	PG	the-mighty-ducks	104	movie	889	1992-10-02	\N	\N	C+
Basic Instinct	R	basic-instinct	127	movie	890	1992-03-20	\N	\N	B+
Showgirls	NC-17	showgirls	128	movie	891	1995-09-22	\N	\N	D+
Honey, I Shrunk the Kids	PG	honey-i-shrunk-the-kids	93	movie	893	1989-06-23	\N	\N	B-
Hidden Figures	PG	hidden-figures	127	movie	894	2017-01-06	\N	\N	B+
Creed II	PG-13	creed-2	130	movie	898	2018-11-21	\N	\N	B+
M3GAN	PG-13	m3gan	102	movie	899	2023-01-06	\N	\N	B+
Ant-Man and the Wasp: Quantumania	PG-13	ant-man-and-the-wasp-quantumania	124	movie	900	2023-02-17	\N	\N	B-
Forrest Gump	PG-13	forrest-gump	142	movie	901	1994-07-06	\N	\N	A
Braveheart	R	braveheart	178	movie	902	1995-05-24	\N	\N	A
Gladiator	R	gladiator	155	movie	903	2000-05-05	\N	\N	B+
Puss in Boots: The Last Wish	PG	puss-in-boots-the-last-wish	102	movie	904	2022-12-21	\N	\N	A
Chicago	PG-13	chicago	113	movie	906	2002-12-27	\N	\N	B+
The Sound of Music	R	the-sound-of-music	172	movie	907	1965-03-02	\N	\N	A-
Nobody	R	nobody	92	movie	908	2021-03-26	\N	\N	B+
Point Break	R	point-break	122	movie	909	1991-07-12	\N	\N	A-
DC League of Super-Pets	PG	league-of-super-pets	105	movie	910	2022-07-29	\N	\N	C+
Pixels	PG-13	pixels	105	movie	911	2015-07-24	\N	\N	D+
Murder Mystery	PG-13	murder-mystery	97	movie	912	2019-06-14	\N	\N	C
Murder Mystery 2	PG-13	murder-mystery-2	90	movie	913	2023-03-31	\N	\N	C-
Knock at the Cabin	R	knock-at-the-cabin	100	movie	914	2023-02-03	\N	\N	C+
Vampire's Kiss	R	vampires-kiss	103	movie	915	1989-06-02	\N	\N	C-
The Mummy	PG-13	the-mummy-(1999)	124	movie	916	1999-05-07	\N	\N	B
The Mummy Returns	PG-13	the-mummy-returns	130	movie	917	2001-05-04	\N	\N	C
The Scorpion King	PG-13	the-scorpion-king	92	movie	918	2002-04-19	\N	\N	C-
Van Helsing	PG-13	van-helsing	131	movie	919	2004-05-07	\N	\N	C-
Patriots Day	R	patriots-day	133	movie	920	2016-12-21	\N	\N	B+
Cocaine Bear	R	cocaine-bear	95	movie	921	2023-02-24	\N	\N	B
Pete's Dragon	G	petes-dragon-(1977)	128	movie	922	1977-11-03	\N	\N	C+
Pete's Dragon	PG	petes-dragon-(2016)	102	movie	923	2016-08-12	\N	\N	B+
Peter Pan & Wendy	PG	peter-pan-and-wendy	106	movie	924	2023-04-28	\N	\N	C+
Scream VI	R	scream-6	122	movie	925	2023-03-10	\N	\N	B+
Fatal Attraction	R	fatal-attraction	119	movie	926	1987-09-18	\N	\N	B+
Fifty Shades of Grey	R	fifty-shades-of-grey	125	movie	927	2015-02-13	\N	\N	D
Fifty Shades Darker	R	fifty-shades-darker	118	movie	928	2017-02-10	\N	\N	D
Fifty Shades Freed	R	fifty-shades-freed	105	movie	929	2018-02-09	\N	\N	D
Mamma Mia!	PG-13	mamma-mia	108	movie	930	2008-07-18	\N	\N	C+
Mamma Mia! Here We Go Again	PG-13	mamma-mia-here-we-go-again	114	movie	931	2018-07-20	\N	\N	B-
Guardians of the Galaxy Vol. 3	PG-13	guardians-of-the-galaxy-vol-3	150	movie	932	2023-05-05	\N	\N	B+
xXx	PG-13	xxx	124	movie	933	2002-08-09	\N	\N	C
Shazam! Fury of the Gods	PG-13	shazam-fury-of-the-gods	130	movie	934	2023-03-17	\N	\N	B
Final Destination	R	final-destination	98	movie	935	2000-03-17	\N	\N	C+
The Final Destination	R	the-final-destination	82	movie	936	2009-08-28	\N	\N	D+
xXx: State of the Union	PG-13	xxx-state-of-the-union	101	movie	937	2005-04-29	\N	\N	C-
xXx: Return of Xander Cage	PG-13	xxx-return-of-xander-cage	107	movie	938	2017-01-20	\N	\N	C
White Men Can't Jump	R	white-men-cant-jump	115	movie	939	1992-03-27	\N	\N	B+
Dungeons & Dragons: Honor Among Thieves	PG-13	dungeons-and-dragons-honor-among-thieves	134	movie	940	2023-03-31	\N	\N	B+
Into the Woods	PG	into-the-woods	125	movie	941	2014-12-25	\N	\N	C+
The Hunchback of Notre Dame	G	the-hunchback-of-notre-dame	91	movie	942	1996-06-21	\N	\N	A-
Tarzan	G	tarzan	88	movie	943	1999-06-18	\N	\N	A-
Cloudy with a Chance of Meatballs	PG	cloudy-with-a-chance-of-meatballs	90	movie	944	2009-09-18	\N	\N	B+
101 Dalmatians	G	101-dalmatians	103	movie	945	1996-11-27	\N	\N	C-
102 Dalmatians	G	102-dalmatians	100	movie	946	2000-11-22	\N	\N	D+
A Christmas Prince: The Royal Wedding	TV-PG	a-christmas-prince-the-royal-wedding	92	movie	947	2018-11-30	\N	\N	C-
Lemony Snicket's A Series of Unfortunate Events	PG	a-series-of-unfortunate-events	108	movie	948	2004-12-17	\N	\N	B-
Army of Darkness	R	army-of-darkness	81	movie	949	1993-02-19	\N	\N	A-
Artemis Fowl	PG	artemis-fowl	95	movie	950	2020-06-12	\N	\N	D+
Austin Powers: International Man of Mystery	PG-13	austin-powers-international-man-of-mystery	94	movie	951	1997-05-02	\N	\N	B
Back to the Future	PG	back-to-the-future	116	movie	952	1985-07-03	\N	\N	A
Bad Boys II	R	bad-boys-2	147	movie	953	2003-07-18	\N	\N	D+
Blade	R	blade	120	movie	954	1998-08-21	\N	\N	B
Brave	PG	brave	93	movie	955	2012-06-22	\N	\N	B-
Carrie	R	carrie-(2013)	100	movie	956	2013-10-18	\N	\N	B-
Child's Play	R	childs-play-(2019)	90	movie	957	2019-06-21	\N	\N	B-
Coming 2 America	PG-13	coming-2-america	110	movie	958	2021-03-05	\N	\N	D+
Coming to America	R	coming-to-america	117	movie	959	1988-06-29	\N	\N	B-
Cruella	PG-13	cruella	134	movie	960	2021-05-28	\N	\N	B
X-Men: Dark Phoenix	PG-13	dark-phoenix	113	movie	961	2019-06-07	\N	\N	C-
Disenchanted	PG	disenchanted	119	movie	962	2022-11-18	\N	\N	B-
Divergent	PG-13	divergent	139	movie	963	2014-03-21	\N	\N	C+
Evil Dead	R	evil-dead	91	movie	965	2013-04-05	\N	\N	B
Fast & Furious Presents: Hobbs & Shaw	PG-13	hobbs-and-shaw	137	movie	966	2019-08-02	\N	\N	B+
Fred Claus	PG	fred-claus	116	movie	967	2007-11-09	\N	\N	C
Godmothered	PG	godmothered	110	movie	968	2020-12-04	\N	\N	C-
Groundhog Day	PG	groundhog-day	101	movie	969	1993-02-12	\N	\N	B+
Guardians of the Galaxy Vol. 2	PG-13	guardians-of-the-galaxy-vol-2	136	movie	970	2017-05-05	\N	\N	A-
Happy Gilmore	PG-13	happy-gilmore	92	movie	971	1996-02-16	\N	\N	B-
Hercules	G	hercules	93	movie	973	1997-06-13	\N	\N	B+
High School Musical	TV-G	high-school-musical	98	movie	974	2006-01-20	\N	\N	C+
High School Musical 3: Senior Year	G	high-school-musical-3	112	movie	975	2008-10-24	\N	\N	C+
Hubie Halloween	PG-13	hubie-halloween	103	movie	976	2020-10-07	\N	\N	D+
Independence Day	PG-13	independence-day	145	movie	977	1996-07-03	\N	\N	B-
Live Free or Die Hard	PG-13	live-free-or-die-hard	128	movie	978	2007-06-27	\N	\N	B
Magic Mike	R	magic-mike	110	movie	979	2012-06-29	\N	\N	B-
Minions	PG	minions	91	movie	980	2015-07-10	\N	\N	C
Minions: The Rise of Gru	PG	minions-the-rise-of-gru	87	movie	981	2022-07-01	\N	\N	C
Monster Hunter	PG-13	monster-hunter	103	movie	982	2020-12-18	\N	\N	C-
Mortal Kombat	R	mortal-kombat-(2021)	110	movie	983	2021-04-23	\N	\N	B-
Night at the Museum	PG	night-at-the-museum	108	movie	984	2006-12-22	\N	\N	B-
Night at the Museum: Secret of the Tomb	PG	night-at-the-museum-secret-of-the-tomb	98	movie	985	2014-12-19	\N	\N	C+
Noelle	G	noelle	100	movie	986	2019-11-12	\N	\N	C+
Old	PG-13	old	108	movie	987	2021-07-23	\N	\N	C+
Peter Pan	PG	peter-pan-(2003)	113	movie	988	2003-12-25	\N	\N	A-
Planes: Fire & Rescue	PG	planes-fire-and-rescue	83	movie	989	2014-07-18	\N	\N	C
Pocahontas	G	pocahontas	81	movie	990	1995-06-23	\N	\N	B
Prometheus	R	prometheus	124	movie	991	2012-06-08	\N	\N	B-
Return to Halloweentown	TV-PG	return-to-halloweentown	88	movie	992	2006-10-20	\N	\N	D+
Rise of the Guardians	PG	rise-of-the-guardians	97	movie	993	2012-11-21	\N	\N	B+
Santa Claus: The Movie	PG	santa-claus	107	movie	994	1985-11-27	\N	\N	C
Scary Movie	R	scary-movie	88	movie	995	2000-07-07	\N	\N	D
Scream 4	R	scream-4	111	movie	996	2011-04-15	\N	\N	B-
Shrek Forever After	PG	shrek-forever-after	95	movie	997	2010-05-21	\N	\N	B-
Sonic the Hedgehog	PG	sonic-the-hedgehog	99	movie	998	2020-02-14	\N	\N	B-
Sonic the Hedgehog 2	PG	sonic-the-hedgehog-2	122	movie	999	2022-04-08	\N	\N	B
Star Trek Into Darkness	PG-13	star-trek-into-darkness	132	movie	1000	2013-05-15	\N	\N	A-
Stargate	PG-13	stargate	116	movie	1001	1994-10-28	\N	\N	C+
TMNT	PG	tmnt	87	movie	1003	2007-03-23	\N	\N	B
Tron: Legacy	PG	tron-legacy	125	movie	1004	2010-12-17	\N	\N	B
Final Destination 3	R	final-destination-3	93	movie	1005	2006-02-10	\N	\N	C
Teenage Mutant Ninja Turtles	PG	teenage-mutant-ninja-turtles-(1990)	93	movie	1006	1990-03-30	\N	\N	B-
Teenage Mutant Ninja Turtles	PG-13	teenage-mutant-ninja-turtles-(2014)	101	movie	1007	2014-08-08	\N	\N	C-
Teenage Mutant Ninja Turtles: Out of the Shadows	PG-13	teenage-mutant-ninja-turtles-out-of-the-shadows	112	movie	1008	2016-06-03	\N	\N	C-
The Addams Family	PG	the-addams-family-(2019)	86	movie	1009	2019-10-11	\N	\N	C-
The Bourne Ultimatum	PG-13	the-bourne-ultimatum	115	movie	1010	2007-08-03	\N	\N	B+
The Chronicles of Narnia: Prince Caspian	PG	the-chronicles-of-narnia-prince-caspian	150	movie	1011	2008-05-16	\N	\N	B-
The Cloverfield Paradox	PG-13	the-cloverfield-paradox	102	movie	1012	2018-02-04	\N	\N	B-
The Fast and the Furious	PG-13	the-fast-and-the-furious	106	movie	1013	2001-06-22	\N	\N	B-
The Fate of the Furious	PG-13	the-fate-of-the-furious	136	movie	1014	2017-04-14	\N	\N	B-
The Hateful Eight	R	the-hateful-eight	168	movie	1015	2015-12-25	\N	\N	B+
The Hobbit: The Battle of the Five Armies	PG-13	the-hobbit-the-battle-of-the-five-armies	144	movie	1016	2014-12-17	\N	\N	B-
The Incredible Hulk	PG-13	the-incredible-hulk	112	movie	1017	2008-06-13	\N	\N	B-
The Karate Kid Part II	PG	the-karate-kid-part-2	113	movie	1018	1986-06-20	\N	\N	C+
The Lorax	PG	the-lorax	86	movie	1019	2012-03-02	\N	\N	C
The Matrix Resurrections	R	the-matrix-resurrections	148	movie	1020	2021-12-22	\N	\N	B-
The Maze Runner	PG-13	the-maze-runner	113	movie	1021	2014-09-19	\N	\N	B-
The Passion of the Christ	R	the-passion-of-the-christ	127	movie	1022	2004-02-25	\N	\N	C-
The Predator	R	the-predator	107	movie	1023	2018-09-14	\N	\N	C+
The Shining	R	the-shining	146	movie	1024	1980-05-23	\N	\N	A-
The Witches	PG	the-witches-(1990)	91	movie	1025	1990-08-24	\N	\N	B-
The Witches	PG	the-witches-(2020)	106	movie	1026	2020-10-22	\N	\N	C-
Tom & Jerry	PG	tom-and-jerry	101	movie	1027	2021-02-26	\N	\N	C
Twister	PG-13	twister	113	movie	1028	1996-05-10	\N	\N	C+
Uncharted	PG-13	uncharted	116	movie	1029	2022-02-18	\N	\N	B-
Venom: Let There Be Carnage	PG-13	venom-let-there-be-carnage	97	movie	1030	2021-10-01	\N	\N	C
We Can Be Heroes	PG	we-can-be-heroes	100	movie	1031	2020-12-25	\N	\N	D
X-Men: Apocalypse	PG-13	x-men-apocalypse	144	movie	1032	2016-05-27	\N	\N	C+
X-Men: The Last Stand	PG-13	x-men-the-last-stand	104	movie	1033	2006-05-26	\N	\N	B-
Zombieland	R	zombieland	88	movie	1034	2009-10-02	\N	\N	A
Cloudy with a Chance of Meatballs 2	PG	cloudy-with-a-chance-of-meatballs-2	95	movie	1035	2013-09-27	\N	\N	C+
The Mitchells vs the Machines	PG	the-mitchells-vs-the-machines	114	movie	1036	2021-04-23	\N	\N	A
The LEGO Movie	PG	the-lego-movie	100	movie	1037	2014-02-07	\N	\N	A-
The LEGO Batman Movie	PG	the-lego-batman-movie	104	movie	1038	2017-02-10	\N	\N	A-
The LEGO Movie 2: The Second Part	PG	the-lego-movie-2	107	movie	1039	2019-02-08	\N	\N	B+
The Transformers: The Movie	PG	the-transformers	84	movie	1040	1986-08-08	\N	\N	B-
Deep Impact	PG-13	deep-impact	120	movie	1041	1998-05-08	\N	\N	B-
Armageddon	PG-13	armageddon	151	movie	1042	1998-07-01	\N	\N	C+
Creed III	PG-13	creed-3	116	movie	1043	2023-03-03	\N	\N	A-
Red Notice	PG-13	red-notice	118	movie	1044	2021-11-05	\N	\N	C+
The Gray Man	PG-13	the-gray-man	122	movie	1045	2022-07-15	\N	\N	C+
Extraction 2	R	extraction-2	122	movie	1046	2023-06-16	\N	\N	C+
Tommy Boy	PG-13	tommy-boy	97	movie	1047	1995-03-31	\N	\N	B-
6 Underground	R	6-underground	128	movie	1048	2019-12-13	\N	\N	C
12 Years a Slave	R	12-years-a-slave	134	movie	1049	2013-11-08	\N	\N	B+
Renfield	R	renfield	93	movie	1050	2023-04-14	\N	\N	B
National Lampoon's Vacation	R	vacation	98	movie	1051	1983-07-29	\N	\N	A-
National Lampoon's European Vacation	PG-13	european-vacation	95	movie	1052	1985-07-26	\N	\N	B
Transformers: Rise of the Beasts	PG-13	transformers-rise-of-the-beasts	127	movie	1053	2023-06-09	\N	\N	B
Evil Dead Rise	R	evil-dead-rise	96	movie	1054	2023-04-21	\N	\N	B
Insidious	PG-13	insidious	103	movie	1056	2011-04-01	\N	\N	B-
Fantastic Mr. Fox	PG	fantastic-mr-fox	87	movie	1057	2009-11-13	\N	\N	B+
School of Rock	PG-13	school-of-rock	109	movie	1058	2003-10-03	\N	\N	B+
Insidious: Chapter 2	PG-13	insidious-chapter-2	106	movie	1059	2013-09-13	\N	\N	C+
Mission: Impossible	PG-13	mission-impossible	110	movie	1060	1996-05-22	\N	\N	B
Mission: Impossible II	PG-13	mission-impossible-2	123	movie	1061	2000-05-24	\N	\N	C+
Mission: Impossible III	PG-13	mission-impossible-3	126	movie	1062	2006-05-05	\N	\N	B
Mission: Impossible - Ghost Protocol	PG-13	mission-impossible-ghost-protocol	132	movie	1063	2011-12-16	\N	\N	A-
Mission: Impossible - Rogue Nation	PG-13	mission-impossible-rogue-nation	131	movie	1064	2015-07-31	\N	\N	A-
Mission: Impossible - Fallout	PG-13	mission-impossible-fallout	147	movie	1065	2018-07-27	\N	\N	A-
Interstellar	PG-13	interstellar	169	movie	1066	2014-11-05	\N	\N	A-
Dunkirk	PG-13	dunkirk	106	movie	1067	2017-07-21	\N	\N	B+
Indiana Jones and the Dial of Destiny	PG-13	indiana-jones-and-the-dial-of-destiny	154	movie	1068	2023-06-30	\N	\N	B
It Ends with Us	PG-13	it-ends-with-us	130	movie	1069	2024-08-09	\N	\N	B
Final Destination 2	R	final-destination-2	90	movie	1070	2003-01-31	\N	\N	C+
John Wick: Chapter 4	R	john-wick-chapter-4	169	movie	1071	2023-03-24	\N	\N	A-
The Princess Diaries	G	the-princess-diaries	115	movie	1072	2001-08-03	\N	\N	C+
The Princess Diaries 2: Royal Engagement	G	the-princess-diaries-2	113	movie	1073	2004-08-11	\N	\N	C-
Where the Crawdads Sing	PG-13	where-the-crawdads-sing	125	movie	1074	2022-07-15	\N	\N	B
Tomorrowland	PG	tomorrowland	130	movie	1076	2015-05-22	\N	\N	B
Barbie	PG-13	barbie	114	movie	1077	2023-07-21	\N	\N	A-
Hereditary	R	hereditary	127	movie	1078	2018-06-08	\N	\N	A
CODA	PG-13	coda	111	movie	1079	2021-08-13	\N	\N	A
Deep Blue Sea	R	deep-blue-sea	105	movie	1080	1999-07-28	\N	\N	C
The Super Mario Bros. Movie	PG	the-super-mario-bros-movie	92	movie	1081	2023-04-05	\N	\N	C+
Elysium	R	elysium	109	movie	1082	2013-08-09	\N	\N	B-
American Graffiti	PG	american-graffiti	110	movie	1083	1973-08-11	\N	\N	B
Heathers	R	heathers	103	movie	1084	1989-03-31	\N	\N	A-
Enter the Dragon	R	enter-the-dragon	102	movie	1085	1973-08-19	\N	\N	B+
Big	PG	big	104	movie	1086	1988-06-03	\N	\N	B+
The Goonies	PG	the-goonies	114	movie	1087	1985-06-07	\N	\N	B+
Stand by Me	R	stand-by-me	89	movie	1088	1986-08-22	\N	\N	A
Fantastic Four	PG-13	fantastic-four-(2005)	106	movie	1089	2005-07-08	\N	\N	C-
The Emoji Movie	PG	the-emoji-movie	86	movie	1090	2017-07-28	\N	\N	D
Top Gun	PG	top-gun	109	movie	1091	1986-05-16	\N	\N	B-
Fantastic Four: Rise of the Silver Surfer	PG-13	fantastic-four-rise-of-the-silver-surfer	92	movie	1092	2007-06-15	\N	\N	C
Fantastic Four	PG-13	fantastic-four-(2015)	100	movie	1093	2015-08-07	\N	\N	D+
Training Day	R	training-day	122	movie	1095	2001-10-05	\N	\N	A-
Animal House	R	animal-house	109	movie	1096	1978-07-28	\N	\N	B+
My Big Fat Greek Wedding	PG	my-big-fat-greek-wedding	95	movie	1097	2002-04-19	\N	\N	B-
My Big Fat Greek Wedding 2	PG-13	my-big-fat-greek-wedding-2	94	movie	1098	2016-03-25	\N	\N	C-
The Little Mermaid	PG	the-little-mermaid-(2023)	135	movie	1099	2023-05-26	\N	\N	C+
Battleship	PG-13	battleship	131	movie	1100	2012-05-18	\N	\N	C
Clue	PG	clue	94	movie	1101	1985-12-13	\N	\N	B
Gravity	PG-13	gravity	91	movie	1102	2013-10-04	\N	\N	A-
Friday the 13th Part 2	R	friday-the-13th-part-2	87	movie	1103	1981-05-01	\N	\N	C
Friday the 13th Part III	R	friday-the-13th-part-3	95	movie	1104	1982-08-13	\N	\N	C
Friday the 13th: The Final Chapter	R	friday-the-13th-the-final-chapter	91	movie	1105	1984-04-13	\N	\N	C-
The Little Mermaid	G	the-little-mermaid-(1989)	83	movie	1106	1989-11-17	\N	\N	A-
Addams Family Values	PG-13	addams-family-values	94	movie	1107	1993-11-19	\N	\N	A-
Jumanji	PG	jumanji	104	movie	1108	1995-12-15	\N	\N	B-
Mortal Kombat Legends: Scorpion's Revenge	R	mortal-kombat-legends-scorpions-revenge	80	movie	1109	2020-04-14	\N	\N	B
Moonfall	PG-13	moonfall	130	movie	1110	2022-02-04	\N	\N	C-
Death on the Nile	PG-13	death-on-the-nile	127	movie	1111	2022-02-11	\N	\N	B-
Elemental	PG	elemental	101	movie	1112	2023-06-16	\N	\N	B+
Spy Kids	PG	spy-kids	88	movie	1113	2001-03-30	\N	\N	B-
Indiana Jones and the Kingdom of the Crystal Skull	PG-13	indiana-jones-and-the-kingdom-of-the-crystal-skull	122	movie	1114	2008-05-22	\N	\N	C
Independence Day: Resurgence	PG-13	independence-day-resurgence	120	movie	1115	2016-06-24	\N	\N	C-
Doctor Strange	PG-13	doctor-strange	115	movie	1116	2016-11-04	\N	\N	A-
Murder on the Orient Express	PG-13	murder-on-the-orient-express	114	movie	1117	2017-11-10	\N	\N	B-
Ready Player One	PG-13	ready-player-one	140	movie	1118	2018-03-29	\N	\N	B+
Hotel Transylvania 3: Summer Vacation	PG	hotel-transylvania-3	97	movie	1119	2018-07-13	\N	\N	C-
Annabelle Comes Home	R	annabelle-comes-home	106	movie	1120	2019-06-26	\N	\N	B-
Prey	R	prey	100	movie	1121	2022-08-05	\N	\N	B+
G.I. Joe: Retaliation	PG-13	gi-joe-retaliation	110	movie	1122	2013-03-28	\N	\N	C
Snake Eyes: G.I. Joe Origins	PG-13	snake-eyes	121	movie	1123	2021-07-23	\N	\N	C+
Bloodsport	R	bloodsport	92	movie	1124	1988-02-26	\N	\N	B
Fast X	PG-13	fast-x	141	movie	1125	2023-05-19	\N	\N	C+
Teenage Mutant Ninja Turtles: Mutant Mayhem	PG	teenage-mutant-ninja-turtles-mutant-mayhem	99	movie	1127	2023-08-02	\N	\N	A-
Meg 2: The Trench	PG-13	meg-2	116	movie	1128	2023-08-04	\N	\N	C-
The Wolf of Wall Street	R	the-wolf-of-wall-street	180	movie	1129	2013-12-25	\N	\N	A
American Psycho	R	american-psycho	102	movie	1130	2000-04-14	\N	\N	B+
Haunted Mansion	PG-13	haunted-mansion	123	movie	1133	2023-07-28	\N	\N	B
Goosebumps	PG	goosebumps	103	movie	1134	2015-10-16	\N	\N	B-
Goosebumps 2: Haunted Halloween	PG	goosebumps-2	90	movie	1135	2018-10-12	\N	\N	C
The Lost Boys	R	the-lost-boys	97	movie	1136	1987-07-31	\N	\N	A-
Interview with the Vampire: The Vampire Chronicles	R	interview-with-the-vampire	123	movie	1137	1994-11-11	\N	\N	B+
The Boondock Saints	R	the-boondock-saints	108	movie	1138	2000-01-21	\N	\N	C
They Live	R	they-live	94	movie	1139	1988-11-04	\N	\N	B+
Smile	R	smile	115	movie	1140	2022-09-30	\N	\N	B+
The Invisible Man	R	the-invisible-man-(2020)	124	movie	1141	2020-02-28	\N	\N	A
The Birds	PG-13	the-birds	119	movie	1142	1963-03-28	\N	\N	B+
Jennifer's Body	R	jennifers-body	102	movie	1143	2009-09-18	\N	\N	B-
Freaky	R	freaky	102	movie	1144	2020-11-13	\N	\N	B+
Willy's Wonderland	Not Rated	willys-wonderland	88	movie	1145	2021-02-12	\N	\N	B-
Five Nights at Freddy's	PG-13	five-nights-at-freddys	109	movie	1146	2023-10-27	\N	\N	C
The Nun II	R	the-nun-2	110	movie	1147	2023-09-08	\N	\N	C
Constantine	R	constantine	121	movie	1148	2005-02-18	\N	\N	C+
Tropic Thunder	R	tropic-thunder	107	movie	1150	2008-08-13	\N	\N	B+
Scarface	R	scarface	170	movie	1151	1983-12-09	\N	\N	B+
The Marvels	PG-13	the-marvels	105	movie	1152	2023-11-10	\N	\N	C+
Trolls	PG	trolls	92	movie	1153	2016-11-04	\N	\N	C+
Trolls World Tour	PG	trolls-world-tour	91	movie	1154	2020-04-10	\N	\N	C+
King Kong	Not Rated	king-kong-(1933)	100	movie	1155	1933-04-07	\N	\N	B+
Godzilla	Not Rated	godzilla-(1954)	96	movie	1156	1954-11-03	\N	\N	A-
Blue Beetle	PG-13	blue-beetle	127	movie	1157	2023-08-18	\N	\N	B
Meet the Robinsons	G	meet-the-robinsons	95	movie	1158	2007-03-30	\N	\N	B-
Planes, Trains & Automobiles	R	planes-trains-and-automobiles	93	movie	1159	1987-11-25	\N	\N	A
Dances with Wolves	PG-13	dances-with-wolves	181	movie	1160	1990-11-09	\N	\N	A-
Instant Family	PG-13	instant-family	118	movie	1161	2018-11-16	\N	\N	B+
Daddy's Home 2	PG-13	daddys-home-2	100	movie	1162	2017-11-10	\N	\N	D+
Spirited	PG-13	spirited	127	movie	1163	2022-11-11	\N	\N	B
Santa Claus Conquers the Martians	Not Rated	santa-claus-conquers-the-martians	81	movie	1164	1964-11-14	\N	\N	F
Silent Night, Deadly Night	R	silent-night-deadly-night	79	movie	1165	1984-11-09	\N	\N	C-
Krampus	PG-13	krampus	98	movie	1166	2015-12-04	\N	\N	B+
Violent Night	R	violent-night	112	movie	1167	2022-12-02	\N	\N	B
Love Actually	R	love-actually	135	movie	1168	2003-11-14	\N	\N	B
Jack Frost	PG	jack-frost	101	movie	1169	1998-12-11	\N	\N	C
300	R	300	117	movie	1170	2007-03-09	\N	\N	B-
300: Rise of an Empire	R	300-rise-of-an-empire	102	movie	1171	2014-03-07	\N	\N	C+
The Color Purple	PG-13	the-color-purple-(1985)	154	movie	1172	1985-12-18	\N	\N	A-
The Exorcist: Believer	R	the-exorcist-believer	111	movie	1173	2023-10-06	\N	\N	C+
The Nutcracker: The Untold Story	PG	the-nutcracker-the-untold-story	110	movie	1174	2010-11-24	\N	\N	D
Rebel Moon - Part One: A Child of Fire	PG-13	rebel-moon-part-1	133	movie	1175	2023-12-15	\N	\N	C
Oppenheimer	R	oppenheimer	180	movie	1176	2023-07-21	\N	\N	A-
James and the Giant Peach	PG	james-and-the-giant-peach	79	movie	1177	1996-04-12	\N	\N	B-
Atlantis: The Lost Empire	PG	atlantis	95	movie	1178	2001-06-15	\N	\N	B+
Gran Turismo	PG-13	gran-turismo	134	movie	1179	2023-08-25	\N	\N	B
Crank	R	crank	88	movie	1180	2006-09-01	\N	\N	C+
Aquaman and the Lost Kingdom	PG-13	aquaman-and-the-lost-kingdom	124	movie	1183	2023-12-22	\N	\N	C+
Wonka	PG	wonka	116	movie	1184	2023-12-15	\N	\N	B+
The Rocky Horror Picture Show	R	the-rocky-horror-picture-show	100	movie	1186	1975-09-26	\N	\N	A-
The Equalizer	R	the-equalizer	132	movie	1187	2014-09-26	\N	\N	B
The Equalizer 2	R	the-equalizer-2	121	movie	1188	2018-07-20	\N	\N	B
Ted	R	ted	106	movie	1190	2012-06-29	\N	\N	B
Ted 2	R	ted-2	115	movie	1191	2015-06-26	\N	\N	B-
Kingsman: The Secret Service	R	kingsman-the-secret-service	129	movie	1193	2015-02-13	\N	\N	A
Kingsman: The Golden Circle	R	kingsman-the-golden-circle	141	movie	1194	2017-09-22	\N	\N	B+
The King's Man	R	the-kings-man	131	movie	1195	2021-12-22	\N	\N	B-
The LEGO Ninjago Movie	PG	the-lego-ninjago-movie	101	movie	1196	2017-09-22	\N	\N	B
Final Fantasy: The Spirits Within	PG-13	final-fantasy	106	movie	1197	2001-07-11	\N	\N	C
Mr. & Mrs. Smith	PG-13	mr-and-mrs-smith	120	movie	1199	2005-06-10	\N	\N	C+
My Fair Lady	G	my-fair-lady	170	movie	1200	1964-10-21	\N	\N	B+
Batman: Assault on Arkham	PG-13	batman-assault-on-arkham	76	movie	1201	2014-07-29	\N	\N	B+
American Pie 2	R	american-pie-2	108	movie	1203	2001-08-10	\N	\N	B-
IF	PG	if	104	movie	1204	2024-05-17	\N	\N	B
Polar	TV-MA	polar	118	movie	1205	2019-01-25	\N	\N	D+
Jack Reacher	PG-13	jack-reacher	130	movie	1206	2012-12-21	\N	\N	B-
Jack Reacher: Never Go Back	PG-13	jack-reacher-never-go-back	118	movie	1207	2016-10-21	\N	\N	C
Rudy	PG	rudy	114	movie	1208	1993-10-15	\N	\N	B+
Remember the Titans	PG	remember-the-titans	113	movie	1209	2000-09-29	\N	\N	A
Hamilton	PG-13	hamilton	160	movie	1210	2020-07-03	\N	\N	B+
RoboCop	PG-13	robocop-(2014)	117	movie	1211	2014-02-12	\N	\N	C+
Chronicle	PG-13	chronicle	89	movie	1212	2012-02-03	\N	\N	A-
Air Force One	R	air-force-one	124	movie	1213	1997-07-25	\N	\N	B+
Madame Web	PG-13	madame-web	116	movie	1214	2024-02-14	\N	\N	D+
Lincoln	PG-13	lincoln	150	movie	1215	2012-11-16	\N	\N	B+
Selma	PG-13	selma	128	movie	1216	2014-12-25	\N	\N	A-
The Color Purple	PG-13	the-color-purple-(2023)	141	movie	1217	2023-12-25	\N	\N	B+
Madagascar	PG	madagascar	86	movie	1218	2005-05-27	\N	\N	B
Madagascar: Escape 2 Africa	PG	madagascar-escape-2-africa	89	movie	1219	2008-11-07	\N	\N	B+
Madagascar 3: Europe's Most Wanted	PG	madagascar-3	95	movie	1220	2012-06-08	\N	\N	B
Penguins of Madagascar	PG	penguins-of-madagascar	92	movie	1221	2014-11-26	\N	\N	B
Monsters vs. Aliens	PG	monsters-vs-aliens	94	movie	1222	2009-03-27	\N	\N	C+
American Beauty	R	american-beauty	122	movie	1223	1999-10-01	\N	\N	B+
Slumdog Millionaire	R	slumdog-millionaire	120	movie	1224	2008-11-12	\N	\N	A-
Birdman or (The Unexpected Virtue of Ignorance)	R	birdman	119	movie	1225	2014-10-17	\N	\N	A
La La Land	PG-13	la-la-land	128	movie	1226	2016-12-09	\N	\N	B+
Moonlight	R	moonlight	111	movie	1227	2016-10-21	\N	\N	B
Mean Girls	PG-13	mean-girls-(2024)	112	movie	1229	2024-01-12	\N	\N	C+
Mars Attacks!	PG-13	mars-attacks	106	movie	1312	1996-12-13	\N	\N	C+
Damsel	PG-13	damsel	108	movie	1228	2024-03-08	\N	\N	C+
Megalopolis	R	megalopolis	138	movie	1643	2024-09-27	\N	2025-12-28 21:21:46.064-05	C-
City Lights	G	city-lights	87	movie	1647	1931-03-07	\N	2026-01-03 22:10:07.221-05	B+
The SpongeBob SquarePants Movie	PG	the-spongebob-squarepants-movie	87	movie	1230	2004-11-19	\N	\N	C+
The SpongeBob Movie: Sponge Out of Water	PG	the-spongebob-movie-sponge-out-of-water	92	movie	1231	2015-02-06	\N	\N	C+
The SpongeBob Movie: Sponge on the Run	PG	the-spongebob-movie-sponge-on-the-run	91	movie	1232	2021-03-04	\N	\N	C+
Dirty Dancing	PG-13	dirty-dancing	100	movie	1233	1987-08-21	\N	\N	B+
Road House	R	road-house-(1989)	114	movie	1234	1989-05-19	\N	\N	B
Ghost	PG-13	ghost	127	movie	1235	1990-07-13	\N	\N	A-
Trolls Band Together	PG	trolls-band-together	91	movie	1236	2023-11-17	\N	\N	C+
Road House	R	road-house-(2024)	121	movie	1237	2024-03-21	\N	\N	C+
Death Note	TV-MA	death-note	101	movie	1238	2017-08-25	\N	\N	C+
King Kong	PG-13	king-kong-(2005)	187	movie	1239	2005-12-14	\N	\N	A-
Fight Club	R	fight-club	139	movie	1240	1999-10-15	\N	\N	A
Footloose	PG	footloose	107	movie	1241	1984-02-17	\N	\N	B
The Croods: A New Age	PG	the-croods-a-new-age	95	movie	1242	2020-11-25	\N	\N	C+
The Omen	R	the-omen	111	movie	1243	1976-06-25	\N	\N	A
Wish	PG	wish	95	movie	1244	2023-11-22	\N	\N	B-
The Green Knight	R	the-green-knight	130	movie	1245	2021-07-30	\N	\N	B+
A.I. Artificial Intelligence	PG-13	ai	146	movie	1246	2001-06-29	\N	\N	B
The Creator	PG-13	the-creator	133	movie	1247	2023-09-29	\N	\N	B
Ex Machina	R	ex-machina	108	movie	1248	2015-04-10	\N	\N	A
Argylle	PG-13	argylle	139	movie	1251	2024-02-02	\N	\N	C
Lisa Frankenstein	PG-13	lisa-frankenstein	101	movie	1252	2024-02-09	\N	\N	B-
Seven Samurai	Not Rated	seven-samurai	207	movie	1253	1954-04-26	\N	\N	B+
Rebel Moon - Part Two: The Scargiver	PG-13	rebel-moon-part-2	122	movie	1254	2024-04-12	\N	\N	D+
The Mask	PG-13	the-mask	101	movie	1255	1994-07-29	\N	\N	B+
Dumb and Dumber	PG-13	dumb-and-dumber	107	movie	1256	1994-12-16	\N	\N	B
Liar Liar	PG-13	liar-liar	86	movie	1257	1997-03-21	\N	\N	B+
The Truman Show	PG	the-truman-show	103	movie	1258	1998-06-05	\N	\N	A
King Richard	PG-13	king-richard	144	movie	1259	2021-11-19	\N	\N	B
Civil War	R	civil-war	109	movie	1260	2024-04-12	\N	\N	B+
Planet of the Apes	G	planet-of-the-apes-(1968)	112	movie	1261	1968-04-03	\N	\N	A
Beneath the Planet of the Apes	G	beneath-the-planet-of-the-apes	95	movie	1262	1970-05-26	\N	\N	B
Escape from the Planet of the Apes	G	escape-from-the-planet-of-the-apes	98	movie	1263	1971-05-26	\N	\N	B
Conquest of the Planet of the Apes	PG	conquest-of-the-planet-of-the-apes	88	movie	1264	1972-06-14	\N	\N	C+
Planet of the Apes	PG-13	planet-of-the-apes-(2001)	120	movie	1265	2001-07-27	\N	\N	C
Rise of the Planet of the Apes	PG-13	rise-of-the-planet-of-the-apes	105	movie	1266	2011-08-05	\N	\N	A-
Dawn of the Planet of the Apes	PG-13	dawn-of-the-planet-of-the-apes	130	movie	1267	2014-07-11	\N	\N	A
Daddy's Home	PG-13	daddys-home	96	movie	1268	2015-12-25	\N	\N	C
War for the Planet of the Apes	PG-13	war-for-the-planet-of-the-apes	140	movie	1269	2017-07-14	\N	\N	A
A Bad Moms Christmas	R	a-bad-moms-christmas	104	movie	1270	2017-11-01	\N	\N	D+
The Strangers	R	the-strangers	86	movie	1271	2008-05-30	\N	\N	C+
The Strangers: Prey at Night	R	the-strangers-prey-at-night	85	movie	1272	2018-03-09	\N	\N	C
The Dark Crystal	PG	the-dark-crystal	93	movie	1273	1982-12-17	\N	\N	B+
Garfield: The Movie	PG	garfield-the-movie	80	movie	1274	2004-06-11	\N	\N	D+
Garfield: A Tail of Two Kitties	PG	garfield-a-tail-of-two-kitties	82	movie	1275	2006-06-16	\N	\N	D+
The Emperor's New Groove	G	the-emperors-new-groove	78	movie	1276	2000-12-15	\N	\N	A
Furiosa: A Mad Max Saga	R	furiosa	148	movie	1277	2024-05-24	\N	\N	B+
American Sniper	R	american-sniper	133	movie	1278	2014-12-25	\N	\N	B+
The Hunger Games: The Ballad of Songbirds & Snakes	PG-13	the-hunger-games-the-ballad-of-songbirds-and-snakes	157	movie	1279	2023-11-17	\N	\N	B-
Glass	PG-13	glass	129	movie	1280	2019-01-18	\N	\N	B
I, Robot	PG-13	i-robot	115	movie	1281	2004-07-16	\N	\N	B-
Hellboy	PG-13	hellboy-(2004)	122	movie	1282	2004-04-02	\N	\N	A-
Hellboy	R	hellboy-(2019)	120	movie	1283	2019-04-12	\N	\N	C+
X	R	x	105	movie	1284	2022-03-18	\N	\N	B+
Beverly Hills Cop	R	beverly-hills-cop	105	movie	1285	1984-12-05	\N	\N	A
Beverly Hills Cop II	R	beverly-hills-cop-2	100	movie	1286	1987-05-20	\N	\N	B
American Pie	R	american-pie	95	movie	1287	1999-07-09	\N	\N	B+
Beverly Hills Cop: Axel F	R	beverly-hills-cop-axel-f	118	movie	1288	2024-07-03	\N	\N	B
Poor Things	R	poor-things	141	movie	1289	2023-12-08	\N	\N	A
Princess Protection Program	TV-G	princess-protection-program	90	movie	1291	2009-06-26	\N	\N	C
Sausage Party	R	sausage-party	89	movie	1292	2016-08-12	\N	\N	B
Dante's Peak	PG-13	dantes-peak	108	movie	1293	1997-02-07	\N	\N	B
Volcano	PG-13	volcano	104	movie	1294	1997-04-25	\N	\N	C
San Andreas	PG-13	san-andreas	114	movie	1296	2015-05-29	\N	\N	C+
Ghostbusters: Frozen Empire	PG-13	ghostbusters-frozen-empire	115	movie	1297	2024-03-22	\N	\N	B
Girl, Interrupted	R	girl-interrupted	127	movie	1298	1999-12-21	\N	\N	A-
Love Lies Bleeding	R	love-lies-bleeding	104	movie	1299	2024-03-08	\N	\N	B+
Anchorman 2: The Legend Continues	PG-13	anchorman-2	119	movie	1300	2013-12-18	\N	\N	B-
The Visit	PG-13	the-visit	94	movie	1301	2015-09-11	\N	\N	A-
Kingdom of the Planet of the Apes	PG-13	kingdom-of-the-planet-of-the-apes	145	movie	1302	2024-05-10	\N	\N	B+
Conan the Barbarian	R	conan-the-barbarian	129	movie	1303	1982-05-14	\N	\N	C+
Conan the Destroyer	PG	conan-the-destroyer	101	movie	1304	1984-06-29	\N	\N	C-
True Lies	R	true-lies	141	movie	1305	1994-07-15	\N	\N	B+
The Crow	R	the-crow	102	movie	1306	1994-05-13	\N	\N	A-
Rear Window	PG	rear-window	111	movie	1307	1954-09-01	\N	\N	B
Steel Magnolias	PG	steel-magnolias	118	movie	1308	1989-11-15	\N	\N	C+
A Quiet Place: Day One	PG-13	a-quiet-place-day-one	99	movie	1309	2024-06-28	\N	\N	B
Bambi	G	bambi	70	movie	1310	1942-08-13	\N	\N	B
Apocalypse Now	R	apocalypse-now	147	movie	1311	1979-08-15	\N	\N	A
Miss Peregrine's Home for Peculiar Children	PG-13	miss-peregrines-home-for-peculiar-children	127	movie	1313	2016-09-30	\N	\N	B-
Midsommar	R	midsommar	147	movie	1314	2019-07-03	\N	\N	B+
Charlie's Angels	PG-13	charlies-angels-(2000)	98	movie	1315	2000-11-03	\N	\N	C
Charlie's Angels	PG-13	charlies-angels-(2019)	118	movie	1316	2019-11-15	\N	\N	C+
Eragon	PG	eragon	103	movie	1317	2006-12-15	\N	\N	C-
Blazing Saddles	R	blazing-saddles	93	movie	1318	1974-02-07	\N	\N	A
The Usual Suspects	R	the-usual-suspects	106	movie	1319	1995-08-16	\N	\N	A
The Craft	R	the-craft	101	movie	1320	1996-05-03	\N	\N	B+
The Craft: Legacy	PG-13	the-craft-legacy	97	movie	1321	2020-10-28	\N	\N	C
The Sorcerer's Apprentice	PG	the-sorcerers-apprentice	109	movie	1322	2010-07-14	\N	\N	C+
Whiplash	R	whiplash	106	movie	1323	2014-10-10	\N	\N	A
Rosemary's Baby	R	rosemarys-baby	137	movie	1324	1968-06-12	\N	\N	A-
The Outsiders	PG	the-outsiders	91	movie	1325	1983-03-25	\N	\N	B
Inside Out 2	PG	inside-out-2	96	movie	1326	2024-06-14	\N	\N	A+
Challengers	R	challengers	131	movie	1327	2024-04-26	\N	\N	B+
The Fall Guy	PG-13	the-fall-guy	126	movie	1328	2024-05-03	\N	\N	B+
Abigail	R	abigail	109	movie	1329	2024-04-19	\N	\N	B+
Insidious: Chapter 3	PG-13	insidious-chapter-3	98	movie	1330	2015-06-05	\N	\N	C+
Insidious: The Last Key	PG-13	insidious-the-last-key	103	movie	1331	2018-01-05	\N	\N	C
Insidious: The Red Door	PG-13	insidious-the-red-door	107	movie	1332	2023-07-07	\N	\N	C+
The Amityville Horror	R	the-amityville-horror-(2005)	89	movie	1333	2005-04-15	\N	\N	C-
Joker: Folie à Deux	R	joker-folie-a-deux	138	movie	1334	2024-10-04	\N	\N	C+
Winnie-the-Pooh: Blood and Honey 2	Not Rated	winnie-the-pooh-blood-and-honey-2	94	movie	1335	2024-03-26	\N	\N	D
The Thing	R	the-thing	109	movie	1336	1982-06-25	\N	\N	A
MaXXXine	R	maxxxine	104	movie	1337	2024-07-05	\N	\N	B
Hellraiser: Bloodline	R	hellraiser-bloodline	85	movie	1338	1996-03-08	\N	\N	C-
Brightburn	R	brightburn	90	movie	1339	2019-05-24	\N	\N	C+
Trap	PG-13	trap	105	movie	1340	2024-08-02	\N	\N	B-
Firestarter	R	firestarter-(1984)	114	movie	1341	1984-05-11	\N	\N	C
Orphan	R	orphan	123	movie	1342	2009-07-24	\N	\N	B+
The Wicker Man	PG-13	the-wicker-man	102	movie	1344	2006-09-01	\N	\N	D+
Venom: The Last Dance	PG-13	venom-the-last-dance	109	movie	1345	2024-10-25	\N	\N	C+
Troy	R	troy	163	movie	1346	2004-05-14	\N	\N	B+
Napoleon	R	napoleon	157	movie	1347	2023-11-22	\N	\N	B
Edge of Tomorrow	PG-13	edge-of-tomorrow	113	movie	1348	2014-06-06	\N	\N	A-
Nimona	PG	nimona	99	movie	1349	2023-06-23	\N	\N	A
Black Hawk Down	R	black-hawk-down	144	movie	1351	2001-12-28	\N	\N	B
Ghosted	PG-13	ghosted	116	movie	1352	2023-04-21	\N	\N	C+
Dr. Strangelove	PG	dr-strangelove	94	movie	1353	1964-01-29	\N	\N	A-
Alien: Romulus	R	alien-romulus	119	movie	1354	2024-08-16	\N	\N	B+
Treasure Planet	PG	treasure-planet	95	movie	1355	2002-11-27	\N	\N	B+
Thanksgiving	R	thanksgiving	106	movie	1356	2023-11-17	\N	\N	B-
Despicable Me 4	PG	despicable-me-4	95	movie	1357	2024-07-03	\N	\N	C
Beetlejuice Beetlejuice	PG-13	beetlejuice-beetlejuice	104	movie	1358	2024-09-06	\N	\N	B+
Moana 2	PG	moana-2	100	movie	1359	2024-11-27	\N	\N	B
The Lighthouse	R	the-lighthouse	109	movie	1360	2019-10-18	\N	\N	B
The Holdovers	R	the-holdovers	133	movie	1361	2023-10-27	\N	\N	A
Bad Santa	R	bad-santa	92	movie	1362	2003-11-26	\N	\N	B+
Trading Places	R	trading-places	116	movie	1363	1983-06-08	\N	\N	B+
Meet Me in St. Louis	Not Rated	meet-me-in-st-louis	113	movie	1364	1944-11-22	\N	\N	B+
Eyes Wide Shut	R	eyes-wide-shut	159	movie	1366	1999-07-16	\N	\N	B-
Wicked	PG	wicked	160	movie	1367	2024-11-22	\N	\N	A
Alvin and the Chipmunks	PG	alvin-and-the-chipmunks	92	movie	1368	2007-12-14	\N	\N	D+
Alvin and the Chipmunks: The Squeakquel	PG	alvin-and-the-chipmunks-the-squeakquel	88	movie	1369	2009-12-23	\N	\N	D
Alvin and the Chipmunks: Chipwrecked	G	alvin-and-the-chipmunks-chipwrecked	87	movie	1370	2011-12-16	\N	\N	D-
Alvin and the Chipmunks: The Road Chip	PG	alvin-and-the-chipmunks-the-road-chip	92	movie	1371	2015-12-18	\N	\N	D
Den of Thieves	R	den-of-thieves	140	movie	1372	2018-01-19	\N	\N	C
12 Angry Men	Not Rated	12-angry-men	96	movie	1374	1957-04-10	\N	\N	A
The Mouse Trap	Not Rated	the-mouse-trap	80	movie	1375	2024-08-06	\N	\N	F
An American Werewolf in London	R	an-american-werewolf-in-london	97	movie	1376	1981-08-21	\N	\N	B+
Amadeus	PG	amadeus	161	movie	1378	1984-09-19	\N	\N	B+
Turbo	PG	turbo	96	movie	1379	2013-07-17	\N	\N	C+
Gladiator II	R	gladiator-2	148	movie	1380	2024-11-22	\N	\N	B+
Mr. Peabody & Sherman	PG	mr-peabody-and-sherman	92	movie	1381	2014-03-07	\N	\N	B
Home	PG	home	94	movie	1382	2015-03-27	\N	\N	C+
Abominable	PG	abominable	97	movie	1383	2019-09-27	\N	\N	B
The Bad Guys	PG	the-bad-guys	100	movie	1384	2022-04-22	\N	\N	A
Ruby Gillman, Teenage Kraken	PG	ruby-gillman	91	movie	1385	2023-06-30	\N	\N	B-
Barbarian	R	barbarian	102	movie	1386	2022-09-09	\N	\N	B+
Bridget Jones: The Edge of Reason	R	bridget-jones-the-edge-of-reason	108	movie	1387	2004-11-12	\N	\N	C
Bridget Jones's Baby	R	bridget-joness-baby	123	movie	1388	2016-09-16	\N	\N	B+
Paddington 2	PG	paddington-2	104	movie	1389	2017-11-10	\N	\N	A
Kiki's Delivery Service	G	kikis-delivery-service	102	movie	1390	1989-07-29	\N	\N	A
Captain America: Brave New World	PG-13	captain-america-brave-new-world	118	movie	1391	2025-02-14	\N	\N	B
Sonic the Hedgehog 3	PG	sonic-the-hedgehog-3	110	movie	1392	2024-12-20	\N	\N	B+
Castle in the Sky	PG	castle-in-the-sky	124	movie	1393	1986-08-02	\N	\N	B+
Captain Underpants: The First Epic Movie	PG	captain-underpants	90	movie	1394	2017-06-02	\N	\N	B+
High School Musical 2	TV-G	high-school-musical-2	104	movie	1396	2007-08-17	\N	\N	C+
Hotel Transylvania	PG	hotel-transylvania	91	movie	1397	2012-09-28	\N	\N	B
Jungle Cruise	PG-13	jungle-cruise	127	movie	1398	2021-07-30	\N	\N	B-
Romeo + Juliet	PG-13	romeo-+-juliet	120	movie	1399	1996-11-01	\N	\N	C-
Teenage Mutant Ninja Turtles II: The Secret of the Ooze	PG	teenage-mutant-ninja-turtles-2	88	movie	1400	1991-03-22	\N	\N	C
Teenage Mutant Ninja Turtles III	PG	teenage-mutant-ninja-turtles-3	96	movie	1401	1993-03-19	\N	\N	C
The Karate Kid Part III	PG	the-karate-kid-part-3	112	movie	1402	1989-06-30	\N	\N	C
Ace Ventura: Pet Detective	PG-13	ace-ventura-pet-detective	86	movie	1403	1994-02-04	\N	\N	C-
Pet Sematary	R	pet-sematary-(1989)	103	movie	1404	1989-04-21	\N	\N	C
Winnie-the-Pooh: Blood and Honey	Not Rated	winnie-the-pooh-blood-and-honey	84	movie	1405	2023-02-15	\N	\N	F
Casper	PG	casper	100	movie	1406	1995-05-26	\N	\N	C
The Blind Side	PG-13	the-blind-side	129	movie	1407	2009-11-20	\N	\N	B
Ace Ventura: When Nature Calls	PG-13	ace-ventura-when-nature-calls	90	movie	1408	1995-11-10	\N	\N	C
Descendants: The Rise of Red	TV-G	descendants-the-rise-of-red	91	movie	1409	2024-07-12	\N	\N	D+
The Amityville Horror	R	the-amityville-horror-(1979)	118	movie	1410	1979-07-27	\N	\N	B-
Terrifier 3	Not Rated	terrifier-3	125	movie	1411	2024-10-11	\N	\N	B
The Boss Baby: Family Business	PG	the-boss-baby-family-business	107	movie	1412	2021-07-02	\N	\N	C
The Punisher	R	the-punisher-(2004)	123	movie	1413	2004-04-16	\N	\N	C+
The Departed	R	the-departed	151	movie	1414	2006-10-06	\N	\N	A
Bad Boys: Ride or Die	R	bad-boys-ride-or-die	115	movie	1415	2024-06-07	\N	\N	B-
Life is Beautiful	PG-13	life-is-beautiful	116	movie	1417	1997-12-20	\N	\N	A
The Boss Baby	PG	the-boss-baby	97	movie	1418	2017-03-31	\N	\N	C
American History X	R	american-history-x	119	movie	1419	1998-10-30	\N	\N	B+
The Punisher	R	the-punisher-(1989)	89	movie	1420	1991-04-25	\N	\N	C+
One Flew Over the Cuckoo's Nest	R	one-flew-over-the-cuckoos-nest	135	movie	1421	1975-11-19	\N	\N	A-
Metropolis	Not Rated	metropolis	153	movie	1422	1927-01-10	\N	\N	B
Nosferatu	R	nosferatu-(2024)	132	movie	1423	2024-12-25	\N	\N	B+
The Apartment	Not Rated	the-apartment	125	movie	1424	1960-06-15	\N	\N	A-
Paddington	PG	paddington	95	movie	1425	2014-11-28	\N	\N	A
My Neighbor Totoro	G	my-neighbor-totoro	86	movie	1426	1988-04-16	\N	\N	A
Howard the Duck	PG	howard-the-duck	111	movie	1427	1986-08-01	\N	\N	D
Howl's Moving Castle	PG	howls-moving-castle	119	movie	1428	2004-11-20	\N	\N	B+
Bridget Jones's Diary	R	bridget-joness-diary	96	movie	1429	2001-04-13	\N	\N	B
Captain America	PG-13	captain-america	97	movie	1430	1992-07-22	\N	\N	D+
Bridget Jones: Mad About the Boy	R	bridget-jones-mad-about-the-boy	125	movie	1431	2025-02-13	\N	\N	B
Punisher: War Zone	R	punisher-war-zone	103	movie	1433	2008-12-05	\N	\N	D+
The Lord of the Rings: The War of the Rohirrim	PG-13	the-lord-of-the-rings-the-war-of-the-rohirrim	134	movie	1434	2024-12-03	\N	\N	B
Longlegs	R	longlegs	101	movie	1435	2024-07-12	\N	\N	B+
Borderlands	PG-13	borderlands	101	movie	1436	2024-08-09	\N	\N	D+
Dead Poets Society	PG	dead-poets-society	128	movie	1437	1989-06-02	\N	\N	B+
Kraven the Hunter	R	kraven-the-hunter	127	movie	1438	2024-12-13	\N	\N	C
Emilia Pérez	R	emilia-perez	132	movie	1440	2024-08-21	\N	\N	B-
Anora	R	anora	139	movie	1441	2024-10-18	\N	\N	B+
Mirror Mirror	PG	mirror-mirror	106	movie	1442	2012-03-30	\N	\N	C+
Snow White and the Huntsman	PG-13	snow-white-and-the-huntsman	127	movie	1443	2012-06-01	\N	\N	C
The Huntsman: Winter's War	PG-13	the-huntsman-winters-war	114	movie	1444	2016-04-22	\N	\N	C
Looney Tunes: Back in Action	PG	looney-tunes-back-in-action	91	movie	1445	2003-11-14	\N	\N	B
Alexander and the Terrible, Horrible, No Good, Very Bad Day	PG	alexander-and-the-terrible-horrible-no-good-very-bad-day	81	movie	1446	2014-10-10	\N	\N	B-
Mufasa: The Lion King	PG	mufasa	118	movie	1447	2024-12-20	\N	\N	B-
The Beekeeper	R	the-beekeeper	105	movie	1448	2024-01-12	\N	\N	B
Underworld: Awakening	R	underworld-awakening	86	movie	1449	2012-01-20	\N	\N	D+
Underworld: Blood Wars	R	underworld-blood-wars	91	movie	1450	2017-01-06	\N	\N	D+
Resident Evil	R	resident-evil	100	movie	1451	2002-03-15	\N	\N	C
Resident Evil: Apocalypse	R	resident-evil-apocalypse	93	movie	1452	2004-09-10	\N	\N	D
Resident Evil: Afterlife	R	resident-evil-afterlife	97	movie	1454	2010-09-10	\N	\N	D+
Resident Evil: Retribution	R	resident-evil-retribution	96	movie	1455	2012-09-14	\N	\N	D
Resident Evil: The Final Chapter	R	resident-evil-the-final-chapter	107	movie	1456	2017-01-27	\N	\N	C-
Resident Evil: Welcome to Raccoon City	R	resident-evil-welcome-to-raccoon-city	107	movie	1457	2021-11-24	\N	\N	C+
Happy Death Day	PG-13	happy-death-day	96	movie	1458	2017-10-13	\N	\N	B+
Happy Death Day 2U	PG-13	happy-death-day-2u	100	movie	1459	2019-02-13	\N	\N	B
The Monkey	R	the-monkey	98	movie	1460	2025-02-21	\N	\N	B+
Tombstone	R	tombstone	130	movie	1461	1993-12-25	\N	\N	A
Pride & Prejudice	PG	pride-and-prejudice	127	movie	1463	2005-11-23	\N	\N	B+
Monty Python and the Holy Grail	PG	monty-python-and-the-holy-grail	92	movie	1464	1975-04-03	\N	\N	A-
Wolf Man	R	wolf-man	103	movie	1465	2025-01-17	\N	\N	C+
Princess Mononoke	PG-13	princess-mononoke	133	movie	1466	1997-07-12	\N	\N	A
From Dusk till Dawn	R	from-dusk-till-dawn	108	movie	1467	1996-01-19	\N	\N	B
Memento	R	memento	113	movie	1469	2001-03-16	\N	\N	A
The Prestige	PG-13	the-prestige	130	movie	1470	2006-10-20	\N	\N	A
Paper Towns	PG-13	paper-towns	109	movie	1471	2015-07-24	\N	\N	B
Reservoir Dogs	R	reservoir-dogs	99	movie	1472	1992-10-09	\N	\N	A
A Fish Called Wanda	R	a-fish-called-wanda	108	movie	1473	1988-07-15	\N	\N	A-
Eternal Sunshine of the Spotless Mind	R	eternal-sunshine-of-the-spotless-mind	108	movie	1474	2004-03-19	\N	\N	B+
Mystery Men	PG-13	mystery-men	120	movie	1475	1999-08-06	\N	\N	C
Thunderbolts*	PG-13	thunderbolts	126	movie	1476	2025-05-02	\N	\N	A-
The Accountant	R	the-accountant	128	movie	1468	2016-10-14	\N	\N	C+
Resident Evil: Extinction	R	resident-evil-extinction	94	movie	1453	2007-09-21	\N	\N	C-
Days of Thunder	PG-13	days-of-thunder	108	movie	1477	1990-06-27	\N	\N	C+
Jerry Maguire	R	jerry-maguire	139	movie	1478	1996-12-13	\N	\N	A-
Minority Report	PG-13	minority-report	145	movie	1479	2002-06-21	\N	\N	A-
War of the Worlds	PG-13	war-of-the-worlds-(2005)	117	movie	1480	2005-06-29	\N	\N	B+
Fear Street: Prom Queen	R	fear-street-prom-queen	90	movie	1481	2025-05-23	\N	\N	C+
Lilo & Stitch	PG	lilo-and-stitch-(2025)	108	movie	1482	2025-05-23	\N	\N	B-
Mickey 17	R	mickey-17	137	movie	1483	2025-03-07	\N	\N	B+
Battlefield Earth	PG-13	battlefield-earth	117	movie	1501	2000-05-12	\N	\N	D
Atomic Blonde	R	atomic-blonde	115	movie	1503	2017-07-28	\N	\N	B+
Predator: Killer of Killers	R	predator-killer-of-killers	85	movie	1504	2025-06-06	\N	\N	A-
The Grand Budapest Hotel	R	the-grand-budapest-hotel	100	movie	1505	2014-03-07	\N	\N	A-
The Road to El Dorado	PG	the-road-to-el-dorado	89	movie	1506	2000-03-31	\N	\N	B+
Shark Tale	PG	shark-tale	90	movie	1507	2004-10-01	\N	\N	C-
Over the Hedge	PG	over-the-hedge	83	movie	1508	2006-05-19	\N	\N	C+
Snow White	PG	snow-white	109	movie	1509	2025-03-21	\N	\N	C-
28 Days Later	R	28-days-later	113	movie	1510	2002-11-01	\N	\N	B+
28 Weeks Later	R	28-weeks-later	99	movie	1511	2007-05-11	\N	\N	C+
A Minecraft Movie	PG	a-minecraft-movie	101	movie	1513	2025-04-04	\N	\N	C
Speed Racer	PG	speed-racer	135	movie	1514	2008-05-09	\N	\N	D+
65	PG-13	65	93	movie	1515	2023-03-10	\N	\N	C+
Olympus Has Fallen	R	olympus-has-fallen	119	movie	1516	2013-03-22	\N	\N	C
White House Down	PG-13	white-house-down	131	movie	1517	2013-06-28	\N	\N	C+
The Old Guard 2	R	the-old-guard-2	104	movie	1519	2025-07-02	\N	\N	C+
F1	PG-13	f1	156	movie	1520	2025-06-27	\N	\N	A-
Sinners	R	sinners	137	movie	1521	2025-04-18	\N	\N	A+
London Has Fallen	R	london-has-fallen	99	movie	1522	2016-03-04	\N	\N	C
Angel Has Fallen	R	angel-has-fallen	121	movie	1523	2019-08-23	\N	\N	C
Requiem for a Dream	Not Rated	requiem-for-a-dream	102	movie	1524	2000-10-06	\N	\N	B+
The Pianist	R	the-pianist	150	movie	1525	2002-09-06	\N	\N	B+
Dora and the Lost City of Gold	PG	dora-and-the-lost-city-of-gold	102	movie	1526	2019-08-09	\N	\N	B
Zombies 4: Dawn of the Vampires	TV-G	zombies-4	88	movie	1527	2025-07-10	\N	\N	C-
The Smurfs	PG	the-smurfs	103	movie	1528	2011-07-29	\N	\N	D+
The Smurfs 2	PG	the-smurfs-2	105	movie	1529	2013-07-31	\N	\N	D
Smurfs: The Lost Village	PG	smurfs-the-lost-village	90	movie	1530	2017-04-07	\N	\N	C+
Superman	PG-13	superman-(2025)	129	movie	1531	2025-07-11	\N	\N	A-
Beau Is Afraid	R	beau-is-afraid	179	movie	1532	2023-04-14	\N	\N	B
The Waterboy	PG-13	the-waterboy	90	movie	1533	1998-11-06	\N	\N	D+
Little Nicky	PG-13	little-nicky	90	movie	1534	2000-11-10	\N	\N	D-
Click	PG-13	click	107	movie	1535	2006-06-23	\N	\N	C-
You Don't Mess with the Zohan	PG-13	you-dont-mess-with-the-zohan	113	movie	1536	2008-06-06	\N	\N	C
Grown Ups	PG-13	grown-ups	102	movie	1537	2010-06-25	\N	\N	D+
Grown Ups 2	PG-13	grown-ups-2	101	movie	1538	2013-07-12	\N	\N	D
Caddyshack	R	caddyshack	98	movie	1539	1980-07-25	\N	\N	B
Happy Gilmore 2	PG-13	happy-gilmore-2	118	movie	1540	2025-07-25	\N	\N	C+
The Naked Gun: From the Files of Police Squad!	PG-13	the-naked-gun-from-the-files-of-police-squad	85	movie	1541	1988-12-02	\N	\N	A
The Naked Gun 2½: The Smell of Fear	PG-13	the-naked-gun-2-1-2	85	movie	1542	1991-06-28	\N	\N	A-
Naked Gun 33⅓: The Final Insult	PG-13	naked-gun-33-1-3	83	movie	1543	1994-03-18	\N	\N	B
Final Destination Bloodlines	R	final-destination-bloodlines	110	movie	1545	2025-05-16	\N	\N	B+
The Fantastic Four: First Steps	PG-13	the-fantastic-four-first-steps	114	movie	1546	2025-07-25	\N	\N	A-
Freaky Friday	PG	freaky-friday	97	movie	1547	2003-08-06	\N	\N	A-
Jurassic World Rebirth	PG-13	jurassic-world-rebirth	133	movie	1548	2025-07-02	\N	\N	C+
KPop Demon Hunters	PG	kpop-demon-hunters	97	movie	1549	2025-06-20	\N	\N	A
Red Sonja	PG-13	red-sonja	89	movie	1550	1985-07-03	\N	\N	D+
Apollo 13	PG-13	apollo-13	140	movie	1551	1995-06-30	\N	\N	A-
Cast Away	PG-13	cast-away	143	movie	1552	2000-12-22	\N	\N	A-
The Martian	PG-13	the-martian	142	movie	1553	2015-10-02	\N	\N	A
War of the Worlds	PG-13	war-of-the-worlds-(2025)	91	movie	1554	2025-07-30	\N	\N	F
Black Swan	R	black-swan	108	movie	1555	2010-12-17	\N	\N	A-
Death of a Unicorn	R	death-of-a-unicorn	107	movie	1556	2025-03-28	\N	\N	C+
Léon: The Professional	R	leon	110	movie	1557	1994-09-14	\N	\N	A
Good Will Hunting	R	good-will-hunting	126	movie	1558	1997-12-05	\N	\N	A
The War of the Roses	R	the-war-of-the-roses	116	movie	1559	1989-12-08	\N	\N	B+
The Toxic Avenger	R	the-toxic-avenger	82	movie	1560	1984-04-04	\N	\N	D+
Flash Gordon	PG	flash-gordon	111	movie	1561	1980-12-05	\N	\N	C+
Lights Out	PG-13	lights-out	81	movie	1562	2016-07-22	\N	\N	B+
Maximum Overdrive	R	maximum-overdrive	98	movie	1563	1986-07-25	\N	\N	C-
Ender's Game	PG-13	ender's-game	114	movie	1564	2013-11-01	\N	\N	C+
Downton Abbey	PG	downton-abbey	122	movie	1565	2019-09-20	\N	\N	B
Downton Abbey: A New Era	PG	downton-abbey-a-new-era	124	movie	1566	2022-05-20	\N	\N	B+
This Is Spinal Tap	R	this-is-spinal-tap	82	movie	1567	1984-03-02	\N	\N	A-
The Devil Wears Prada	PG-13	the-devil-wears-prada	109	movie	1568	2006-06-30	\N	\N	A-
Moneyball	PG-13	moneyball	133	movie	1569	2011-09-23	\N	\N	A-
A Few Good Men	R	a-few-good-men	138	movie	1570	1992-12-11	\N	\N	A
The Long Walk	R	the-long-walk	108	movie	1571	2025-09-12	\N	\N	A
Elio	PG	elio	98	movie	1572	2025-06-20	\N	\N	B+
Smurfs	PG	smurfs	90	movie	1573	2025-07-18	\N	\N	D+
Punch-Drunk Love	R	punch-drunk-love	95	movie	1574	2002-11-01	\N	\N	B
Boogie Nights	R	boogie-nights	155	movie	1575	1997-10-10	\N	\N	A
There Will Be Blood	R	there-will-be-blood	158	movie	1576	2007-12-26	\N	\N	A
M3GAN 2.0	PG-13	m3gan-2	120	movie	1579	2025-06-27	\N	\N	C+
Karate Kid: Legends	PG-13	karate-kid-legends	94	movie	1580	2025-05-30	\N	\N	B-
Until Dawn	R	until-dawn	103	movie	1581	2025-04-25	\N	\N	C+
28 Years Later	R	28-years-later	115	movie	1582	2025-06-20	\N	\N	B
Central Intelligence	PG-13	central-intelligence	107	movie	1583	2016-06-17	\N	\N	C+
The Naked Gun	PG-13	the-naked-gun	85	movie	1584	2025-08-01	\N	\N	A-
The Night of the Hunter	Not Rated	the-night-of-the-hunter	92	movie	1585	1955-07-26	\N	\N	B-
The Human Centipede (First Sequence)	R	the-human-centipede	92	movie	1586	2010-04-30	\N	\N	D-
Cannibal Holocaust	Not Rated	cannibal-holocaust	96	movie	1587	1980-02-07	\N	\N	D
How to Train Your Dragon	PG	how-to-train-your-dragon-(2025)	125	movie	1588	2025-06-13	\N	\N	A-
Suspiria	R	suspiria-(1977)	99	movie	1589	1977-02-01	\N	\N	B
Suspiria	R	suspiria-(2018)	152	movie	1590	2018-10-26	\N	\N	B
Fright Night	R	fright-night	106	movie	1592	1985-08-02	\N	\N	A
I Know What You Did Last Summer	R	i-know-what-you-did-last-summer-(2025)	111	movie	1593	2025-07-18	\N	\N	C
Tremors	PG-13	tremors	96	movie	1594	1990-01-19	\N	\N	B+
Ginger Snaps	R	ginger-snaps	108	movie	1595	2001-05-11	\N	\N	B+
Doom	R	doom	105	movie	1596	2005-10-21	\N	\N	D+
Grindhouse	R	grindhouse	191	movie	1597	2007-04-06	\N	\N	A-
Cabin Fever	R	cabin-fever	95	movie	1598	2003-09-12	\N	\N	B
House of 1000 Corpses	R	house-of-1000-corpses	89	movie	1599	2003-04-11	\N	\N	C+
The Devil's Rejects	R	the-devils-rejects	109	movie	1600	2005-07-22	\N	\N	B-
Weapons	R	weapons	128	movie	1601	2025-08-08	\N	\N	A
The Fly	R	the-fly	96	movie	1602	1986-08-15	\N	\N	A
The Fly II	R	the-fly-2	105	movie	1603	1989-02-10	\N	\N	C
The Others	PG-13	the-others	104	movie	1604	2001-08-10	\N	\N	A+
Commando	R	commando	90	movie	1605	1985-10-04	\N	\N	B-
Young Frankenstein	PG	young-frankenstein	106	movie	1606	1974-12-15	\N	\N	A
Mary Shelley's Frankenstein	R	mary-shelleys-frankenstein	123	movie	1607	1994-11-04	\N	\N	C+
Frankenweenie	PG	frankenweenie	87	movie	1608	2012-10-05	\N	\N	B
The Shape of Water	R	the-shape-of-water	123	movie	1609	2017-12-01	\N	\N	A-
Frankenstein	R	frankenstein-(2025)	150	movie	1610	2025-10-17	\N	\N	A
The Running Man	R	the-running-man-(1987)	101	movie	1611	1987-11-13	\N	\N	C+
Now You See Me	PG-13	now-you-see-me	115	movie	1612	2013-05-31	\N	\N	C+
Now You See Me 2	PG-13	now-you-see-me-2	129	movie	1613	2016-06-10	\N	\N	C+
Freakier Friday	PG	freakier-friday	111	movie	1614	2025-08-08	\N	\N	B
Baby Driver	R	baby-driver	113	movie	1615	2017-06-28	\N	\N	A
The Running Man	R	the-running-man-(2025)	133	movie	1616	2025-11-14	\N	\N	B
Eddington	R	eddington	149	movie	1617	2025-07-18	\N	\N	B-
Nobody 2	R	nobody-2	89	movie	1618	2025-08-15	\N	\N	B
The Wiz	G	the-wiz	133	movie	1619	1978-10-24	\N	\N	C+
The Whale	R	the-whale	117	movie	1620	2022-12-09	\N	\N	A
Sisu	R	sisu	91	movie	1621	2023-04-28	\N	\N	B+
The Bad Guys 2	PG	the-bad-guys-2	104	movie	1622	2025-08-01	\N	\N	A-
Looper	R	looper	118	movie	1630	2012-09-28	\N	2025-12-05 09:00:22.851-05	A
Hot Frosty	TV-PG	hot-frosty	92	movie	1631	2024-11-13	\N	2025-12-06 09:12:48.699-05	C
Jingle Jangle: A Christmas Journey	PG	jingle-jangle	122	movie	1632	2020-11-13	\N	2025-12-08 09:16:33.975-05	B+
The Mean One	Not Rated	the-mean-one	93	movie	1633	2022-12-09	\N	2025-12-09 09:19:32.68-05	D-
The Night Before	R	the-night-before	101	movie	1634	2015-11-20	\N	2025-12-11 09:21:55.173-05	B-
The Family Stone	PG-13	the-family-stone	104	movie	1635	2005-12-16	\N	2025-12-12 09:24:09.966-05	C
The Nativity Story	PG	the-nativity-story	101	movie	1638	2006-12-01	\N	2025-12-15 16:26:32.275-05	B-
Home Alone: The Holiday Heist	TV-PG	home-alone-the-holiday-heist	90	movie	1640	2012-11-25	\N	2025-12-19 16:59:20.067-05	D
Home Sweet Home Alone	PG	home-sweet-home-alone	93	movie	1641	2021-11-12	\N	2025-12-20 17:04:05.587-05	D
Sleepaway Camp	R	sleepaway-camp	84	movie	1591	1983-11-18	\N	\N	C+
Reefer Madness	Not Rated	reefer-madness	66	movie	737	1936-01-01	\N	\N	D+
Alice in Wonderland	G	alice-in-wonderland-(1951)	75	movie	214	1951-07-28	\N	\N	A-
Frankenstein	Not Rated	frankenstein-(1931)	70	movie	360	1931-11-21	\N	\N	B
Paddington in Peru	PG	paddington-in-peru	106	movie	1500	2024-11-08	\N	\N	A-
Star Wars	PG	star-wars	121	movie	703	1977-05-25	\N	\N	A
A Christmas Carol	PG	a-christmas-carol-(1984)	100	movie	1642	1984-12-17	\N	2025-12-23 21:16:31.287-05	A
The Conjuring: Last Rites	R	the-conjuring-last-rites	135	movie	1623	2025-09-05	\N	\N	C+
Free Birds	PG	free-birds	91	movie	1624	2013-11-01	\N	\N	C-
Wicked: For Good	PG	wicked-for-good	137	movie	1625	2025-11-21	\N	\N	B+
Mission: Impossible - The Final Reckoning	PG-13	mission-impossible-the-final-reckoning	170	movie	1644	2025-05-23	\N	2025-12-29 22:21:27.23-05	B+
One Battle After Another	R	one-battle-after-another	162	movie	1645	2025-09-26	\N	2025-12-30 22:59:22.708-05	A-
Stranger Things	TV-14	stranger-things	\N	show	1002	\N	t	\N	\N
Anaconda	PG-13	anaconda	89	movie	1626	1997-04-11	\N	\N	C
Regretting You	PG-13	regretting-you	116	movie	1646	2025-10-24	\N	2026-01-01 18:26:27.99-05	C+
Lake Placid	R	lake-placid	82	movie	1627	1999-07-16	\N	\N	D+
Wake Up Dead Man: A Knives Out Mystery	PG-13	wake-up-dead-man	144	movie	1636	2025-11-26	\N	2025-12-14 09:27:26.605-05	A-
Marriage Story	R	marriage-story	137	movie	1628	2019-11-06	\N	\N	A-
Shakespeare in Love	R	shakespeare-in-love	123	movie	1629	1998-12-11	\N	\N	B+
Modern Times	G	modern-times	87	movie	1648	1936-02-25	\N	2026-01-04 17:59:29.177-05	B
\.


--
-- Data for Name: media_cast; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_cast (media_id, actor_id, ordering) FROM stdin;
1480	64	1
54	58	1
54	233	2
54	274	3
54	34	4
54	138	5
54	480	6
54	218	7
953	765	1
953	150	2
953	1074	3
953	1274	4
1468	173	1
762	376	4
923	399	6
746	153	1
953	937	5
447	136	6
447	334	7
211	147	1
953	1231	6
1231	42	1
762	478	6
1231	209	3
586	338	2
762	184	7
762	584	8
953	829	7
762	337	10
762	341	11
164	2254	5
830	486	1
855	2254	7
830	242	3
188	78	7
188	366	8
586	579	5
54	686	9
830	653	4
830	731	5
33	2255	3
912	2256	8
1100	1065	2
830	781	8
830	346	9
1100	1368	5
372	388	1
1100	366	6
372	65	2
913	2256	6
1447	2256	3
181	2256	6
341	2257	4
341	2258	6
398	2258	3
830	855	15
349	340	1
682	2259	2
830	931	17
830	934	18
830	935	19
515	2260	6
1466	2260	6
942	2262	5
652	2263	5
29	2264	7
28	2264	8
25	2264	8
1125	2264	8
338	2265	5
1224	2266	4
410	2267	4
1318	2268	4
990	2270	8
823	2271	5
144	2272	4
1253	2273	5
1156	2274	2
762	720	9
586	724	1
1468	775	7
372	921	3
317	936	2
762	940	5
1468	940	6
830	992	20
923	1105	3
54	1115	8
830	978	21
54	1190	10
317	1226	1
1378	2275	8
586	2276	4
1098	2279	3
1097	2279	3
1536	2279	5
331	2280	2
138	2281	1
1230	2282	1
1231	2282	2
1232	2282	1
1158	2282	11
115	2283	7
19	2284	3
1085	2285	6
1212	2286	4
549	2287	5
1468	2289	2
464	2289	3
492	2289	5
986	2289	1
1077	1025	7
830	474	22
941	2289	4
1153	2289	1
1154	2289	1
1236	2289	1
661	2289	11
816	2290	7
433	2291	9
360	2292	7
49	2294	8
112	2294	6
843	2294	3
1224	2294	5
235	2295	3
54	1235	11
317	1291	7
415	1304	5
1410	2295	2
519	2295	8
709	2295	6
396	2295	9
168	2295	8
55	2298	3
56	2298	5
599	2300	9
602	2300	10
942	2301	7
1412	2302	7
1418	2302	3
1104	2303	1
1253	2304	4
1428	2305	2
685	2306	3
1103	2307	1
32	2307	2
861	2308	6
99	2343	1
577	2343	1
1148	2343	3
1114	2343	7
578	2343	1
101	2344	1
293	2344	4
1550	2345	6
684	2345	4
566	2346	4
594	2347	7
1070	2349	3
256	2350	4
459	2352	5
208	2353	5
1052	2354	5
1326	2356	4
680	2357	4
213	2358	3
16	2359	1
762	1406	3
300	1453	1
151	2359	4
223	2359	9
1125	2359	13
1152	2359	1
768	2361	3
340	2361	2
913	2362	4
1048	2362	2
393	2362	8
1222	2363	3
1076	2363	2
221	2363	2
211	1504	4
145	2363	9
760	2364	11
461	58	1
461	34	2
461	233	3
316	150	1
461	274	5
461	218	6
1193	79	1
461	138	8
461	480	9
316	765	2
1193	100	2
589	401	1
890	74	1
890	155	2
5	34	1
5	101	2
890	643	3
5	161	4
5	439	5
1193	213	5
1296	695	2
461	686	14
890	450	4
890	752	5
1230	2365	7
316	829	9
1231	2365	6
411	90	1
1232	2365	9
1367	473	8
1367	88	9
1230	2367	5
194	65	1
194	388	2
350	556	4
350	915	5
1232	209	4
1231	2367	7
1232	2367	10
983	2368	3
1083	2369	3
729	2370	5
350	860	11
1549	2372	8
649	482	1
649	65	2
649	39	3
350	509	13
649	787	5
649	566	6
649	959	7
273	2372	4
333	1059	2
1122	2372	2
333	220	4
170	2372	11
418	2374	1
311	2375	3
131	2376	3
661	2377	5
331	2380	1
777	2382	4
1188	2383	5
1232	134	11
1522	2383	8
1516	2383	9
1190	164	1
1187	2383	6
769	2384	3
93	2386	4
1190	405	5
693	2387	1
468	2387	1
1442	2388	6
369	2388	6
129	2392	6
1480	826	3
417	2393	3
988	864	6
1232	948	12
461	987	4
988	1002	3
461	1007	11
461	1115	10
1232	1125	6
988	1158	1
1190	1172	2
461	1190	7
461	1235	13
832	1238	1
496	2394	10
987	2395	8
486	2395	5
194	1294	3
499	2397	10
169	2398	5
50	2399	5
1013	2399	8
560	2399	4
1287	2400	7
1203	2400	11
358	2400	8
1152	2402	5
804	2403	8
298	2404	4
1455	2406	10
862	2406	2
100	2406	6
7	2408	6
654	2411	2
1013	2415	6
1001	2416	4
943	2418	4
491	2418	1
1069	2422	1
629	2422	2
1052	2423	4
531	2424	3
763	1319	2
1055	2424	4
1024	2425	4
451	2427	4
819	2428	2
396	2429	6
1547	2431	2
751	2431	1
230	2432	7
523	2433	4
1404	2434	5
1368	2435	4
1369	2435	4
1370	2435	4
1371	2435	5
1386	2435	3
978	2435	2
1412	2436	6
1554	2436	2
1526	2436	4
525	2437	6
277	2437	15
1157	2437	6
1303	2438	6
859	2440	10
817	2441	6
1345	2442	6
178	2444	5
1130	2444	4
741	2444	4
1205	2445	4
663	2445	5
1184	2445	5
818	2446	5
29	2446	5
28	2446	7
36	2446	6
1014	2446	6
25	2446	4
1125	2446	4
418	2447	2
507	2447	5
1177	2449	5
484	2450	2
910	2450	7
1082	2450	5
280	2451	10
1532	2451	9
1367	1386	3
1143	1506	6
470	2453	7
589	2454	4
126	2454	4
616	2456	1
395	2457	3
756	2458	5
955	2459	1
1074	2460	5
1463	2461	2
658	2461	4
263	2461	8
1191	2462	2
1190	2462	3
699	2462	3
176	2463	5
730	2464	5
731	2464	4
460	58	1
460	34	2
460	233	3
460	274	4
460	218	5
924	109	1
460	194	7
460	127	8
460	480	9
1478	64	1
1478	281	2
1478	172	3
1478	392	4
1415	150	1
1194	79	1
4	469	3
1415	765	2
1194	122	2
437	125	1
437	317	2
437	44	3
1467	104	1
1467	58	2
525	184	4
1467	156	3
1344	563	2
1344	51	1
1467	334	4
1424	2466	3
229	526	2
831	2467	4
229	825	4
460	686	14
1467	93	7
437	971	6
1292	93	13
437	685	7
437	827	8
247	2468	9
1113	42	4
1113	695	5
1113	609	6
1113	91	7
1415	829	12
257	556	4
375	1375	1
1302	2469	4
825	2470	3
24	2470	2
482	2470	3
257	458	8
285	2471	2
257	915	10
257	860	11
229	932	5
229	762	6
257	509	12
410	2472	2
638	2474	4
20	120	1
1364	2475	6
1003	2476	3
20	1138	4
1256	56	1
1256	614	2
1256	300	3
1303	2476	7
1304	2476	4
1099	2477	7
1256	276	7
1305	2477	5
23	2478	2
518	2478	3
1463	2478	6
1299	2478	3
296	2479	6
120	2480	3
488	2480	2
1191	164	1
1478	730	7
712	746	5
1191	405	4
1467	787	5
1113	787	8
1191	83	7
122	2480	2
1292	820	12
1113	832	9
1113	905	10
1113	948	3
4	976	2
460	1115	10
525	1123	5
712	1137	3
1194	1162	6
460	1190	6
1478	1221	5
460	1235	13
712	1238	1
1344	1259	6
1194	532	5
124	2480	2
1097	2481	6
1194	207	8
889	256	1
889	479	2
1098	2481	6
374	2482	2
195	2482	3
1530	2483	3
979	2483	8
887	2483	3
830	2484	10
650	2485	6
989	2486	4
990	2486	10
869	2487	6
771	2488	3
349	2488	2
847	2489	7
152	2489	9
1553	2490	6
1093	2490	3
1177	2493	6
1312	2494	14
545	2495	7
1106	2496	7
1403	2497	5
539	2498	7
1384	2499	2
138	2501	4
1106	2502	8
1503	2503	5
346	2503	4
162	2503	5
72	2503	5
694	2504	4
808	2505	5
480	2505	2
471	2506	7
621	2506	4
1374	2507	4
709	2507	11
1097	2511	7
1098	2511	7
1164	2512	9
921	2513	7
1161	2513	4
689	2514	7
1050	2514	6
317	2516	4
1171	2518	4
33	2519	1
1079	2520	6
1213	2521	6
1571	7588	1
1571	5025	2
1571	7589	3
1571	7590	4
1571	4519	5
1571	7591	6
1571	5037	7
1571	7592	8
1571	2018	9
1571	287	10
1344	1420	3
1500	1478	1
1480	137	4
850	49	1
1195	78	1
1384	1243	1
912	651	1
227	317	1
283	246	5
485	445	1
850	204	8
485	90	2
227	237	2
227	129	3
912	36	2
1408	56	1
227	458	4
164	42	1
164	695	2
345	388	1
304	150	2
55	383	7
912	434	4
850	539	2
1500	554	4
1408	569	3
227	685	5
1416	404	7
1416	287	8
1572	7595	1
344	1283	2
344	201	3
850	1364	9
1572	2956	2
164	50	10
1572	7596	3
1572	7597	4
1572	2990	5
1572	7598	6
1572	1138	7
344	1361	6
1572	4417	8
344	307	8
665	107	4
665	120	6
665	949	7
665	1202	10
665	445	11
164	787	9
164	794	8
164	805	6
1416	822	9
283	875	4
283	1059	2
850	1085	3
1195	1153	8
850	1227	5
485	1248	4
876	1307	2
1195	613	9
876	237	5
587	3106	6
392	3107	5
558	3108	2
198	3108	3
84	3109	5
85	3109	8
1016	3109	8
474	3110	3
861	3111	9
457	3114	7
655	3115	3
464	3116	8
1013	3119	7
960	3120	7
172	3136	5
1416	1395	2
173	3136	5
1148	3136	4
837	3136	11
509	3136	3
652	3139	6
154	3140	2
311	3140	4
273	3141	8
404	3141	9
1426	3142	3
1156	3143	1
1390	3144	1
877	3145	5
1230	3146	6
584	3148	3
1393	3149	1
362	1432	1
448	1433	5
448	1435	3
1384	1480	8
1195	1517	7
449	143	1
1213	80	1
279	1172	1
913	651	1
1213	126	2
226	106	1
226	101	2
226	56	3
449	596	5
1213	344	5
449	523	6
913	36	2
279	387	5
279	488	6
987	1345	7
933	491	2
338	388	1
808	513	4
1403	599	3
987	619	11
808	621	3
1155	1365	2
1403	56	1
1403	474	2
855	42	1
855	695	2
169	3151	6
1253	3153	13
317	3155	10
808	106	1
808	463	2
117	3155	9
715	3156	2
164	3159	7
855	3159	6
13	3159	9
439	651	1
855	153	9
439	1247	2
439	834	3
940	283	6
439	393	5
439	599	6
439	1179	7
1258	3159	5
652	3160	3
32	3161	6
420	3162	4
419	3162	3
650	3162	5
19	3162	5
172	554	7
172	366	8
632	3164	7
1393	3167	4
132	3168	5
1177	3169	1
519	3170	12
1358	3171	4
689	3171	2
1196	3171	8
1130	3171	10
824	3172	5
341	3174	12
323	3175	4
1203	3176	10
143	3178	7
682	3179	5
544	3180	4
855	787	8
855	805	5
987	903	3
1213	935	7
449	974	4
1213	1038	4
933	1124	1
980	1160	4
1403	1186	4
471	1239	6
449	1254	2
226	105	4
226	374	5
615	3181	9
226	685	6
980	49	1
418	3182	4
980	317	3
470	3182	4
507	3182	8
335	3183	3
179	3184	3
1236	3184	9
976	3184	7
752	3185	4
1121	3186	4
535	3189	5
1396	3191	3
974	3191	3
975	3191	3
471	3191	3
621	3191	1
1274	3193	3
1390	3194	4
1545	3195	8
777	3195	2
935	3195	4
320	3195	6
1362	3196	5
428	3197	3
451	3198	9
1253	3199	12
990	3200	14
296	3202	5
399	3202	6
537	3205	4
772	3206	6
445	3206	5
428	3207	9
9	3209	7
713	3210	2
1320	3211	4
1157	3212	4
1263	3213	4
278	3213	3
1264	3213	4
1253	3214	11
1253	3215	3
484	3217	6
1244	3217	3
594	3217	11
126	3217	6
231	3217	10
1281	3217	6
479	3217	10
101	3217	2
1400	3218	1
1401	3218	2
1130	3219	11
51	3220	2
29	3222	4
577	3222	4
99	3222	2
578	3222	4
818	3222	2
787	3222	6
28	3222	6
36	3222	5
1014	3222	5
25	3222	3
1125	3222	3
859	3222	7
263	3223	6
656	3225	5
1000	3227	9
885	3227	6
923	3227	4
626	3227	17
627	3227	15
884	3227	9
567	3227	7
869	3227	5
1284	3228	6
169	3229	4
632	3230	8
880	3231	7
196	3232	9
877	3233	3
243	3234	7
241	3234	12
143	3235	6
839	3235	6
510	3236	6
756	3237	6
349	3238	5
771	3238	4
360	3238	6
1097	3239	1
1098	3239	1
471	1389	4
279	1432	2
35	1432	1
1338	3240	2
487	3243	6
1113	3244	1
164	3244	3
723	157	1
450	134	1
213	167	2
330	388	1
1117	46	2
1270	1172	1
11	143	1
11	58	2
11	374	3
1270	1100	5
450	330	8
450	232	9
524	314	2
524	338	3
1117	232	4
1117	629	5
1117	70	6
1270	142	6
1145	51	1
855	3244	3
1117	129	9
66	3245	2
801	362	1
801	190	2
245	3246	5
801	231	3
801	255	4
129	3246	2
917	3247	6
937	607	1
937	232	2
604	418	1
604	172	2
1088	464	1
1088	131	2
1088	261	3
604	47	3
1088	440	5
641	654	1
641	135	2
604	282	4
191	3247	3
604	878	6
1573	3993	1
1573	1678	2
1573	2723	3
1573	7599	4
1573	4130	5
1573	2998	6
1573	1189	7
1573	2725	8
1573	2302	9
1573	3072	10
1573	3930	11
1573	3936	12
1573	3373	13
1573	7600	14
1573	414	15
524	734	1
981	948	8
801	1044	5
1239	1112	3
1117	1121	3
1239	1143	5
1573	282	16
981	1179	6
450	1213	5
1088	1221	4
621	1239	13
981	473	4
937	1261	3
981	114	7
981	163	9
981	180	10
981	183	11
11	158	4
11	148	5
11	685	6
937	1266	4
11	343	8
1067	46	8
621	1389	10
1239	1431	6
1270	1432	2
1239	1457	2
1243	26	1
403	134	1
403	265	2
1362	448	1
151	100	2
151	282	3
373	65	1
1107	314	2
1107	338	3
1107	229	4
1107	135	5
1503	157	1
6	150	1
228	287	2
403	330	8
228	626	3
228	541	4
1362	410	6
1362	1190	7
587	466	1
616	1358	6
373	1362	2
1574	651	1
1519	157	1
1574	962	2
1574	298	3
1530	831	11
1540	651	1
938	591	8
938	100	9
1574	2046	4
1540	794	3
210	587	3
210	252	5
169	82	1
1448	1262	1
1540	933	7
1448	307	6
373	708	7
1107	734	1
1107	743	6
373	770	6
1243	872	2
403	937	9
1243	961	3
373	1043	4
587	1056	8
938	1124	1
347	1156	1
373	1174	8
403	1213	7
373	1223	5
587	1335	2
228	957	5
1553	233	1
1553	614	4
1553	196	7
151	401	13
451	24	1
451	30	5
1540	1485	2
1556	333	8
1556	689	9
1559	74	1
1559	453	2
1559	237	3
1559	186	5
1562	1103	5
885	2785	2
683	2785	4
623	2785	5
1118	2785	5
1110	2786	4
1196	2786	2
1027	2786	2
4	2786	6
1553	2786	5
1526	2786	3
219	2786	5
220	2786	3
1379	2786	3
758	2787	7
1140	2788	4
710	2788	7
1128	2789	5
66	2789	3
1454	2789	5
1077	2790	6
888	2790	2
519	2791	9
709	2791	8
864	2792	4
300	2793	5
1570	64	1
1570	125	2
1570	121	3
1570	40	4
1570	851	5
1083	2796	6
1570	459	7
1570	440	8
828	2797	7
830	2798	14
353	2798	8
845	2800	1
390	2800	5
591	2800	7
1463	2801	5
188	2801	2
1206	2801	2
492	2802	6
1340	2802	5
1139	2803	1
443	2805	3
833	2806	7
1398	2806	5
1142	2807	3
945	2808	4
487	2809	3
891	2809	4
1369	2810	7
1370	2810	7
685	2810	1
1326	2810	1
751	2810	5
3	2811	4
70	2812	7
867	72	1
867	34	2
755	90	1
404	134	1
404	532	2
404	265	3
755	547	5
404	612	4
1259	150	1
867	127	10
867	631	9
1009	157	2
788	317	1
788	191	2
1009	359	7
788	68	3
1259	683	5
788	313	4
788	822	5
788	140	6
1290	725	1
1290	1220	2
273	644	2
1290	87	3
1290	839	4
1290	1092	5
1290	675	6
1530	138	12
273	393	7
1541	371	1
93	176	10
93	312	11
702	421	1
702	372	2
702	634	4
702	511	6
702	319	7
1006	320	2
273	395	11
114	187	1
114	459	4
682	65	7
404	734	7
702	748	3
702	749	9
93	767	9
114	792	3
114	838	2
114	871	5
702	939	5
682	1099	6
702	1120	10
1009	1125	6
1097	1128	8
1446	1137	2
1009	1160	8
682	1218	3
682	1240	1
273	1283	10
93	1320	5
273	1331	1
1541	805	4
1550	143	1
1550	370	2
1550	528	3
1554	607	1
1557	402	1
1557	126	2
1557	132	3
1563	256	1
1500	42	7
1421	125	1
158	70	1
1071	134	1
1335	569	7
767	157	2
1421	660	2
1503	897	4
1510	644	3
158	393	5
767	359	8
663	70	1
663	204	3
663	278	4
1542	371	1
663	409	7
663	272	8
1071	265	4
1302	344	5
1442	138	1
1071	209	10
1358	317	1
1358	140	2
1358	822	3
1551	90	1
1358	522	5
1551	40	2
195	353	1
165	421	1
165	372	2
1358	232	7
165	634	4
165	319	5
825	539	1
1551	128	3
165	533	8
1122	393	5
1551	424	4
825	915	4
1122	168	8
1551	290	5
825	739	6
825	204	7
165	178	11
195	242	5
1442	196	7
195	668	7
165	748	3
1442	760	4
165	805	12
158	888	2
767	908	6
663	923	10
165	939	6
1400	961	2
1164	984	8
663	1085	2
767	1125	7
1098	1128	5
1071	1325	9
640	1256	3
1551	396	6
1555	132	1
1555	1172	2
1555	1007	3
1555	716	4
1555	140	5
1558	167	1
1558	233	2
1558	173	3
1558	915	4
1558	246	5
1561	992	4
1561	203	8
1564	750	3
1564	80	6
1335	1399	4
1164	1427	3
158	1466	3
1425	1478	1
134	70	1
59	70	1
463	339	3
1200	7	1
1200	706	2
464	480	4
1503	282	3
59	393	8
1543	371	1
464	282	13
1244	675	5
1552	90	1
1200	536	7
363	482	1
363	166	2
363	409	3
1552	98	2
268	8	1
268	545	4
826	29	1
826	598	2
826	807	7
826	1337	11
1401	320	1
134	204	5
374	353	1
374	242	4
134	409	7
134	272	8
76	421	1
76	748	2
994	775	2
994	806	1
363	905	4
59	915	4
134	923	10
76	939	4
786	1024	4
76	634	3
76	319	5
134	1085	2
464	1195	6
76	338	8
405	1243	7
363	1243	5
786	568	1
786	515	2
786	1	5
1565	918	18
1565	928	19
134	1404	6
464	1463	11
59	1466	2
1565	1478	1
464	1480	12
1200	1501	6
58	70	1
1176	233	3
1176	243	4
406	69	2
1176	480	7
1425	105	6
58	220	6
1526	948	5
1425	554	4
1176	708	6
833	514	1
58	393	10
94	482	1
142	65	1
230	96	2
230	347	3
230	472	4
230	278	6
77	421	1
77	372	2
77	634	4
230	740	8
77	319	6
1260	247	1
1003	679	2
1003	265	7
809	229	8
1313	257	5
1313	434	6
1313	629	8
1313	100	9
214	722	3
77	748	3
142	833	5
406	843	1
94	869	2
58	888	7
58	915	4
1003	931	5
77	939	5
94	1000	5
1003	1079	4
1313	1160	4
809	1192	7
809	1248	1
676	317	2
676	237	3
676	183	5
1176	46	9
214	1423	5
58	1466	2
157	70	1
681	65	1
1511	573	1
1519	158	8
215	426	1
215	166	2
184	482	1
1389	283	7
1475	189	2
1475	344	3
215	305	5
1022	522	2
1389	554	5
215	575	3
1022	581	1
215	301	6
1285	365	1
166	421	1
1285	869	2
166	372	2
1285	1373	3
166	634	4
166	319	5
1475	665	5
1285	1022	4
416	65	4
1285	600	5
1007	655	3
1285	530	6
666	1042	1
666	25	2
1475	403	7
1475	275	8
666	918	4
666	179	6
1274	123	4
681	698	7
416	311	6
416	591	7
1274	718	2
1025	734	1
1060	64	1
1060	457	2
1060	611	3
1060	212	4
1060	402	5
1060	404	6
1060	145	7
1060	400	8
1334	746	4
166	748	3
215	754	7
681	833	5
1334	843	1
416	849	11
1342	853	4
184	869	2
157	888	4
1475	888	10
215	927	4
1475	933	1
166	939	7
1007	1098	2
157	1121	2
184	1184	6
1274	1206	1
438	193	1
438	213	2
438	366	3
438	1151	4
438	126	5
438	293	8
438	83	10
1546	1189	8
1566	918	21
1566	928	22
1546	1395	1
1389	1478	1
1566	1478	2
666	1487	3
184	1500	7
216	166	1
156	70	1
724	86	1
156	509	2
205	282	2
724	408	3
1501	160	1
1108	167	1
1108	247	2
914	1345	4
95	482	1
95	181	5
1547	65	1
1286	365	1
797	65	1
95	183	9
1286	869	2
78	421	1
78	372	2
1286	855	3
1286	600	4
1286	1373	5
1286	370	6
1286	870	8
1275	123	4
440	78	5
440	366	6
78	634	4
78	319	5
78	214	8
1275	718	2
1108	730	4
724	744	6
78	748	3
1008	774	3
1108	816	6
797	833	4
1347	843	1
78	849	10
95	869	3
156	888	6
95	911	10
1061	64	1
78	939	7
1026	949	3
78	961	9
1026	1085	1
1008	1098	2
1008	1138	10
1061	404	8
1108	1141	3
724	1158	4
724	1180	2
95	1184	6
1275	1206	1
12	173	1
12	1319	3
12	108	5
12	265	6
12	307	7
12	304	8
1567	694	1
1567	868	4
724	1376	7
95	1500	7
945	221	1
920	164	1
265	55	3
265	404	4
945	408	3
596	166	1
920	40	2
911	651	1
920	282	3
596	297	4
566	14	1
802	90	1
1166	591	2
566	561	6
802	233	3
802	620	5
701	270	2
701	433	3
596	613	3
945	614	2
596	641	2
288	365	1
288	869	2
288	647	3
701	564	4
701	241	5
701	354	6
701	425	7
701	353	8
701	634	9
701	319	10
701	421	11
288	1231	4
757	1349	2
757	1082	3
680	290	7
680	274	8
1127	215	12
1127	607	13
265	769	7
1181	785	5
1501	836	2
143	873	1
1062	874	6
802	914	4
701	931	1
265	932	5
1132	943	4
566	999	3
1127	1023	11
566	1041	7
911	1083	6
1062	64	1
1062	298	2
1062	404	3
1062	605	4
1166	1090	1
143	1113	3
1062	265	9
1166	1130	5
1062	1247	7
527	950	5
1568	437	1
1568	1085	2
1568	949	3
1181	1384	6
1548	1386	3
407	1457	2
946	221	1
1096	2	1
738	166	1
877	340	2
1325	441	4
738	140	2
1325	108	6
1325	256	7
946	238	5
1325	64	8
773	1359	7
486	77	1
486	279	2
1288	365	1
738	383	3
738	295	4
1096	439	6
773	521	3
773	583	2
1288	869	4
738	242	6
738	467	7
1288	1373	5
1288	870	6
516	270	2
1288	845	7
773	340	5
1288	40	8
516	433	3
410	353	1
516	564	4
516	241	5
516	354	6
516	425	7
516	224	9
516	321	10
564	143	1
564	199	2
564	89	3
1438	63	6
1063	64	1
48	279	11
48	237	12
1325	727	1
1096	729	5
365	746	6
1325	782	3
1096	789	2
773	859	1
839	873	1
516	931	1
1501	969	3
839	1113	2
1438	1219	4
486	1229	3
516	1288	8
1096	1304	3
1262	1028	1
1262	732	2
1262	8	5
1569	34	1
1569	298	3
1569	472	4
48	1457	2
1096	1467	4
1374	12	1
467	173	1
1051	217	1
89	123	2
472	91	4
467	197	3
472	339	6
467	281	4
472	33	8
467	457	6
472	249	10
467	191	8
467	708	2
472	106	12
647	297	3
1051	230	2
599	95	2
487	358	5
89	458	8
79	270	2
79	433	3
79	564	4
79	241	5
667	90	1
667	532	2
1051	570	5
667	554	3
1235	441	1
1235	121	2
1235	87	3
1235	683	4
667	142	11
667	283	12
79	354	6
79	425	7
79	478	8
522	143	1
522	89	2
599	740	3
89	750	3
522	832	3
1051	858	4
376	873	1
467	914	5
79	931	1
599	215	5
324	965	3
79	986	10
647	1001	4
1051	1003	6
1064	64	1
1374	1012	2
89	1023	7
1064	404	4
1374	1073	3
376	1113	2
1064	191	7
472	1138	5
472	1167	2
324	1172	2
647	1178	1
599	1183	7
487	1208	4
472	1254	11
487	1280	1
472	1334	9
278	796	1
278	1332	2
278	500	5
278	735	7
667	1385	6
487	1433	9
599	1457	1
647	1484	2
324	1494	5
1052	217	1
842	130	3
1052	230	2
989	91	5
1504	199	4
989	290	7
600	95	3
600	126	4
1049	34	8
853	358	5
700	270	2
1221	347	9
842	679	2
1086	90	1
1129	72	1
1086	838	2
1086	1187	3
1129	119	4
700	433	3
700	564	4
700	241	5
700	425	6
700	354	7
523	143	1
1086	712	4
523	67	3
366	51	1
944	568	3
366	252	4
366	663	6
944	814	6
944	551	8
944	291	9
346	150	1
346	157	2
346	514	3
842	718	1
1052	737	6
600	740	2
1129	868	6
523	926	2
700	931	1
1221	937	8
366	1105	3
989	1138	3
989	1167	2
600	1183	6
853	1191	3
1049	1227	7
842	1230	4
1049	1288	9
366	1297	5
600	473	9
600	215	10
1065	64	1
1065	404	3
1065	195	7
1065	191	10
298	1380	2
853	1433	1
600	1457	1
989	1485	6
1159	117	1
1159	570	2
455	217	1
455	230	2
845	514	4
693	196	4
443	51	1
693	48	5
884	140	7
443	322	5
693	158	11
193	605	3
1481	1170	4
1481	443	8
98	309	3
231	1326	1
884	372	12
81	193	1
1511	791	5
81	481	7
81	204	8
231	224	8
1035	568	3
1035	551	6
1035	291	7
624	718	1
443	719	2
602	740	4
693	746	8
693	829	10
624	842	4
455	858	3
818	871	6
884	1014	2
624	1064	5
845	1137	3
602	95	3
602	1156	9
845	1160	5
602	1183	7
312	1210	7
624	1220	3
624	1230	2
602	215	11
312	64	1
312	404	3
312	611	10
884	1396	11
193	1425	5
120	1433	1
120	1438	5
602	1457	1
1261	8	1
588	1346	7
848	51	1
287	404	4
287	50	5
813	51	1
287	39	6
408	196	3
848	104	2
813	291	7
848	457	3
848	196	5
819	637	1
287	651	1
1505	78	1
1505	1248	12
367	123	1
367	39	2
588	472	3
367	166	3
588	444	5
171	207	1
367	398	4
171	282	2
171	122	3
171	50	4
171	950	6
1000	462	10
170	143	1
543	164	1
543	330	3
543	560	4
1261	732	4
1261	796	2
367	808	5
588	818	6
848	849	7
488	881	5
468	949	6
170	1049	10
875	95	7
488	1106	6
287	1108	3
784	1159	1
408	1172	2
170	1278	8
784	703	2
813	1395	2
813	1402	4
848	1411	6
488	1433	1
875	1457	1
784	1497	4
820	66	1
1281	150	1
1265	164	1
1265	412	2
1281	224	4
1265	204	3
1404	225	3
217	59	3
820	279	6
820	289	7
315	168	1
315	100	2
315	472	3
409	367	1
409	239	2
409	88	3
409	187	4
1404	696	2
1505	820	10
232	134	1
1505	1286	16
456	51	1
456	457	2
409	470	7
409	100	8
732	472	5
409	406	11
456	104	3
456	290	4
456	361	8
711	89	1
711	143	2
38	123	1
38	39	2
38	166	3
38	398	4
38	728	6
409	752	9
1265	755	5
409	790	10
1404	801	1
38	808	5
732	818	6
820	835	3
820	847	4
38	852	7
122	881	4
1265	1081	4
1281	1213	2
1482	1278	5
1265	1281	6
732	1395	4
456	1411	6
122	1433	1
1404	1439	7
1012	1517	4
473	198	1
127	330	2
473	232	2
473	146	3
686	367	1
686	344	2
686	333	3
334	149	1
124	659	4
124	77	5
1029	164	2
336	287	1
336	80	2
1029	42	5
336	266	3
334	635	3
336	1367	7
1505	478	2
314	205	1
182	292	1
336	234	4
336	312	6
182	438	3
822	134	1
822	1299	3
822	479	4
1101	228	2
37	613	5
1101	742	3
1101	338	4
1101	461	7
314	59	2
127	767	3
275	775	3
686	1161	6
686	1219	4
334	1233	2
127	1244	1
124	1433	1
127	1457	5
1101	1499	1
182	1508	5
656	549	1
128	330	2
990	193	2
49	231	3
990	86	6
1505	88	6
49	470	7
971	651	1
1528	291	1
13	134	1
922	567	4
580	651	1
13	1299	11
750	148	1
1419	686	5
546	722	5
1184	38	8
689	478	5
1184	283	13
775	100	4
607	728	5
990	731	7
128	763	6
128	767	3
971	794	2
689	252	9
977	795	4
1419	820	1
1319	828	4
720	841	7
1319	851	5
607	852	4
977	858	7
775	878	1
922	884	3
546	890	4
990	932	12
971	963	4
990	1391	1
990	1429	3
1513	1457	2
971	1485	3
909	441	1
683	330	2
909	134	2
1297	1374	14
909	565	3
1505	232	5
337	651	1
382	33	4
382	592	5
382	621	6
382	705	8
337	1192	5
382	707	9
729	197	1
1369	488	9
733	34	1
382	305	10
50	470	6
50	88	7
921	1247	1
703	287	1
703	80	2
382	409	11
1297	728	12
683	763	5
921	337	8
683	767	3
703	266	3
703	610	4
703	6	5
1297	123	10
1297	39	11
1460	471	8
909	840	4
1297	852	13
382	918	13
1460	1090	7
874	1101	6
1369	1181	3
92	1418	7
874	1433	1
92	1495	4
874	1496	4
730	197	1
388	330	2
1505	1112	4
233	49	1
388	112	6
780	239	3
780	88	4
780	367	5
420	457	2
1528	1279	3
780	470	8
1532	843	1
233	1227	5
233	347	7
657	308	3
668	551	3
1151	127	1
614	287	1
614	80	2
614	266	3
668	1273	4
668	824	7
1370	488	9
614	234	5
614	650	6
614	376	9
206	166	2
206	366	5
840	46	4
840	33	5
840	592	6
840	621	7
840	705	9
840	409	11
730	739	6
420	740	1
388	763	7
388	767	3
657	811	1
840	918	13
614	971	4
1352	1112	3
1352	1126	6
840	1158	10
851	1238	1
657	1268	2
614	1392	7
687	173	1
623	330	2
1505	104	7
623	112	7
984	695	2
1528	189	4
1532	760	2
984	167	6
1298	140	1
995	646	2
1371	488	10
687	307	8
687	108	9
704	287	1
704	80	2
704	266	3
704	234	5
704	650	6
704	376	9
131	255	6
766	50	1
1298	400	8
1298	87	9
766	453	7
381	592	4
381	126	7
381	409	8
381	444	12
381	445	13
419	719	4
687	719	10
419	740	1
1298	740	2
623	763	8
623	767	3
1298	771	6
687	818	11
766	822	6
984	884	4
419	897	6
381	918	10
381	923	11
221	928	5
1410	929	3
984	933	1
1298	940	7
984	953	3
704	971	4
381	1032	5
995	1058	3
131	1108	1
419	1153	5
766	1181	5
1298	1212	5
1298	1216	4
995	1283	10
131	1306	2
995	1314	1
687	1319	7
704	1392	7
131	1394	5
419	1408	7
1449	197	1
1378	478	1
555	90	1
1378	531	3
1378	569	4
1449	613	6
1204	684	6
1225	317	1
1225	820	3
622	228	7
849	189	4
633	77	5
849	694	5
849	167	7
606	207	1
132	255	6
856	366	1
856	120	2
1378	313	7
652	477	8
856	132	3
1172	87	1
856	234	6
1172	976	2
856	188	8
856	376	9
606	437	2
1172	279	3
652	1072	10
1172	994	5
1172	585	6
378	592	4
378	78	5
982	102	1
982	383	8
378	126	9
378	409	10
633	727	2
1378	729	2
856	793	5
1449	863	2
378	918	11
378	923	12
622	924	3
849	933	1
378	1032	6
606	1065	4
606	1151	5
378	1158	8
856	1185	4
622	1189	5
622	1283	2
849	1286	3
849	1319	2
652	100	13
652	234	14
652	328	15
1529	291	1
652	1389	4
856	1392	7
132	1475	4
132	1503	1
1483	591	4
1450	613	5
302	1347	2
1505	109	8
1142	942	1
1142	941	2
1450	197	1
985	167	2
1142	713	4
903	63	1
112	423	7
112	262	8
302	371	4
903	705	7
302	407	10
302	146	12
857	120	1
857	132	2
857	100	5
857	328	6
857	234	7
857	376	9
548	269	5
691	282	1
691	226	2
691	50	3
133	321	9
380	204	4
691	222	4
691	159	5
380	592	5
380	621	6
380	78	7
380	126	12
380	409	13
380	444	17
380	445	18
903	739	5
985	750	5
302	763	8
112	767	4
857	793	4
903	818	3
903	843	2
903	866	4
112	899	5
380	918	15
389	919	8
380	928	16
985	933	1
474	972	1
380	1032	8
903	1153	6
380	1158	11
634	1169	2
302	1194	5
634	1209	3
474	1217	2
548	1233	2
302	1237	6
985	1286	3
548	1290	1
857	1392	8
390	72	1
113	619	6
1505	123	9
1356	628	1
390	198	8
390	213	9
816	6	1
816	27	2
234	837	4
1289	232	3
234	120	8
959	365	1
959	1039	2
1356	85	7
959	312	3
959	1344	4
379	554	4
113	262	9
379	204	5
379	592	6
489	366	1
489	78	3
1380	165	8
489	619	6
858	120	1
858	132	2
858	100	5
858	328	6
858	234	7
858	376	9
816	653	4
816	375	9
52	226	1
52	282	2
52	50	3
52	361	4
379	621	7
379	409	9
379	444	12
1380	739	6
489	750	2
858	793	4
1380	818	7
816	859	6
113	899	5
816	906	8
379	918	10
379	923	11
545	959	9
922	977	5
379	1032	8
52	1132	8
113	1136	3
52	1147	7
858	1392	8
1380	1395	2
735	90	1
1017	161	2
1017	412	3
1017	306	4
1223	525	2
735	68	2
735	116	3
1223	673	5
1223	151	1
1506	107	1
1223	201	3
864	496	1
553	251	1
1514	135	2
1520	34	1
1529	189	5
792	48	7
958	365	1
958	1039	2
553	403	6
280	265	3
280	473	4
1280	168	2
1280	100	5
280	539	12
958	428	10
280	157	14
705	80	1
705	287	2
705	266	3
958	312	11
705	234	11
1139	669	3
735	436	6
735	394	8
1222	469	1
1222	440	5
841	204	4
841	592	5
841	621	6
841	78	7
841	305	11
841	409	13
841	444	17
735	777	5
1017	820	1
553	822	3
735	840	4
864	849	2
553	891	2
841	923	15
841	928	16
705	992	13
841	1032	8
1222	1098	4
841	1158	12
735	1197	7
1280	1227	4
60	1307	8
648	428	1
620	143	1
146	304	2
1506	837	3
648	133	5
1514	282	3
1058	229	2
1083	245	1
146	100	5
235	733	1
235	637	2
706	287	1
1399	3248	7
866	3249	4
1336	414	1
1083	97	2
249	51	1
706	266	2
207	325	3
249	66	2
249	347	3
249	50	4
249	404	5
207	70	6
207	254	7
249	357	6
616	3251	2
249	946	8
1055	3251	5
1291	3252	6
377	204	4
668	3253	5
471	3254	8
1148	3256	5
377	592	5
377	621	6
311	3257	2
377	78	7
127	3257	4
776	3257	12
93	3258	2
706	234	10
129	3259	5
459	3260	2
706	239	13
706	625	14
1037	366	8
1037	83	9
916	3261	4
1464	33	2
917	3261	4
1174	3262	8
613	3263	7
1126	3263	4
293	3266	7
1201	3268	3
877	3269	1
353	3271	7
394	3271	1
678	3272	2
29	3272	2
818	3272	1
28	3272	2
36	3272	2
1013	3272	2
1085	3273	4
831	3275	1
377	305	9
716	3276	5
377	126	11
377	409	12
912	3277	6
377	444	14
1304	3278	5
1464	737	4
146	746	7
648	755	2
834	820	2
1083	916	4
377	918	13
1500	3279	3
1425	3279	3
1389	3279	4
153	3279	5
382	3279	14
840	3279	14
381	3279	14
380	3279	19
379	3279	13
620	963	2
546	1005	2
1378	1020	6
841	3279	18
377	3279	15
1037	1025	2
955	3279	4
377	1032	8
1037	1098	4
834	1156	8
377	1158	10
1037	1307	3
207	1308	5
930	3279	5
931	3279	9
286	3280	7
393	3281	2
217	3281	2
837	3281	10
328	3281	2
168	3282	6
604	3283	5
1276	3283	4
115	3283	12
426	3284	6
632	3285	9
300	3286	6
1374	3287	5
759	3287	12
826	3288	9
880	3289	5
895	3290	1
1247	3290	1
1199	3291	4
280	3291	13
1089	3291	6
1092	3291	6
18	3291	9
328	3291	4
3	3292	5
851	3293	7
438	3293	9
39	3293	2
836	3293	11
1247	3293	3
390	3293	2
382	3295	3
840	3295	3
665	3295	1
381	3295	3
378	3295	3
380	3295	3
379	3295	3
841	3295	3
377	3295	3
1239	3296	1
557	3296	1
1225	3296	7
175	3296	10
664	3296	11
231	3297	6
995	3298	11
622	3298	1
457	3299	6
57	3300	2
233	3301	6
534	3301	7
581	3302	2
625	3302	12
722	3302	4
551	3302	4
1016	3302	13
667	3302	4
84	3302	9
626	3302	13
627	3302	12
838	3302	5
1058	1457	1
207	1462	2
242	3302	3
91	3302	4
213	3305	1
990	3308	15
213	3308	5
161	3308	10
100	3309	7
626	3311	15
627	3311	14
817	3311	2
919	3311	4
1170	3311	3
462	3312	6
651	3313	2
1433	3314	2
61	279	1
720	304	2
1419	558	6
1015	100	1
61	565	2
720	100	6
1566	3314	23
1170	3314	4
61	483	4
61	128	5
1506	46	2
61	617	6
1419	273	2
1419	41	3
297	3315	8
332	679	2
332	335	3
1419	230	7
344	3317	1
332	38	5
80	266	1
80	287	2
151	3320	10
1238	3320	4
1126	3320	9
153	3321	3
80	234	7
667	3321	7
1500	3321	8
80	689	10
1425	3321	7
111	77	6
208	254	6
368	47	1
1303	143	1
1303	312	2
368	165	2
186	132	2
368	77	3
1303	528	3
368	83	4
1389	3321	8
1019	3322	7
578	3323	8
292	3324	2
1058	3325	3
229	3326	3
186	415	11
186	96	12
737	3328	5
1303	992	10
1273	3329	3
1243	3329	4
337	3331	2
1038	78	5
1110	532	1
485	3331	5
365	3331	3
836	3331	4
612	3331	7
1015	414	2
1015	331	3
1110	439	8
530	3331	7
921	3332	6
761	3333	3
762	3333	2
759	3333	6
1015	412	6
760	3333	4
552	3333	3
1261	3334	6
559	3334	7
443	3335	4
942	3336	8
432	3338	2
438	3339	7
724	3339	8
1505	3339	15
1216	3339	2
1474	3339	6
766	3340	8
1015	345	7
1015	631	8
264	3340	6
582	3340	4
80	793	15
186	915	4
80	971	16
61	998	3
1038	1098	1
332	1117	4
846	1221	2
332	1230	1
80	1247	12
773	3341	8
1083	3343	7
1008	3344	11
530	3345	5
714	3346	5
1371	3346	3
859	3346	4
335	3347	5
769	3348	2
121	3349	5
1211	3349	7
37	3349	6
102	3350	2
1030	3350	2
373	3350	3
324	3350	4
719	3350	3
504	3350	4
239	3350	6
988	3351	5
561	3351	3
278	3352	6
756	3353	4
331	3354	6
249	3356	7
936	3356	3
123	3356	3
901	3356	4
292	3357	5
480	3357	1
337	3358	4
842	3358	6
154	3358	4
344	3359	5
310	3360	3
114	3361	6
888	3361	5
1056	3362	1
1120	3362	5
1059	3362	1
283	3362	3
597	3362	2
103	3362	7
1110	3362	2
531	3362	2
192	3362	2
1332	3362	2
8	3362	4
1183	3362	2
1530	3363	2
1222	3363	6
860	3363	3
696	3363	3
862	3363	3
1165	3364	2
1401	3365	5
108	3365	5
82	3366	3
1565	3366	20
1566	3366	24
1463	3366	8
165	3367	10
564	3367	4
992	3368	9
1015	1425	5
176	3369	4
1205	3370	3
205	3371	1
234	3371	2
492	3371	2
430	3371	4
1005	3371	1
230	3372	1
904	3372	6
1114	3372	4
135	3372	7
1228	3372	2
387	3372	5
1414	3372	6
1443	3372	7
232	3373	2
822	3373	2
13	3373	2
450	3374	6
1116	3379	4
223	3379	12
514	3379	9
1553	3379	12
496	3379	6
479	3379	6
977	150	1
977	394	2
977	88	3
1196	1363	6
187	1368	11
329	3379	4
547	147	3
62	265	5
1319	625	3
469	3381	3
490	679	2
490	335	3
907	3382	4
490	691	5
1351	708	1
3	325	1
977	656	10
490	148	8
1001	414	1
1001	432	2
1001	618	3
3	37	2
3	265	3
187	132	2
513	3384	10
1351	120	3
1351	914	4
187	644	6
1351	655	5
1351	909	6
1304	143	1
3	671	8
1304	1163	2
3	254	9
187	415	13
187	96	14
539	5	1
539	127	2
539	568	3
1007	3385	4
539	248	5
539	711	6
1520	509	5
1532	133	8
1304	991	6
1196	215	7
539	316	9
537	3386	1
175	3386	1
963	3386	1
664	3386	1
756	3387	1
1376	3388	4
229	3389	9
188	3390	1
669	3390	1
440	3390	1
222	3390	1
81	3390	2
838	3390	2
1155	3391	1
1106	3392	9
462	3392	4
727	3394	4
527	3395	4
717	3395	7
180	3395	8
87	3395	8
88	3395	8
954	3397	4
544	365	1
544	434	2
1106	3398	10
1090	3399	5
544	159	5
547	782	1
547	811	2
544	908	3
187	915	4
490	1000	6
539	1013	8
262	3400	3
680	3401	5
319	3401	8
62	1112	1
490	1117	4
490	1230	1
187	1331	7
1128	3402	2
992	3403	8
1401	3404	3
437	3405	4
393	3406	16
510	3408	7
214	3409	1
428	3409	11
1353	3410	4
207	3411	4
1390	3414	3
285	3415	3
884	3419	10
81	3419	3
1000	3419	11
885	3419	7
484	3420	4
692	3420	2
938	3420	2
1071	3420	2
1180	3421	5
1393	3422	2
709	3423	9
519	3423	13
259	3424	5
483	3425	3
160	3425	3
68	3425	3
69	3425	3
697	3425	3
159	3425	2
737	3426	7
628	3427	4
992	3428	5
361	3429	4
327	3430	9
815	3431	13
817	3433	3
496	3434	7
1013	3436	5
1516	3436	12
137	3437	6
744	3439	8
297	3440	4
1025	3442	2
1003	3443	6
1012	3443	8
836	3443	12
143	3444	4
839	3444	5
376	3444	3
992	3444	2
141	3446	3
7	3448	3
690	3448	8
1362	3454	4
919	3455	5
1221	3457	4
1221	3459	3
2	3461	2
1140	3461	3
269	3461	9
1008	3462	12
613	3463	4
894	3463	7
1548	3463	2
217	3463	4
1227	3463	7
896	3463	2
1126	3463	12
672	3464	6
186	3465	5
187	3465	8
403	3466	5
81	3466	6
515	3467	2
471	3468	10
621	3468	7
1291	3470	3
242	3471	6
930	3471	6
1351	1396	2
62	1495	3
931	3471	3
319	3471	4
350	3472	10
631	3473	7
388	3475	5
219	3476	3
1319	192	1
1319	211	2
900	3476	10
810	3477	5
1345	3478	3
1319	391	6
1319	151	7
847	3478	6
1506	824	5
1115	88	2
1115	394	3
152	3478	8
56	3479	8
431	254	1
861	127	1
861	248	2
1152	3480	8
861	316	3
861	69	4
1533	651	1
1135	3481	1
1112	3481	5
861	582	7
161	164	2
298	3482	1
1115	655	6
1115	672	7
1389	3484	2
1425	3484	2
39	3484	5
236	195	10
236	969	11
836	3484	5
1184	3484	7
571	454	1
571	358	2
571	407	3
571	566	4
571	291	5
1204	3486	3
571	308	7
910	3486	4
567	539	3
531	443	4
567	88	5
209	3486	2
119	3486	6
151	3487	12
567	96	9
932	3489	10
471	3490	2
611	3490	3
1021	3490	3
608	3490	3
650	3491	7
1372	3491	2
242	3493	9
1133	237	4
137	3494	5
131	3494	4
693	3495	2
1133	65	7
468	3495	2
787	771	1
1133	771	8
1018	782	1
1150	3495	7
835	3496	5
6	3497	5
317	3499	6
1116	3500	3
833	3500	2
892	3500	2
72	3500	6
162	3500	3
751	3500	2
329	3500	7
305	3501	8
66	3503	8
407	3505	7
1049	3506	2
193	3506	1
592	3506	2
991	3506	2
591	3506	3
1032	3506	2
1018	811	2
861	910	5
1039	1098	4
161	1158	3
1023	1159	9
571	1214	6
1133	1286	3
1039	1307	2
961	3506	2
393	3506	3
181	3507	7
817	3508	5
279	3509	3
1270	3509	3
834	3509	4
1119	3509	10
384	3509	3
1076	3509	6
1301	3509	5
1353	3510	6
525	3511	3
1077	3512	3
385	3512	4
307	3512	2
386	3512	5
487	3513	2
679	3516	3
638	3518	5
252	3518	2
253	3518	3
263	3518	4
635	3518	4
317	3521	8
1127	3522	7
1162	3522	4
25	3522	5
1125	3522	5
240	3522	2
563	3522	3
1251	3522	8
49	3523	6
780	3523	9
843	3523	4
74	3524	7
1143	3525	1
1007	3525	1
577	3525	2
99	3525	5
1008	3525	1
792	3526	4
694	3528	7
965	3529	3
1143	3530	2
1191	3530	3
155	3530	5
161	3530	6
301	3530	4
930	3530	7
931	3530	7
1181	3531	3
251	3532	3
151	3532	1
526	3532	7
186	3532	3
187	3532	3
567	3532	2
871	3533	7
1167	3533	1
1187	3533	4
1283	3533	1
1476	3533	9
135	3533	3
1179	3533	1
273	3535	5
1278	3535	2
1154	3537	9
1438	3538	1
1328	3538	3
434	3538	8
325	3538	1
39	3538	1
1423	3538	4
814	3538	3
1174	3542	1
708	3542	1
847	3542	3
152	3542	2
1035	3543	9
13	3543	3
1394	3543	6
146	3544	3
720	3544	3
900	3546	4
851	3546	3
1252	3546	1
1144	3546	2
1329	3546	3
695	3547	4
219	3547	7
434	3547	12
224	3547	12
1439	3547	6
243	3547	4
241	3547	5
1391	3547	1
440	3549	4
1564	3550	5
684	80	1
684	176	2
684	648	6
1034	3550	4
598	3550	4
670	3551	3
1130	193	1
1130	232	2
1470	193	2
432	254	1
1130	351	5
636	193	2
872	46	2
1470	213	3
306	3552	4
716	127	1
259	3555	1
1130	469	12
716	316	2
500	3556	3
716	274	4
1470	205	7
1533	515	2
948	56	1
198	3557	6
948	109	2
558	3557	6
1158	3559	3
512	3560	4
1308	262	1
1308	379	2
1308	342	3
1308	288	4
1308	636	5
1308	138	6
1308	426	7
434	3560	11
243	3560	5
1207	3560	2
1201	3561	4
1368	3561	5
636	63	6
636	132	7
716	267	7
716	701	8
716	597	9
1369	3561	5
823	339	11
823	195	12
1370	3561	5
1371	3561	6
1460	3565	2
95	3566	8
137	3568	2
597	1089	6
948	437	11
965	3568	4
1282	3569	5
528	3569	3
817	3570	4
1292	3571	7
193	3571	4
872	473	11
1130	771	3
1402	782	1
1036	3571	1
716	786	6
1150	3571	6
199	3571	7
1503	3573	6
1254	3573	1
276	3573	2
1175	3573	1
187	3575	10
1369	3575	1
502	3575	1
520	3575	2
934	3575	1
911	3576	3
920	3576	5
1062	3576	5
1065	3576	9
1321	3576	6
1337	3576	4
1019	3578	2
1394	3578	2
433	3579	3
1277	3580	2
636	3580	1
1308	792	8
1402	811	2
948	822	6
297	853	10
297	874	12
1130	902	8
1308	909	10
716	910	3
948	923	5
37	3580	7
186	3580	1
918	1081	7
918	1127	6
918	1155	3
948	1329	3
187	3580	1
567	3580	1
322	3580	1
530	3580	2
526	3580	4
434	3580	2
223	3580	4
224	3580	2
1443	3580	3
1444	3580	1
871	3580	1
1046	3580	1
983	3581	1
1141	3582	5
102	3583	5
1030	3583	4
499	3585	8
563	3586	4
707	3586	4
1211	3586	1
350	3588	6
257	3588	7
914	3588	1
834	3588	9
15	3588	9
371	3588	3
970	3588	3
932	3588	3
433	3588	1
224	3588	16
339	3590	5
1436	3591	4
188	3591	4
1398	3591	3
1010	3591	6
202	3591	5
1440	3591	6
606	3592	7
486	3593	6
1330	3593	4
1331	3593	3
1128	3594	4
880	3595	2
881	3595	2
882	3595	4
85	3596	6
1016	3596	5
371	3596	6
16	3596	5
676	3600	4
1313	3600	1
83	3600	3
793	3600	3
1171	3600	2
848	3604	4
456	3604	5
1346	3604	4
393	3604	5
706	3605	6
80	3605	6
350	3605	3
1009	3605	1
767	3605	1
1248	3605	3
705	3605	7
518	3605	7
870	3605	7
1032	3605	4
1126	3605	13
918	1496	2
948	1511	4
525	3606	1
277	3606	14
661	3606	3
660	3606	3
659	3606	3
97	3606	3
147	3607	6
1409	3608	9
514	3609	3
1221	3609	5
392	80	1
342	621	1
392	572	2
1507	69	2
1084	140	1
1084	149	2
1084	632	3
90	215	2
968	1122	3
1514	142	4
1522	645	2
812	1183	5
492	1248	8
1533	41	3
812	1274	4
1049	3609	3
492	608	3
1000	3609	2
782	620	3
85	3609	4
782	92	5
1016	3609	7
179	3609	1
812	395	2
224	3609	6
1116	3609	1
329	3609	1
201	3610	9
179	3610	5
316	3612	5
1415	3612	5
47	3613	5
56	3615	6
837	3615	4
575	3616	5
1023	3616	4
876	3616	3
1476	339	11
755	3616	4
1076	3616	7
794	3616	1
1081	3616	5
342	36	2
322	3616	4
125	3616	8
1119	3616	7
154	495	1
384	3616	8
1184	3616	3
247	3616	8
154	430	5
154	322	6
137	3617	4
661	3618	8
659	3618	8
97	3618	8
339	3620	4
1154	3622	6
1253	3623	14
1396	3625	2
316	3625	3
1415	3625	3
1205	3625	2
974	3625	2
975	3625	2
518	3625	4
1031	3627	12
472	3627	3
1020	3627	7
878	3630	6
351	3631	2
180	3633	2
1448	3633	3
86	3633	2
87	3633	2
88	3633	2
1146	3633	1
534	3633	6
82	3635	6
50	3635	3
988	3636	4
403	3637	4
872	3637	10
244	3638	1
18	3638	5
236	3639	9
1023	3639	5
1468	3641	4
1259	3641	6
639	3641	2
110	3642	3
1554	3642	6
109	3642	2
981	3643	5
1153	3643	4
145	3643	2
1111	3643	4
199	3643	3
200	3643	5
118	3644	1
298	3645	5
306	3646	2
430	3646	3
1372	3647	4
982	3648	7
665	3649	5
362	3649	4
35	3649	3
1117	3649	7
911	3649	5
950	3649	3
299	3651	6
1392	3652	3
231	3653	7
694	3654	6
1191	3655	6
1296	3656	3
693	3656	3
468	3656	3
833	3658	4
813	3658	3
575	3659	10
1099	3660	6
135	3661	4
1568	3662	5
1176	3662	2
209	3662	1
119	3662	1
941	3662	2
1348	3662	2
1328	3662	2
153	3662	1
1398	3662	2
1444	3662	3
81	3664	4
558	3665	9
198	3665	12
1034	3669	3
598	3669	3
532	3669	2
112	3669	2
113	3669	2
1226	3669	2
1225	3669	6
1289	3669	1
1242	3669	2
960	3669	1
98	3670	4
689	3671	6
962	3671	4
1167	3672	3
1395	3673	2
1249	3675	4
1004	3675	3
145	3676	8
82	3677	4
204	3677	4
1079	3678	3
220	3679	10
1183	3679	5
56	3680	3
151	3680	5
1128	3681	6
386	3683	9
1553	3683	3
1292	3683	2
732	3683	3
37	3683	2
385	3683	8
199	3683	4
200	3683	2
673	3683	2
1357	3683	2
259	3685	4
744	3686	6
815	3686	10
745	3686	8
1317	3687	6
155	3687	2
1004	3687	1
1045	3688	8
351	3689	7
991	3691	5
267	3691	1
293	3692	6
391	80	1
49	3693	4
301	63	2
1507	172	3
1059	3693	4
391	60	6
1376	639	3
1376	174	2
1463	439	4
391	648	2
1332	3693	1
325	51	5
172	3694	3
1011	3694	2
1463	629	9
493	184	1
493	53	2
493	599	3
493	335	4
493	356	5
493	162	6
493	43	7
173	3694	2
1271	161	1
615	3697	4
568	72	1
568	468	2
568	475	3
568	515	4
135	306	6
1008	3698	9
135	965	8
1264	796	1
471	3702	9
568	128	10
1264	805	3
621	3702	9
512	3703	6
851	3704	6
928	3705	4
301	204	6
929	3705	4
1409	3705	13
335	430	2
1109	3706	5
117	3706	3
357	3707	3
568	821	8
335	871	7
568	961	9
301	1085	3
1109	3708	1
568	1131	5
1271	1261	2
117	3708	4
631	3709	5
1122	3710	1
183	3711	4
66	3712	7
787	3713	5
321	3714	1
1396	3714	1
1019	3714	3
719	3714	2
161	3714	5
974	3714	1
975	3714	1
66	3715	6
319	3717	1
339	3718	1
339	3719	3
1476	3720	4
135	3720	5
1046	3720	8
938	3721	6
982	3721	2
199	3722	5
200	3722	4
673	3722	5
1357	3722	5
71	3723	10
530	3724	1
1032	3725	10
132	3728	3
1244	3730	8
1000	3731	3
313	3732	3
665	3732	2
985	3732	4
1329	3732	2
851	3734	5
1291	3735	2
1397	3735	3
125	3735	3
1119	3735	3
384	3735	2
1440	3735	3
4	3736	4
850	3736	4
685	3736	6
894	3737	9
318	3737	2
569	3737	5
745	3737	12
1530	3738	1
1291	3738	1
936	3739	2
1181	3741	1
616	3742	3
983	3743	5
324	3744	7
1517	3744	6
814	3744	2
1357	3744	4
1076	3745	3
185	3745	4
74	3747	1
85	3748	5
1016	3748	4
695	3748	3
219	3748	2
301	1404	7
753	2082	3
772	2083	3
345	2084	3
338	2084	2
374	2084	5
195	2084	6
574	2085	7
297	2086	11
787	2086	4
72	2086	4
1452	2086	5
1510	2087	2
1227	2087	6
67	2087	2
1030	2087	3
546	2088	1
854	2089	6
511	2089	5
75	2089	8
1064	2090	6
1065	2090	6
1245	2090	5
219	2091	8
898	2091	4
1043	2091	4
1262	2092	4
1261	2092	7
198	2095	2
407	2095	3
48	2095	3
302	2095	3
558	2095	3
1436	2095	2
910	2095	2
1394	2095	1
449	2096	3
772	2097	7
1393	2098	3
631	2099	6
818	2099	4
1516	2099	6
268	2100	2
816	2100	3
907	2101	3
214	2101	2
182	2102	4
247	2103	7
183	2104	2
1171	2104	3
297	2104	5
1170	2104	2
959	2105	6
958	2105	7
280	2106	9
824	2108	7
459	2109	6
1422	2110	2
1114	80	1
883	106	1
1114	176	3
1114	539	2
1114	305	5
883	78	2
1114	554	6
883	129	3
1410	555	1
883	49	4
458	101	1
883	88	5
883	279	6
983	1368	4
883	361	8
883	117	9
1507	144	6
495	184	1
495	53	2
495	599	3
495	679	4
220	3748	2
421	86	1
900	3748	2
495	387	8
495	416	9
421	279	2
421	565	3
458	509	2
458	556	3
448	3749	1
894	3750	6
1148	134	1
1148	965	2
1382	3750	1
589	3751	3
883	911	10
1530	3751	4
1148	1153	6
126	3751	5
1148	937	8
199	3751	8
944	3752	7
1219	3753	11
1394	3755	5
575	3755	6
794	3755	2
299	3756	3
1019	3756	5
1054	3757	2
1145	3760	4
541	3761	2
1500	3762	6
1036	3762	6
1184	3762	12
904	3762	5
121	3764	3
308	3765	1
1517	3765	1
1194	3765	7
273	3765	9
1122	3765	7
408	3765	1
883	931	7
495	1168	5
495	1221	7
1015	3765	10
979	3765	1
887	3765	1
1238	3767	5
259	3769	7
1012	3770	5
1313	3770	3
836	3773	8
1029	3774	3
804	3775	4
1342	3776	5
1483	3778	1
527	3778	1
1360	3778	2
661	3778	2
659	3778	2
97	3778	2
1273	2522	2
614	2525	8
704	2525	8
705	2525	12
336	2525	5
592	2526	1
591	2526	2
258	2526	1
1503	2526	2
1032	2526	1
172	2526	6
1280	2526	1
221	2526	1
47	2526	1
961	2526	1
1281	2527	5
597	2528	5
370	2529	5
1099	2531	9
37	2531	1
1368	2532	6
1369	2532	6
1370	2532	6
1371	2532	7
632	2534	6
709	2534	12
396	2534	4
168	2534	4
737	2535	6
1164	2536	4
1168	2537	8
665	2538	8
265	2539	6
1201	2540	2
242	2540	8
1457	2540	7
727	2542	3
413	2543	2
337	2543	6
1430	2543	4
830	2544	11
1221	2545	1
1220	2545	8
1148	2546	7
1190	2547	4
1109	2547	4
117	2547	2
873	2547	1
946	2548	4
475	2549	5
810	2550	1
947	2550	1
821	2550	1
1567	2552	2
1101	2552	5
1080	2553	4
693	2554	9
633	2554	4
955	2554	6
1077	2555	4
37	2555	3
910	2555	3
344	2556	4
1089	2558	5
1092	2558	5
830	2559	12
157	2560	5
59	2560	7
58	2560	9
156	2560	5
1408	2561	2
182	2562	6
1301	2563	4
403	2564	11
404	2564	8
1071	2564	11
157	2564	3
450	2564	7
599	2564	4
875	2564	5
765	2564	5
83	2564	5
1283	2564	3
1443	2564	5
694	2566	5
990	2568	11
306	2569	6
723	2573	5
484	2574	3
1118	2574	3
16	2574	3
42	2575	2
366	2575	2
818	2575	3
362	2576	2
35	2576	2
962	2576	7
580	2576	5
805	2576	5
405	2577	5
618	2577	5
697	2578	6
1068	80	1
414	158	1
1068	42	3
1461	414	1
1333	699	3
994	2578	5
666	2578	5
1507	740	4
281	260	1
483	2578	5
1461	106	2
160	2578	5
414	269	3
414	345	4
414	288	5
414	574	6
68	2578	5
1534	651	1
389	2579	5
804	282	11
115	184	1
115	53	2
115	599	3
115	628	4
682	2580	4
115	297	6
1005	2580	2
115	118	8
234	2581	5
115	133	10
107	86	1
107	279	2
417	2582	2
908	338	4
369	47	1
369	402	2
954	428	1
518	695	6
369	189	4
954	635	2
518	680	9
1461	199	3
954	755	3
495	2582	6
1461	626	6
1461	252	7
954	1297	5
1355	2582	7
1461	128	10
1158	2582	7
757	2583	4
484	2586	5
1461	475	14
1461	8	15
1116	2586	8
440	2586	3
1205	2586	1
1068	2586	8
1447	2586	8
677	2586	9
737	2587	3
475	2588	2
418	2590	11
107	384	3
107	479	4
353	2591	3
107	318	6
394	2591	5
176	2594	6
908	818	2
369	846	3
804	976	9
414	1009	7
1461	1055	8
804	1116	2
398	2595	4
317	2596	3
1454	2597	8
115	1133	5
804	1154	10
414	1183	2
281	1198	2
1210	2602	6
153	2602	2
363	2603	6
95	2604	2
184	2604	4
123	2604	2
445	2606	4
731	2607	3
1466	2608	7
1428	2608	3
1253	2609	6
8	2611	1
1513	2611	1
687	2611	5
350	2611	12
1183	2611	1
1125	2611	16
734	2611	6
444	2612	6
625	2613	9
626	2613	11
627	2613	10
105	2613	4
1409	2614	10
1290	2614	9
1164	2615	7
374	2616	3
195	2616	2
1072	2618	4
520	2618	1
612	2618	3
1409	2619	6
774	2623	4
806	2624	4
566	2625	2
67	2626	5
103	2626	6
32	2627	7
1163	2628	7
958	2628	5
161	2628	9
686	2629	5
759	2630	10
491	2631	2
574	2632	11
1178	2633	5
644	2634	2
656	2635	2
1183	2636	7
697	2637	5
1500	2638	2
115	2638	9
504	2638	5
387	2638	6
244	2638	4
153	2638	4
270	2639	4
1479	2641	3
26	2641	6
172	2642	1
1011	2642	3
337	2644	3
118	2646	2
1260	2647	2
1045	2647	6
1082	2647	6
904	2647	9
1101	2648	6
138	2650	5
995	2650	7
34	2651	12
668	2652	6
1067	2653	9
1176	2653	1
1510	2653	1
438	2653	6
119	2653	2
390	2653	7
79	2654	9
520	2654	3
511	2654	6
227	2656	7
1355	2657	2
1264	2658	2
52	2659	6
208	2662	2
31	2664	5
515	2665	4
830	2666	13
65	2667	3
979	2668	9
804	1412	7
281	1445	3
1109	1470	2
281	1493	4
518	1511	1
887	2668	4
515	2669	3
1376	2670	1
96	2671	3
375	2672	2
759	2673	4
758	2673	3
843	90	1
996	1347	6
760	2673	6
552	2673	4
556	77	1
761	2673	4
1522	83	3
264	488	2
1534	37	2
415	2674	3
14	428	1
14	755	2
556	694	4
14	383	3
556	485	6
556	472	7
556	258	8
556	226	9
996	184	1
996	53	2
996	599	3
149	158	1
149	288	2
14	1311	4
149	574	3
149	345	4
108	86	1
108	279	2
14	1232	5
32	2675	5
1352	2676	7
765	91	2
642	149	1
490	2676	7
1523	2676	5
1047	259	1
1093	2676	7
1047	71	3
1047	630	4
837	2676	9
1391	2676	8
986	342	6
1017	2676	5
108	384	3
108	415	4
403	2677	10
22	2677	5
39	200	4
84	2678	4
39	436	6
85	2678	9
1016	2678	9
964	2679	6
1335	2680	6
398	2681	2
73	2682	5
1061	2682	3
996	795	12
556	831	2
556	891	3
556	908	5
642	973	2
264	1025	1
996	1252	13
1047	1260	2
820	2682	5
1447	2682	9
775	2684	3
165	2685	7
166	2685	6
77	2685	7
78	2685	6
702	2685	8
76	2685	6
273	2686	6
587	2687	5
188	2688	3
1416	2688	4
58	2688	5
59	2688	5
851	2688	8
1168	2688	9
729	2688	6
730	2688	7
731	2688	2
221	2688	3
627	2689	16
33	2691	5
615	2693	3
528	2694	4
72	2695	3
202	2695	3
991	2695	1
1430	2696	5
1178	2697	4
1507	1457	5
1338	1493	3
996	1506	8
642	1510	3
450	2699	2
737	2700	4
1364	2701	2
621	2702	14
107	2704	5
1246	2705	3
597	2705	3
1308	2706	9
916	2706	6
919	2706	6
772	2707	5
457	2708	2
268	2709	7
757	2710	1
709	2711	7
229	2712	1
375	2713	3
852	2713	3
619	2713	3
635	2714	2
640	2714	2
644	2714	1
638	2714	1
634	2714	4
637	2714	5
639	2714	4
688	2714	3
846	2714	3
1453	2714	9
976	2715	8
126	2716	8
358	2716	4
801	2718	8
999	2719	4
93	2720	7
908	2721	1
146	2721	6
1260	2723	6
1037	2723	5
1039	2723	8
201	2723	10
479	2725	7
579	2725	2
1111	2726	11
342	2727	3
182	2729	2
39	2730	3
241	2730	10
434	2730	9
224	2730	11
329	2730	2
358	2731	5
728	3778	2
660	3778	2
1074	3779	8
1117	3781	8
347	3781	2
1210	3781	7
834	3781	5
1173	3781	1
1180	3783	3
401	3784	2
1540	3785	4
1317	3786	7
333	3787	3
231	3787	5
518	3787	5
1291	3787	4
708	3789	9
941	3790	5
884	3790	5
940	3790	1
4	3790	8
1244	3790	2
1000	3790	6
588	3790	2
885	3790	3
732	3790	2
993	3790	1
301	3791	5
408	3791	4
677	3791	1
26	3791	1
27	3791	1
1505	3792	11
417	3792	1
393	34	1
708	3793	3
1507	150	1
187	3794	12
1522	195	5
237	80	1
1072	647	2
237	293	2
1072	350	3
237	474	3
237	824	4
250	70	1
250	204	2
393	124	14
636	3794	4
186	3794	10
811	467	4
1072	180	7
188	3795	5
151	3795	6
1300	488	5
206	3795	4
1267	3795	5
1093	3795	5
319	3795	5
1291	3796	5
494	599	6
494	184	7
494	53	8
707	150	1
1152	3797	4
304	3798	1
90	3798	1
836	613	6
594	3799	5
101	3800	4
562	3801	5
775	3801	2
275	3802	2
836	436	10
1090	3803	7
1232	3804	3
1231	3804	8
1416	3804	6
711	3805	6
982	3805	5
1384	3806	6
615	3806	6
422	86	1
422	279	2
422	384	3
422	415	4
267	3807	3
5	3808	3
811	3809	2
646	3809	2
2	3811	6
661	3811	9
659	3811	7
97	3811	7
1534	104	3
707	771	2
745	3811	10
1037	3812	6
422	773	6
422	878	5
393	897	7
393	942	15
1300	1025	1
391	1033	5
1039	3812	7
996	3812	7
534	3812	4
2	3814	4
880	3814	6
21	3815	3
1072	1085	1
494	1252	5
776	1313	13
707	1331	8
255	3815	4
827	3815	4
746	3816	3
251	3818	2
1553	3818	2
961	3818	8
1220	3818	9
47	3818	2
1444	3818	7
1066	3818	3
1217	3819	9
236	3821	1
241	3821	8
224	3821	9
316	3824	4
1415	3824	4
1046	3826	5
853	3828	4
297	3829	3
99	3830	6
450	3832	4
1122	3832	3
1050	3833	5
1196	3834	9
1023	3834	2
979	3834	5
1032	3834	9
173	3838	3
471	3839	1
621	3839	2
813	3840	5
1532	3841	6
393	3841	13
699	3842	9
707	1402	9
595	3842	5
713	3844	3
159	3845	3
401	3846	4
1158	3849	2
178	3850	4
506	3851	2
1340	3853	3
1009	3854	3
767	3854	3
956	3854	1
285	1353	6
285	751	7
1349	3854	1
325	3854	3
1027	3854	1
793	3854	6
387	3854	4
1187	3854	3
411	3855	3
356	3856	8
1326	3856	2
979	3857	2
1553	3862	8
243	3862	3
1476	3862	2
242	3862	5
241	3862	4
224	3862	13
528	3863	2
718	3864	3
317	3866	9
690	3867	7
1055	3867	7
847	3868	2
1082	3868	3
327	3868	1
172	3869	4
1011	3869	1
173	3869	1
306	3870	5
944	3871	4
1035	3871	5
1397	3871	2
125	3871	2
1119	3871	2
384	3871	1
247	3871	2
1226	3873	4
269	3873	2
15	3874	4
1453	3875	8
1331	3875	4
1454	3875	6
1069	3876	2
306	3877	3
1004	3878	6
1121	3880	1
692	3882	1
1292	3883	3
1569	3883	2
1129	3883	2
385	3883	5
386	3883	6
603	3883	3
500	3884	4
499	3884	7
404	3885	12
720	3887	4
296	3889	4
1076	58	1
256	15	1
7	90	1
7	120	2
661	3889	10
659	3889	9
1073	350	2
256	21	3
7	32	7
97	3889	9
1073	647	4
1073	180	5
887	3890	7
8	3890	2
1183	3890	3
15	80	2
1282	383	1
13	3892	8
1528	3892	2
15	472	5
1529	3892	3
962	3892	5
1140	3893	5
705	3894	10
15	771	10
1320	41	1
706	3894	9
80	3894	9
1248	3894	1
1396	3895	4
992	3895	4
376	3895	6
974	3895	4
1282	305	6
975	3895	4
303	3896	6
1257	757	4
404	3897	11
1505	3898	17
1320	452	2
1320	53	3
925	3898	10
513	3898	9
512	3898	9
514	3898	10
525	3900	2
1530	3902	8
256	889	2
7	915	4
1381	3902	3
1282	940	3
977	1048	5
1115	1048	8
1257	56	1
170	3905	7
787	3905	2
1063	3906	4
319	3906	2
161	3907	4
279	3909	4
1392	3910	7
999	3910	3
1257	159	3
1203	1058	2
823	3915	3
236	3915	4
223	3915	11
224	3915	14
1226	3916	3
218	3917	2
1511	3918	7
111	3918	1
1257	240	5
1223	1060	6
1287	1060	6
1203	1060	9
652	3919	1
637	3919	4
835	1065	1
1073	1085	1
1099	3920	1
1257	77	8
505	1097	1
1217	3920	6
393	3922	12
116	3923	1
1176	3923	8
1519	3924	6
1223	1105	7
399	1107	5
648	1108	3
873	284	2
1287	1109	1
1203	1109	1
1282	1110	2
723	3924	6
1140	3925	1
688	3926	1
846	3926	4
643	3926	1
677	3927	7
1237	3927	4
545	1124	3
1375	3928	13
1292	3930	10
843	1135	5
1009	3930	5
1203	1144	3
767	3930	4
201	3930	6
198	3930	7
295	3930	7
699	3930	11
399	1154	2
1394	3930	3
665	3931	3
912	3931	3
755	3931	7
873	1155	4
28	3931	9
85	3931	7
1016	3931	6
201	3932	5
1223	1160	4
699	3932	7
665	3933	9
1012	3933	1
4	3933	5
1328	3936	4
1482	3936	3
770	3936	9
1419	1167	4
1471	3937	1
537	3937	5
1238	3937	1
1287	1170	2
613	3938	8
1203	1170	4
247	3938	1
1076	1201	5
1257	1269	2
904	3938	8
468	3940	4
276	3941	3
218	3941	1
813	3943	8
1039	3943	3
1232	3943	8
1415	3943	11
621	3943	12
1133	3943	2
198	3943	5
6	3944	6
1078	3945	2
987	3945	4
48	3945	7
357	3946	6
30	3946	3
1221	3947	2
894	3948	3
1227	3948	3
834	3948	3
981	3950	2
673	3950	4
1357	3950	3
1008	3953	4
958	3954	3
1395	3955	3
1210	3956	4
15	3958	3
416	3958	3
1045	3958	3
1352	3958	2
1468	3959	5
925	3960	6
305	3961	9
569	3962	2
1093	3962	1
175	3962	7
925	611	4
835	1425	10
925	364	7
925	599	14
563	153	5
963	3962	7
664	3962	4
1323	3962	1
472	3963	7
711	3965	5
1417	524	1
872	3966	3
685	108	8
272	105	2
1140	3967	2
1027	3969	3
1134	3970	2
260	383	1
1321	75	7
272	92	6
266	3970	2
272	232	8
155	3971	3
70	123	1
70	176	2
2	3971	3
1249	3971	3
1272	3972	3
1381	3973	2
898	3974	3
567	3974	6
636	3974	3
689	3974	1
897	3974	3
260	305	5
70	743	5
1043	3974	2
1417	550	2
294	103	2
1112	3975	4
294	180	3
219	3976	6
685	781	9
220	3976	7
982	3976	3
112	3977	1
113	3977	1
260	940	4
562	3977	2
514	3977	12
838	3977	1
255	3978	6
1409	3978	12
827	3978	5
872	3979	4
272	997	7
272	1065	1
927	3979	2
928	3979	2
260	1110	2
929	3979	2
433	3980	10
269	3980	8
1562	3982	1
439	3982	8
1322	3982	4
1328	3982	5
670	3982	2
1368	1181	1
1370	1181	1
1371	1181	1
720	1181	5
838	3982	4
1317	3984	1
327	3985	6
295	3986	6
992	3987	6
650	3989	3
983	3989	7
102	3992	3
977	1187	8
879	3992	6
648	1189	6
1349	3992	2
1382	3993	2
1287	1189	3
1203	1189	5
1100	3993	3
850	3993	7
663	3994	6
134	3994	3
251	3994	1
780	3995	6
950	3997	5
155	3997	4
1048	3999	7
670	3999	4
1196	3999	1
1299	3999	5
534	3999	2
201	4000	13
303	1212	5
243	4004	8
434	4004	13
505	1216	3
146	1217	1
20	4004	2
312	4004	2
242	4004	4
1100	4005	1
720	1217	1
1287	1218	4
1203	1218	6
925	4006	11
102	4007	4
117	4008	7
1109	4008	8
1178	1224	7
695	4009	2
231	4010	3
1125	4011	11
1007	4011	9
1008	4011	8
746	4013	5
31	4013	3
833	4014	5
714	4014	4
1196	4017	5
987	4018	12
878	4019	7
1287	1233	5
965	4020	2
1203	1233	7
1225	4021	4
55	4022	5
319	4022	7
1048	1238	1
247	4023	6
832	4024	4
1527	4026	3
106	4026	4
605	4026	4
500	4027	7
940	4028	3
1045	4028	5
565	4030	2
1023	4030	7
1204	1238	2
638	4030	2
648	1238	4
1333	1238	1
255	4032	5
936	4034	1
928	4036	5
929	4036	5
45	1243	5
128	1244	1
683	1244	1
388	1244	1
623	1244	1
16	4038	7
128	1249	4
1247	4038	2
479	4038	4
623	1249	6
1203	1249	8
729	1261	2
730	1261	2
24	4038	1
938	4044	3
1435	4046	1
1115	4046	4
401	4046	1
979	4047	7
427	4047	6
1174	4048	9
1416	4049	1
236	4049	3
823	4049	2
218	1288	3
89	4049	5
1049	4049	6
705	4049	8
706	4049	8
70	667	3
70	682	4
70	22	6
708	649	5
80	4049	11
303	4049	1
1309	4049	1
1091	64	1
1519	4050	5
1091	355	2
1091	106	3
1091	249	4
1318	776	1
470	1357	5
1091	426	5
1326	108	13
723	4050	4
1521	4051	5
1236	4052	7
83	105	1
1530	4054	9
83	252	2
276	4054	4
1283	102	2
613	4054	2
1126	4054	5
509	4055	7
960	4056	3
83	515	7
83	145	8
1173	4057	4
558	576	7
1174	4058	4
101	4059	3
106	4060	5
558	557	11
605	4060	5
343	330	2
343	302	3
343	351	4
269	4061	6
957	4062	1
823	4063	9
178	4063	2
343	724	1
1125	4064	9
1318	466	2
1318	844	3
56	4064	2
1318	208	5
1199	740	2
190	759	4
1326	781	14
190	826	5
343	930	5
707	4064	10
1318	742	7
1180	1262	1
1283	1011	6
343	1021	7
83	1202	4
465	4066	1
1007	4067	5
1180	1257	2
295	4068	4
147	1299	8
1143	4069	3
1123	4070	3
180	4071	1
591	4071	4
1032	4071	3
961	4071	3
86	4071	1
1360	232	1
87	4071	1
88	4071	1
661	4072	4
659	4072	10
97	4072	10
1481	4074	9
26	4074	2
27	4074	2
677	4074	8
193	4074	2
1457	4075	5
598	4075	8
464	4076	1
1267	4076	6
18	4077	2
257	4078	9
1505	4078	13
47	4079	4
1385	4081	3
73	4082	4
1553	4082	11
513	4082	6
470	1310	9
1447	4082	7
181	4082	1
887	4082	8
236	4083	6
365	4083	1
811	4083	1
1126	4083	11
27	4085	8
582	4086	2
1342	4087	3
327	4088	2
804	4089	6
1112	4093	1
83	4094	10
1442	4097	3
562	4097	4
1111	4097	8
18	4097	4
405	4098	4
595	4098	8
196	4099	2
521	4099	2
674	4103	1
110	4103	1
109	4103	1
178	4105	3
1126	4106	10
417	4109	4
1245	4110	1
296	4110	2
1224	4110	1
999	4111	2
1392	4111	2
1379	4111	9
1050	4111	3
910	4111	9
606	4113	6
1019	4113	4
277	4113	19
595	4113	7
717	4114	1
190	4116	1
565	4117	4
48	4119	8
1335	4120	2
527	4121	2
27	4121	6
427	4121	7
1199	34	1
175	4121	6
963	4121	6
664	4121	6
313	4122	6
496	4122	4
196	4124	4
521	4124	4
116	4125	2
282	4127	2
293	4127	2
960	4129	5
1133	4130	6
464	4131	5
386	4131	7
325	4131	2
385	4131	6
1100	4132	4
407	4133	4
48	4133	4
371	4133	8
970	4133	7
932	4133	4
223	4133	10
1132	4135	3
921	4137	4
73	4137	1
938	4138	7
1314	4139	7
1556	4139	3
173	4139	4
611	4139	10
932	4139	8
1021	4139	4
1409	4141	8
1227	4144	2
28	4145	10
756	1377	2
146	1400	8
418	1416	5
462	1417	2
470	1423	2
1199	1506	3
1407	49	1
1081	1363	7
725	47	2
252	4145	5
296	4146	3
100	4146	4
725	158	3
1380	4147	5
1523	83	2
1535	651	1
1407	4148	3
433	4151	7
427	4153	5
578	4153	5
646	4157	7
1423	232	7
140	13	1
569	64	1
140	19	2
569	59	3
1115	4159	5
140	10	4
1244	4160	4
569	290	6
569	106	7
776	4161	9
1407	1201	2
983	4163	2
1407	515	4
1352	4164	4
1121	4165	6
1056	716	3
879	4166	3
1248	4166	2
140	726	3
725	760	1
725	777	7
1249	843	1
725	1025	4
1381	1160	6
1381	1195	5
1249	1319	2
1245	4166	2
707	4167	6
563	4167	7
170	4167	4
631	4167	2
175	4167	4
963	4167	4
156	4168	4
1457	4168	1
611	4168	2
1021	4168	2
1247	1160	5
608	4168	2
1008	4169	13
1232	4171	13
1090	4172	1
231	4172	4
137	4172	3
386	4172	8
100	4172	8
1118	4172	4
385	4172	7
252	4172	4
253	4172	6
31	4173	4
835	4174	6
183	4175	3
621	4176	5
631	4177	4
688	4178	2
297	4179	2
832	4180	3
506	4181	6
257	4182	5
867	4182	7
752	4182	2
1214	4185	5
440	4188	2
912	4188	5
1195	4188	2
1530	4189	7
558	4189	5
198	4189	9
196	4190	7
521	4190	7
612	4191	4
708	4193	8
1134	4193	5
21	4194	2
255	4194	2
827	4194	2
299	4195	11
497	4196	2
499	4196	3
501	4196	3
548	4196	3
1564	4197	1
1313	4197	2
185	4197	2
387	4197	3
297	4198	7
1048	4199	5
1548	4199	5
1224	4200	3
1330	4201	2
447	4201	2
878	4202	1
1326	4203	12
365	4204	4
1020	4208	5
362	4208	3
35	4208	4
914	4208	2
1210	4208	3
694	4209	9
48	4210	5
407	4210	5
871	4211	6
401	4213	6
1184	4215	6
1141	4216	6
16	4218	6
506	4219	5
259	4220	6
793	4223	7
201	4225	12
1036	4225	5
1236	4225	3
708	4228	4
924	4229	4
417	4231	6
74	4233	4
1564	4234	2
1521	4234	2
613	4234	3
1126	4234	2
240	4234	1
1166	4235	4
71	4236	11
1152	4237	7
1382	4238	4
1339	4238	4
778	4239	3
1439	4240	8
558	4240	4
198	4240	4
1370	4240	3
594	4240	4
1069	4240	3
1019	4240	6
673	4240	7
219	4241	11
220	4241	6
900	4241	5
1556	4242	4
1531	4242	5
13	4242	6
47	4243	7
611	4244	4
1125	4244	6
25	4244	6
986	4245	4
1447	4245	5
181	4245	5
779	4246	3
293	4248	3
356	4251	6
30	4251	2
1212	4252	1
113	4252	4
356	4253	1
357	4253	7
30	4253	1
1418	4254	5
646	555	6
725	1410	6
725	1419	5
1081	1457	4
685	1458	5
1326	1458	6
198	576	8
198	80	13
185	4255	6
1214	4256	2
1314	4257	3
900	4257	7
1523	387	3
892	676	3
1535	197	2
1124	163	1
494	4258	2
925	4258	5
570	143	1
558	4259	8
892	175	8
631	168	1
991	157	6
198	4259	11
447	4260	1
973	237	2
1124	969	5
1124	982	6
1217	4261	5
774	1322	2
356	4263	7
30	4263	6
570	155	3
982	4264	6
570	308	4
774	537	6
570	600	5
1166	4265	7
973	171	3
1067	4266	5
1059	716	5
1215	721	6
991	834	3
892	886	4
892	909	7
570	946	2
973	1126	1
892	1196	5
1059	1251	3
465	4268	2
6	4269	7
833	4269	3
1482	4269	2
1237	4269	3
1314	4270	2
100	4270	5
1236	4271	8
1023	4272	1
618	4272	4
1068	4272	6
1044	4273	3
12	4273	9
588	4273	1
732	4273	1
687	4273	3
1509	4273	3
126	4273	3
1111	4273	7
734	4273	4
1337	4274	7
1215	235	1
1442	4274	2
297	4274	1
117	4276	6
341	4277	8
362	4278	5
1266	4279	2
1224	4279	2
674	4280	2
110	4280	2
109	4280	4
180	4281	3
815	4281	11
86	4281	3
87	4281	3
88	4281	3
1115	4281	1
904	4282	3
1244	4282	7
312	4283	8
970	4283	8
932	4283	5
71	4284	2
274	4287	2
864	4288	3
1141	4289	4
1339	4291	5
117	4292	8
817	4292	7
1109	4292	7
1147	4293	3
554	4293	3
612	4294	5
670	4295	5
280	4296	8
1027	4296	4
263	4296	5
1055	4297	1
26	4297	5
27	4297	5
677	4297	3
734	4297	7
687	4297	4
24	4298	8
983	4301	8
13	4304	4
925	4304	12
1123	4304	4
598	4305	9
836	4305	7
910	4305	8
1394	4305	4
987	4306	2
1077	4308	1
1129	4308	3
867	4308	3
707	4308	3
1215	262	2
563	4308	1
234	4308	1
832	4309	2
447	4310	3
1334	4311	2
210	4311	2
1483	4312	3
811	4312	3
1519	4315	4
792	4315	6
6	4315	4
1215	436	3
723	4315	3
1352	4315	8
276	4315	6
1398	4316	4
327	4318	3
24	4319	5
322	4319	2
835	4319	4
313	4319	2
613	4319	5
1126	4319	3
814	4319	4
957	4319	3
319	4320	6
1054	4321	3
60	4324	4
280	4325	1
580	4326	2
416	4326	8
1133	4326	1
1238	4326	2
116	4328	3
1184	4329	1
350	4329	1
257	4329	1
417	4329	5
979	4330	4
873	4331	5
792	4332	3
1316	4332	7
1111	4333	5
585	4334	4
779	4335	4
779	4336	2
779	4337	1
779	4339	5
914	4340	3
403	4341	3
1124	1381	3
774	1512	8
71	1515	9
1215	432	5
1215	101	7
610	167	1
610	262	2
610	48	3
610	656	4
632	638	1
632	427	2
632	541	3
632	652	5
632	375	10
1330	364	1
572	90	1
572	482	2
1078	591	1
475	382	1
938	4341	5
1508	168	1
1456	4341	6
862	4341	4
1508	421	4
834	4344	7
1508	373	6
1009	4345	9
1157	1336	3
1078	211	5
717	252	3
219	74	12
475	677	3
475	507	4
133	4345	2
1157	142	5
296	4346	1
327	4347	8
386	4350	11
1216	405	4
1535	458	3
1216	281	6
1216	412	7
24	4350	9
519	5	1
717	352	8
1434	4351	2
15	4353	7
464	4355	2
1546	4356	9
897	153	2
1326	4356	15
960	4356	4
1154	4357	5
549	760	8
475	770	6
549	787	12
717	830	4
572	852	3
572	862	4
519	867	3
572	908	6
549	944	1
572	954	7
1216	976	8
717	985	6
519	1050	7
1216	1219	5
1330	1251	5
658	4358	2
672	4359	2
327	4360	4
817	4361	1
13	4362	12
968	4362	2
1134	4362	6
13	4364	10
1284	4364	7
1236	4364	4
327	4365	5
673	4366	8
681	4367	6
151	4367	11
689	4367	4
297	4369	9
1434	4370	3
1123	4371	5
1111	4372	9
1079	4373	5
1331	4374	5
289	4375	3
745	4376	11
280	4377	6
196	4378	5
521	4378	5
1284	4379	5
441	4380	4
267	4381	2
797	4382	3
1460	4382	5
1212	4383	5
910	4385	5
996	4386	14
961	4387	7
327	4389	7
1221	4390	7
996	4391	10
280	4392	11
1154	4392	3
1036	4393	2
1196	4393	4
650	4395	4
271	4397	6
401	4399	5
71	4400	5
838	4401	3
1313	4402	7
433	4402	2
60	4403	5
983	4403	6
705	4404	4
706	4404	3
80	4404	3
1515	4404	1
895	4404	2
1166	4405	6
1152	4407	2
549	47	2
778	4407	2
1443	4408	4
798	4408	2
1444	4408	5
1316	4408	6
1416	4409	5
549	312	3
1328	4409	6
800	4409	2
521	4410	1
196	4410	1
1513	4411	4
876	4412	1
1297	4412	5
1196	4412	3
24	4412	3
49	4413	5
1228	4413	3
424	4413	1
404	4414	5
71	4415	3
73	4418	6
1204	4418	5
1068	4418	2
1386	4419	1
1254	4420	6
687	4420	6
1175	4420	6
734	4420	5
1438	4421	5
1465	4421	1
1289	4421	5
92	4422	1
170	4423	3
73	4423	3
717	4425	2
528	4426	1
598	4428	6
1349	4430	3
133	4431	8
817	4432	8
1069	4435	4
1217	4436	4
151	4436	8
1048	4436	4
389	4436	2
1244	4439	1
1438	4439	2
1251	4439	7
585	4439	3
1288	4440	3
593	4441	1
605	4441	1
1356	4441	3
1527	4441	2
549	307	4
106	4441	1
958	4442	8
71	4443	4
351	4445	1
1039	4445	5
595	4446	3
900	4447	3
1043	4447	3
519	285	2
519	519	4
1157	1405	2
519	664	6
554	1425	1
549	38	10
549	87	11
519	434	11
476	160	1
1331	622	6
1045	4448	4
573	90	1
1020	4448	4
476	100	2
476	158	3
834	4448	6
573	482	2
1535	709	5
706	4449	11
612	4449	8
894	61	4
608	4450	1
742	69	1
476	104	4
742	337	2
220	129	11
742	384	3
220	265	13
220	74	14
476	412	5
611	4450	1
742	547	4
476	404	8
476	435	9
476	185	10
476	458	11
476	168	12
795	34	1
795	83	2
795	377	3
116	790	5
709	285	1
1021	4450	1
742	429	5
117	4451	5
116	124	8
388	4452	4
894	247	5
898	153	2
150	4453	5
1449	4454	4
1450	4454	2
1460	4454	1
795	798	4
454	811	7
476	848	6
709	867	2
454	939	8
454	966	1
454	1134	5
1331	1251	1
181	1288	4
1147	1312	1
963	4454	2
175	4454	2
664	4454	2
1329	4456	6
1299	4457	4
1367	4458	2
878	4459	4
67	4461	4
299	4463	1
48	4464	9
606	4465	8
1134	4465	3
878	4466	5
1110	4467	7
898	114	7
1032	4469	8
961	4469	5
913	4470	5
810	4472	2
947	4472	2
821	4472	2
1244	4473	9
1289	4473	4
608	4474	6
611	4474	8
1076	4475	4
269	4476	7
1071	4477	6
878	4478	2
521	4479	6
196	4479	6
987	4480	6
427	4480	8
1279	4481	1
1229	4482	1
1212	4483	2
965	4484	5
776	4485	2
170	4486	6
56	4487	1
705	4487	6
706	4487	5
80	4487	5
1210	4488	8
1327	4489	1
350	4489	8
257	4489	2
719	4489	5
74	4489	5
513	4489	5
512	4489	3
514	4489	2
1147	4490	2
639	4490	1
554	4490	2
770	4493	4
565	4493	5
1527	4494	4
605	4494	6
823	4495	7
1546	4496	2
1347	4496	2
1065	4496	8
312	4496	6
966	4496	4
833	4497	6
150	4498	6
289	4499	1
713	4499	8
612	4500	1
672	4500	3
521	4501	3
196	4501	3
133	4503	4
231	4505	2
965	4506	1
266	4506	1
1069	4507	5
236	4508	7
201	4508	11
224	4508	15
823	4508	1
1111	4508	13
814	4510	5
1123	4510	2
233	4512	4
217	4512	1
851	4514	4
1383	4515	1
874	4516	3
463	4517	1
1029	4517	1
513	4517	1
512	4517	1
514	4517	1
224	4517	8
241	4517	14
1127	4518	4
1110	4519	5
351	4520	8
597	4521	4
708	4523	7
1314	4524	5
1067	4525	4
579	4526	6
810	4527	7
947	4527	5
1067	4528	3
1046	4530	6
365	4531	2
899	4531	1
1375	4532	7
825	4533	2
931	4533	6
1135	4536	4
156	4537	3
606	4537	3
689	4538	3
1055	4538	6
161	4538	7
1126	4540	8
635	4541	1
640	4541	1
709	519	3
181	312	9
454	365	2
454	470	3
709	434	13
454	654	4
638	4541	3
639	4541	3
247	4542	10
1420	114	1
1420	684	2
151	4543	9
574	90	1
1523	373	7
60	4545	1
745	4546	13
24	4547	6
1138	232	1
900	123	8
900	129	9
658	689	5
900	74	11
1138	659	2
1138	1232	3
658	361	7
658	83	8
1087	186	1
1087	556	2
212	4548	1
1087	261	4
1110	4550	3
1087	389	6
1184	4552	11
1126	4553	1
574	482	2
613	4553	1
776	4554	7
1238	4554	6
1289	4555	6
259	4556	3
574	229	3
6	4557	3
269	4557	1
60	4557	2
1316	4557	2
1253	802	1
271	4558	4
396	823	5
396	857	2
574	862	6
396	867	1
574	908	5
396	955	8
574	519	8
574	317	9
1332	1313	4
1046	4559	4
499	4560	9
1244	4561	10
658	4562	6
233	4563	3
27	4564	7
677	4564	6
357	4565	5
1099	4566	3
1210	4566	1
1236	4566	5
1120	4567	3
234	4568	7
621	4568	11
1260	4571	5
1067	4572	7
24	4572	7
494	4573	4
1118	4574	1
1032	4574	7
961	4574	6
1079	4575	1
1012	4576	2
1337	4576	2
253	4577	8
904	4578	7
1553	4579	10
711	4579	3
15	4579	6
1335	4580	1
1242	4581	9
706	4581	12
80	4581	14
479	4581	1
1395	4582	6
1548	4583	6
217	4583	5
1175	4583	3
252	4583	3
152	4583	6
1254	4583	3
521	4584	8
447	4585	5
447	4586	4
299	4587	4
6	4588	2
389	4589	4
494	4589	1
925	4589	1
1329	4589	1
1327	4590	3
585	4590	5
1556	4591	5
1163	4591	4
606	4593	9
1301	4595	2
1446	4595	3
1054	4596	1
262	4597	6
1321	4598	2
685	4599	7
752	4600	3
1301	4600	1
960	4601	6
923	4602	2
356	4603	3
357	4603	8
30	4603	5
986	4604	3
347	4605	3
1071	4606	8
401	4607	3
266	4607	3
607	4608	1
1297	4608	2
1375	4609	8
1247	4610	4
871	4611	4
133	4613	1
1252	4614	3
142	4615	6
177	4617	3
31	4618	1
613	4619	9
1297	4620	8
746	4621	4
192	4622	3
502	4623	3
934	4623	2
1476	4624	10
1457	4624	2
220	4624	5
1077	4625	5
1126	4625	7
923	4626	5
672	4628	1
1380	4629	3
1546	4629	4
1309	4629	2
433	4630	11
1335	4632	3
1531	4633	1
262	4633	2
821	4634	4
1327	4635	2
496	4637	1
202	4638	4
21	4639	1
255	4639	1
827	4639	1
1527	4640	1
106	4640	2
593	4640	2
605	4640	2
290	4642	5
1556	4643	2
1358	4643	6
1284	4643	2
494	4643	3
925	4643	9
1415	4644	9
1157	4645	1
259	4646	2
867	4648	5
1238	4648	3
269	4650	3
1118	4651	2
274	4651	1
1074	4652	2
1302	4653	1
1147	4654	4
4	4654	1
1141	4654	3
574	1437	10
974	1464	5
1161	164	1
177	4656	1
743	35	1
743	508	3
904	4657	10
1361	4657	2
1023	4658	6
1099	4658	5
425	4658	1
743	39	2
1413	160	2
1436	539	1
650	4659	8
585	4660	1
537	4660	2
175	4660	8
1174	689	7
664	4660	5
1436	85	7
1436	65	8
987	4662	5
405	4662	2
575	90	1
1120	4663	1
607	4663	3
1297	4663	4
1210	4664	5
299	4665	9
1161	4665	3
1526	4665	1
1531	4665	7
1354	4665	4
496	750	9
575	482	2
1174	760	2
743	784	8
1413	833	3
1214	4665	3
743	279	5
575	852	3
743	285	6
168	867	1
1413	893	4
1174	950	3
743	1122	4
743	112	7
1413	1135	6
1413	1150	5
1413	1159	1
743	1199	9
1413	1245	7
575	1333	12
1036	4666	4
190	4667	2
1562	4668	2
957	4668	2
255	4669	7
811	4670	5
318	4670	4
1132	4671	2
190	4671	3
1259	4673	3
427	4674	9
233	4675	2
1227	4675	1
1023	4675	3
934	4676	6
116	4677	4
1048	4677	6
56	4678	7
1048	4678	3
787	4678	3
1152	4679	9
106	4680	3
605	4680	3
692	4681	4
1371	4682	4
217	4683	7
1334	4684	8
1117	4686	1
1111	4686	1
274	4687	4
1007	4688	8
575	134	9
1008	4688	7
1383	4689	2
234	4690	6
262	4691	1
1284	4691	1
1337	4691	1
1236	4692	10
899	4693	3
1345	4694	7
1513	4695	3
1217	4695	2
219	4696	10
220	4696	12
293	4698	1
282	4698	1
358	4699	3
1471	4701	2
707	4701	11
914	4703	6
1334	4704	7
1384	4705	3
48	4705	6
875	4705	2
575	229	13
850	4705	6
876	4705	4
479	4705	2
1232	4705	2
496	4705	2
1050	4705	2
1099	4705	4
1326	4706	9
289	4707	2
743	153	11
1411	4707	4
1117	4708	10
705	4708	5
706	4708	4
80	4708	4
835	4709	7
253	4709	4
859	4709	6
133	4710	5
1375	4711	12
1193	4712	4
1194	4712	3
201	4712	4
482	4712	1
699	4712	6
1188	4714	3
1227	4714	4
605	4715	10
925	4716	2
142	4717	3
681	4717	3
797	4717	2
621	4718	3
321	4719	3
743	155	12
60	4720	3
1383	4721	3
448	4723	4
776	4724	1
1046	4725	3
1135	4726	3
8	4727	6
1183	4727	4
743	458	13
1020	4727	3
778	4727	1
357	4728	1
1120	4729	2
1135	4729	2
48	4729	10
1416	4730	3
925	4731	3
799	4732	1
1439	4732	1
835	4732	2
798	4732	1
836	4732	3
1228	4732	1
1210	4734	10
1392	4735	4
1184	4735	10
1244	4735	6
1146	4736	2
271	4737	5
513	4738	8
895	4738	3
496	473	8
668	4739	1
1044	4742	4
1367	4743	4
168	285	2
168	606	5
168	296	7
251	1424	5
1134	1457	1
1436	1457	3
1396	1464	5
1424	332	1
1476	4744	5
1272	4744	4
1535	186	8
1127	4748	10
823	4749	8
1418	191	1
1418	50	2
89	4750	1
1418	756	4
271	4751	1
1363	39	1
1418	783	6
532	51	1
1363	365	2
92	4751	2
1363	521	3
1363	484	4
1363	648	5
1424	342	2
532	1238	3
532	746	4
532	766	5
1081	4751	2
1277	4751	1
272	4751	4
258	4751	2
1363	65	6
1280	4751	3
416	4752	10
400	4752	1
155	4753	6
1384	4754	7
406	4754	3
1334	4754	5
253	4754	5
1321	4755	5
1367	4756	6
357	4757	10
1314	4758	6
1179	4758	3
1099	4759	2
607	4760	2
1297	4760	3
1009	4760	4
837	4760	7
1375	4761	1
389	4762	3
66	4763	5
925	4764	8
1476	4765	1
904	4765	4
257	4765	6
1314	4765	1
135	4765	2
1176	4765	5
1433	752	7
710	761	4
692	769	3
692	773	6
710	889	5
1424	960	4
1433	1106	3
1252	695	6
1013	1124	1
710	1196	3
1067	4767	2
1433	1207	6
497	1233	1
497	1290	5
1433	1296	5
692	31	5
1424	1321	5
1395	4768	4
859	4769	3
714	4769	2
940	4770	5
240	4771	5
441	4771	1
605	4772	7
1152	4773	6
859	4774	9
1237	4775	8
71	4777	7
1195	4778	6
612	4778	2
1074	4778	3
152	4778	5
290	4779	3
357	4780	2
1053	4781	2
579	4782	3
316	4783	6
418	4784	10
859	4785	8
714	4785	3
111	4786	4
934	4787	3
425	4787	2
502	4787	4
1045	4788	7
212	4789	2
827	4789	3
21	4789	4
255	4789	3
177	4790	2
1367	4792	5
605	4793	8
1340	4794	2
236	4795	8
823	4795	4
303	4795	2
1328	4795	7
312	4796	9
1145	4797	2
291	4798	3
92	4799	3
1125	4800	10
1237	4800	2
782	4801	2
575	4801	7
1031	4802	4
713	4803	4
1395	4805	5
776	4806	4
206	4807	1
1405	4808	6
293	4809	5
672	4809	4
1519	4810	7
1123	4810	1
1384	4811	9
252	4812	6
253	4812	7
1409	4813	7
872	4814	1
832	4815	5
921	4816	2
836	4816	9
1372	4816	3
1384	4817	5
1210	4817	9
318	4817	3
1053	4817	1
389	4817	1
1029	4818	4
13	4819	5
192	4820	5
272	4821	5
1405	4822	7
290	4823	4
1391	4824	2
1179	4825	4
1423	4826	3
1339	4827	3
92	4830	6
618	4832	6
899	4834	4
111	4835	5
938	4836	4
940	4838	4
851	4838	2
497	712	4
1471	4838	4
299	4839	10
1299	4841	2
900	4841	6
897	4842	5
1434	4844	4
710	133	6
1079	4845	4
73	4847	7
710	151	9
80	4847	13
1337	4848	3
1167	4849	4
133	4850	6
780	4851	7
1112	4851	2
82	4852	2
1173	4853	2
673	4856	9
975	1464	5
710	1481	2
1013	1503	4
1385	4860	1
950	4861	2
1121	4863	7
106	4865	6
1524	563	1
605	4865	13
1095	165	1
1095	92	2
397	208	1
1095	680	3
397	624	2
1179	700	5
794	4866	4
425	4868	4
1311	5	1
24	4869	4
812	4870	3
612	4871	6
71	4873	1
1412	191	1
1412	1196	2
201	4874	8
1337	4874	6
1412	88	5
1409	4876	4
755	4877	6
397	742	3
397	766	5
653	822	4
498	979	5
1311	1027	4
397	1047	7
1095	1125	6
1106	1142	6
1179	1153	6
498	1200	4
498	1233	2
498	1290	1
1367	4877	1
1154	4878	7
1204	4879	1
871	4880	2
356	4881	2
357	4881	9
30	4881	4
1311	248	2
1412	756	8
1242	51	1
987	4882	9
280	4884	5
111	4885	3
92	4887	5
1311	423	3
1184	4889	2
119	4890	4
183	92	1
240	4892	3
150	4893	4
289	4894	4
290	4894	6
1411	4894	1
579	4895	4
316	4896	8
192	4897	4
1447	4898	1
987	4898	10
1031	4899	2
1412	4900	4
1242	1238	3
1481	4900	7
1515	4900	2
1436	4900	5
958	4902	9
1321	4903	3
1283	4904	4
318	4904	6
776	4905	3
1483	4906	2
80	4906	8
452	4909	2
1359	4909	1
1229	4909	3
1251	4910	6
771	315	1
770	4911	7
441	4913	5
416	4914	9
921	4915	5
1242	746	4
829	4916	3
1242	766	6
1031	4917	9
1242	1195	8
1127	4918	3
1031	4919	3
74	4920	3
501	4922	4
389	4923	7
1227	4924	5
384	4925	9
605	4926	12
1067	4927	1
329	4928	5
1237	4930	7
479	4931	8
1144	4933	4
119	4935	3
1111	4936	10
921	4937	3
1460	4937	3
1043	4938	6
1436	4938	6
898	4938	6
496	4938	5
950	4943	4
513	4944	7
512	4944	7
514	4944	4
776	4946	5
1311	265	7
1316	4947	3
303	4949	4
1321	4951	1
1260	4951	3
1354	4951	1
56	4951	4
34	4952	11
924	4953	3
1127	4954	2
290	4955	1
1311	302	8
1411	4955	2
1405	4956	3
280	4957	2
1074	4958	1
318	4958	1
1078	4959	3
1031	4960	10
357	4961	4
71	4962	6
247	4964	3
1519	4964	2
958	4964	6
723	4964	2
1302	4965	2
1409	4967	1
1128	4968	3
1031	4969	1
498	269	3
1055	4972	2
899	4974	2
653	173	1
653	674	2
653	488	3
303	4975	3
1031	4976	11
595	4978	9
1127	4980	5
1326	4980	8
351	4981	5
321	4982	2
579	4984	1
1031	4985	6
1354	4987	3
770	4988	6
776	4989	11
351	4990	4
874	4991	5
1380	4993	1
672	4994	5
146	4998	4
962	4999	6
792	5000	5
1031	5002	5
1217	5004	8
782	5006	1
1297	5007	7
1144	5007	5
1214	5007	4
1106	1376	1
1106	1403	2
1106	1437	3
654	1459	1
1179	1466	2
1311	1483	6
678	1342	6
42	150	1
99	1347	4
42	1362	6
1356	5008	5
1127	5009	1
1524	771	2
1102	49	1
1102	58	2
868	233	1
868	1089	2
1259	5011	4
1031	5012	8
868	1083	5
868	1331	6
1306	327	1
1306	728	2
1306	467	3
924	5013	5
1279	5015	3
42	861	5
791	923	4
499	925	11
295	5016	8
99	950	7
916	965	2
678	1124	1
499	1200	5
499	1215	6
499	1233	2
42	1276	4
99	457	8
499	1290	1
950	5017	1
776	5018	6
1110	5019	6
1438	5021	3
356	5021	5
1380	5021	4
814	5022	8
1540	5022	5
823	5023	6
837	5024	3
1354	5025	2
580	5028	3
111	5029	2
859	5030	5
1356	5032	4
1409	5033	3
1314	5034	4
479	5035	3
1411	5036	3
290	5036	2
405	5037	1
872	5038	7
1099	509	8
924	5039	2
916	271	1
767	5040	5
916	702	3
746	5040	2
755	5041	2
872	5043	8
1068	5044	7
1074	5046	6
1423	5047	5
263	5047	3
1146	5048	3
1326	5049	3
1163	5050	6
1375	5051	5
356	5052	4
1031	5054	7
605	5055	9
1329	5056	7
8	232	3
1279	5057	2
1509	5057	1
934	5057	4
585	5057	2
1279	5058	6
1229	5062	4
1409	5063	2
1405	5064	4
1354	5065	5
809	5066	5
313	5067	4
1297	5068	9
1321	5069	4
1431	5070	3
1229	5072	2
1277	5073	4
1405	5074	5
1409	5075	5
579	5076	5
1326	5077	10
1121	5078	3
924	5080	6
1054	5081	5
776	5083	8
1332	5085	3
1356	5089	2
1054	5090	4
605	5092	11
425	5093	3
872	5094	6
712	5095	4
1121	5096	5
1152	5097	3
496	5098	3
269	5099	4
1405	5102	2
579	5104	8
1375	5105	11
924	5106	7
1354	5107	6
776	5109	10
262	5110	5
1405	5113	1
899	5114	5
1252	5115	4
1121	5116	2
8	114	5
914	5117	5
1043	5118	5
667	5119	9
1335	5120	5
1464	5211	5
1464	5212	1
1473	5213	4
1464	5213	6
1546	5214	5
1465	5214	2
1465	5215	3
1466	5216	1
1466	5217	2
1466	5218	3
1466	5219	4
1466	5220	5
1466	5221	8
1466	5222	9
8	105	7
1467	5223	6
1471	5225	3
1471	5226	5
1472	5228	3
1472	5229	5
1475	5233	4
1475	5234	6
1475	5235	11
1475	5236	13
1476	5237	6
1476	5238	7
1476	5239	8
1478	5241	6
1478	5242	8
1481	5249	1
1481	5250	2
1481	5251	3
1481	5252	5
1481	5253	6
1482	5257	1
1482	5258	7
499	71	4
499	709	12
791	70	1
791	204	2
791	409	3
791	1404	5
678	1503	4
84	1364	3
1524	59	3
869	233	1
869	1089	2
869	1083	3
869	1265	4
869	175	7
960	445	2
1045	448	10
84	539	6
84	301	7
84	328	8
84	471	10
671	117	4
671	523	5
671	570	6
671	694	7
671	123	8
671	808	1
1183	911	8
577	950	5
917	965	2
29	1124	1
917	1129	5
84	1202	1
917	271	1
500	1233	2
1045	1288	9
500	1290	1
917	702	3
500	709	6
880	366	1
1183	114	6
1183	105	9
880	309	8
648	5315	8
1504	5328	3
1207	5411	5
1546	5421	3
1545	5459	7
1500	5472	5
1501	5493	5
1501	5494	6
904	5797	11
1207	6061	4
1207	6062	6
29	1503	3
408	6086	5
414	6090	10
149	6090	5
917	6204	7
1504	6552	1
1504	6553	2
1505	6554	3
1506	6557	4
1508	6559	2
1508	6560	5
1509	6562	2
1510	6563	4
1511	6567	4
1511	6568	6
1513	6577	5
652	6578	12
1514	6579	5
1514	6580	6
1514	6581	8
1514	6582	9
1522	7367	6
1516	7367	5
1516	7368	7
1522	7369	9
1516	7369	11
1521	7389	3
1521	7390	4
1066	119	1
63	42	1
1066	563	5
85	1364	3
63	93	2
1066	213	6
978	168	1
63	448	4
1524	1283	4
1536	651	1
1536	950	2
1251	100	9
1536	895	6
881	366	1
881	309	3
1010	233	1
1010	1265	2
1010	436	3
1010	680	4
1010	657	7
40	160	1
40	369	2
40	216	3
40	594	4
40	490	5
40	498	6
40	540	7
1010	175	8
191	1117	1
578	628	6
305	271	1
578	347	9
305	702	4
305	473	5
578	352	10
305	773	2
1251	822	5
578	950	3
1066	1085	2
305	1103	3
28	1124	1
85	1202	1
501	1233	2
1251	1243	3
305	1287	6
501	1290	1
85	1466	10
28	1503	5
1521	7391	6
1521	7392	7
1521	7393	8
1520	7394	2
1520	7395	3
1520	7396	4
1522	7399	4
1522	7400	10
1522	7401	11
1137	64	1
1137	34	2
904	42	1
1137	42	4
1137	149	5
1137	247	6
1042	168	1
1042	448	2
1042	161	3
1042	173	4
904	93	2
1016	1364	3
1522	7402	12
1042	50	8
1523	7404	6
1525	7408	3
100	164	1
1525	7409	4
1525	7410	5
1525	7411	6
870	965	2
870	820	3
870	657	4
870	175	5
870	1167	6
1525	7412	7
870	680	8
36	414	9
715	90	1
141	580	1
141	129	2
1525	1112	1
715	1202	3
715	363	4
715	855	5
141	490	6
1525	7413	8
715	402	7
1527	7416	5
1527	7417	6
1527	7418	7
1527	7419	8
1527	7420	9
1527	7421	10
618	689	3
100	688	3
1527	7422	11
1529	7425	4
1530	7426	5
276	64	1
1530	7427	10
1531	7428	2
1531	7429	4
1532	7430	5
1532	7431	7
276	63	7
1533	7433	4
1533	7434	5
1535	7434	4
1534	7435	5
1534	7436	6
1537	651	1
1539	7436	2
1537	878	3
1537	1260	4
1016	539	10
1537	895	5
1537	93	6
1537	1103	7
1535	7437	6
1536	7438	3
1538	7439	8
1536	7439	4
1539	7443	3
1539	7444	4
1540	7449	6
1541	7451	2
1542	7451	2
1543	7451	2
1541	7452	3
1542	7452	3
1543	7452	3
1016	301	11
1542	7453	4
1016	328	12
1543	7453	4
1542	7454	5
1543	7456	5
1042	833	5
1137	863	3
618	931	2
1042	937	6
100	949	2
882	969	2
141	1051	9
559	1104	6
36	1124	1
36	1153	8
141	1188	4
1016	1202	1
36	1262	10
276	1278	5
559	1299	4
1545	7470	1
1545	7471	2
1545	7472	3
1545	7473	4
1545	7474	5
1545	7475	6
1546	7478	6
1546	7479	7
1547	7481	3
1547	7482	4
1547	7483	5
1548	7484	4
1549	7489	1
1549	7490	2
1549	7491	3
1549	7492	4
1549	7493	5
1550	7496	5
1552	7497	3
1554	7501	4
1554	7502	5
1554	7503	7
1554	7504	8
1556	7509	6
1556	7510	7
1557	7511	4
1559	7514	4
1559	7515	6
1559	7516	7
1560	7520	1
1560	7521	2
1560	7522	3
1560	7523	4
1560	7524	5
1560	7525	6
1560	7526	7
1560	7527	8
1561	7530	1
1561	7531	2
715	1449	6
1016	1466	14
36	1503	7
1561	7532	3
1561	7533	5
1561	7534	7
1561	7535	9
1562	7536	3
1563	7550	3
1563	7551	4
1563	7552	5
1563	7553	6
1563	7554	7
1563	7555	8
1563	7556	9
1565	7559	2
1566	7559	3
1565	7560	4
1566	7560	5
1565	7561	5
1566	7561	6
1565	7562	6
1566	7562	8
1565	7563	7
1566	7563	9
1565	7564	8
1566	7564	10
1565	7565	9
1566	7565	11
1565	7566	11
1566	7566	12
1565	7567	12
1566	7567	14
1565	7568	13
1566	7568	15
1565	7569	14
1566	7569	16
559	137	1
559	83	2
559	209	5
882	366	1
882	309	3
941	437	1
949	619	2
1565	7570	15
1566	7570	17
1565	7571	16
1566	7571	18
1565	7572	17
941	70	8
1538	651	1
1014	414	7
1014	157	8
718	72	1
1268	1025	1
144	359	1
1268	164	2
1268	1117	3
576	164	1
718	502	7
144	378	2
576	96	4
144	201	5
758	714	1
718	783	2
144	815	3
576	949	3
941	951	6
1435	978	3
941	1100	7
1014	1124	1
502	1153	5
144	1250	6
1014	1262	3
1538	878	3
1538	1260	4
1538	93	5
1538	1103	7
1435	51	4
758	376	2
758	640	6
1517	1136	2
1445	271	1
770	359	1
238	126	1
966	361	6
238	140	2
238	96	3
238	134	4
759	376	2
1162	1025	1
1162	164	2
1162	1117	3
759	693	7
1162	775	5
759	33	9
1162	86	6
770	378	2
934	361	10
943	683	1
943	246	2
943	221	3
759	714	1
943	752	9
1445	117	3
1445	229	5
1445	111	6
770	815	3
772	859	2
759	876	8
772	938	1
759	952	11
119	1153	5
934	1153	9
934	1183	8
943	1222	5
966	1262	2
1517	171	7
1539	217	1
1539	123	5
934	1506	5
943	203	6
943	710	7
943	297	8
1516	645	2
1516	83	3
1516	195	4
955	445	2
955	592	5
1040	368	2
162	243	1
162	109	2
1516	103	8
1516	792	10
1040	372	3
1228	1328	4
1228	195	5
1228	472	6
1040	29	6
25	361	9
1019	237	1
25	414	10
25	157	11
760	714	1
1040	737	1
760	877	12
542	969	3
760	1047	10
542	1053	5
25	1124	1
760	376	2
1309	1153	3
1141	1212	1
542	1319	1
760	590	9
25	1503	7
477	95	1
477	64	2
477	280	3
72	243	1
72	109	2
902	86	1
902	348	2
902	799	3
902	791	4
322	50	5
322	265	6
1160	61	1
1382	117	3
1160	795	2
1125	361	12
284	305	4
1160	692	3
1160	1036	4
1382	112	5
545	595	2
545	36	1
545	766	5
545	784	6
545	794	8
1125	809	14
284	234	8
552	213	1
1125	157	17
896	813	1
552	376	5
896	1117	3
1125	1124	1
1125	1262	15
950	629	7
1125	1503	7
1340	708	1
126	401	1
354	160	1
354	51	2
354	175	3
221	554	4
354	85	4
383	227	1
383	384	2
126	363	7
1024	125	1
1024	642	2
748	256	1
1024	604	3
625	471	1
625	161	3
625	186	5
625	539	6
383	712	4
625	328	11
625	196	13
625	301	14
1340	804	4
761	228	1
625	813	4
383	822	5
1245	1010	4
761	376	6
399	243	1
625	1202	2
354	1219	5
625	1466	10
748	698	3
748	368	4
748	136	5
625	1489	8
748	422	6
1293	48	1
1293	89	2
399	207	3
399	377	4
65	153	1
65	602	2
824	315	1
1355	445	3
65	530	4
891	529	1
824	1295	4
891	85	3
1178	82	1
43	227	1
891	617	5
43	384	2
1355	467	6
626	471	1
1178	676	2
739	173	1
43	712	4
739	1137	2
626	161	3
739	1081	3
626	186	5
739	829	5
626	539	6
626	328	9
629	195	5
629	137	6
43	228	5
626	242	16
626	1466	12
739	747	7
45	243	1
1355	736	4
891	781	2
1178	784	10
1355	799	9
626	813	4
43	822	7
626	826	14
1355	911	5
1178	932	9
1178	954	11
626	1489	10
1355	1004	8
43	1029	6
626	1202	2
629	1238	1
45	377	2
45	218	3
1178	372	13
45	413	6
45	100	7
64	153	1
64	602	2
698	124	1
951	124	1
698	365	2
951	99	2
698	73	3
1429	172	1
627	471	1
1429	79	2
540	730	3
951	139	4
627	161	3
1429	283	3
627	186	5
627	539	6
147	750	11
1429	554	4
698	775	4
26	457	7
147	654	9
540	90	1
627	301	18
627	196	19
540	812	2
627	813	4
627	826	13
541	830	3
147	834	4
540	836	10
541	1390	1
540	927	13
627	1466	11
627	1489	9
951	983	3
540	1081	4
541	1083	4
147	243	1
147	377	2
540	1161	6
627	1202	2
540	1243	9
540	1296	8
147	218	3
540	224	5
540	692	7
1434	1370	5
694	153	1
1387	172	1
10	124	1
893	808	1
1387	283	2
1387	79	3
1434	826	6
10	958	4
27	109	9
27	70	10
1387	554	4
163	124	1
163	365	2
163	73	3
370	57	2
163	180	4
617	193	1
163	42	5
163	33	6
617	213	2
163	257	7
617	1180	3
617	126	4
617	645	5
617	83	7
10	983	3
370	995	3
370	1031	1
1434	1083	1
694	1106	2
10	687	2
10	691	5
10	99	6
66	153	1
44	95	1
677	109	2
44	167	2
44	138	3
1388	172	1
1388	79	2
1388	628	3
1136	261	1
503	124	1
1388	554	4
1136	715	4
9	124	1
503	365	2
503	73	3
503	42	4
503	180	5
503	33	6
1388	445	6
1136	277	2
9	691	3
503	257	7
1136	286	3
533	193	1
533	213	2
533	126	3
533	1085	4
41	57	2
41	681	3
41	386	5
1136	380	6
1136	440	7
533	83	8
41	328	6
44	724	4
503	737	8
44	753	6
44	918	5
9	958	5
1136	970	8
9	983	4
41	1031	1
1153	1264	6
1153	1270	2
503	1270	9
9	213	8
66	1405	4
1431	172	1
1431	554	4
1431	79	6
1431	283	7
793	70	1
997	124	1
793	129	2
793	803	5
997	365	2
222	166	5
997	73	3
721	88	1
793	204	8
997	42	4
997	180	5
997	33	6
721	122	2
721	391	3
145	189	4
145	709	7
179	762	4
145	838	6
222	1055	3
1089	1097	2
1154	1111	10
1089	1119	4
145	1196	1
1154	1243	8
1154	1270	2
67	1330	3
478	301	2
478	375	5
478	275	6
478	630	7
202	150	1
504	72	1
445	28	1
969	123	1
969	341	2
1168	283	1
1168	366	2
1168	79	3
1168	445	5
1168	409	6
445	512	3
1168	38	10
445	542	7
669	166	3
1397	651	1
1397	244	5
1397	50	6
504	750	3
1168	774	4
878	2732	3
867	2733	6
978	2733	3
202	1402	6
1092	1497	7
515	2734	7
880	2736	3
882	2736	7
151	2738	7
298	2738	3
445	865	2
1012	2738	6
669	468	5
678	2738	5
28	2738	11
240	2738	4
587	2740	3
1297	2741	6
478	2741	1
504	992	7
445	1035	9
669	1055	4
1092	1097	2
478	1098	9
1092	1119	4
478	1138	4
1397	1260	8
1236	1270	2
198	2741	1
995	2742	8
773	2744	6
122	2745	5
868	2746	4
505	2746	4
57	2747	1
428	2749	10
450	2750	3
405	2750	6
1023	2750	8
1012	2751	7
1206	2751	5
1216	2751	1
809	2752	6
306	2753	1
553	2755	7
1163	2756	5
71	2757	8
774	2758	5
32	2759	1
925	2760	13
412	2760	4
996	2760	5
1296	2761	5
335	2762	6
1122	2764	4
590	2764	9
341	2765	1
907	2766	6
1344	2767	5
1209	2768	4
1015	2770	9
328	2771	9
414	2771	11
149	2771	6
1135	2772	5
96	2773	2
120	2775	2
488	2775	3
208	2776	1
169	2777	3
1430	2777	8
992	2778	1
344	2780	7
451	2781	2
1406	2782	1
409	2783	5
128	2784	5
623	2784	4
1063	2785	3
1064	2785	3
1065	2785	4
884	2785	4
312	2785	4
1000	2785	5
1061	2813	5
172	2814	2
1011	2814	4
1147	2814	5
471	2816	5
621	2816	8
1569	2817	5
463	2817	2
49	2817	1
50	2817	1
780	2817	1
1037	2817	1
1039	2817	1
565	2817	1
224	2817	19
806	207	1
1439	2817	2
932	2817	1
1339	1307	1
806	206	2
125	651	1
371	2817	1
970	2817	1
1081	2817	1
355	2818	4
546	2820	3
1208	2822	6
114	2822	7
610	2822	5
41	2822	4
648	2823	7
392	2824	3
655	679	1
19	2825	6
1062	2827	8
348	86	1
978	2827	5
1267	126	3
655	394	5
1267	1247	4
963	2827	9
175	2827	9
664	2827	7
526	243	1
460	2828	12
875	2830	6
1299	290	6
1087	2830	7
392	2830	6
1439	2830	3
800	2830	3
816	2832	5
1303	2833	8
884	2834	6
1000	2834	7
885	2834	4
891	2835	6
382	2836	1
840	2836	1
125	50	6
381	2836	1
378	2836	1
125	244	9
125	208	10
380	2836	1
379	2836	1
348	843	2
526	915	8
806	961	3
655	1102	2
125	1260	5
841	2836	1
377	2836	1
323	2838	5
1181	2839	4
1180	2839	4
299	2839	8
1338	2840	1
1236	2843	6
782	2844	4
47	2844	6
506	2844	4
211	2845	3
898	2846	5
897	2846	4
1043	2846	7
1448	2846	5
615	2846	7
928	2847	6
929	2847	6
891	2850	7
615	2851	8
1132	2852	1
659	2852	6
97	2852	6
977	2853	9
1523	2854	4
404	2854	6
835	2854	8
403	2854	6
1071	2854	7
922	2855	1
1421	2856	3
418	2857	8
1208	2858	5
34	2861	2
872	2862	9
1145	2866	3
198	2867	10
341	2868	7
1164	2869	10
470	1401	11
1093	1431	4
93	2870	3
1511	2871	3
1063	2871	2
1064	2871	2
526	2871	6
434	2871	6
223	2871	6
870	2871	1
542	2871	2
241	2871	7
448	2872	2
711	2873	4
1233	2874	4
1264	2875	5
411	2876	2
1073	2877	3
391	2877	4
684	2877	5
625	2877	7
626	2877	7
627	2877	7
1068	2877	4
681	2878	8
797	2878	5
1368	2879	3
265	2880	9
652	2880	11
1366	2881	4
34	2882	4
115	2883	11
622	2884	4
1219	2884	7
1220	2884	7
572	2885	5
574	2885	4
150	2886	3
457	2887	5
1255	2888	2
847	2889	4
152	2889	4
138	2890	3
1307	2891	4
300	2892	4
996	2894	4
277	2894	17
1214	2894	7
418	2895	3
854	2896	5
526	100	9
768	2897	1
1292	2898	8
1384	2898	4
1567	2900	3
369	2900	7
1256	2901	6
1282	2902	4
979	2903	10
887	2903	5
117	2904	1
1109	2904	3
940	2905	2
1530	2905	6
222	2905	4
1379	2905	10
28	2905	4
1014	2905	4
1013	2905	3
678	2905	3
36	2905	4
25	2905	2
1125	2905	2
1451	2905	2
1455	2905	2
143	2906	5
839	2906	7
376	2906	5
247	2907	11
1292	2907	1
1127	2907	8
1081	2907	6
1447	2907	4
181	2907	2
599	2907	6
600	2907	5
602	2907	6
1222	2907	2
534	2907	3
1057	58	1
1057	437	2
944	2909	10
1057	123	4
1057	232	5
434	243	1
478	2910	3
560	81	1
560	96	2
560	680	3
1461	2911	12
371	2911	7
239	1180	1
1004	207	2
1477	2911	5
970	2911	6
239	1117	3
1004	206	4
365	2912	5
1447	2913	11
804	2913	1
239	1085	5
1130	2917	6
239	858	7
174	395	1
361	2918	3
1119	651	1
174	301	3
371	401	10
433	2919	5
371	221	11
371	625	12
174	1059	4
174	460	5
488	2920	7
393	2921	4
710	2923	1
492	2923	7
138	2924	2
1061	2925	4
919	2925	3
752	2925	5
19	2926	8
1119	50	6
1119	244	9
1119	208	12
434	915	16
434	1117	15
371	1124	4
424	1137	2
371	1153	9
1057	1248	3
1119	1260	5
1057	1286	6
434	218	7
434	1449	10
434	432	17
434	100	18
355	352	1
355	344	2
355	50	3
223	556	16
1150	243	3
323	843	1
323	808	3
970	153	9
1150	373	9
1150	119	10
831	601	3
1150	64	11
970	414	10
323	442	6
1477	64	1
1477	248	2
1477	858	3
1477	105	4
223	243	1
1477	401	6
1477	77	7
384	50	5
384	244	10
1150	933	1
355	937	5
831	943	2
970	1124	4
384	1260	7
384	1316	11
425	1407	6
1150	1415	5
1150	1457	2
223	218	7
831	43	5
223	377	15
1307	28	1
1307	9	2
224	243	1
747	381	1
747	331	2
1348	64	1
1307	562	5
1346	34	1
747	57	4
1346	196	6
1346	375	8
444	56	1
886	56	1
886	83	2
886	36	3
886	699	4
932	153	13
224	556	18
910	1189	6
1348	128	3
224	218	7
910	134	10
747	869	3
747	882	6
444	940	2
747	960	7
1346	1083	5
444	1100	3
932	1117	11
932	1124	6
608	1965	5
611	1965	6
116	1965	6
1430	1968	7
418	1969	9
170	1970	9
353	1971	4
748	1971	2
1246	1972	4
1510	1972	5
230	1972	5
1061	1972	6
378	1972	7
1529	1972	2
380	1972	9
841	1972	9
1334	1972	3
1389	1972	3
1346	1972	7
662	1972	6
1348	1972	4
747	1382	5
1346	1396	2
224	1449	10
1346	1466	3
420	1974	3
1453	1974	4
1456	1974	2
338	1975	6
326	1976	3
762	1977	1
758	1977	5
759	1977	3
760	1977	3
552	1977	2
761	1977	2
611	1978	7
328	1978	6
1015	1978	4
62	1978	4
220	1978	4
1210	1981	2
982	1984	4
488	1984	8
934	1984	7
489	1985	4
1072	1985	5
1195	1986	4
1565	1986	10
103	1986	3
345	1987	4
40	1988	11
141	1988	8
594	1990	1
373	1991	9
273	1991	3
755	1991	3
1215	1991	4
1288	1991	2
1355	1991	1
533	1991	7
390	1991	3
634	1992	1
637	1992	3
342	1993	5
1077	1994	2
15	1994	1
892	1994	1
1226	1994	1
1045	1994	1
1328	1994	1
14	1996	6
213	1997	6
873	1997	3
345	1998	2
338	1998	3
62	2000	2
895	2000	4
277	2000	10
75	2000	5
299	2001	2
1362	2001	3
944	2001	11
1030	2002	5
1345	2002	5
825	2003	5
459	2004	4
1145	2005	5
566	2006	8
1087	2010	5
139	2011	3
671	2012	2
1255	2013	3
397	2014	9
1404	2016	4
884	2017	3
559	2044	3
948	2046	9
1379	2046	4
451	2047	3
796	2048	1
512	2048	11
23	2048	1
926	74	1
812	2048	1
926	221	2
239	2048	2
174	2048	2
926	182	3
1237	2048	1
837	120	1
617	2049	6
766	2049	3
1517	2049	3
1292	2051	4
767	2051	9
412	1132	1
412	151	2
790	854	6
581	863	3
1175	96	8
699	119	1
699	469	2
837	950	6
790	970	3
426	996	4
1175	1153	2
412	339	3
60	2051	6
699	401	5
837	383	5
986	2051	2
82	2051	7
837	539	8
426	86	1
1437	167	1
1305	143	1
1305	65	2
1305	494	3
944	2051	1
1035	2051	1
1305	128	4
790	70	1
685	2051	4
581	132	1
47	2051	3
1150	2051	8
790	505	5
1305	55	6
1379	2051	5
330	2052	3
300	2053	7
986	2053	5
1161	2053	5
575	2054	4
770	2054	8
1371	2054	2
1326	2054	5
566	2055	5
2	2056	1
217	2056	6
1522	2056	7
793	2056	4
1211	2056	6
103	2056	5
1311	2057	5
833	2059	8
451	2060	6
1470	2061	5
835	2061	3
82	2061	5
313	2061	1
147	2061	5
995	2062	6
302	2062	11
1293	2063	3
446	2064	3
402	2064	5
1410	2064	4
980	2065	2
518	2065	8
322	2065	7
569	2065	4
790	140	2
317	2066	5
169	2067	2
132	2070	2
1257	2071	6
1158	2072	1
96	2073	5
268	2074	3
528	2075	5
457	2076	4
670	2077	6
727	2079	2
1067	2080	11
533	2080	5
427	2080	1
1345	2080	1
102	2080	1
1030	2080	1
390	2080	6
1272	2111	2
1284	2111	3
557	2111	2
790	183	7
34	2112	9
1174	2113	5
350	2114	7
1260	2114	4
417	2114	7
1532	2114	4
1272	2115	1
575	2115	8
1553	2116	9
1012	2116	3
919	2119	7
981	2120	3
1217	2120	1
581	305	4
90	2120	3
894	2120	1
126	2120	9
707	2122	7
575	2122	11
918	2124	5
335	2126	4
553	2128	4
77	2130	8
136	2130	1
352	2131	3
1164	2132	2
1426	2133	2
1253	2134	16
768	2135	2
340	2135	1
967	2136	4
83	2137	6
19	2137	2
1175	1385	5
385	1415	1
837	1492	2
426	1516	3
515	2138	1
790	698	4
464	2139	9
918	2139	4
568	2139	6
626	2139	8
627	2139	8
1052	2141	3
861	2142	8
1270	2145	4
1563	2146	2
437	2146	5
227	2146	6
226	2146	7
11	2146	7
1156	2147	3
867	2148	4
1514	2148	1
579	2149	7
992	2150	3
1006	2150	1
143	2150	2
839	2150	3
376	2150	4
824	2151	3
341	2152	14
34	2152	13
630	2152	1
1207	2153	3
792	2153	2
894	2153	8
1141	2153	2
565	2154	6
1356	2156	6
784	2158	3
1195	2159	5
1463	2159	7
116	2159	7
370	2160	4
1200	2161	3
507	2162	7
342	2163	4
794	2165	6
599	2165	10
600	2165	8
875	2165	4
579	2165	9
277	515	2
454	2165	6
537	239	3
800	2165	4
871	2166	3
386	539	2
1254	96	7
201	119	1
201	469	2
1423	2170	2
537	232	6
1531	2170	3
427	2170	3
1050	2170	1
814	34	1
1032	2170	5
961	2170	4
838	455	7
863	86	1
670	2170	1
105	2171	3
188	2171	6
588	2171	4
1523	2171	8
1258	56	1
814	49	9
1258	649	3
252	1238	1
801	2173	6
1258	290	6
721	2173	4
923	2174	1
50	2174	2
780	2174	2
81	2174	5
49	2174	2
1251	2174	2
660	2174	4
662	2174	3
482	2174	4
1254	1385	5
386	1415	1
201	1479	14
75	2174	6
1007	2176	7
1008	2176	6
694	2177	10
801	2178	7
994	2179	3
171	2179	5
1136	2180	5
806	2180	5
53	2181	3
277	763	13
1258	774	2
277	628	6
277	647	7
1404	2181	6
1258	797	4
1439	949	10
1439	1023	9
1175	2183	4
1439	1083	7
1254	2183	4
277	1085	11
1439	1092	4
277	1097	1
277	1108	3
277	1136	8
1439	289	5
277	1137	9
1254	1153	2
386	1153	10
397	2184	11
277	1173	12
55	2185	1
251	2185	4
1175	2185	7
758	2186	4
759	2186	5
760	2186	5
679	2187	6
710	2188	8
530	2189	3
1074	2191	4
916	2192	5
1108	2192	5
568	2192	7
1200	2193	4
1195	2194	3
134	2194	4
1534	2194	4
112	2194	3
1345	2194	4
979	2195	11
887	2195	6
1253	2196	7
271	2197	2
277	342	16
1423	2197	6
277	138	18
1546	2197	10
1245	2197	6
1066	2199	4
444	2199	4
1022	2202	3
744	2203	9
553	2204	8
1383	2205	4
1475	2205	12
244	2205	6
1083	2206	8
189	2207	2
105	2207	1
591	2207	1
155	2207	1
1470	2207	1
98	2207	1
301	2207	1
618	2207	1
719	2207	1
695	2207	1
263	2207	2
590	2207	2
1033	2207	1
993	2207	3
919	2207	1
269	2211	5
268	2212	8
866	2213	5
709	2214	10
42	2215	3
911	2215	2
766	2215	4
287	2215	2
1537	2215	2
1538	2215	2
1397	2215	4
125	2215	4
1119	2215	4
976	2215	2
15	2216	8
1447	2216	10
942	2218	3
461	2219	12
460	2219	11
1255	2220	5
1517	2222	5
1379	2222	11
530	2222	6
1206	2222	3
221	2223	6
1221	2225	6
1549	2225	7
689	2225	8
161	2225	8
1027	2225	5
1135	2225	6
1379	2225	12
200	2225	6
484	2226	7
771	2227	2
45	2228	4
526	2228	5
434	2228	5
1230	2228	11
405	2228	8
1548	2228	1
89	2228	6
1470	2228	4
1249	2228	5
135	2228	1
322	2228	3
699	2228	4
201	2228	3
243	2228	2
241	2228	3
223	2228	5
224	2228	5
203	2229	4
428	2230	4
927	2231	1
1214	2231	1
915	1371	4
928	2231	1
929	2231	1
1296	2232	1
307	478	3
307	539	4
506	92	1
1122	2232	9
51	86	1
407	2232	1
48	2232	1
792	2232	1
506	446	3
918	2232	1
311	1137	1
1398	2232	1
253	1238	1
253	556	2
915	518	3
452	2232	1
1359	2232	2
29	2232	8
917	2232	8
28	2232	3
36	2232	3
1014	2232	2
966	2232	1
67	2232	1
910	2232	1
1044	2232	1
295	2232	1
650	2232	1
294	2232	1
928	2233	3
929	2233	3
877	2238	4
616	2239	4
770	2239	5
713	2239	5
260	2239	3
457	2240	1
484	2241	1
206	2241	3
307	1415	1
843	2241	2
830	2242	6
1341	2242	3
1387	2243	5
1429	2243	5
1388	2243	5
1431	2243	5
958	2245	4
37	2245	4
763	2247	4
809	2247	3
179	2247	2
33	2248	4
1044	1238	2
1503	2249	7
50	2249	4
784	2249	5
242	2249	7
243	2249	9
1443	2249	9
1068	2249	5
1312	2250	10
1212	2251	3
633	2251	3
897	2251	1
1521	2251	1
236	2251	2
898	2251	1
1043	2251	1
1093	2251	2
830	2252	7
1184	2253	4
915	51	1
915	483	2
311	434	5
1427	447	1
1427	313	2
1427	137	3
713	1211	6
919	197	2
713	638	7
295	730	5
1112	822	6
462	942	1
427	157	2
1379	1125	7
295	1183	3
561	168	1
561	591	2
561	1225	4
1379	1238	1
263	1238	1
1379	100	6
427	1516	4
430	1356	2
1218	878	1
1218	898	3
1218	933	2
430	392	1
430	414	5
964	568	2
672	122	7
672	1319	8
1428	1387	1
1218	387	4
964	1025	1
964	1263	4
964	496	5
749	47	1
749	141	2
650	53	2
752	90	1
505	625	2
1238	232	7
976	651	1
1219	387	4
976	337	4
976	50	9
1219	878	2
749	887	3
976	895	5
1219	898	3
1219	933	1
976	933	12
728	1127	4
1219	1190	8
1219	191	9
976	1203	10
696	1221	1
696	1245	2
505	471	7
505	413	5
505	168	6
1219	1404	5
976	1485	3
1030	289	6
1209	165	1
507	1338	6
538	168	1
538	126	2
538	301	3
538	451	4
538	102	5
777	346	1
1082	233	1
1220	387	4
860	1221	1
860	1245	2
1082	655	7
387	109	7
387	750	1
1209	833	2
1220	878	2
1220	898	3
1220	911	11
1220	933	1
661	1127	7
1345	1273	8
1082	81	2
1220	352	12
507	1377	3
387	1404	2
1220	1404	5
777	1442	3
1082	1495	4
927	250	3
927	703	4
741	59	2
741	252	3
741	373	5
662	843	1
508	875	3
508	1032	4
1214	1090	8
662	1112	2
1111	525	2
1050	51	7
508	70	1
1050	1328	4
1111	46	3
508	135	2
662	306	4
662	166	5
741	1396	1
508	454	5
508	313	6
1472	104	1
1472	412	2
942	121	2
928	44	7
928	703	8
1430	600	2
1430	519	3
1472	50	4
254	47	1
254	237	2
254	1123	3
1472	345	6
942	107	4
942	729	1
1090	931	10
942	932	9
979	119	3
942	1092	6
1090	1096	8
659	1127	5
1090	1279	9
979	1475	6
1167	330	2
1167	230	5
1451	102	1
242	101	2
929	250	7
929	703	8
1276	282	2
242	949	10
1080	1114	1
1080	1159	2
1080	1174	3
1080	861	5
1080	915	6
1080	100	7
86	289	4
86	439	8
86	949	7
97	1127	5
86	1171	6
1276	1193	5
1276	1260	1
86	1307	5
887	1307	10
887	341	9
887	1475	2
887	387	11
1452	102	1
1028	98	1
1240	34	1
1240	204	3
1294	101	1
1294	94	2
1294	299	3
243	174	10
1028	128	2
1294	218	4
1028	277	3
1028	77	4
243	399	11
351	330	3
243	100	12
1041	248	1
1041	333	2
1041	471	3
1041	400	4
1041	894	5
1041	83	6
180	289	4
180	298	7
180	439	10
1240	820	2
180	949	9
1452	1129	3
180	1171	6
351	1275	9
180	1307	5
308	93	2
1453	102	1
241	243	2
241	218	6
241	449	13
241	306	17
805	628	2
87	289	4
87	122	6
87	298	7
87	439	10
847	740	1
935	892	1
805	923	4
847	928	5
87	949	9
1453	1129	2
1453	1176	3
935	1176	2
805	1196	3
935	1258	3
318	1269	5
87	1307	5
805	1319	1
241	1449	9
241	1517	18
805	142	6
1454	102	1
590	532	4
1391	1023	6
1391	161	7
590	622	7
1391	80	9
1414	72	1
1414	233	2
1414	125	3
1414	164	4
1414	423	5
1414	191	8
148	651	1
148	127	3
590	309	5
88	289	4
88	122	6
88	298	7
88	439	10
1443	724	6
152	740	1
1443	157	2
590	830	10
152	928	7
590	931	1
88	949	9
798	204	4
148	1151	2
1454	1176	2
1070	1176	1
590	1196	6
590	1202	3
590	1245	8
88	1307	5
152	129	10
1455	102	1
1169	317	1
1169	392	2
16	100	2
16	1153	4
16	525	8
189	532	4
16	109	10
930	437	1
930	48	2
930	79	3
189	609	9
799	204	3
189	622	10
189	309	5
189	830	11
930	915	4
189	931	1
189	1083	8
1169	1095	3
930	1100	8
189	1196	6
189	1202	3
189	1245	7
1279	1248	4
1033	1372	9
1033	532	2
1085	18	1
1456	102	1
1444	157	2
1206	64	1
1033	688	6
1033	309	4
1206	717	4
1033	830	5
1206	248	6
931	915	8
1033	931	12
509	1001	6
931	1100	1
1033	1165	11
1456	1176	3
1033	1196	7
1033	1202	3
1033	1245	8
931	48	2
931	79	4
931	274	5
509	305	8
509	290	9
931	219	10
931	437	11
509	1431	4
1207	64	1
105	416	2
952	82	1
394	621	2
394	658	3
1187	165	1
952	338	2
952	447	3
952	278	4
690	1204	9
105	1238	5
562	1270	3
1457	1297	6
690	1319	2
320	1430	2
394	1490	4
690	61	4
690	108	5
690	265	6
690	63	10
1187	394	5
1197	191	2
1197	171	3
1197	439	4
1197	404	5
1197	50	6
1188	165	1
435	82	1
435	338	2
73	289	2
435	447	3
592	40	6
592	847	5
992	873	7
1312	911	6
1312	929	9
1177	569	2
1177	245	3
785	431	1
1197	966	1
435	975	4
1177	142	7
1177	391	8
1177	444	9
785	160	2
785	764	3
1197	1140	7
592	1164	4
1177	1182	4
1312	125	1
1312	221	2
1312	525	3
1312	48	4
1188	1395	2
73	1449	8
1312	237	5
1188	394	4
1312	378	7
1312	82	8
1312	697	11
1312	132	12
1312	559	13
1409	1220	14
591	532	5
679	557	1
879	233	1
679	623	2
679	232	4
879	101	2
956	122	4
199	1098	6
199	180	9
436	82	1
436	338	2
436	447	5
591	830	6
679	888	5
591	931	10
436	975	4
879	1007	4
635	1139	3
591	1202	9
436	1263	3
879	1265	5
753	691	1
753	229	5
57	1436	4
1189	165	1
358	623	1
358	557	2
1317	307	2
480	41	4
998	56	2
225	150	2
225	333	3
331	690	3
1317	573	4
17	1286	1
17	23	2
200	551	3
358	316	7
225	744	4
480	764	3
225	765	1
225	829	6
1317	965	8
1317	1153	5
998	1196	1
225	1231	5
70	1288	8
1152	100	10
1317	347	9
272	1398	3
1341	43	2
428	180	1
244	1286	2
1341	111	4
1263	548	5
244	213	3
244	950	5
1341	423	5
1263	732	2
999	56	6
1341	660	8
673	1226	3
673	180	10
1341	747	1
1263	796	1
1263	805	7
1341	900	6
428	953	2
557	1083	3
999	1196	1
428	1295	8
428	1383	5
1263	360	6
153	762	6
734	173	1
993	191	2
734	818	12
402	893	1
993	109	5
1392	56	1
18	1286	1
18	730	6
402	245	3
1357	1279	7
1357	1025	8
402	907	2
321	917	4
153	953	9
1392	1196	6
1392	1209	5
321	1236	7
734	1319	3
153	79	7
153	437	8
734	232	8
321	1422	5
734	307	10
734	108	11
1392	134	9
245	4	1
359	153	1
245	3	2
359	602	2
245	1046	3
245	859	4
359	630	3
1322	51	1
245	1037	6
1322	363	3
245	20	7
1322	522	5
1266	775	3
674	1300	3
674	985	4
446	893	1
1255	981	4
796	1054	8
1266	1083	4
796	1083	5
796	1297	7
1255	56	1
1255	73	6
1322	1415	2
796	243	3
796	249	4
796	320	6
796	364	9
395	395	1
1234	441	1
1234	678	2
1234	252	4
395	492	2
1234	779	3
615	1136	1
395	684	4
177	1145	4
1406	135	2
1406	394	3
1406	810	4
1406	737	5
109	1300	3
109	985	5
1474	56	1
1474	468	2
888	237	1
888	619	3
1034	289	1
1474	247	3
615	1495	5
1474	471	5
615	195	10
598	289	1
551	134	1
24	740	11
551	265	2
1237	1341	5
907	180	1
551	829	5
178	833	6
907	849	2
628	213	5
551	1211	3
580	1472	6
628	1277	3
598	1285	7
445	1476	6
729	1507	4
730	1507	4
393	1517	6
24	93	10
1473	33	1
619	462	1
1473	65	2
442	265	1
619	177	2
1473	107	3
619	917	5
261	936	2
261	1146	4
91	1211	3
261	1226	1
91	134	1
91	265	2
91	387	5
595	629	2
595	1202	6
261	1441	3
441	148	2
442	367	2
619	600	4
442	396	3
619	654	6
442	408	4
852	462	1
852	177	2
722	134	1
722	1211	3
852	516	5
722	265	2
185	126	1
185	695	3
852	1302	4
800	473	1
185	470	5
722	387	5
31	665	6
310	532	1
310	551	2
310	155	5
326	168	1
326	409	2
326	520	4
800	65	5
481	177	2
651	752	3
481	947	6
1146	349	4
1146	335	5
22	168	1
22	520	2
22	1374	3
651	1067	1
481	1148	3
22	956	4
1020	1211	2
651	1231	4
1020	134	1
1020	291	6
1020	387	8
22	1299	6
22	1344	7
535	1388	4
651	237	5
594	730	6
594	514	2
1211	126	2
1211	317	3
1211	100	4
1337	1023	8
1315	73	1
1211	250	8
74	218	2
1337	40	9
1315	43	2
594	586	8
1055	317	8
1315	1183	3
1315	123	4
1315	1243	5
1315	228	6
1315	779	7
828	168	1
828	307	2
828	100	3
828	692	4
1211	1415	9
74	1440	6
352	1446	2
828	1514	6
726	60	1
726	51	2
726	290	3
726	199	4
726	668	5
510	208	1
510	570	2
1241	40	1
1241	775	4
510	808	3
1316	1307	4
1316	1153	5
1316	931	8
1233	441	1
1233	284	2
1233	825	3
510	394	4
582	166	7
582	815	6
582	862	5
510	877	8
1241	913	2
1241	970	3
510	989	5
901	90	1
901	472	2
901	424	3
1269	289	2
901	262	5
292	330	1
19	70	1
292	423	3
19	204	4
608	836	7
608	443	8
19	328	9
1269	985	3
608	1023	4
292	1231	4
292	442	6
482	1431	2
353	553	1
353	621	2
1186	228	1
1186	142	2
1186	544	3
270	134	1
270	302	2
270	49	3
270	614	5
360	315	4
906	172	1
906	987	2
611	836	9
611	1023	5
319	1135	3
906	84	3
906	763	4
906	401	5
906	1183	6
962	1319	1
962	628	2
360	1473	3
353	1482	6
1193	3120	3
1194	3120	4
913	3120	3
325	3120	4
502	3120	2
162	3120	4
629	3120	4
353	3121	5
989	3123	8
1475	3123	9
1116	3124	5
204	3124	5
542	3124	4
329	3124	6
667	3125	5
680	3125	2
323	3127	2
27	3128	4
677	3128	5
26	3128	4
515	3129	8
962	1196	8
649	3130	4
341	3131	5
1178	3132	3
988	3133	2
262	3134	4
1409	3135	11
1116	3136	9
1505	3136	14
469	47	1
483	153	1
1144	455	1
286	229	2
286	1309	3
286	985	4
854	783	1
286	1197	5
854	232	2
854	247	3
469	590	2
1144	887	6
483	910	2
483	963	4
751	1203	3
469	422	4
286	1494	1
160	153	1
967	455	1
136	891	2
963	103	3
511	247	2
511	363	4
967	515	7
967	151	8
963	683	8
511	783	1
176	563	1
963	468	10
967	875	3
160	910	2
160	963	4
967	965	6
176	992	2
176	1012	3
967	1307	5
670	347	7
176	202	7
1173	563	7
103	605	2
103	695	4
1158	1351	12
139	254	1
68	153	1
139	754	5
75	783	1
68	910	2
68	963	4
1158	967	9
75	1011	4
1158	1267	8
1158	1284	6
139	1289	2
103	1330	1
1158	195	4
1158	419	5
957	287	4
75	247	2
75	224	7
175	468	11
69	153	1
69	370	5
69	114	6
246	1152	1
744	773	3
69	910	2
246	89	2
664	614	3
32	40	8
69	963	4
513	317	2
513	1017	11
513	377	4
744	1118	10
744	1262	2
513	449	12
513	243	13
1364	14	1
1364	497	3
744	1378	7
32	1414	4
1364	1498	4
744	153	1
744	114	4
744	411	5
744	413	13
697	153	1
512	100	2
815	773	3
815	819	5
512	449	10
794	195	3
794	404	5
697	910	2
862	1262	1
815	1262	2
815	1325	12
247	1098	4
328	1136	1
328	72	3
247	1396	5
328	100	5
328	871	8
328	311	10
815	153	1
815	114	4
815	163	6
815	168	7
815	143	8
159	153	1
745	773	4
514	783	13
514	1136	6
1	56	1
1128	1262	1
745	1262	2
53	254	1
53	325	2
1	126	2
514	232	7
514	363	8
514	449	11
1	79	3
1	724	4
1	472	5
1	77	6
829	120	1
1104	1509	3
745	617	14
745	688	7
745	153	1
745	42	3
745	428	5
745	114	6
745	86	15
745	80	16
745	143	17
584	534	2
1105	278	3
584	30	1
584	809	4
484	969	8
584	1008	5
603	1025	1
613	1271	6
714	414	1
613	51	10
613	416	11
603	34	5
714	1157	6
1116	551	6
1116	1325	7
1105	1413	2
1105	1426	1
1399	72	1
1399	67	2
859	414	1
1399	630	3
859	294	2
1399	330	4
1399	391	5
1399	429	6
859	353	11
585	809	6
1469	829	3
1469	834	1
1469	1211	2
1126	1248	6
1046	1444	7
810	321	6
266	1055	4
1074	436	9
429	101	1
429	150	2
429	264	3
429	231	4
1366	850	3
429	947	5
1163	1025	1
1163	1238	2
1366	64	1
1366	105	2
1324	652	1
1324	577	2
341	1340	13
1324	521	6
947	321	3
291	1055	1
203	101	1
203	150	2
203	661	3
341	1409	10
1324	1460	4
1323	870	3
341	1468	3
203	905	6
203	947	7
1324	1034	3
1246	1225	1
1246	109	2
1246	306	5
1385	591	2
1385	268	5
258	560	3
866	603	1
866	745	2
204	150	1
204	101	2
204	556	3
821	321	3
204	445	6
23	43	3
23	795	4
23	885	5
23	441	6
23	980	7
1329	1023	8
34	1155	10
34	1454	3
1208	186	1
1208	519	2
939	289	1
939	837	3
1208	641	3
1208	443	4
1230	940	12
1479	992	4
1422	1052	1
939	428	2
1230	209	3
138	254	6
1353	420	1
1383	1227	5
1353	900	2
1353	711	3
1353	844	5
1230	191	9
1230	709	10
413	1453	3
1479	64	1
389	2927	6
1022	2928	4
1292	2929	9
1556	2929	1
330	2929	2
1127	2929	14
607	2929	6
1297	2929	1
1222	2929	7
264	2929	3
1300	2929	3
219	2929	1
220	2929	1
900	2929	1
223	2929	8
241	2929	11
1379	2930	8
1127	2930	6
231	2930	9
1036	2930	3
1039	2930	9
1090	2930	4
1538	2930	6
425	2930	5
1537	2930	8
976	2930	11
962	2930	3
796	2931	2
712	2931	2
1483	2931	5
526	2931	3
434	2931	3
223	2931	3
224	2931	3
1289	2931	2
567	2931	8
504	2931	2
1474	2931	4
376	2932	7
605	2933	14
208	2935	3
120	2937	4
488	2937	4
122	2937	3
124	2937	3
1476	2939	3
1225	2942	5
1134	2942	4
1532	2942	3
330	2943	4
481	2944	4
1067	2945	10
82	2945	1
1118	2945	6
908	2946	3
1113	2947	2
164	2947	4
855	2947	4
549	2948	7
489	2950	5
1130	2951	7
988	2952	7
1426	2954	1
1390	2955	2
884	2956	8
1000	2956	8
885	2956	5
712	2956	6
1440	2956	1
222	2956	2
669	2956	2
224	2956	17
970	2956	2
932	2956	2
371	2956	2
1430	2958	1
1451	2959	6
1455	2959	7
1433	2959	4
1330	2960	3
1331	2960	2
426	2961	2
98	2962	2
1514	2962	7
983	2962	9
1071	2962	5
433	2962	8
814	2962	6
121	2963	4
265	2964	2
1482	2964	4
1158	2965	10
535	2966	2
826	2967	10
1171	2968	5
527	2971	6
629	2971	3
1342	2971	2
809	2972	4
765	2973	3
980	2973	6
1111	2973	12
163	2973	8
699	2973	8
515	2974	5
53	2975	4
235	2975	4
207	2975	1
3	2975	6
1085	2975	2
519	2978	10
512	2979	8
723	2981	7
1519	2981	3
284	2982	3
459	2983	1
459	2984	3
29	2986	6
694	2987	3
300	2988	3
1072	2989	6
433	2990	6
1415	2992	6
813	2992	6
1061	2993	2
882	2993	5
268	2994	6
441	2995	3
213	2996	7
1143	2998	5
1412	2998	3
1352	2998	5
286	2998	6
63	2998	5
1415	2999	13
240	3001	6
763	3002	1
199	3002	2
280	3005	7
699	3005	10
1061	3006	7
881	3006	4
1266	3007	6
1239	3007	7
626	3007	18
625	3007	15
627	3007	17
84	3007	11
527	3007	7
705	3007	9
706	3007	7
236	3007	12
1470	3007	6
1267	3007	1
1345	3007	9
1269	3007	1
392	3008	4
624	3009	7
291	3010	2
1130	3011	9
553	3012	5
594	3013	12
416	3015	5
814	3015	7
690	3015	3
1055	3015	3
384	3016	6
444	3016	5
1397	3016	7
125	3016	7
1119	3016	8
743	3019	10
382	3020	12
840	3020	12
381	3020	9
380	3020	14
841	3020	14
343	3020	6
1204	3020	4
663	3021	9
134	3021	9
729	3021	3
731	3021	1
1004	3021	7
661	3021	12
97	3021	11
361	3022	2
1219	3023	10
995	3024	9
285	3025	5
1085	3026	5
1253	3027	17
1401	3028	4
1156	3029	4
1253	3029	2
656	3031	4
507	3032	2
737	3034	1
154	3036	3
335	3036	1
1312	3038	15
96	3039	4
589	3041	2
126	3041	2
1058	3041	4
247	3042	12
1323	3042	2
1468	3042	3
845	3042	6
602	3042	5
170	3042	5
1143	3042	4
295	3042	9
809	3042	2
920	3042	4
687	3042	12
565	3042	3
594	3042	9
75	3042	9
734	3042	13
497	3043	3
549	3044	14
959	3044	5
299	3045	7
339	3046	2
1071	3047	3
1386	3047	2
1423	3047	1
400	3047	2
47	3047	8
664	3047	9
1191	3048	5
826	3049	4
331	3050	4
1352	3051	9
468	3052	5
274	3052	3
713	3052	1
889	3054	3
417	3055	8
830	3056	16
1550	3056	4
685	3057	2
1326	3057	7
853	3059	2
874	3059	2
122	3059	6
487	3059	8
1415	3060	10
1303	3061	9
234	3062	3
1284	3063	4
415	3064	2
52	3066	5
478	3066	8
646	3066	3
1395	3069	1
509	3069	2
479	3070	9
646	3071	5
1163	3072	3
894	3072	2
463	3072	4
1026	3072	2
175	3072	3
509	3072	5
1161	3072	6
594	3072	10
664	3072	10
341	3073	2
757	3074	5
1252	3075	2
31	3075	2
882	3076	6
976	3077	6
284	3078	2
361	3079	5
990	3080	13
1040	3081	4
1166	3082	8
697	3084	4
1040	3085	5
263	3086	7
1033	3086	10
1178	3087	8
1171	3089	1
338	3090	4
1256	3091	5
1103	3092	2
727	3094	1
397	3095	8
396	3095	7
753	3096	4
9	3096	6
383	3097	3
43	3097	3
786	3098	3
141	3099	10
1122	3101	6
186	3101	8
187	3101	9
175	3101	5
963	3101	5
664	3101	8
1433	3101	1
661	3103	1
660	3103	1
1299	3103	1
728	3103	1
659	3103	1
97	3103	1
1443	3103	1
1316	3103	1
826	3104	8
1164	3105	5
1375	5121	9
1361	5122	3
1173	5123	3
1375	5124	3
1375	5126	6
1375	5127	10
1375	5128	2
1375	5129	4
1326	5131	11
1329	5132	4
1435	5134	2
1440	5137	2
1440	5138	4
1440	5139	5
1441	5141	1
1441	5142	2
1441	5143	3
1441	5144	4
1441	5145	5
1441	5146	6
1441	5147	7
1442	5149	5
1444	5152	6
1445	5153	2
1445	5154	4
1561	5154	6
1237	5156	6
1391	5157	5
1391	5158	3
1391	5159	4
1325	5160	2
1325	5161	5
1325	5162	9
1447	5163	2
1447	5164	6
1447	5165	12
1448	5166	2
1448	5167	4
1449	5170	3
1449	5171	5
1450	5173	3
1450	5174	4
1451	5175	3
1451	5176	4
1451	5177	5
1453	5180	5
1453	5181	7
1501	5182	4
1454	5182	3
1455	5183	5
1454	5183	4
1456	5183	4
1455	5184	9
1454	5184	7
1455	5185	6
1455	5186	8
1456	5187	5
1456	5188	7
1457	5189	3
1457	5190	4
1458	5191	1
1459	5191	1
1458	5192	2
1459	5192	2
1459	5193	3
1459	5194	4
1460	5195	4
1460	5196	6
1461	5198	4
1461	5199	9
1461	5200	11
1461	5201	13
1463	5209	3
1464	5210	3
284	1519	9
717	1520	5
1231	1522	4
1232	1522	5
1230	1522	4
1461	1524	5
481	1524	1
1562	1525	4
728	1525	3
661	1525	6
660	1525	5
659	1525	4
97	1525	4
1277	1526	3
133	1527	3
802	1528	2
96	1529	1
426	1530	5
764	1531	2
1381	1531	1
358	1531	6
1017	1531	6
656	1532	3
652	1533	9
57	1533	3
1178	1533	12
1124	1534	4
1397	1535	9
582	1536	1
283	1537	1
680	1537	1
1170	1537	1
419	1537	2
1522	1537	1
1523	1537	1
1516	1537	1
385	1537	2
386	1537	3
1372	1537	1
165	1538	9
76	1538	7
1173	1539	5
1511	1541	2
1127	1541	9
1059	1541	2
1332	1541	5
1161	1541	2
592	1541	3
1032	1541	6
1056	1541	2
40	1542	8
771	1543	5
558	1544	1
1155	1545	3
1017	1546	7
1172	1547	4
397	1548	10
40	1548	9
141	1548	7
549	1550	6
265	1551	8
1164	1552	1
150	1553	1
828	1554	5
944	1555	5
949	1555	1
535	1555	1
352	1555	1
470	1557	8
407	1558	6
219	1558	4
220	1558	9
201	1558	7
1337	1558	5
766	1560	2
1425	1561	5
1389	1561	6
563	1561	8
137	1562	1
1085	1563	3
981	1564	1
1446	1564	1
1508	1564	3
199	1564	1
200	1564	1
673	1564	1
1357	1564	1
1204	1564	7
264	1564	4
1300	1564	2
397	1565	6
1097	1566	5
1098	1566	4
232	1567	3
822	1567	5
302	1567	7
774	1568	1
336	1569	8
760	1569	7
1341	1569	7
907	1571	5
336	1573	9
1106	1574	4
300	1577	2
13	1577	7
1565	1578	3
1566	1578	4
1184	1578	9
539	1580	4
481	1581	5
1093	1582	6
1230	1583	8
3	1584	7
12	1585	2
1065	1585	2
687	1585	2
1251	1585	1
798	1585	3
799	1585	2
690	1585	1
734	1585	2
948	1586	8
1219	1586	6
1220	1586	6
351	1587	6
1292	1588	5
845	1588	2
1038	1588	3
492	1588	1
849	1590	6
1304	1592	3
196	1593	8
633	1594	1
349	1595	3
833	1596	9
1129	1596	5
836	1596	1
835	1596	9
708	1596	2
284	1597	5
350	1598	9
862	1599	5
774	1600	7
210	1602	4
398	1605	1
265	1606	1
333	1607	1
1165	1608	1
1026	1613	4
254	1613	4
1253	1614	8
1383	1615	6
884	1617	1
1000	1617	1
885	1617	1
1252	1618	5
857	1619	3
858	1619	3
1178	1620	6
328	1621	7
830	1623	2
1083	1625	5
1554	1626	3
186	1626	6
16	1626	9
170	1628	2
275	1628	1
718	1628	6
1517	1628	4
1267	1628	2
360	1629	2
540	1630	12
504	1630	6
1021	1630	5
608	1630	9
611	1630	11
761	1631	5
824	1633	2
360	1633	1
824	1634	6
866	1635	3
324	1637	6
624	1637	6
984	1637	5
1051	1638	3
760	1639	8
1087	1640	3
832	1641	6
405	1641	3
636	1641	5
646	1641	4
1222	1642	8
1381	1642	4
1357	1642	6
145	1643	5
587	1644	7
974	1645	6
1396	1645	6
975	1645	6
977	1646	6
470	1647	6
826	1648	5
214	1649	4
826	1650	3
195	1651	4
374	1651	6
1164	1653	6
141	1654	5
1275	1656	3
990	1656	4
948	1656	7
1138	1656	5
955	1656	3
892	1657	6
470	1658	3
1344	1659	4
310	1659	4
406	1659	4
1349	1659	4
1201	1660	1
228	1660	1
1010	1661	5
1098	1662	8
1097	1662	4
211	1663	2
980	1664	5
1334	1664	6
693	1664	6
558	1664	10
1150	1664	4
673	1664	6
1070	1665	2
472	1667	1
989	1667	1
632	1668	4
33	1669	2
1513	1670	6
948	1670	10
1535	1670	7
1090	1670	6
210	1671	1
371	1671	5
970	1671	5
932	1671	7
277	1671	4
1278	1671	1
223	1671	14
868	1672	3
763	1672	3
411	1672	4
724	1672	5
18	1672	3
1223	1672	8
1200	1673	5
709	1674	4
519	1674	5
396	1674	3
168	1674	3
1257	1675	7
1098	1677	2
1097	1677	2
850	1678	10
941	1678	3
1153	1678	5
1154	1678	4
1090	1678	2
595	1678	1
1307	1679	3
1211	1680	5
680	1680	3
518	1680	2
994	1681	4
410	1682	3
229	1683	8
507	1686	1
390	1688	4
533	1688	6
826	1689	6
142	1691	4
681	1691	4
797	1691	6
451	1692	8
341	1693	11
284	1694	7
324	1695	8
1362	1695	2
1290	1696	7
416	1697	1
420	1697	5
834	1697	1
83	1697	9
737	1699	2
415	1700	1
340	1701	3
602	1702	2
875	1702	3
60	1702	7
39	1702	7
1251	1702	4
1220	1702	10
815	1703	9
745	1703	9
1035	1703	8
744	1703	12
1213	1704	3
94	1704	3
184	1704	3
95	1704	4
32	1705	3
603	1706	4
599	1706	8
600	1706	7
602	1706	8
1368	1706	2
1369	1706	2
1370	1706	2
1169	1707	4
191	1708	2
1187	1709	2
933	1709	3
996	1711	9
331	1712	5
20	1714	3
1506	1714	6
804	1714	5
549	1714	13
34	1715	5
305	1716	7
145	1718	3
1371	1718	8
730	1719	3
34	1720	6
1095	1721	4
862	1721	6
1128	1721	7
829	1721	4
296	1721	7
978	1721	4
966	1721	5
320	1723	1
1067	1725	6
667	1725	8
1549	1726	6
1283	1726	5
479	1726	5
34	1727	1
129	1728	4
733	1729	3
147	1729	7
922	1730	2
299	1733	5
1261	1734	5
852	1735	6
1566	1736	7
1415	1737	7
277	1737	5
744	1739	11
527	1740	3
1049	1740	4
415	1741	4
912	1742	7
278	1743	4
59	1745	6
58	1745	8
1294	1746	5
1139	1746	2
804	1746	3
667	1746	10
811	1746	6
1042	1746	7
1303	1747	4
500	1748	5
462	1750	5
1279	1752	7
1564	1752	4
563	1752	6
875	1752	8
707	1752	5
598	1753	5
203	1753	5
637	1753	1
846	1753	1
1038	1753	4
693	1753	7
645	1753	1
1133	1753	5
55	1754	4
56	1754	9
52	1754	9
1037	1754	7
1039	1754	6
1081	1754	3
1174	1755	6
476	1756	7
1109	1758	6
139	1759	4
2	1762	5
1112	1764	3
316	1765	7
1344	1766	7
18	1767	8
640	1768	4
1138	1769	4
535	1770	3
33	1772	6
540	1773	11
1189	1774	3
1339	1774	2
587	1775	9
774	1776	3
352	1777	4
1526	1778	2
1079	1778	2
680	1778	6
658	1778	3
543	1780	2
1153	1780	3
964	1780	3
1290	1781	8
34	1782	7
1044	1783	5
271	1784	3
393	1785	9
772	1786	4
1074	1787	7
433	1787	12
1263	1789	3
413	1790	1
1430	1790	6
93	1791	8
1242	1793	7
1279	1793	5
591	1793	8
1367	1793	7
911	1793	4
150	1796	2
997	1799	7
352	1800	5
1385	1801	4
1217	1801	3
778	1801	4
769	1802	1
645	1803	2
391	1804	3
428	1806	6
1378	1807	5
956	1808	3
810	1809	4
947	1809	4
821	1809	5
1304	1809	7
709	1809	5
1078	1810	4
1173	1810	6
117	1811	10
1095	1812	5
1364	1813	5
652	1814	2
414	1815	8
393	1815	10
470	1816	1
1256	1818	4
99	1821	3
577	1821	3
578	1821	2
576	1821	2
424	1821	3
1129	1822	8
1242	1823	5
532	1823	6
1301	1824	3
369	1826	5
578	1826	7
55	1827	6
470	1828	10
34	1829	8
1455	1830	4
1329	1830	5
1302	1830	3
297	1830	6
695	1830	5
1298	1831	3
655	1831	4
989	1832	9
457	1833	3
718	1834	4
1245	1834	3
202	1834	2
1106	1836	5
973	1837	4
562	1838	1
598	1838	2
12	1838	4
734	1838	9
1034	1838	2
1553	1839	13
1116	1839	2
723	1839	8
1519	1839	9
1049	1839	1
820	1839	2
181	1839	3
1431	1839	2
1345	1839	2
152	1839	3
329	1839	3
121	1840	2
26	1840	8
1216	1840	3
55	1841	2
991	1841	4
434	1841	14
594	1841	3
186	1841	9
187	1841	5
563	1841	2
89	1841	4
443	1841	6
1511	1841	8
885	1841	8
567	1841	4
966	1841	3
999	1841	5
1392	1841	8
595	1841	4
1046	1841	9
708	1842	6
622	1843	6
969	1843	3
1217	1844	7
1259	1844	2
486	1846	4
733	1847	2
1452	1848	6
1214	1848	6
1453	1848	6
320	1849	4
946	1850	3
243	1851	1
526	1851	2
434	1851	4
1003	1851	1
1352	1851	1
492	1851	4
646	1851	1
416	1851	2
1045	1851	2
1089	1851	3
1092	1851	3
295	1851	2
242	1851	1
241	1851	1
509	1851	1
223	1851	2
224	1851	4
1324	1853	5
1262	1853	3
1261	1853	3
229	1854	7
1408	1855	4
1231	1856	5
1230	1856	2
1232	1856	7
1209	1858	3
990	1859	5
1480	1861	2
850	1861	11
1189	1861	2
765	1861	1
867	1861	8
661	1861	13
660	1861	6
97	1861	12
871	1862	5
1046	1862	2
995	1863	4
302	1863	1
944	1863	2
1035	1863	2
1369	1863	8
1370	1863	8
1371	1863	9
239	1863	4
1090	1863	3
597	1864	1
192	1864	1
1342	1864	1
531	1864	1
836	1864	2
1120	1864	4
1414	1864	7
26	1865	9
1479	1865	2
485	1865	6
676	1865	1
527	1865	8
950	1865	6
739	1865	4
7	1867	5
512	1868	5
514	1868	5
1129	1868	7
147	1868	10
223	1868	13
739	1868	6
513	1868	3
445	1869	8
129	1871	3
1266	1873	5
756	1874	3
507	1874	4
418	1874	7
906	1875	7
186	1875	7
467	1875	7
113	1875	7
955	1876	7
385	1876	3
386	1876	4
307	1876	5
257	1877	3
829	1877	2
350	1877	2
1064	1877	5
1065	1877	5
312	1877	5
719	1877	4
464	1878	10
313	1879	5
409	1880	6
888	1881	4
764	1883	3
603	1883	2
872	1883	5
615	1883	2
751	1883	6
637	1885	2
52	1885	10
1531	1885	6
932	1885	12
18	1885	7
1144	1886	3
968	1887	1
718	1887	5
993	1887	4
320	1888	3
1008	1889	5
1007	1889	6
586	1892	3
404	1898	10
26	1899	3
27	1899	3
753	1899	2
677	1899	4
944	1901	12
1035	1901	4
161	1901	1
91	1902	6
133	1903	7
19	1904	7
1004	1906	5
1292	1907	6
1266	1907	1
534	1907	1
324	1907	1
854	1907	4
511	1907	3
75	1907	3
451	1909	7
418	1910	6
738	1911	5
213	1912	4
823	1913	10
236	1913	5
84	1913	2
85	1913	2
1016	1913	2
241	1913	16
684	1914	3
765	1915	4
1111	1915	6
33	1918	7
548	1919	4
1443	1920	8
1444	1920	4
652	1921	7
349	1922	4
360	1922	5
1422	1923	3
1253	1924	9
285	1925	1
995	1927	5
1103	1929	3
924	1932	8
1119	1932	11
384	1932	4
425	1932	7
842	1933	5
4	1934	7
1225	1934	2
1038	1934	2
1482	1934	6
63	1934	3
205	1935	3
545	1936	4
428	1939	7
987	1940	1
668	1940	2
671	1941	3
178	1942	1
433	1942	4
1286	1943	7
464	1945	7
582	1945	3
1273	1946	1
580	1947	4
446	1948	2
628	1948	1
402	1948	4
751	1950	4
1303	1951	5
471	1952	11
621	1952	6
534	1953	5
93	1954	6
1333	1955	2
462	1957	3
764	1958	1
40	1959	10
1296	1960	6
485	1960	3
1398	1960	6
1049	1960	5
1265	1960	7
1361	1960	1
1379	1960	2
113	1960	8
967	1960	2
1124	1961	2
691	1962	6
616	1963	5
1000	2017	4
456	2017	7
1281	2017	3
681	2018	2
956	2018	2
142	2018	2
219	2018	9
220	2018	8
731	2020	5
321	2021	6
1181	2022	2
880	2022	4
302	2023	9
268	2024	5
838	2025	6
439	2026	4
382	2026	7
840	2026	8
381	2026	6
380	2026	10
841	2026	10
121	2027	1
243	2027	6
123	2027	1
241	2027	15
914	2028	7
382	2028	2
840	2028	2
381	2028	2
378	2028	2
380	2028	2
379	2028	2
841	2028	2
377	2028	2
393	2029	11
1415	2030	8
1296	2030	4
946	2030	2
1089	2030	1
1092	2030	1
284	2033	1
284	2034	6
628	2036	2
549	2037	9
1452	2038	2
1455	2038	3
1317	2038	3
93	2039	1
208	2040	4
182	2042	7
932	2043	9
1408	2044	5
361	2309	1
587	2310	4
1276	2311	3
1422	2312	4
810	2314	3
58	2315	3
158	2315	4
59	2315	3
1463	2315	1
658	2315	1
1168	2315	7
286	2316	8
9	2317	2
1447	2317	13
181	2317	8
773	2318	4
487	2319	7
996	2319	11
843	2320	6
631	2321	3
1253	2322	10
320	2323	5
1166	2323	3
264	2323	5
1300	2323	4
631	2324	8
397	2326	4
1318	2326	6
336	2326	10
1253	2328	15
839	2330	4
341	2331	9
530	2332	4
1104	2333	2
129	2334	1
1239	2335	4
1525	2335	2
1452	2335	4
184	2336	5
1292	2336	11
94	2336	4
990	2337	9
414	2338	9
285	2338	4
372	2341	4
694	2342	8
1566	7572	20
1566	7574	1
1566	7575	13
1566	7576	19
1566	7577	25
1567	7578	5
1567	7579	6
1567	7580	7
1568	7583	4
1568	7584	6
1570	7586	6
1575	164	1
1575	122	2
1575	7602	3
1575	218	4
1575	401	5
1575	344	6
1575	687	7
1576	235	1
1576	1740	2
1576	2706	3
1576	719	4
1576	7603	5
1580	215	1
1580	782	2
1580	7591	3
1580	966	6
1579	4531	1
1579	4974	2
1579	5114	3
1579	4834	4
1579	7631	5
1579	7632	6
1579	4636	7
1579	7633	8
1579	3677	9
1580	7634	4
1580	7635	5
1581	5253	1
1581	7638	2
1581	4724	3
1581	7492	4
1581	7639	5
1581	4099	6
1581	937	7
1582	4309	1
1582	3538	2
1582	7390	3
1582	7640	4
1582	78	5
1583	2095	1
1583	2232	2
1583	2942	3
1583	7642	4
1584	366	1
1584	7643	2
1584	4356	3
1584	1830	4
1584	2171	5
1585	22	1
1585	977	2
1585	7646	3
1585	7647	4
1585	7648	5
1585	7649	6
1585	7650	7
1585	7651	8
1585	7652	9
1585	7653	10
1586	7655	1
1586	7656	2
1586	7657	3
1586	7658	4
1587	7661	1
1587	7662	2
1587	7663	3
1587	7664	4
1587	7665	5
1588	5006	1
1588	7669	2
1588	7670	3
1588	4709	4
1588	7671	5
1588	5042	6
1588	3005	7
1588	1920	8
1588	1537	9
1589	7674	1
1589	7675	2
1589	7676	3
1589	7677	4
1589	7678	5
1589	7679	6
1589	7680	7
1589	7681	8
1589	7682	9
1590	2231	1
1590	3136	2
1590	4691	3
1590	7684	4
1590	7685	5
1590	7686	6
1590	7687	7
1590	7688	8
1590	7689	9
1590	7690	10
1590	7691	11
1590	7674	12
1590	3854	13
1591	7693	1
1591	7694	2
1591	7695	3
1591	7696	4
1591	7697	5
1591	7698	6
1591	7699	7
1592	891	1
1592	7700	2
1592	7701	3
1592	7702	4
1592	796	5
1593	4344	1
1593	7704	2
1593	4759	3
1593	7705	4
1593	7706	5
1593	7707	6
1593	7708	7
1593	7709	8
1593	1230	9
1593	718	10
1594	40	1
1594	7456	2
1594	7712	3
1594	7713	4
1594	7714	5
1595	7717	1
1595	7718	2
1595	7719	3
1595	3800	4
1595	7720	5
1595	7721	6
1595	7722	7
1595	139	8
1596	3227	1
1596	2801	2
1596	2735	3
1596	7725	4
1596	7724	5
1596	7726	6
1596	2232	7
1597	356	1
1597	7727	2
1597	199	3
1597	7728	4
1597	556	5
1597	1252	6
1597	414	7
1597	1753	8
1597	7729	9
1597	7730	10
1597	7731	11
1597	7732	12
1597	3371	13
1597	7733	14
1598	7740	1
1598	7730	2
1598	7741	3
1598	7742	4
1598	7743	5
1598	7744	6
1598	7745	7
1599	7746	1
1599	7747	2
1599	2616	3
1599	7748	4
1600	7746	1
1600	7747	2
1600	2616	3
1600	7749	4
1600	7750	5
1600	668	6
1601	556	1
1601	5214	2
1601	4137	3
1601	5226	4
1601	7751	5
1601	7752	6
1601	3379	7
1601	7753	8
1602	88	1
1602	68	2
1602	7756	3
1603	435	1
1603	989	2
1603	7758	3
1603	7759	4
1603	7756	5
1604	105	1
1604	658	2
1604	644	3
1604	7761	4
1604	7762	5
1604	7763	6
1604	7764	7
1605	143	1
1605	585	2
1606	466	1
1606	1000	2
1606	7765	3
1606	766	4
1606	276	5
1606	2502	6
1606	742	7
1607	69	1
1607	46	2
1607	729	3
1607	204	4
1607	7767	5
1607	301	6
1607	33	7
1608	822	1
1608	911	2
1608	7768	3
1608	7769	4
1608	7770	5
1608	140	6
1609	3484	1
1609	3015	2
1609	2222	3
1609	2239	4
1609	3124	5
1609	3072	6
1610	3605	1
1610	7771	2
1610	4691	3
1610	7772	4
1610	1492	5
1610	2585	6
1610	4937	7
1610	613	8
1610	3281	9
1611	143	1
1611	483	2
1611	754	3
1611	7773	4
1612	1838	1
1612	2931	2
1612	289	3
1612	2362	4
1612	1887	5
1612	3466	6
1612	3999	7
1612	213	8
1612	83	9
1613	1838	1
1613	2931	2
1613	289	3
1613	3999	4
1613	2836	5
1613	1562	6
1613	7775	7
1613	1178	8
1613	213	9
1613	83	10
1614	65	1
1614	2431	2
1614	4788	3
1614	7778	4
1614	4361	5
1614	7483	6
1615	4660	1
1615	151	2
1615	4533	3
1615	2065	4
1615	4174	5
1615	3641	6
1615	1136	7
1616	3737	1
1616	344	2
1616	3596	3
1616	1588	4
1616	4575	5
1616	7779	6
1616	7391	7
1616	1147	8
1616	1801	9
1616	556	10
1617	843	1
1617	1395	2
1617	4036	3
1617	2703	4
1617	7780	5
1617	4182	6
1617	3669	7
1618	2721	1
1618	818	2
1618	2738	3
1618	1143	4
1618	2946	5
1618	338	6
1618	155	7
1619	7783	1
1619	7784	2
1619	7785	3
1619	7786	4
1619	7787	5
1619	7788	6
1619	7789	7
1619	7790	8
1619	857	9
1620	271	1
1620	4728	2
1620	7792	3
1620	3693	4
1620	2641	5
1621	7794	1
1621	2116	2
1621	7795	3
1621	7796	4
1621	7797	5
1622	1243	1
1622	2499	2
1622	4705	3
1622	2898	4
1622	4817	5
1622	4754	6
1622	4695	7
1622	1189	8
1622	7798	9
1622	1480	10
1622	3806	11
1622	4811	12
1623	1864	1
1623	3362	2
1623	7799	3
1623	4677	4
1624	1286	1
1624	289	2
1624	2810	3
1624	939	4
1624	357	5
1624	1746	6
1624	1899	7
1625	4458	1
1625	4877	2
1625	1386	3
1625	4743	4
1625	4792	5
1625	4756	6
1625	1801	7
1625	473	8
1625	88	9
1626	112	1
1626	607	2
1626	457	3
1626	435	4
1626	2192	5
1626	1286	6
1627	394	1
1627	267	2
1627	847	3
1627	1972	4
1627	3322	5
1628	2228	1
1628	4404	2
1628	239	3
1628	7804	4
1628	337	5
1628	2053	6
1628	7805	7
1629	377	1
1629	7809	2
1629	888	3
1629	79	4
1629	173	5
1629	629	6
1629	569	7
1629	1578	8
1629	7810	9
1629	7811	10
1629	928	11
1629	3339	12
1629	7812	13
1630	168	1
1630	1991	2
1630	3662	3
1630	1740	4
1630	7813	5
1630	7404	6
1630	7814	7
1630	614	8
1631	7817	1
1631	7818	2
1631	7819	3
1631	300	4
1631	7820	5
1631	7821	6
1631	2898	7
1632	969	1
1632	3616	2
1632	1478	3
1632	2913	4
1632	7823	5
1632	2846	6
1632	7824	7
1633	4894	1
1633	7828	2
1633	7829	3
1633	7830	4
1633	7831	5
1633	7826	6
1633	7832	7
1634	1991	1
1634	2907	2
1634	3547	3
1634	1562	4
1634	4362	5
1634	3736	6
1634	3015	7
1635	67	1
1635	316	2
1635	3500	3
1635	364	4
1635	1217	5
1635	378	6
1635	1285	7
1636	1697	1
1636	4635	2
1636	221	3
1636	556	4
1636	1172	5
1636	2871	6
1636	3291	7
1636	7834	8
1636	4951	9
1636	7835	10
1636	1011	11
1638	7855	1
1638	3605	2
1638	1313	3
1638	3202	4
1638	7856	5
1638	719	6
1638	1328	7
1639	7859	1
1639	7860	2
1639	7861	3
1639	7862	4
1639	7863	5
1639	7864	6
1639	2825	7
1639	7865	8
1640	7868	1
1640	7869	2
1640	1878	3
1640	7870	4
1640	7871	5
1640	7872	6
1640	353	7
1641	4189	1
1641	4296	2
1641	7875	3
1641	7876	4
1641	3184	5
1641	7877	6
1641	3659	7
1641	2772	8
1642	900	1
1642	7408	2
1642	961	3
1642	3423	4
1642	7880	5
1642	7881	6
1642	7882	7
1643	4404	1
1643	1023	2
1643	4244	3
1643	4062	4
1643	2343	5
1643	457	6
1643	265	7
1643	910	8
1643	1248	9
1643	7883	10
1643	7884	11
1643	7885	12
1643	871	13
1643	442	14
1643	95	15
1644	64	1
1644	4004	2
1644	404	3
1644	2785	4
1644	1210	5
1644	4283	6
1644	611	7
1644	7886	8
1644	5385	9
1644	2723	10
1644	3936	11
1644	7887	12
1644	195	13
1645	72	1
1645	381	2
1645	625	3
1645	2062	4
1645	4442	5
1645	7888	6
1646	4531	1
1646	4663	2
1646	3999	3
1646	5006	4
1646	7890	5
1646	4064	6
1646	7891	7
1646	209	8
1647	7892	1
1647	7893	2
1647	7894	3
1647	7895	4
1647	7896	5
1648	7892	1
1648	7897	2
1648	7898	3
1648	7899	4
1648	7900	5
\.


--
-- Data for Name: media_directors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_directors (media_id, director_id, ordering) FROM stdin;
1480	152	1
953	517	1
1159	303	1
392	152	1
830	115	1
214	2452	4
754	2452	2
693	593	1
355	589	1
1101	2455	1
1376	323	1
1190	2462	1
1191	2462	1
646	2465	1
1429	2473	1
372	54	1
968	2473	1
1388	2473	1
1345	2491	1
160	153	1
1100	527	1
1151	236	1
331	2492	1
704	2500	1
1283	2508	1
941	2509	1
153	2509	1
906	2509	1
1099	2509	1
952	476	1
96	723	1
54	920	1
1352	1026	1
1277	1088	1
426	1088	1
162	1241	1
1322	1272	1
157	2509	1
388	2515	1
1571	3699	1
173	489	1
760	376	1
402	152	1
329	397	1
187	3157	1
1263	3158	1
927	3163	1
42	3165	1
1369	3173	1
623	3187	1
388	3187	2
1292	3188	2
767	3188	1
1009	3188	1
228	3190	2
713	3192	1
14	3201	1
251	3201	1
55	3201	1
1282	3201	1
260	3201	1
837	3201	1
616	3201	1
1121	3204	1
1504	3204	1
205	3204	1
229	3208	1
942	3208	1
1178	3208	1
667	3221	2
668	3226	1
574	3226	1
1193	3242	1
325	3242	1
1251	3242	1
592	3242	1
1194	3242	1
1195	3242	1
1076	1456	1
323	1461	1
311	1488	1
557	3250	1
59	3250	1
58	3250	1
158	3250	1
350	3255	1
257	3255	1
15	3255	1
542	3255	1
408	3264	2
91	3264	2
722	3264	2
551	3264	2
667	3264	3
1514	3264	2
408	3265	1
551	3265	1
91	3265	1
722	3265	1
1020	3265	1
667	3265	1
1514	3265	1
773	3267	1
375	3274	1
1547	3294	1
751	3294	1
1164	3303	1
127	3304	1
83	3306	1
661	3306	1
1287	3307	1
753	3310	1
883	3310	3
249	3316	1
815	3316	1
420	3316	1
353	3318	2
526	3319	1
434	3319	1
890	456	1
1572	7593	1
1572	4908	2
391	152	1
1572	6493	3
1307	16	1
1517	253	1
68	153	1
171	589	1
70	633	1
886	904	1
785	236	1
1160	61	1
768	510	1
444	97	1
435	476	1
84	738	1
525	879	1
217	879	1
1031	879	1
591	912	1
461	920	1
772	968	1
747	1045	1
992	1057	1
139	1068	1
1298	1078	1
618	1078	1
863	1088	1
552	1149	1
72	1241	1
848	1272	1
862	1272	1
995	1282	1
1006	1298	1
80	1315	1
763	1471	1
109	1486	1
437	210	1
1265	210	1
1114	152	1
409	152	1
1573	3947	1
458	589	1
1042	517	1
395	1343	1
458	588	2
982	1350	1
69	153	1
1024	11	1
436	476	1
85	738	1
926	780	1
1281	856	1
786	868	1
1091	901	1
1032	912	1
460	920	1
168	1030	1
679	1084	1
51	1088	1
761	1149	1
1404	1175	1
277	1197	1
456	1272	1
622	1282	1
421	633	1
895	329	1
412	1177	1
956	1228	1
825	46	1
1172	152	1
1180	1091	1
1293	1019	1
516	270	1
1001	253	1
764	1471	1
334	1474	1
110	1486	1
227	210	1
473	154	1
1574	7601	1
414	156	1
1366	11	1
1213	385	1
949	397	1
182	385	1
53	62	1
697	499	1
891	456	1
508	210	1
903	417	1
870	1305	1
17	1177	1
826	29	1
225	517	1
314	714	1
79	270	1
571	456	1
1016	738	1
283	896	1
710	912	1
302	988	1
686	1061	1
850	1062	1
1068	1078	1
358	1084	1
427	1088	1
480	1093	1
261	1226	1
274	3327	1
254	3330	1
129	3337	1
231	3342	2
1252	3355	1
1332	3362	1
1178	3375	2
229	3375	2
942	3375	2
907	3376	1
584	3376	1
702	3376	1
978	3377	1
729	3377	1
730	3377	1
333	3380	1
935	3380	1
1005	3380	1
492	3393	1
1463	3396	1
155	3396	1
268	3407	1
1338	3412	1
1209	3413	1
259	3416	1
1339	3417	1
380	3418	1
915	1451	1
545	1456	1
441	1486	1
26	3418	1
379	3418	1
841	3418	1
27	3418	1
677	3418	1
377	3418	1
138	3432	1
107	633	1
1445	615	1
602	3435	1
612	3435	1
600	3435	1
1105	3445	1
195	3447	1
1111	46	1
374	3447	1
1235	3449	1
1313	210	1
90	3450	1
297	3450	1
1097	3451	1
1362	3452	1
1205	3453	1
1180	3456	2
443	3456	2
1009	3457	2
767	3457	2
163	3457	3
1222	3457	1
1220	3457	2
1292	3457	1
1035	3458	1
604	3460	1
1221	3460	2
541	3469	1
1166	3469	1
836	3469	1
1266	3474	1
1204	3486	1
209	3486	1
119	3486	1
1126	3498	3
1271	3504	1
323	3520	2
1003	3527	1
871	3534	1
1046	3534	1
1132	3536	1
829	3536	1
650	3540	1
1044	3540	1
1089	3545	1
1027	3545	1
1092	3545	1
1245	3548	1
924	3548	1
923	3548	1
49	3554	1
780	3554	1
699	3562	1
201	3562	1
487	3563	1
853	3563	1
120	3563	1
775	3563	1
963	3567	1
4	3572	1
1216	3572	1
425	3574	1
351	3577	1
746	3584	1
787	3587	1
57	3589	1
267	3593	1
1141	3593	1
1465	3593	1
1330	3593	1
1231	3597	1
131	3598	1
306	3598	1
1386	3599	1
530	3602	1
2	3603	1
513	3614	1
512	3614	1
514	3614	1
1507	3621	3
1222	3621	2
851	3621	1
1134	3621	1
611	3624	1
1302	3624	1
608	3624	1
1021	3624	1
655	3628	1
1214	3629	1
719	3634	1
1457	3650	1
1272	3650	1
913	3657	1
206	3663	1
50	3663	1
448	3666	2
226	896	1
448	3667	1
843	97	1
149	156	1
1128	3668	1
240	3684	1
1246	152	1
961	3690	1
779	3695	1
580	3696	1
180	3699	1
1148	3699	1
87	3699	1
88	3699	1
1279	3699	1
670	3700	1
16	3701	1
401	3716	1
244	1177	1
159	153	1
1	476	1
489	152	1
339	3718	1
959	323	1
1380	417	1
1224	546	1
774	493	1
540	616	1
700	504	1
1273	714	1
1273	376	2
652	3726	1
326	800	1
570	456	1
621	3727	1
776	3733	1
835	3740	1
1238	3740	1
556	868	1
1025	880	1
1353	11	1
656	1087	1
1308	1303	1
313	3740	1
108	633	1
698	1323	1
1342	3746	1
792	3746	1
1398	3746	1
303	3755	1
1060	236	1
811	3755	1
365	3755	1
71	3758	1
156	3759	1
152	3759	1
471	3763	2
766	3768	1
1297	3768	1
1284	3771	1
262	3771	1
1337	3771	1
531	3772	1
597	3772	1
36	3772	1
1183	3772	1
1056	3772	1
1059	3772	1
8	3772	1
486	3772	1
1333	3777	1
1227	3782	1
1447	3782	1
580	3785	2
319	3788	1
275	3810	2
275	3813	1
1012	3817	1
1391	3817	1
1079	3823	1
362	3835	2
35	3835	2
126	3836	2
846	3837	1
118	3837	1
1326	3848	1
930	3852	1
156	3860	2
1425	3861	1
1389	3861	1
689	1421	1
528	1434	1
1184	3861	1
1379	3865	1
1394	3865	1
247	3872	1
31	3876	1
1069	3876	1
1126	3881	1
411	3888	1
660	3891	1
1171	3899	1
998	3901	1
999	3901	1
1392	3901	1
1081	3903	1
1008	3912	1
1540	3914	1
912	3914	1
252	3921	1
711	3921	1
266	3929	1
1354	3929	1
965	3929	1
318	3934	1
1321	3939	1
537	3942	1
92	3942	1
63	3947	1
503	3947	1
1135	3949	1
980	3950	1
199	3950	2
200	3950	2
673	3950	1
602	3957	2
1162	3964	1
1163	3964	1
1161	3964	1
1268	3964	1
1090	3968	1
1077	3981	1
417	3981	1
520	3988	1
192	3991	1
191	3991	1
1147	3991	1
1509	3996	1
112	3996	1
113	3996	1
1384	4002	1
899	4025	1
1054	4033	1
290	4035	1
1411	4035	1
289	4035	1
24	4040	1
613	4042	1
291	4045	1
322	4053	1
575	4053	1
957	4065	1
1133	4091	1
484	4092	1
39	4092	1
1247	4092	1
1548	4092	1
812	4101	1
479	4101	1
873	4102	1
635	4102	1
637	4102	1
1109	4102	1
117	4102	1
1201	4102	2
1035	4104	2
925	4118	1
1329	4118	1
494	4118	1
1210	4123	1
554	4126	1
1431	4128	1
1081	4134	2
347	4136	1
60	4140	1
925	4143	2
1329	4143	2
494	4143	2
1120	4149	1
1167	4150	1
190	4156	1
502	4156	1
934	4156	1
1562	4156	1
1093	4158	1
11	896	1
1458	2351	1
393	156	1
909	535	1
1117	46	1
163	1369	2
1459	2351	1
382	593	1
1144	2351	1
1289	2355	1
7	97	1
507	2360	2
986	2366	1
796	263	1
585	152	1
1026	476	1
1264	2371	1
278	2371	1
237	417	1
238	223	1
1084	2378	1
814	2379	1
966	2379	1
370	615	1
1503	2379	1
1328	2379	1
253	2379	1
294	2381	1
1080	704	1
791	210	1
22	704	1
1139	54	1
184	2381	1
95	2381	1
218	2385	1
335	2385	1
1341	2389	1
709	2390	1
422	633	1
284	506	1
396	2390	1
440	2391	1
888	237	1
1125	2391	1
1061	169	1
1017	2391	1
449	2396	1
610	593	1
695	2401	1
984	2401	1
849	2401	1
985	2401	1
712	2401	1
832	2401	1
263	2401	1
1145	2405	1
1291	2407	1
188	2409	1
132	2409	1
1007	2409	1
943	2412	1
946	2412	1
805	2412	1
1239	738	1
114	2524	1
603	2545	1
1218	2545	2
1219	2545	2
1220	2545	3
1418	2545	1
1412	2545	1
264	2551	1
1300	2551	1
33	2557	1
581	2567	1
882	2570	1
881	2570	1
894	2572	1
78	2584	1
165	2584	1
429	922	1
1303	2589	1
944	2592	2
572	1177	1
1037	2592	2
505	2593	2
1103	2598	1
1104	2598	1
373	2598	1
1381	2599	1
549	2599	2
544	2599	1
1364	2600	1
1433	2601	1
430	2605	1
875	2605	1
1153	2605	1
997	2605	1
653	2605	1
1072	1197	1
884	1315	1
163	1323	1
1370	2605	1
1039	2605	1
1390	2610	1
515	2610	1
1466	2610	1
1428	2610	1
1393	2610	1
1426	2610	1
631	2617	1
589	2620	1
126	2620	1
1212	4158	1
983	4183	1
1049	4184	1
133	4187	1
177	4192	1
1004	4207	1
569	4207	1
1520	4207	1
464	4222	2
479	4230	2
1359	4249	3
876	4262	1
1359	4267	2
1349	4275	1
280	1452	1
958	1502	1
349	1513	1
1482	5254	1
1500	5468	1
1501	5490	1
1563	5746	1
675	5757	4
1310	5757	3
754	5757	3
675	5758	2
754	5758	4
675	5759	5
754	5759	5
1130	2093	1
398	2094	1
34	2107	1
1413	2118	1
232	2121	1
945	2121	1
889	2121	1
1234	2123	1
1513	2125	1
1181	2125	1
822	2127	1
1274	2127	1
281	2129	1
762	2143	1
1368	2143	1
1275	2143	1
1232	2143	1
594	2620	2
279	2621	2
147	538	1
1243	633	1
256	16	1
1270	2621	1
1510	546	1
840	593	1
880	2622	1
343	2640	1
179	2643	1
523	2645	1
950	46	1
742	144	1
41	615	1
955	1354	1
1530	1369	1
643	2655	1
245	1016	1
859	593	1
400	2660	1
47	2660	1
1553	417	1
1055	2660	1
1058	336	1
795	263	1
1041	768	1
828	800	1
1559	237	1
804	2661	1
1355	2661	1
973	2661	1
213	2661	1
1106	2661	1
1336	54	1
452	2661	1
769	2663	1
81	2683	1
1315	2683	1
1067	2690	1
617	2690	1
1469	2690	1
533	2690	1
1176	2690	1
390	2690	1
1066	2690	1
438	2690	1
1470	2690	1
954	2692	1
606	2698	1
625	738	1
1257	904	1
1319	912	1
1408	2722	1
51	2724	2
203	922	1
633	2728	1
634	2728	1
1201	2728	1
640	2728	1
638	2728	1
688	2728	1
1570	868	1
754	5760	7
1515	5798	1
1515	5799	2
803	5912	2
803	5913	3
803	5914	4
1508	6063	2
1310	6378	2
1310	6379	4
675	6380	6
1310	6380	5
1310	6381	6
1310	6382	7
1506	6555	1
1507	6555	2
1506	6556	2
1546	6726	1
1519	7386	1
74	1063	1
105	1086	1
573	1177	1
1073	1197	1
1000	1315	1
1062	1315	1
1522	7397	1
1523	7403	1
1555	7405	1
1524	7405	1
1533	7432	1
1535	7432	1
1545	7467	1
1545	7468	2
1549	7485	1
1549	7486	2
1554	7498	1
1556	7508	1
1558	7512	1
1448	1379	1
1371	1428	1
1560	7517	1
1560	7518	2
1561	7528	1
1565	7557	1
1566	7573	1
1568	7581	1
1569	7585	1
233	1450	1
1526	1471	1
867	156	1
755	476	1
788	210	1
1378	666	1
419	543	1
535	397	1
1541	988	1
442	1350	1
749	303	1
802	152	1
1557	45	1
1028	543	1
1087	633	1
1253	17	1
510	208	1
626	738	1
477	772	1
1113	879	1
204	922	1
368	990	1
680	1018	1
6	1241	1
902	86	1
810	1292	1
454	1397	2
1063	1456	1
1082	1465	1
1483	1477	1
976	1505	1
757	1079	1
793	210	1
1233	993	1
186	46	1
1417	524	1
1110	253	1
663	210	1
555	476	1
352	397	1
354	169	1
538	45	1
1358	210	1
1421	666	1
1318	208	1
748	303	1
539	223	1
969	398	1
1324	390	1
1542	988	1
383	593	1
387	144	1
504	144	1
627	738	1
1374	778	1
410	11	1
1551	97	1
378	817	1
164	879	1
564	52	1
979	920	1
866	1016	1
1064	1071	1
459	1080	1
336	1094	1
1414	144	1
1422	324	1
134	1471	1
1552	476	1
619	456	1
1142	16	1
861	223	1
824	968	1
43	593	1
741	326	1
474	723	1
855	879	1
1200	1015	1
1050	1066	1
497	1069	1
548	1069	1
1249	1166	1
951	1242	1
939	1253	1
270	543	1
522	52	1
1363	323	1
1129	144	1
1505	1352	1
816	110	1
991	417	1
1472	156	1
892	578	1
1208	487	1
928	662	1
560	627	1
445	571	1
854	397	1
230	476	1
1124	1366	1
703	113	1
716	223	1
174	253	1
1088	868	1
457	883	1
1136	896	1
308	920	1
498	1069	1
1065	1071	1
64	1076	1
1169	1077	1
98	1078	1
1223	1205	1
10	1242	1
818	1255	1
771	1293	1
1215	152	1
144	2737	1
21	2737	1
827	2737	1
255	2737	1
974	2737	1
215	417	1
1396	2737	1
975	2737	1
599	2739	2
338	2743	1
809	2752	1
1211	2754	1
13	2763	1
363	2763	1
931	2769	1
94	2774	1
707	1379	1
1179	1465	1
327	1465	1
1361	2779	1
1296	2794	1
67	2794	1
1409	2795	1
406	2799	1
1430	1469	1
509	1477	1
1395	1477	1
1334	2799	1
798	1491	1
1534	1505	1
310	2804	1
1262	2815	1
471	2816	1
1400	2819	1
723	2821	1
651	2826	1
320	2829	1
1349	2831	2
228	2837	1
993	2841	1
613	2841	2
340	2842	1
1033	2849	1
220	2859	1
219	2859	1
900	2859	1
1267	2860	1
137	2860	1
527	2860	1
1269	2860	1
507	2863	3
462	2863	1
546	2863	1
367	2864	1
38	2864	1
845	2865	1
607	2865	1
558	2867	1
1019	2867	1
198	2867	1
199	2867	1
200	2867	1
1357	2867	1
584	2893	2
293	2899	1
282	2899	1
1331	2899	1
1203	2908	1
777	2914	1
1410	2915	1
194	2916	1
682	2916	1
1356	2921	1
1436	2921	1
613	2922	3
1255	2938	1
918	2938	1
586	476	1
3	2938	1
224	2940	1
819	11	1
1022	86	1
549	1339	1
1451	1350	1
1434	2261	1
295	2269	1
475	16	1
694	153	1
407	2269	1
48	2269	1
1419	2277	1
1285	552	1
929	662	1
714	2278	1
300	2278	1
23	2288	1
242	1061	1
562	263	1
852	2293	1
614	2293	1
1387	2296	1
246	2297	1
511	397	1
40	2313	1
1306	856	1
1477	901	1
1174	2325	1
394	2327	1
359	2329	1
276	2339	1
1143	2340	1
868	2413	1
1237	2413	1
1199	2413	1
1348	2413	1
678	2414	1
29	2414	1
28	2414	1
885	2414	1
25	2414	1
654	2414	1
806	2419	1
345	2420	1
860	2421	1
645	2421	1
696	2421	1
721	152	1
642	2421	1
639	2421	1
641	2421	1
1196	2430	3
944	2439	1
1037	2439	1
279	2443	1
1270	2443	2
752	2448	1
1399	2448	1
735	788	1
1403	904	1
893	1061	1
86	1062	1
718	2448	1
499	1069	1
418	2452	1
353	1070	1
1206	1071	1
462	2452	2
312	1071	1
443	1091	1
470	2452	1
317	1226	1
756	2452	2
142	2009	1
9	1242	1
99	517	1
681	2009	1
797	2009	1
1173	2009	1
869	2015	1
1010	2015	1
879	2015	1
122	2019	1
124	2019	1
874	2019	1
66	2031	1
1327	2032	1
1372	2035	1
1531	2041	1
371	2041	1
970	2041	1
563	2041	1
932	2041	1
837	2045	2
488	2050	1
472	2058	1
1407	2068	1
485	2068	1
803	2069	1
1310	2069	1
728	2078	1
1508	2237	1
1382	2237	1
743	2237	2
1098	2244	1
342	2246	1
1043	2251	1
216	52	1
1083	113	1
799	1491	1
154	1350	1
820	253	1
724	253	1
1347	417	1
476	156	1
207	62	1
1286	901	1
1240	263	1
493	62	1
116	912	1
73	97	1
649	1246	1
75	397	1
1564	1086	1
568	52	1
577	517	1
44	152	1
1344	758	1
620	800	1
524	922	1
1150	933	1
1207	990	1
1108	1061	1
500	1069	1
582	1084	1
784	616	1
708	1315	1
146	1456	1
596	263	1
222	52	1
1346	385	1
911	593	1
288	323	1
726	517	1
1525	390	1
495	62	1
1316	1307	1
920	527	1
1437	964	1
856	113	1
1015	156	1
578	517	1
1467	879	1
590	912	1
1107	922	1
658	1040	1
658	1061	2
1038	1066	1
501	1069	1
305	1075	1
1241	1303	1
176	670	1
676	210	1
720	1456	1
831	152	1
738	310	1
669	52	1
1325	223	1
977	253	1
1096	323	1
877	170	1
1454	1350	1
647	1350	1
547	499	1
62	1360	1
1305	52	1
115	62	1
559	616	1
901	476	1
369	253	1
838	86	1
1351	417	1
19	210	1
715	97	1
328	156	1
76	372	1
1424	465	1
857	113	1
808	97	1
100	517	1
189	912	1
482	1026	1
839	1175	1
202	1379	1
980	1393	2
1196	1421	1
424	1443	1
37	1452	1
141	1455	1
478	1456	1
324	397	1
1455	1350	1
1115	253	1
1051	398	1
1018	499	1
1023	538	1
431	704	1
1539	398	1
1567	868	1
82	152	1
996	62	1
77	372	1
858	113	1
172	1323	1
750	1045	1
576	517	1
505	879	1
1258	964	1
360	968	1
1013	1075	1
933	1075	1
790	210	1
469	503	1
1048	517	1
467	517	1
981	1393	1
673	1393	2
744	153	1
1311	223	1
1456	1350	1
1158	1351	1
1402	499	1
1057	1352	1
1118	152	1
483	499	1
1086	788	1
801	11	1
346	527	1
239	326	1
1011	1323	1
921	1307	1
250	210	1
166	421	1
519	633	1
671	376	1
872	46	1
1312	210	1
397	208	1
759	714	1
1137	741	1
1052	1045	1
565	1066	1
705	1315	1
684	152	1
1479	152	1
211	593	1
193	417	1
1278	76	1
243	2940	1
1045	2940	1
1439	2940	1
223	2940	1
241	2940	1
224	2941	2
243	2941	2
1045	2941	2
1439	2941	2
223	2941	2
241	2941	2
1197	2953	1
128	2957	1
683	2957	1
385	2964	1
265	2964	1
532	2964	1
1416	2964	1
628	2970	1
52	2976	1
463	2976	1
1261	2977	1
1155	2980	2
212	2985	1
947	2985	1
821	2985	1
1123	2991	1
175	2991	1
664	2991	1
451	2997	1
1543	3000	1
1047	3000	1
794	3003	1
553	3003	1
1177	3003	1
765	3003	1
1165	3004	1
1030	3007	1
439	3014	1
962	3014	1
1186	3017	1
803	3018	6
214	3018	1
754	3018	1
675	3018	1
1040	3030	1
208	3033	1
135	3035	1
543	3037	1
304	3037	1
296	3037	1
1280	3037	1
1340	3037	1
258	3037	1
348	3037	1
987	3037	1
315	3037	1
662	3037	1
1301	3037	1
914	3037	1
561	3037	1
1406	3040	1
948	3040	1
221	3058	1
103	3065	1
1175	3065	1
1254	3065	1
433	3065	1
734	3065	1
687	3065	1
518	3065	1
12	3065	1
1170	3065	1
690	3065	1
1112	3066	1
717	3066	1
344	3067	1
273	3068	1
919	3068	1
916	3068	1
917	3068	1
450	3083	1
403	3083	1
404	3083	1
1071	3083	1
361	3093	1
599	3100	1
428	3102	1
298	3112	2
298	3113	1
725	3117	1
847	3118	1
587	3122	1
446	3137	1
994	3137	1
632	3137	1
769	3138	2
937	3147	1
1146	3150	1
1397	3152	1
125	3152	1
1119	3152	1
731	3154	1
170	3157	1
910	4286	1
111	4307	1
1244	4314	2
1229	4317	2
904	4327	1
1242	4327	1
272	4342	1
1423	4342	1
1360	4342	1
271	4342	1
800	4343	2
1226	4348	1
1323	4348	1
1074	4349	1
813	4352	1
1259	4354	1
817	4363	1
1521	4384	1
823	4384	1
897	4384	1
236	4384	1
800	4396	1
151	4427	1
1299	4460	1
1157	4491	1
1309	4502	1
1359	4504	1
234	4511	1
1053	4513	1
898	4513	1
356	4522	1
30	4522	1
357	4522	1
1532	4539	1
1078	4539	1
1314	4539	1
316	4549	2
1415	4549	2
696	4551	2
860	4551	2
1152	4627	1
778	4627	1
316	4631	1
1415	4631	1
846	4647	2
645	4655	2
644	4655	1
1036	4666	1
1126	4702	2
908	4745	1
384	4747	2
1405	4791	1
1335	4791	1
1140	4804	1
269	4804	1
1127	4828	1
1229	4862	1
1217	4901	1
579	4908	1
1375	4948	1
1288	4973	1
321	4992	1
883	4995	2
604	4995	2
1435	5133	1
1460	5133	1
1438	5135	1
1440	5136	1
1441	5140	1
1442	5148	1
1443	5150	1
1444	5151	1
1446	5155	1
1449	5168	1
1449	5169	2
1450	5172	1
1452	5178	1
1453	5179	1
1464	5210	1
1464	5211	2
1468	5224	1
1471	5227	1
1476	5227	1
1473	5230	1
1474	5231	1
1475	5232	1
1478	5240	1
1481	5247	1
1244	1518	1
943	1518	2
362	1518	1
35	1518	1
341	1521	1
657	1549	1
629	1556	1
624	1559	1
692	1570	1
299	1572	1
701	1575	1
938	1579	1
161	1589	1
922	1591	1
883	1601	1
955	1601	2
330	1603	1
672	1609	1
455	1610	1
185	1611	1
179	1612	2
415	1616	1
447	1622	1
1122	1622	1
389	1622	1
1367	1622	1
413	1624	1
235	1624	1
507	1627	4
213	1632	2
804	1632	2
1355	1632	2
973	1632	2
1106	1632	2
452	1632	2
1085	1636	1
405	1641	1
567	1641	1
636	1641	1
665	1652	1
659	1652	1
97	1652	1
454	1666	1
210	1671	1
1155	1676	1
65	1684	1
1461	1684	1
101	1698	1
381	1710	1
1102	1710	1
1383	1713	1
32	1717	1
1168	1722	1
940	1731	2
833	1731	1
169	1738	1
1221	1744	1
1218	1744	1
1219	1744	1
1220	1744	1
743	1744	1
666	1749	1
337	1751	1
1385	1757	1
532	1757	2
385	1760	2
265	1760	2
386	1760	1
307	1760	1
481	1761	1
56	1763	1
121	1771	1
123	1771	1
183	1771	1
782	1779	1
506	1779	1
1116	1779	1
1276	1792	1
286	1792	1
292	1794	1
376	1794	1
150	1796	1
967	1797	1
615	1798	1
685	1798	1
691	1798	1
864	1798	1
1154	1799	1
1236	1799	1
384	1817	1
1138	1819	1
287	1820	1
971	1820	1
148	1820	1
1536	1820	1
1537	1820	1
1538	1820	1
143	1825	1
1070	1845	1
936	1845	1
93	1852	1
1317	1860	1
896	1866	1
1256	1866	1
964	1868	1
399	1868	1
45	1868	1
181	1868	1
89	1868	1
18	1870	1
464	1872	1
648	1882	1
136	1884	1
1196	1890	2
16	1891	2
1550	1893	1
1304	1893	1
1034	1894	1
1029	1894	1
598	1894	1
102	1894	1
1320	1895	1
566	1896	1
140	1896	1
770	1897	1
733	1900	1
20	1900	1
727	1905	1
534	1907	1
758	1908	1
1228	1916	1
1511	1916	1
674	1917	1
468	1917	1
285	1926	1
1516	1928	1
1189	1928	1
1095	1928	1
1187	1928	1
1188	1928	1
878	1930	1
990	1931	1
989	1938	1
1260	1944	1
1248	1944	1
737	1949	1
507	1956	1
418	1956	2
462	1956	3
470	1956	2
756	1956	3
214	1956	2
1401	1964	1
960	1966	1
842	1967	1
990	1979	2
1420	1980	1
940	1982	1
833	1982	2
1225	1983	1
490	1995	1
332	1995	1
1528	1995	1
1529	1995	1
491	1995	1
178	1999	1
1014	2007	1
5	2008	1
145	2143	1
1230	2144	1
106	2155	1
593	2155	1
1527	2155	1
605	2155	1
988	2157	1
1156	2164	1
301	2167	1
595	2167	1
61	2168	1
432	2168	1
196	2169	1
521	2169	1
520	2175	2
351	2175	2
594	2175	1
745	2182	1
1427	2190	1
630	2200	1
1290	2201	1
1294	2208	1
803	2209	5
418	2209	3
470	2209	3
756	2209	1
214	2209	3
754	2209	6
675	2209	3
887	2210	1
343	2217	2
588	2221	1
732	2221	1
698	2224	2
1507	2224	1
739	2234	1
366	2234	1
250	2235	2
706	2236	1
834	2236	1
416	2236	1
465	4095	1
496	4096	1
231	4101	1
1575	7601	1
1576	7601	1
1579	4025	1
1580	7636	1
1581	4156	1
1582	546	1
1583	3540	1
1584	3872	1
1585	7644	1
1586	7654	1
1587	7659	1
1588	1760	1
1589	7672	1
1590	2032	1
1591	7692	1
1592	1884	1
1593	6008	1
1594	7228	1
1595	7715	1
1596	7723	1
1597	879	1
1597	156	2
1598	2921	1
1599	3447	1
1600	3447	1
1601	3599	1
1602	7754	1
1603	7757	1
1604	7760	1
1605	2389	1
1606	208	1
1607	46	1
1608	210	1
1609	3201	1
1610	3201	1
1611	7774	1
1612	2391	1
1613	1622	1
1614	7776	1
1615	3393	1
1616	3393	1
1617	4539	1
1618	7781	1
1619	778	1
1620	7405	1
1621	7793	1
1622	4002	1
1623	3991	1
1624	7800	1
1625	1622	1
1626	7801	1
1627	2598	1
1628	6147	1
1629	7806	1
1630	2236	1
1631	7815	1
1632	7822	1
1633	7825	1
1634	3700	1
1635	7833	1
1636	2236	1
1638	2078	1
1639	1738	1
1640	2127	1
1641	6436	1
1642	7879	1
1643	223	1
1644	1071	1
1645	7601	1
1646	3942	1
1647	7892	1
1648	7892	1
\.


--
-- Data for Name: media_temp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_temp (rating, title, type, year) FROM stdin;
9	F1: The Movie	Movie	2025
6	The Old Guard 2	Movie	2025
6	White House Down	Movie	2013
6	Olympus Has Fallen	Movie	2013
6	65	Movie	2023
4	Speed Racer	Movie	2008
5	A Minecraft Movie	Movie	2025
7	28 Weeks Later	Movie	2007
8	28 Days Later	Movie	2002
5	Snow White	Movie	2025
7	Over the Hedge	Movie	2006
4	Shark Tale	Movie	2004
8	The Road to El Dorado	Movie	2000
9	The Grand Budapest Hotel	Movie	2014
9	Predator: Killer of Killers	Movie	2025
8	Atomic Blonde	Movie	2017
3	Battlefield Earth	Movie	2000
9	Paddington in Peru	Movie	2024
8	Mickey 17	Movie	2025
7	Lilo & Stitch	Movie	2025
6	Fear Street: Prom Queen	Movie	2025
8	War of the Worlds	Movie	2005
9	Minority Report	Movie	2002
8	Jerry Maguire	Movie	1996
7	Days of Thunder	Movie	1990
9	Thunderbolts*	Movie	2025
6	Mystery Men	Movie	1999
8	Eternal Sunshine of the Spotless Mind	Movie	2004
9	A Fish Called Wanda	Movie	1988
9	Reservoir Dogs	Movie	1992
7	Paper Towns	Movie	2015
9	The Prestige	Movie	2006
9	Memento	Movie	2000
7	The Accountant	Movie	2016
7	From Dusk Till Dawn	Movie	1996
9	Princess Mononoke	Movie	1997
6	Wolf Man	Movie	2025
9	Monty Python and the Holy Grail	Movie	1975
8	Pride & Prejudice	Movie	2005
8	The Monkey	Movie	2025
9	Tombstone	Movie	1993
8	Happy Death Day 2U	Movie	2019
8	Happy Death Day	Movie	2017
6	Resident Evil: Welcome to Raccoon City	Movie	2021
5	Resident Evil: The Final Chapter	Movie	2016
3	Resident Evil: Retribution	Movie	2012
4	Resident Evil: Afterlife	Movie	2010
4	Resident Evil: Extinction	Movie	2007
3	Resident Evil: Apocalypse	Movie	2004
5	Resident Evil	Movie	2002
4	Underworld: Blood Wars	Movie	2016
4	Underworld: Awakening	Movie	2012
7	The Beekeeper	Movie	2024
7	Mufasa: The Lion King	Movie	2024
7	Alexander and the Terrible, Horrible, No Good, Very Bad Day	Movie	2014
7	Looney Tunes: Back in Action	Movie	2003
6	The Huntsman: Winter's War	Movie	2016
6	Snow White and the Huntsman	Movie	2012
6	Mirror Mirror	Movie	2012
8	Anora	Movie	2024
7	Emilia Pérez	Movie	2024
7	The Electric State	Movie	2025
5	Kraven the Hunter	Movie	2024
9	Dead Poets Society	Movie	1989
4	Borderlands	Movie	2024
8	Longlegs	Movie	2024
10	Parasite	Movie	2019
9	The Departed	Movie	2006
9	One Flew Over the Cuckoo's Nest	Movie	1975
9	The Apartment	Movie	1960
8	Howl's Moving Castle	Movie	2004
8	The Lord of the Rings: The War of the Rohirrim	Movie	2024
4	Punisher: War Zone	Movie	2008
6	The Punisher	Movie	2004
6	The Punisher	Movie	1989
8	Nosferatu	Movie	2024
8	Castle in the Sky	Movie	1986
3	Howard the Duck	Movie	1986
8	Sonic the Hedgehog 3	Movie	2024
8	Captain America: Brave New World	Movie	2025
9	My Neighbor Totoro	Movie	1988
8	Bridget Jones: Mad About the Boy	Movie	2025
8	American History X	Movie	1998
9	Kiki's Delivery Service	Movie	1989
9	Paddington 2	Movie	2017
9	Paddington	Movie	2014
4	Captain America	Movie	1990
7	Metropolis	Movie	1927
8	Bridget Jones's Baby	Movie	2016
5	Bridget Jones: The Edge of Reason	Movie	2004
7	Bridget Jones's Diary	Movie	2001
8	Barbarian	Movie	2022
6	Ruby Gillman: Teenage Kraken	Movie	2023
9	The Bad Guys	Movie	2022
7	Abominable	Movie	2019
8	Captain Underpants: The First Epic Movie	Movie	2017
5	The Boss Baby: Family Business	Movie	2021
6	The Boss Baby	Movie	2017
6	Home	Movie	2015
7	Mr. Peabody & Sherman	Movie	2014
8	Gladiator II	Movie	2024
6	Turbo	Movie	2013
9	Life Is Beautiful	Movie	1997
8	Amadeus	Movie	1984
8	An American Werewolf in London	Movie	1981
1	The Mouse Trap	Movie	2024
9	12 Angry Men	Movie	1957
5	Den of Thieves	Movie	2018
3	Alvin and the Chipmunks: The Road Chip	Movie	2015
2	Alvin and the Chipmunks: Chipwrecked	Movie	2011
3	Alvin and the Chipmunks: The Squeakquel	Movie	2009
4	Alvin and the Chipmunks	Movie	2007
7	Terrifier 3	Movie	2024
10	The Wild Robot	Movie	2024
9	Wicked	Movie	2024
7	Eyes Wide Shut	Movie	1999
8	Meet Me in St. Louis	Movie	1944
8	Trading Places	Movie	1983
8	Bad Santa	Movie	2003
9	The Holdovers	Movie	2023
9	The Northman	Movie	2022
8	The Lighthouse	Movie	2019
9	The Witch	Movie	2015
9	Speed	Movie	1994
9	Kick-Ass	Movie	2010
8	Moana 2	Movie	2024
5	The Lord of the Rings	Movie	1978
8	Beetlejuice Beetlejuice	Movie	2024
6	Oz the Great and Powerful	Movie	2013
9	Smile 2	Movie	2024
5	Despicable Me 4	Movie	2024
7	Thanksgiving	Movie	2023
5	Red One	Movie	2024
6	Brother Bear	Movie	2003
8	Treasure Planet	Movie	2002
8	Alien: Romulus	Movie	2024
9	Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb	Movie	1964
7	The Phantom of the Opera	Movie	2004
9	Ben-Hur	Movie	1959
8	Transformers One	Movie	2024
5	Ghosted	Movie	2023
3	Tooth Fairy	Movie	2010
8	Black Hawk Down	Movie	2001
9	Nimona	Movie	2023
9	Edge of Tomorrow	Movie	2014
7	Napoleon	Movie	2023
8	Troy	Movie	2004
7	Bad Boys: Ride or Die	Movie	2024
6	Venom: The Last Dance	Movie	2024
5	The Wicker Man	Movie	2006
8	Orphan	Movie	2009
5	Escape Room: Tournament of Champions	Movie	2021
6	Escape Room	Movie	2019
5	Firestarter	Movie	2022
6	Firestarter	Movie	1984
7	Trap	Movie	2024
6	Brightburn	Movie	2019
4	Hellraiser: Bloodline	Movie	1996
6	Hellraiser III: Hell on Earth	Movie	1992
9	Upgrade	Movie	2018
7	Final Destination 5	Movie	2011
3	Spawn	Movie	1997
7	MaXXXine	Movie	2024
9	The Thing	Movie	1982
8	Little Shop of Horrors	Movie	1986
2	Plan 9 from Outer Space	Movie	1957
4	The Final Destination	Movie	2009
5	Final Destination 3	Movie	2006
6	Final Destination 2	Movie	2003
6	Final Destination	Movie	2000
3	Winnie-the-Pooh: Blood and Honey 2	Movie	2024
6	Joker: Folie à Deux	Movie	2024
5	The Amityville Horror	Movie	2005
6	The Amityville Horror	Movie	1979
6	Insidious: The Red Door	Movie	2023
5	Insidious: The Last Key	Movie	2018
6	Insidious: Chapter 3	Movie	2015
8	Abigail	Movie	2024
8	The Fall Guy	Movie	2024
8	Challengers	Movie	2024
10	Inside Out 2	Movie	2024
7	The Outsiders	Movie	1983
8	Rosemary's Baby	Movie	1968
9	Whiplash	Movie	2014
6	The Sorcerer's Apprentice	Movie	2010
5	The Craft: Legacy	Movie	2020
8	The Craft	Movie	1996
9	The Usual Suspects	Movie	1995
9	Blazing Saddles	Movie	1974
4	Eragon	Movie	2006
6	Charlie's Angels	Movie	2019
5	Charlie's Angels	Movie	2000
8	Midsommar	Movie	2019
7	Miss Peregrine's Home for Peculiar Children	Movie	2016
6	Mars Attacks!	Movie	1996
9	Apocalypse Now	Movie	1979
7	Bambi	Movie	1942
7	A Quiet Place: Day One	Movie	2024
7	It Ends with Us	Movie	2024
6	Steel Magnolias	Movie	1989
8	Rear Window	Movie	1954
9	The Crow	Movie	1994
8	True Lies	Movie	1994
4	Conan the Destroyer	Movie	1984
6	Conan the Barbarian	Movie	1982
7	Don't Breathe 2	Movie	2021
9	Don't Breathe	Movie	2016
9	Lilo & Stitch	Movie	2002
7	Terrifier 2	Movie	2022
5	Terrifier	Movie	2016
8	Lawrence of Arabia	Movie	1962
4	Warcraft	Movie	2016
8	Kingdom of the Planet of the Apes	Movie	2024
8	The Visit	Movie	2015
7	Anchorman 2: The Legend Continues	Movie	2013
9	Anchorman: The Legend of Ron Burgundy	Movie	2004
8	Love Lies Bleeding	Movie	2024
9	Deadpool & Wolverine	Movie	2024
9	Girl, Interrupted	Movie	1999
8	Twisters	Movie	2024
7	Ghostbusters: Frozen Empire	Movie	2024
7	IF	Movie	2024
6	San Andreas	Movie	2015
6	Volcano	Movie	1997
7	Dante's Peak	Movie	1997
4	Descendants: The Rise of Red	Movie	2024
7	Sausage Party	Movie	2016
5	The School for Good and Evil	Movie	2022
6	Princess Protection Program	Movie	2009
7	Cinderella	Movie	1997
9	Poor Things	Movie	2023
7	Beverly Hills Cop: Axel F	Movie	2024
7	American Pie 2	Movie	2001
8	American Pie	Movie	1999
7	Migration	Movie	2023
7	Kung Fu Panda 4	Movie	2024
5	Beverly Hills Cop III	Movie	1994
7	Beverly Hills Cop II	Movie	1987
9	Beverly Hills Cop	Movie	1984
9	Pearl	Movie	2022
8	X	Movie	2022
8	Team America: World Police	Movie	2004
9	South Park: Bigger, Longer & Uncut	Movie	1999
4	I Now Pronounce You Chuck & Larry	Movie	2007
6	Hellboy	Movie	2019
9	Hellboy II: The Golden Army	Movie	2008
8	Hellboy	Movie	2004
7	I, Robot	Movie	2004
9	Godzilla Minus One	Movie	2023
6	Bad Boys for Life	Movie	2020
7	Glass	Movie	2019
9	Split	Movie	2016
8	Unbreakable	Movie	2000
8	Labyrinth	Movie	1986
7	The Hunger Games: The Ballad of Songbirds & Snakes	Movie	2023
8	American Sniper	Movie	2014
8	Furiosa: A Mad Max Saga	Movie	2024
5	Chicken Little	Movie	2005
9	The Emperor's New Groove	Movie	2000
9	Dune: Part Two	Movie	2024
4	Garfield: A Tail of Two Kitties	Movie	2006
4	Garfield: The Movie	Movie	2004
9	North by Northwest	Movie	1959
8	The Dark Crystal	Movie	1982
6	The Strangers: Prey at Night	Movie	2018
6	The Strangers	Movie	2008
4	A Bad Moms Christmas	Movie	2017
5	Bad Moms	Movie	2016
9	War for the Planet of the Apes	Movie	2017
9	Dawn of the Planet of the Apes	Movie	2014
8	Rise of the Planet of the Apes	Movie	2011
6	Planet of the Apes	Movie	2001
6	Godzilla x Kong: The New Empire	Movie	2024
5	Battle for the Planet of the Apes	Movie	1973
6	Conquest of the Planet of the Apes	Movie	1972
7	Escape from the Planet of the Apes	Movie	1971
7	Beneath the Planet of the Apes	Movie	1970
9	Planet of the Apes	Movie	1968
8	Civil War	Movie	2024
8	King Richard	Movie	2021
9	The Truman Show	Movie	1998
8	Liar Liar	Movie	1997
7	Dumb and Dumber	Movie	1994
8	The Mask	Movie	1994
4	Rebel Moon - Part Two: The Scargiver	Movie	2024
8	Seven Samurai	Movie	1954
7	Lisa Frankenstein	Movie	2024
5	Argylle	Movie	2024
10	Her	Movie	2013
9	Ex Machina	Movie	2014
7	The Creator	Movie	2023
7	A.I. Artificial Intelligence	Movie	2001
8	The Green Knight	Movie	2021
7	Wish	Movie	2023
9	The Omen	Movie	1976
7	The Croods: A New Age	Movie	2020
5	Ace Ventura: When Nature Calls	Movie	1995
8	Footloose	Movie	1984
9	Fight Club	Movie	1999
9	King Kong	Movie	2005
6	Death Note	Movie	2017
6	Road House	Movie	2024
6	Trolls Band Together	Movie	2023
9	Ghost	Movie	1990
7	Road House	Movie	1989
8	Dirty Dancing	Movie	1987
5	The Boondock Saints	Movie	1999
6	The SpongeBob Movie: Sponge on the Run	Movie	2020
6	The SpongeBob Movie: Sponge Out of Water	Movie	2015
6	The SpongeBob SquarePants Movie	Movie	2004
6	Mean Girls	Movie	2024
7	Damsel	Movie	2024
7	Moonlight	Movie	2016
8	La La Land	Movie	2016
9	Birdman or (The Unexpected Virtue of Ignorance)	Movie	2014
9	Slumdog Millionaire	Movie	2008
8	American Beauty	Movie	1999
9	Arrival	Movie	2016
6	Monsters vs. Aliens	Movie	2009
7	Penguins of Madagascar	Movie	2014
8	Madagascar 3: Europe's Most Wanted	Movie	2012
8	Madagascar: Escape 2 Africa	Movie	2008
7	Madagascar	Movie	2005
8	The Color Purple	Movie	2023
9	Selma	Movie	2014
8	Lincoln	Movie	2012
4	Madame Web	Movie	2024
8	Air Force One	Movie	1997
5	Valentine's Day	Movie	2010
8	Warm Bodies	Movie	2013
9	Chronicle	Movie	2012
6	RoboCop	Movie	2014
7	The Blind Side	Movie	2009
8	Hamilton	Movie	2020
9	Remember the Titans	Movie	2000
8	Rudy	Movie	1993
5	Jack Reacher: Never Go Back	Movie	2016
7	Jack Reacher	Movie	2012
9	Batman: Assault on Arkham	Movie	2014
8	My Fair Lady	Movie	1964
6	Mr. & Mrs. Smith	Movie	2005
5	Final Fantasy: The Spirits Within	Movie	2001
7	The Lego Ninjago Movie	Movie	2017
7	The King's Man	Movie	2021
8	Kingsman: The Golden Circle	Movie	2017
9	Kingsman: The Secret Service	Movie	2014
6	Ted 2	Movie	2015
7	Ted	Movie	2012
7	The Equalizer 3	Movie	2023
7	The Equalizer 2	Movie	2018
8	The Equalizer	Movie	2014
9	The Rocky Horror Picture Show	Movie	1975
8	Wonka	Movie	2023
6	Aquaman and the Lost Kingdom	Movie	2023
7	Napoleon Dynamite	Movie	2004
6	Crank	Movie	2006
7	Gran Turismo	Movie	2023
8	Atlantis: The Lost Empire	Movie	2001
7	James and the Giant Peach	Movie	1996
9	Mission: Impossible - Dead Reckoning Part One	Movie	2023
9	Oppenheimer	Movie	2023
7	Saw X	Movie	2023
6	Mortal Kombat Legends: Cage Match	Movie	2023
5	Rebel Moon - Part One: A Child of Fire	Movie	2023
3	The Nutcracker: The Untold Story	Movie	2010
6	The Exorcist: Believer	Movie	2023
8	The Color Purple	Movie	1985
6	300: Rise of an Empire	Movie	2014
7	300	Movie	2006
5	Jack Frost	Movie	1998
7	Love Actually	Movie	2003
7	Violent Night	Movie	2022
8	Krampus	Movie	2015
1	Silent Night, Deadly Night Part 2	Movie	1987
4	Silent Night, Deadly Night	Movie	1984
2	Santa Claus Conquers the Martians	Movie	1964
7	Spirited	Movie	2022
4	Daddy's Home 2	Movie	2017
5	Daddy's Home	Movie	2015
8	Instant Family	Movie	2018
9	Dances with Wolves	Movie	1990
9	Planes, Trains & Automobiles	Movie	1987
7	Meet the Robinsons	Movie	2007
7	Blue Beetle	Movie	2023
8	Godzilla	Movie	1954
8	King Kong	Movie	1933
6	Trolls World Tour	Movie	2020
6	Trolls	Movie	2016
7	Battle Royale	Movie	2000
6	The Marvels	Movie	2023
3	Elektra	Movie	2005
8	Scarface	Movie	1983
3	Catwoman	Movie	2004
8	Tropic Thunder	Movie	2008
6	Constantine	Movie	2005
5	The Nun II	Movie	2023
7	A Haunting in Venice	Movie	2023
9	Trick 'r Treat	Movie	2007
5	Five Nights at Freddy's	Movie	2023
5	Casper	Movie	1995
8	Willy's Wonderland	Movie	2021
8	Freaky	Movie	2020
7	Jennifer's Body	Movie	2009
8	The Birds	Movie	1963
9	The Invisible Man	Movie	2020
4	The Mummy	Movie	2017
8	Smile	Movie	2022
8	They Live	Movie	1988
7	Interview with the Vampire	Movie	1994
8	The Lost Boys	Movie	1987
3	Winnie-the-Pooh: Blood and Honey	Movie	2023
5	Goosebumps 2: Haunted Halloween	Movie	2018
6	Goosebumps	Movie	2015
5	Pet Sematary	Movie	2019
5	Pet Sematary	Movie	1989
7	Haunted Mansion	Movie	2023
7	Ouija: Origin of Evil	Movie	2016
5	Ouija	Movie	2014
8	American Psycho	Movie	2000
9	The Wolf of Wall Street	Movie	2013
4	Meg 2: The Trench	Movie	2023
9	Teenage Mutant Ninja Turtles: Mutant Mayhem	Movie	2023
10	Spider-Man: Across the Spider-Verse	Movie	2023
6	Fast X	Movie	2023
7	Bloodsport	Movie	1988
6	Snake Eyes	Movie	2021
5	G.I. Joe: Retaliation	Movie	2013
4	G.I. Joe: The Rise of Cobra	Movie	2009
8	Prey	Movie	2022
7	Annabelle Comes Home	Movie	2019
5	Hotel Transylvania 3: Summer Vacation	Movie	2018
8	Ready Player One	Movie	2018
7	Murder on the Orient Express	Movie	2017
8	Doctor Strange	Movie	2016
5	Independence Day: Resurgence	Movie	2016
5	Indiana Jones and the Kingdom of the Crystal Skull	Movie	2008
7	Spy Kids	Movie	2001
8	Elemental	Movie	2023
7	Death on the Nile	Movie	2022
5	Moonfall	Movie	2022
7	Mortal Kombat Legends: Scorpion's Revenge	Movie	2020
7	Jumanji	Movie	1995
5	Ace Ventura: Pet Detective	Movie	1994
8	Addams Family Values	Movie	1993
8	The Little Mermaid	Movie	1989
5	Friday the 13th: The Final Chapter	Movie	1984
6	Friday the 13th: Part 3	Movie	1982
6	Friday the 13th Part 2	Movie	1981
9	Gravity	Movie	2013
7	Clue	Movie	1985
5	Battleship	Movie	2012
6	The Little Mermaid	Movie	2023
4	My Big Fat Greek Wedding 2	Movie	2016
7	My Big Fat Greek Wedding	Movie	2002
8	National Lampoon's Animal House	Movie	1978
9	Training Day	Movie	2001
4	Fantastic Four	Movie	2015
5	Fantastic Four: Rise of the Silver Surfer	Movie	2007
7	Top Gun	Movie	1986
3	The Emoji Movie	Movie	2017
5	Fantastic Four	Movie	2005
9	Stand by Me	Movie	1986
8	The Goonies	Movie	1985
7	Mrs. Doubtfire	Movie	1993
8	Big	Movie	1988
8	Enter the Dragon	Movie	1973
9	Heathers	Movie	1989
8	American Graffiti	Movie	1973
7	Elysium	Movie	2013
6	The Super Mario Bros. Movie	Movie	2023
5	Deep Blue Sea	Movie	1999
9	CODA	Movie	2021
9	Hereditary	Movie	2018
8	Barbie	Movie	2023
7	Tomorrowland	Movie	2015
7	Where the Crawdads Sing	Movie	2022
5	The Princess Diaries 2: Royal Engagement	Movie	2004
6	The Princess Diaries	Movie	2001
8	John Wick: Chapter 4	Movie	2023
7	Indiana Jones and the Dial of Destiny	Movie	2023
8	Dunkirk	Movie	2017
8	Interstellar	Movie	2014
9	Mission: Impossible - Fallout	Movie	2018
8	Mission: Impossible - Rogue Nation	Movie	2015
9	Mission: Impossible - Ghost Protocol	Movie	2011
7	Mission: Impossible III	Movie	2006
6	Mission: Impossible II	Movie	2000
7	Mission: Impossible	Movie	1996
6	Insidious: Chapter 2	Movie	2013
8	School of Rock	Movie	2003
8	Fantastic Mr. Fox	Movie	2009
7	Insidious	Movie	2010
7	The Flash	Movie	2023
7	Evil Dead Rise	Movie	2023
7	Transformers: Rise of the Beasts	Movie	2023
7	National Lampoon's European Vacation	Movie	1985
8	National Lampoon's Vacation	Movie	1983
7	Renfield	Movie	2023
8	12 Years a Slave	Movie	2013
5	6 Underground	Movie	2019
7	Tommy Boy	Movie	1995
6	Extraction II	Movie	2023
6	The Gray Man	Movie	2022
6	Red Notice	Movie	2021
6	Extraction	Movie	2020
5	Magic Mike's Last Dance	Movie	2023
9	Creed III	Movie	2023
6	Armageddon	Movie	1998
7	Deep Impact	Movie	1998
7	The Transformers: The Movie	Movie	1986
8	The Lego Movie 2: The Second Part	Movie	2019
8	The Lego Batman Movie	Movie	2017
9	The Lego Movie	Movie	2014
9	The Mitchells vs. the Machines	Movie	2021
6	Cloudy with a Chance of Meatballs 2	Movie	2013
9	Zombieland	Movie	2009
7	X-Men: The Last Stand	Movie	2006
6	X-Men: Apocalypse	Movie	2016
4	We Can Be Heroes	Movie	2020
7	WarGames	Movie	1983
5	Venom: Let There Be Carnage	Movie	2021
7	Uncharted	Movie	2022
6	Twister	Movie	1996
5	Tom & Jerry	Movie	2021
5	The Witches	Movie	2020
7	The Witches	Movie	1990
9	The Shining	Movie	1980
6	The Predator	Movie	2018
5	The Passion of the Christ	Movie	2004
7	The Maze Runner	Movie	2014
7	The Matrix Resurrections	Movie	2021
5	The Lorax	Movie	2012
5	The Karate Kid Part III	Movie	1989
6	The Karate Kid Part II	Movie	1986
7	The Incredible Hulk	Movie	2008
7	The Hobbit: The Battle of the Five Armies	Movie	2014
7	The Hateful Eight	Movie	2015
7	The Fate of the Furious	Movie	2017
7	The Fast and the Furious	Movie	2001
7	The Cloverfield Paradox	Movie	2018
7	The Chronicles of Narnia: Prince Caspian	Movie	2008
8	The Bourne Ultimatum	Movie	2007
5	The Addams Family	Movie	2019
5	Teenage Mutant Ninja Turtles: Out of the Shadows	Movie	2016
5	Teenage Mutant Ninja Turtles	Movie	2014
7	Teenage Mutant Ninja Turtles	Movie	1990
5	Teenage Mutant Ninja Turtles III	Movie	1993
5	Teenage Mutant Ninja Turtles II: The Secret of the Ooze	Movie	1991
7	Tron: Legacy	Movie	2010
7	TMNT	Movie	2007
6	Stargate	Movie	1994
8	Star Trek Into Darkness	Movie	2013
7	Sonic the Hedgehog 2	Movie	2022
7	Sonic the Hedgehog	Movie	2020
5	Signs	Movie	2002
7	Shrek Forever After	Movie	2010
7	Shazam! Fury of the Gods	Movie	2023
7	Scream 4	Movie	2011
3	Scary Movie	Movie	2000
6	Santa Claus	Movie	1985
5	Romeo + Juliet	Movie	1996
7	Rise of the Guardians	Movie	2012
4	Return to Halloweentown	Movie	2006
7	Prometheus	Movie	2012
4	Polar	Movie	2019
7	Pocahontas	Movie	1995
5	Planes: Fire & Rescue	Movie	2014
8	Peter Pan	Movie	2003
6	Old	Movie	2021
6	Noelle	Movie	2019
6	Night at the Museum: Secret of the Tomb	Movie	2014
7	Night at the Museum	Movie	2006
2	Music	Movie	2021
7	Mortal Kombat	Movie	2021
5	Monster Hunter	Movie	2020
5	Minions: The Rise of Gru	Movie	2022
5	Minions	Movie	2015
7	Magic Mike	Movie	2012
7	Live Free or Die Hard	Movie	2007
7	Jungle Cruise	Movie	2021
7	Independence Day	Movie	1996
4	Hubie Halloween	Movie	2020
8	How to Train Your Dragon: The Hidden World	Movie	2019
7	Hotel Transylvania	Movie	2012
6	High School Musical 3: Senior Year	Movie	2008
6	High School Musical 2	Movie	2007
6	High School Musical	Movie	2006
8	Hercules	Movie	1997
7	Happy Gilmore	Movie	1996
5	Hancock	Movie	2008
5	Halloween 4: The Return of Michael Myers	Movie	1988
8	Guardians of the Galaxy Vol. 2	Movie	2017
8	Groundhog Day	Movie	1993
5	Godmothered	Movie	2020
5	Friday the 13th	Movie	2009
5	Fred Claus	Movie	2007
8	Fast & Furious Presents: Hobbs & Shaw	Movie	2019
7	Evil Dead	Movie	2013
7	Elf	Movie	2003
6	Divergent	Movie	2014
7	Disenchanted	Movie	2022
5	X-Men: Dark Phoenix	Movie	2019
7	Cruella	Movie	2021
7	Coming to America	Movie	1988
4	Coming 2 America	Movie	2021
7	Child's Play	Movie	2019
7	Carrie	Movie	2013
7	Brave	Movie	2012
7	Blade	Movie	1998
4	Bad Boys II	Movie	2003
9	Back to the Future	Movie	1985
7	Austin Powers: International Man of Mystery	Movie	1997
4	Artemis Fowl	Movie	2020
8	Army of Darkness	Movie	1992
7	A Series of Unfortunate Events	Movie	2004
5	A Christmas Prince: The Royal Wedding	Movie	2018
4	102 Dalmatians	Movie	2000
5	101 Dalmatians	Movie	1996
8	Cloudy with a Chance of Meatballs	Movie	2009
9	Tarzan	Movie	1999
9	The Hunchback of Notre Dame	Movie	1996
6	Into the Woods	Movie	2014
8	Dungeons & Dragons: Honor Among Thieves	Movie	2023
2	Dungeons & Dragons	Movie	2000
8	White Men Can't Jump	Movie	1992
5	xXx: Return of Xander Cage	Movie	2017
4	xXx: State of the Union	Movie	2005
5	xXx	Movie	2002
8	Guardians of the Galaxy Vol. 3	Movie	2023
7	Mamma Mia! Here We Go Again	Movie	2018
6	Mamma Mia!	Movie	2008
3	Fifty Shades Freed	Movie	2018
3	Fifty Shades Darker	Movie	2017
3	Fifty Shades of Grey	Movie	2015
8	Fatal Attraction	Movie	1987
8	Scream VI	Movie	2023
6	Peter Pan & Wendy	Movie	2023
8	Pete's Dragon	Movie	2016
6	Pete's Dragon	Movie	1977
7	Cocaine Bear	Movie	2023
8	Patriots Day	Movie	2016
4	Van Helsing	Movie	2004
3	The Mummy: Tomb of the Dragon Emperor	Movie	2008
4	The Scorpion King	Movie	2002
5	The Mummy Returns	Movie	2001
7	The Mummy	Movie	1999
4	Vampire's Kiss	Movie	1988
6	Knock at the Cabin	Movie	2023
3	Super Mario Bros.	Movie	1993
4	Murder Mystery 2	Movie	2023
5	Murder Mystery	Movie	2019
4	Pixels	Movie	2015
6	DC League of Super-Pets	Movie	2022
8	Point Break	Movie	1991
8	Nobody	Movie	2021
9	The Sound of Music	Movie	1965
8	Chicago	Movie	2002
9	Puss in Boots: The Last Wish	Movie	2022
8	Gladiator	Movie	2000
9	Braveheart	Movie	1995
9	Forrest Gump	Movie	1994
7	Ant-Man and the Wasp: Quantumania	Movie	2023
5	History of the World: Part I	Movie	1981
3	Leprechaun	Movie	1993
8	M3GAN	Movie	2022
8	Creed II	Movie	2018
9	Creed	Movie	2015
9	Green Book	Movie	2018
9	BlacKkKlansman	Movie	2018
8	Hidden Figures	Movie	2016
7	Honey, I Shrunk the Kids	Movie	1989
7	The Notebook	Movie	2004
4	Showgirls	Movie	1995
8	Basic Instinct	Movie	1992
6	The Mighty Ducks	Movie	1992
8	Matilda	Movie	1996
6	Magic Mike XXL	Movie	2015
6	Bruce Almighty	Movie	2003
8	Star Trek Beyond	Movie	2016
9	Star Trek	Movie	2009
3	After Earth	Movie	2013
8	Antz	Movie	1998
9	The Prince of Egypt	Movie	1998
4	Taken 3	Movie	2014
5	Taken 2	Movie	2012
8	Taken	Movie	2008
6	Jason Bourne	Movie	2016
6	The Bourne Legacy	Movie	2012
8	The Bourne Supremacy	Movie	2004
9	The Bourne Identity	Movie	2002
9	Once Upon a Time... in Hollywood	Movie	2019
8	Avatar: The Way of Water	Movie	2022
8	White Christmas	Movie	1954
8	Us	Movie	2019
8	Up	Movie	2009
6	Unfriended	Movie	2014
8	The Road Warrior	Movie	1981
5	The Meg	Movie	2018
8	The Godfather Part II	Movie	1974
6	The Expendables 2	Movie	2012
8	The Death of Superman	Movie	2018
6	The Christmas Chronicles: Part Two	Movie	2020
6	Star Wars: Episode III - Revenge of the Sith	Movie	2005
5	Star Wars: Episode II - Attack of the Clones	Movie	2002
5	Star Wars: Episode I - The Phantom Menace	Movie	1999
4	Spy Kids 3: Game Over	Movie	2003
8	Spider-Man	Movie	2002
3	Scary Movie 3	Movie	2003
5	Saw III	Movie	2006
4	RoboCop 2	Movie	1990
8	Pokémon: Detective Pikachu	Movie	2019
5	Ocean's Eight	Movie	2018
5	Night at the Museum: Battle of the Smithsonian	Movie	2009
6	National Treasure	Movie	2004
6	Maleficent	Movie	2014
6	Les Misérables	Movie	2012
8	Justice League Dark: Apokolips War	Movie	2020
8	Juno	Movie	2007
6	Inferno	Movie	2016
6	I Know What You Did Last Summer	Movie	1997
8	Harry Potter and the Deathly Hallows: Part 1	Movie	2010
8	Harry Potter and the Chamber of Secrets	Movie	2002
4	Halloweentown II: Kalabar's Revenge	Movie	2001
8	Hacksaw Ridge	Movie	2016
8	Guillermo del Toro's Pinocchio	Movie	2022
6	Godzilla: King of the Monsters	Movie	2019
6	Godzilla vs. Kong	Movie	2021
8	Glass Onion	Movie	2022
8	Game Night	Movie	2018
4	Friday the 13th: The New Blood	Movie	1988
8	Free Guy	Movie	2021
8	E.T. the Extra-Terrestrial	Movie	1982
5	Dune	Movie	1984
8	Doctor Sleep	Movie	2019
8	Die Hard with a Vengeance	Movie	1995
5	Descendants 2	Movie	2017
8	Citizen Kane	Movie	1941
6	Cinderella	Movie	2015
8	Bride of Frankenstein	Movie	1935
8	Black Panther: Wakanda Forever	Movie	2022
8	Bill & Ted's Bogus Journey	Movie	1991
6	A Christmas Story Christmas	Movie	2022
4	A Christmas Prince: The Royal Baby	Movie	2019
5	2012	Movie	2009
8	2001: A Space Odyssey	Movie	1968
5	2 Fast 2 Furious	Movie	2003
6	Mortal Kombat Legends: Snow Blind	Movie	2022
8	Bullet Train	Movie	2022
8	The Unbearable Weight of Massive Talent	Movie	2022
7	Strange World	Movie	2022
8	Nope	Movie	2022
5	A Christmas Prince	Movie	2017
9	Klaus	Movie	2019
7	Willow	Movie	1988
8	Tron	Movie	1982
9	Enchanted	Movie	2007
8	The Princess and the Frog	Movie	2009
8	Snow White and the Seven Dwarfs	Movie	1937
9	Saving Private Ryan	Movie	1998
8	Full Metal Jacket	Movie	1987
10	Everything Everywhere All at Once	Movie	2022
8	Enola Holmes 2	Movie	2022
8	Enola Holmes	Movie	2020
5	Halloween Ends	Movie	2022
8	Zodiac	Movie	2007
9	Se7en	Movie	1995
7	Wendell & Wild	Movie	2022
6	Dark Shadows	Movie	2012
6	Black Adam	Movie	2022
8	Sweeney Todd: The Demon Barber of Fleet Street	Movie	2007
9	Edward Scissorhands	Movie	1990
8	Beetlejuice	Movie	1988
5	Morbius	Movie	2022
9	Misery	Movie	1990
9	Carrie	Movie	1976
7	The Mist	Movie	2007
8	The Black Phone	Movie	2021
4	Jurassic World: Dominion	Movie	2022
1	Birdemic: Shock and Terror	Movie	2010
8	Candyman	Movie	2021
8	Candyman	Movie	1992
7	Hellraiser	Movie	2022
5	Spiral	Movie	2021
7	Creature from the Black Lagoon	Movie	1954
7	The Wolf Man	Movie	1941
8	The Invisible Man	Movie	1933
7	The Mummy	Movie	1932
6	Hocus Pocus 2	Movie	2022
7	The Blair Witch Project	Movie	1999
5	Hellbound: Hellraiser II	Movie	1988
8	Hellraiser	Movie	1987
4	The Addams Family 2	Movie	2021
6	Monster House	Movie	2006
10	Coraline	Movie	2009
7	Muppets Most Wanted	Movie	2014
9	The Muppets	Movie	2011
6	Muppets from Space	Movie	1999
8	Muppet Treasure Island	Movie	1996
8	The Muppets Take Manhattan	Movie	1984
8	The Great Muppet Caper	Movie	1981
9	The Muppet Movie	Movie	1979
9	Clerks	Movie	1994
8	Cinderella	Movie	1950
5	Pinocchio	Movie	2022
8	Pinocchio	Movie	1940
4	Mars Needs Moms	Movie	2011
8	Elvis	Movie	2022
9	Mean Girls	Movie	2004
7	Clueless	Movie	1995
8	Ferris Bueller's Day Off	Movie	1986
9	The Breakfast Club	Movie	1985
8	Fast Times at Ridgemont High	Movie	1982
5	Middle School: The Worst Years of My Life	Movie	2016
6	Samaritan	Movie	2022
6	The Expendables 3	Movie	2014
6	The Expendables	Movie	2010
9	Goodfellas	Movie	1990
5	Hulk	Movie	2003
4	Daredevil	Movie	2003
4	Alien: Resurrection	Movie	1997
4	Reefer Madness	Movie	1938
9	A League of Their Own	Movie	1992
7	Zack Snyder's Justice League	Movie	2021
6	World War Z	Movie	2013
6	Wonder Woman 1984	Movie	2020
5	Underworld: Rise of the Lycans	Movie	2009
5	Underworld: Evolution	Movie	2006
6	Underworld	Movie	2003
4	Twilight	Movie	2008
1	Troll 2	Movie	1990
1	The Room	Movie	2003
7	The Rock	Movie	1996
8	The Producers	Movie	2005
7	The Patriot	Movie	2000
6	The Old Guard	Movie	2020
6	The Matrix Revolutions	Movie	2003
6	The Lost World: Jurassic Park	Movie	1997
10	The Incredibles	Movie	2004
7	The Greatest Showman	Movie	2017
7	The Great Gatsby	Movie	2013
6	The Good Dinosaur	Movie	2015
7	The Godfather Part III	Movie	1990
6	The Da Vinci Code	Movie	2006
7	The Christmas Chronicles	Movie	2018
4	The Bye Bye Man	Movie	2017
8	The Adam Project	Movie	2022
7	Terminator: Dark Fate	Movie	2019
6	Superman Returns	Movie	2006
7	Superman II	Movie	1980
8	Super 8	Movie	2011
5	Suicide Squad	Movie	2016
8	Star Wars: Episode VIII - The Last Jedi	Movie	2017
9	Star Wars: Episode VII - The Force Awakens	Movie	2015
9	Star Wars: Episode VI - Return of the Jedi	Movie	1983
10	Star Wars: Episode IV - A New Hope	Movie	1977
6	Star Trek: The Motion Picture	Movie	1979
7	Star Trek: Generations	Movie	1994
7	Star Trek: Nemesis	Movie	2002
6	Sing	Movie	2016
8	Shrek	Movie	2001
6	Rocky V	Movie	1990
8	Reign of the Supermen	Movie	2019
8	Real Steel	Movie	2011
4	Rambo	Movie	2008
6	Percy Jackson & the Olympians: The Lightning Thief	Movie	2010
6	Mulan	Movie	2020
10	Monsters, Inc.	Movie	2001
7	Man of Steel	Movie	2013
6	Lady and the Tramp	Movie	2019
7	Justice League Dark	Movie	2017
5	Justice League	Movie	2017
5	Jurassic Park III	Movie	2001
9	Inside Out	Movie	2015
10	Raiders of the Lost Ark	Movie	1981
6	Ice Age: Dawn of the Dinosaurs	Movie	2009
4	Halloween: Resurrection	Movie	2002
6	Halloween Kills	Movie	2021
4	Geostorm	Movie	2017
10	Finding Nemo	Movie	2003
6	Fast & Furious	Movie	2009
6	Fantastic Beasts: The Secrets of Dumbledore	Movie	2022
6	Dumbo	Movie	2019
7	Dumbo	Movie	1941
4	Diary of a Wimpy Kid	Movie	2010
5	Despicable Me 3	Movie	2017
6	Dear Evan Hansen	Movie	2021
10	Coco	Movie	2017
7	Cloud Atlas	Movie	2012
6	Clash of the Titans	Movie	1981
6	Beauty and the Beast	Movie	2017
4	Allegiant	Movie	2016
5	Alice in Wonderland	Movie	2010
5	The Village	Movie	2004
4	The Twilight Saga: New Moon	Movie	2009
4	The Twilight Saga: Eclipse	Movie	2010
4	The Twilight Saga: Breaking Dawn - Part 1	Movie	2011
5	The Nutcracker and the Four Realms	Movie	2018
5	The Next Karate Kid	Movie	1994
4	The NeverEnding Story II: The Next Chapter	Movie	1990
5	The Grudge	Movie	2004
5	The Fast and the Furious: Tokyo Drift	Movie	2006
4	Surviving Christmas	Movie	2004
3	Superman III	Movie	1983
5	Star Wars: The Clone Wars	Movie	2008
4	Space Jam	Movie	1996
5	Skyscraper	Movie	2018
4	Christmas with the Kranks	Movie	2004
4	Blade: Trinity	Movie	2004
3	Aliens vs. Predator: Requiem	Movie	2007
5	Alien vs. Predator	Movie	2004
6	Lightyear	Movie	2022
6	Wonder Woman: Bloodlines	Movie	2019
8	Batman: Hush	Movie	2019
8	Constantine: City of Demons - The Movie	Movie	2018
8	Suicide Squad: Hell to Pay	Movie	2018
8	Teen Titans: The Judas Contract	Movie	2017
8	Batman vs. Robin	Movie	2015
8	Justice League vs. Teen Titans	Movie	2016
6	Batman: Bad Blood	Movie	2016
7	Justice League: Throne of Atlantis	Movie	2015
7	Thor: Love and Thunder	Movie	2022
8	Son of Batman	Movie	2014
7	Justice League: War	Movie	2014
8	Justice League: The Flashpoint Paradox	Movie	2013
4	Supergirl	Movie	1984
4	A Good Day to Die Hard	Movie	2013
4	Jason X	Movie	2001
4	Green Lantern	Movie	2011
4	Jaws: The Revenge	Movie	1987
4	Jaws 3-D	Movie	1983
10	The Lord of the Rings: The Return of the King	Movie	2003
10	The Lord of the Rings: The Two Towers	Movie	2002
10	The Lord of the Rings: The Fellowship of the Ring	Movie	2001
4	Halloween 5: The Revenge of Michael Myers	Movie	1989
4	I Still Know What You Did Last Summer	Movie	1998
4	Ice Age: Collision Course	Movie	2016
3	Billy Madison	Movie	1995
1	The Star Wars Holiday Special	Movie	1978
1	Scary Movie 2	Movie	2001
1	Mortal Kombat: Annihilation	Movie	1997
1	Alone in the Dark	Movie	2005
8	Phineas and Ferb the Movie: Candace Against the Universe	Movie	2020
8	Predator	Movie	1987
8	RoboCop	Movie	1987
10	Logan	Movie	2017
10	The Dark Knight	Movie	2008
10	Pan's Labyrinth	Movie	2006
10	Soul	Movie	2020
10	Star Wars: Episode V - The Empire Strikes Back	Movie	1980
10	Spider-Man: Into the Spider-Verse	Movie	2018
4	The Mortal Instruments: City of Bones	Movie	2013
4	The Darkest Minds	Movie	2018
6	Maze Runner: The Death Cure	Movie	2018
6	Maze Runner: The Scorch Trials	Movie	2015
7	Ghostbusters: Afterlife	Movie	2021
6	The Giver	Movie	2014
5	Zombies 3	Movie	2022
5	Bee Movie	Movie	2007
7	Megamind	Movie	2010
8	Kung Fu Panda 3	Movie	2016
9	Kung Fu Panda 2	Movie	2011
9	Kung Fu Panda	Movie	2008
7	Zombieland: Double Tap	Movie	2019
8	The Conjuring 2	Movie	2016
5	Alien³	Movie	1992
2	Dragonball Evolution	Movie	2009
2	Cats	Movie	2019
9	Zootopia	Movie	2016
5	Zombies 2	Movie	2020
9	X-Men: First Class	Movie	2011
9	X-Men: Days of Future Past	Movie	2014
8	X-Men	Movie	2000
8	Wreck-It Ralph	Movie	2012
9	Wonder Woman	Movie	2017
9	Willy Wonka & the Chocolate Factory	Movie	1971
9	Who Framed Roger Rabbit	Movie	1988
8	West Side Story	Movie	2021
9	West Side Story	Movie	1961
9	WALL·E	Movie	2008
9	V for Vendetta	Movie	2005
8	Uncut Gems	Movie	2019
9	Turning Red	Movie	2022
5	Transformers: Dark of the Moon	Movie	2011
4	Transformers: Revenge of the Fallen	Movie	2009
3	Transformers: The Last Knight	Movie	2017
8	Toy Story 4	Movie	2019
9	Toy Story 3	Movie	2010
9	Toy Story 2	Movie	1999
9	Toy Story	Movie	1995
7	Starship Troopers	Movie	1997
8	Total Recall	Movie	1990
8	Top Gun: Maverick	Movie	2022
8	Titanic	Movie	1997
9	Thor: Ragnarok	Movie	2017
9	The Wizard of Oz	Movie	1939
6	The Tomorrow War	Movie	2021
9	The Terminator	Movie	1984
9	The Suicide Squad	Movie	2021
8	The Social Network	Movie	2010
8	The Sixth Sense	Movie	1999
8	The Silence of the Lambs	Movie	1991
9	The Shawshank Redemption	Movie	1994
5	The Secret Life of Pets	Movie	2016
9	The Ring	Movie	2002
9	The Princess Bride	Movie	1987
7	The Polar Express	Movie	2004
4	The Nun	Movie	2018
8	The Nightmare Before Christmas	Movie	1993
9	The Muppet Christmas Carol	Movie	1992
8	The Matrix	Movie	1999
9	The Lion King	Movie	1994
3	The Last Sharknado: It's About Time	Movie	2018
3	The Last Airbender	Movie	2010
8	The Karate Kid	Movie	1984
8	The Jungle Book	Movie	1967
9	The Iron Giant	Movie	1999
5	The Haunted Mansion	Movie	2003
3	The Happening	Movie	2008
8	The Green Mile	Movie	1999
8	The Godfather	Movie	1972
8	The Fifth Element	Movie	1997
9	The Fault in Our Stars	Movie	2014
3	The Ewok Adventure	Movie	1984
9	The Evil Dead	Movie	1981
9	The Disaster Artist	Movie	2017
8	The Dark Knight Rises	Movie	2012
8	The Croods	Movie	2013
9	The Conjuring	Movie	2013
8	The Cabin in the Woods	Movie	2011
5	The Boy	Movie	2016
8	The Batman	Movie	2022
9	The Avengers	Movie	2012
3	The Adventures of Sharkboy and Lavagirl 3-D	Movie	2005
8	The Addams Family	Movie	1991
5	Terminator 3: Rise of the Machines	Movie	2003
9	Terminator 2: Judgment Day	Movie	1991
5	Teen Beach 2	Movie	2015
9	Tangled	Movie	2010
8	Superman	Movie	1978
4	Sucker Punch	Movie	2011
8	Star Trek: First Contact	Movie	1996
8	Spirited Away	Movie	2001
9	Spider-Man: No Way Home	Movie	2021
9	Spider-Man: Homecoming	Movie	2017
8	Spider-Man: Far from Home	Movie	2019
8	Spider-Man 2	Movie	2004
8	Spaceballs	Movie	1987
9	Snowpiercer	Movie	2013
8	Sleepy Hollow	Movie	1999
7	Sleeping Beauty	Movie	1959
8	Sinister	Movie	2012
8	Sin City	Movie	2005
9	Shutter Island	Movie	2010
5	Shrek the Third	Movie	2007
9	Shazam!	Movie	2019
3	Sharknado 5: Global Swarming	Movie	2017
3	Sharknado 4: The 4th Awakens	Movie	2016
3	Sharknado 3: Oh Hell No!	Movie	2015
3	Sharknado 2: The Second One	Movie	2014
3	Sharknado	Movie	2013
8	Shang-Chi and the Legend of the Ten Rings	Movie	2021
7	Scream 2	Movie	1997
8	Scream	Movie	2022
9	Scream	Movie	1996
9	Scott Pilgrim vs. the World	Movie	2010
3	Home Alone 3	Movie	1997
3	Scooby-Doo 2: Monsters Unleashed	Movie	2004
3	Scooby-Doo	Movie	2002
8	Schindler's List	Movie	1993
4	Saw V	Movie	2008
5	Saw II	Movie	2005
6	Saw	Movie	2004
9	Saving Mr. Banks	Movie	2013
8	Rogue One: A Star Wars Story	Movie	2016
9	Rocky	Movie	1976
9	Rocketman	Movie	2019
5	RoboCop 3	Movie	1993
6	Return to Oz	Movie	1985
8	Raya and the Last Dragon	Movie	2021
9	Ratatouille	Movie	2007
8	Rain Man	Movie	1988
9	Pulp Fiction	Movie	1994
8	Psycho	Movie	1960
8	Poltergeist	Movie	1982
8	Platoon	Movie	1986
4	Planes	Movie	2013
9	Phineas and Ferb the Movie: Across the 2nd Dimension	Movie	2011
8	Peter Pan	Movie	1953
5	Percy Jackson: Sea of Monsters	Movie	2013
5	Pearl Harbor	Movie	2001
5	Paranormal Activity	Movie	2007
8	ParaNorman	Movie	2012
8	Onward	Movie	2020
8	One Hundred and One Dalmatians	Movie	1961
5	Ocean's Twelve	Movie	2004
5	Ocean's Thirteen	Movie	2007
7	Nosferatu: A Symphony of Horror	Movie	1922
5	No Country for Old Men	Movie	2007
8	Night of the Living Dead	Movie	1968
5	National Treasure: Book of Secrets	Movie	2007
8	National Lampoon's Christmas Vacation	Movie	1989
8	Mulan	Movie	1998
9	Moana	Movie	2016
8	Miracle on 34th Street	Movie	1947
8	John Wick	Movie	2014
3	Jingle All the Way	Movie	1996
4	Jigsaw	Movie	2017
4	Jem and the Holograms	Movie	2015
5	Jaws 2	Movie	1978
9	It's a Wonderful Life	Movie	1946
4	How the Grinch Stole Christmas	Movie	2000
3	Ghost Rider: Spirit of Vengeance	Movie	2011
5	Event Horizon	Movie	1997
2	Diary of a Wimpy Kid: The Long Haul	Movie	2017
5	Clash of the Titans	Movie	2010
4	Bedtime Stories	Movie	2008
8	Batman Begins	Movie	2005
8	Batman	Movie	1989
8	Back to the Future Part III	Movie	1990
8	Back to the Future Part II	Movie	1989
8	Avengers: Age of Ultron	Movie	2015
6	Army of the Dead	Movie	2021
5	A Nightmare on Elm Street: The Dream Child	Movie	1989
5	A Nightmare on Elm Street 4: The Dream Master	Movie	1988
8	Sky High	Movie	2005
8	Men in Black	Movie	1997
9	Mary Poppins	Movie	1964
8	Mad Max: Fury Road	Movie	2015
8	Mad Max	Movie	1979
9	Luca	Movie	2021
8	Love, Simon	Movie	2018
5	Lethal Weapon 4	Movie	1998
9	Lethal Weapon	Movie	1987
5	Lara Croft: Tomb Raider	Movie	2001
5	Lara Croft: Tomb Raider - The Cradle of Life	Movie	2003
8	Lady and the Tramp	Movie	1955
8	Lady Bird	Movie	2017
8	Knives Out	Movie	2019
5	Killer Klowns from Outer Space	Movie	1988
9	Kill Bill: Vol. 1	Movie	2003
8	A Christmas Story	Movie	1983
8	A Bug's Life	Movie	1998
8	A Beautiful Day in the Neighborhood	Movie	2019
8	A Clockwork Orange	Movie	1971
9	Jurassic Park	Movie	1993
3	Jupiter Ascending	Movie	2015
8	Jumanji: Welcome to the Jungle	Movie	2017
8	Joker	Movie	2019
7	Jojo Rabbit	Movie	2019
8	John Wick: Chapter 3 - Parabellum	Movie	2019
8	John Wick: Chapter 2	Movie	2017
8	Jaws	Movie	1975
3	Jason Goes to Hell: The Final Friday	Movie	1993
8	It Follows	Movie	2014
8	It	Movie	2017
9	Iron Man	Movie	2008
8	Inglourious Basterds	Movie	2009
8	Indiana Jones and the Temple of Doom	Movie	1984
9	Indiana Jones and the Last Crusade	Movie	1989
8	Inception	Movie	2010
8	In the Heights	Movie	2021
5	Ice Age: Continental Drift	Movie	2012
8	Hugo	Movie	2011
9	How to Train Your Dragon 2	Movie	2014
9	How to Train Your Dragon	Movie	2010
5	Hotel Transylvania 4: Transformania	Movie	2022
8	Home Alone	Movie	1990
8	Harry Potter and the Sorcerer's Stone	Movie	2001
9	Harry Potter and the Prisoner of Azkaban	Movie	2004
8	Harry Potter and the Order of the Phoenix	Movie	2007
8	Harry Potter and the Half-Blood Prince	Movie	2009
9	Harry Potter and the Goblet of Fire	Movie	2005
9	Harry Potter and the Deathly Hallows: Part 2	Movie	2011
3	Halloweentown High	Movie	2004
3	Halloween: The Curse of Michael Myers	Movie	1995
5	Halloween III: Season of the Witch	Movie	1982
3	Halloween II	Movie	2009
6	Halloween H20: 20 Years Later	Movie	1998
9	Halloween	Movie	1978
9	Guardians of the Galaxy	Movie	2014
8	Gremlins	Movie	1984
3	Godzilla	Movie	1998
8	Glory	Movie	1989
8	Ghostbusters	Movie	1984
4	Ghost Rider	Movie	2007
9	Get Out	Movie	2017
8	Galaxy Quest	Movie	1999
9	Frozen	Movie	2013
3	Friday the 13th: A New Beginning	Movie	1985
7	Frankenstein	Movie	1931
8	First Blood	Movie	1982
8	Finding Dory	Movie	2016
8	Fear Street: Part Two - 1978	Movie	2021
8	Fear Street: Part One - 1994	Movie	2021
6	Fargo	Movie	1996
8	Face/Off	Movie	1997
3	Ewoks: The Battle for Endor	Movie	1985
9	Evil Dead II	Movie	1987
9	Encanto	Movie	2021
8	Dune: Part One	Movie	2021
7	Dracula	Movie	1931
8	Doctor Strange in the Multiverse of Madness	Movie	2022
8	Django Unchained	Movie	2012
8	District 9	Movie	2009
9	Die Hard	Movie	1988
5	Descendants 3	Movie	2019
4	Deck the Halls	Movie	2006
8	Deadpool 2	Movie	2018
9	Deadpool	Movie	2016
8	Crimson Peak	Movie	2015
8	Corpse Bride	Movie	2005
7	Con Air	Movie	1997
7	Chip 'n Dale: Rescue Rangers	Movie	2022
5	Children of the Corn	Movie	1984
9	Casablanca	Movie	1942
5	Cars 2	Movie	2011
9	Captain America: The Winter Soldier	Movie	2014
9	Captain America: The First Avenger	Movie	2011
9	Captain America: Civil War	Movie	2016
8	Bumblebee	Movie	2018
7	Brokeback Mountain	Movie	2005
6	Dracula	Movie	1992
8	Blade Runner	Movie	1982
8	Black Panther	Movie	2018
7	Black Christmas	Movie	1974
8	Birds of Prey and the Fantabulous Emancipation of One Harley Quinn	Movie	2020
6	Bird Box	Movie	2018
8	Bill & Ted's Excellent Adventure	Movie	1989
9	Big Hero 6	Movie	2014
6	Beowulf	Movie	2007
9	Beauty and the Beast	Movie	1991
8	Batman: Mask of the Phantasm	Movie	1993
8	Batman Returns	Movie	1992
5	Batman Forever	Movie	1995
5	Bad Boys	Movie	1995
9	Avengers: Infinity War	Movie	2018
9	Avengers: Endgame	Movie	2019
8	Avatar	Movie	2009
9	Arthur Christmas	Movie	2011
8	Ant-Man and the Wasp	Movie	2018
8	Ant-Man	Movie	2015
5	Annabelle	Movie	2014
9	Alita: Battle Angel	Movie	2019
9	Aliens	Movie	1986
8	Alien	Movie	1979
8	Alice in Wonderland	Movie	1951
9	Aladdin	Movie	1992
5	Adventures in Babysitting	Movie	2016
5	Adventures in Babysitting	Movie	1987
8	A Star Is Born	Movie	2018
8	A Quiet Place	Movie	2018
5	A Nightmare on Elm Street 2: Freddy's Revenge	Movie	1985
9	A Nightmare on Elm Street	Movie	1984
9	A Monster Calls	Movie	2016
9	10 Cloverfield Lane	Movie	2016
6	Men in Black³	Movie	2012
5	Men in Black II	Movie	2002
4	Bright	Movie	2017
6	Sing 2	Movie	2021
7	Despicable Me 2	Movie	2013
8	Despicable Me	Movie	2010
5	The Secret Life of Pets 2	Movie	2019
5	Teen Beach Movie	Movie	2013
4	Halloween	Movie	2007
6	Halloween II	Movie	1981
6	Alien: Covenant	Movie	2017
6	The Conjuring: The Devil Made Me Do It	Movie	2021
4	The Curse of La Llorona	Movie	2019
6	Annabelle: Creation	Movie	2017
8	X2: X-Men United	Movie	2003
5	Wrath of the Titans	Movie	2012
6	Thor: The Dark World	Movie	2013
8	Thor	Movie	2011
5	The Space Between Us	Movie	2017
5	The Santa Clause 2	Movie	2002
5	The Purge	Movie	2013
8	The NeverEnding Story	Movie	1984
4	The Lion King	Movie	2019
8	The Hunger Games: Catching Fire	Movie	2013
5	The Grinch	Movie	2018
5	The Forever Purge	Movie	2021
5	The First Purge	Movie	2018
8	The Exorcist	Movie	1973
5	Insurgent	Movie	2015
5	The Day After Tomorrow	Movie	2004
5	The Chronicles of Narnia: The Voyage of the Dawn Treader	Movie	2010
8	The Chronicles of Narnia: The Lion, the Witch and the Wardrobe	Movie	2005
8	The Big Lebowski	Movie	1998
5	Terminator Genisys	Movie	2015
5	Teen Wolf	Movie	1985
2	Superman IV: The Quest for Peace	Movie	1987
5	Star Trek V: The Final Frontier	Movie	1989
8	Star Trek II: The Wrath of Khan	Movie	1982
5	Spy Kids 2: Island of Lost Dreams	Movie	2002
8	Shrek 2	Movie	2004
8	Sherlock Holmes	Movie	2009
5	Scoob!	Movie	2020
8	Rocky II	Movie	1979
8	Rocky Balboa	Movie	2006
8	Pirates of the Caribbean: The Curse of the Black Pearl	Movie	2003
5	Pirates of the Caribbean: On Stranger Tides	Movie	2011
5	Pirates of the Caribbean: Dead Men Tell No Tales	Movie	2017
5	Pan	Movie	2015
5	Mortal Kombat	Movie	1995
7	Mary Poppins Returns	Movie	2018
5	Maleficent: Mistress of Evil	Movie	2019
8	Kong: Skull Island	Movie	2017
2	Kirk Cameron's Saving Christmas	Movie	2014
7	Kill Bill: Vol. 2	Movie	2004
2	Jack and Jill	Movie	2011
8	Iron Man 3	Movie	2013
8	Incredibles 2	Movie	2018
4	Hop	Movie	2011
5	Hocus Pocus	Movie	1993
4	Halloweentown	Movie	1998
8	Halloween	Movie	2018
5	Grease 2	Movie	1982
8	Gone with the Wind	Movie	1939
4	Freddy's Dead: The Final Nightmare	Movie	1991
5	Freddy vs. Jason	Movie	2003
8	Cloverfield	Movie	2008
7	Child's Play	Movie	1988
8	Black Widow	Movie	2021
4	Alice Through the Looking Glass	Movie	2016
4	Texas Chainsaw Massacre	Movie	2022
3	The Texas Chainsaw Massacre: The Beginning	Movie	2006
4	The Texas Chainsaw Massacre	Movie	2003
7	The Cabinet of Dr. Caligari	Movie	1920
6	Ice Age: The Meltdown	Movie	2006
7	Ice Age	Movie	2002
7	Ralph Breaks the Internet	Movie	2018
6	Hotel Transylvania 2	Movie	2015
3	Saw 3D	Movie	2010
6	The Purge: Election Year	Movie	2016
4	Saw VI	Movie	2009
6	The Purge: Anarchy	Movie	2014
4	Saw IV	Movie	2007
7	A Quiet Place Part II	Movie	2020
6	Injustice	Movie	2021
6	Mortal Kombat Legends: Battle of the Realms	Movie	2021
7	Bohemian Rhapsody	Movie	2018
6	Scream 3	Movie	2000
7	Miracle on 34th Street	Movie	1994
6	The Amazing Spider-Man 2	Movie	2014
7	The Amazing Spider-Man	Movie	2012
4	Black Christmas	Movie	2019
4	Diary of a Wimpy Kid: Dog Days	Movie	2012
4	Diary of a Wimpy Kid: Rodrick Rules	Movie	2011
6	Lethal Weapon 3	Movie	1992
7	Lethal Weapon 2	Movie	1989
6	Zombies	Movie	2018
4	X-Men Origins: Wolverine	Movie	2009
6	Watchmen	Movie	2009
6	Venom	Movie	2018
7	Tucker and Dale vs Evil	Movie	2010
3	Transformers: Age of Extinction	Movie	2014
6	Transformers	Movie	2007
7	The Wolverine	Movie	2013
4	The Twilight Saga: Breaking Dawn - Part 2	Movie	2012
7	The Texas Chain Saw Massacre	Movie	1974
4	The Santa Clause 3: The Escape Clause	Movie	2006
6	The Santa Clause	Movie	1994
7	The Sandlot	Movie	1993
6	The New Mutants	Movie	2020
6	The Matrix Reloaded	Movie	2003
7	The Karate Kid	Movie	2010
7	The Jungle Book	Movie	2016
6	The Hunger Games: Mockingjay - Part 2	Movie	2015
6	The Hunger Games: Mockingjay - Part 1	Movie	2014
7	The Hunger Games	Movie	2012
7	The Hobbit: The Desolation of Smaug	Movie	2013
7	The Hobbit: An Unexpected Journey	Movie	2012
6	The Golden Compass	Movie	2007
7	The BFG	Movie	2016
6	Terminator Salvation	Movie	2009
6	Star Wars: Episode IX - The Rise of Skywalker	Movie	2019
6	Star Trek: Insurrection	Movie	1998
6	Star Trek VI: The Undiscovered Country	Movie	1991
7	Star Trek IV: The Voyage Home	Movie	1986
7	Star Trek III: The Search for Spock	Movie	1984
6	Spider-Man 3	Movie	2007
4	Space Jam: A New Legacy	Movie	2021
6	Solo: A Star Wars Story	Movie	2018
7	Sherlock Holmes: A Game of Shadows	Movie	2011
4	Secret Society of Second Born Royals	Movie	2020
7	Scrooged	Movie	1988
6	Rocky IV	Movie	1985
7	Rocky III	Movie	1982
6	Rampage	Movie	2018
4	Rambo: Last Blood	Movie	2019
6	Rambo: First Blood Part II	Movie	1985
6	Rambo III	Movie	1988
7	Puss in Boots	Movie	2011
7	Predators	Movie	2010
6	Predator 2	Movie	1990
6	Power Rangers	Movie	2017
6	Pirates of the Caribbean: Dead Man's Chest	Movie	2006
6	Pirates of the Caribbean: At World's End	Movie	2007
6	Return to Never Land	Movie	2002
6	Pacific Rim: Uprising	Movie	2018
7	Pacific Rim	Movie	2013
6	Ocean's Eleven	Movie	2001
7	New Nightmare	Movie	1994
7	Monsters University	Movie	2013
7	Mad Max Beyond Thunderdome	Movie	1985
4	Jurassic World: Fallen Kingdom	Movie	2018
7	Jurassic World	Movie	2015
7	Jumanji: The Next Level	Movie	2019
6	It: Chapter Two	Movie	2019
7	Iron Man 2	Movie	2010
7	Hook	Movie	1991
6	Home Alone 2: Lost in New York	Movie	1992
6	Hitch	Movie	2005
7	Gremlins 2: The New Batch	Movie	1990
7	Grease	Movie	1978
7	Godzilla	Movie	2014
6	Ghostbusters II	Movie	1989
4	Ghostbusters	Movie	2016
7	Furious 7	Movie	2015
7	Frozen II	Movie	2019
3	Friday the 13th Part VIII: Jason Takes Manhattan	Movie	1989
4	Friday the 13th Part VI: Jason Lives	Movie	1986
7	Friday the 13th	Movie	1980
7	Five Feet Apart	Movie	2019
7	Fear Street: Part Three - 1666	Movie	2021
7	Fast Five	Movie	2011
7	Fast & Furious 6	Movie	2013
6	Fantastic Beasts: The Crimes of Grindelwald	Movie	2018
7	Fantastic Beasts and Where to Find Them	Movie	2016
6	F9: The Fast Saga	Movie	2021
6	Eternals	Movie	2021
7	Donnie Darko	Movie	2001
7	Die Hard 2	Movie	1990
6	Descendants	Movie	2015
7	Christopher Robin	Movie	2018
6	Charlie and the Chocolate Factory	Movie	2005
6	Cars 3	Movie	2017
7	Cars	Movie	2006
7	Captain Marvel	Movie	2019
7	Blade Runner 2049	Movie	2017
6	Blade II	Movie	2002
7	Bill & Ted Face the Music	Movie	2020
6	Batman v Superman: Dawn of Justice	Movie	2016
3	Batman & Robin	Movie	1997
6	Austin Powers: The Spy Who Shagged Me	Movie	1999
6	Austin Powers in Goldmember	Movie	2002
7	Aquaman	Movie	2018
6	Angels & Demons	Movie	2009
6	Aladdin	Movie	2019
6	Ad Astra	Movie	2019
6	A Wrinkle in Time	Movie	2018
6	A Nightmare on Elm Street 3: Dream Warriors	Movie	1987
4	A Nightmare on Elm Street	Movie	2010
6	A Christmas Carol	Movie	2009
5	Ironheart	Show	2025
9	The Bear	Show	2022
8	The Continental	Show	2023
7	Stargirl	Show	2020
5	Batwoman	Show	2019
8	The Punisher	Show	2017
7	Runaways	Show	2017
7	The Defenders	Show	2017
6	Black Lightning	Show	2018
5	Inhumans	Show	2017
7	Iron Fist	Show	2017
7	Luke Cage	Show	2016
7	DC's Legends of Tomorrow	Show	2016
8	Jessica Jones	Show	2015
7	Supergirl	Show	2015
9	Daredevil	Show	2015
8	The Flash	Show	2014
8	Agents of S.H.I.E.L.D.	Show	2013
8	Arrow	Show	2012
9	Daredevil: Born Again	Show	2025
8	Your Friendly Neighborhood Spider-Man	Show	2025
8	Skeleton Crew	Show	2024
8	Creature Commandos	Show	2024
7	Dune: Prophecy	Show	2024
9	The Penguin	Show	2024
8	Agatha All Along	Show	2024
5	The Acolyte	Show	2024
6	Knuckles	Show	2024
9	Fallout	Show	2024
8	Percy Jackson and the Olympians	Show	2023
7	Halo	Show	2022
7	Monarch: Legacy of Monsters	Show	2023
7	Echo	Show	2023
8	Gen V	Show	2023
8	Ahsoka	Show	2023
3	Velma	Show	2023
9	Arcane	Show	2021
7	Secret Invasion	Show	2023
9	Stranger Things	Show	2016
7	Star Wars: The Bad Batch	Show	2021
8	Hawkeye	Show	2021
9	The Last of Us	Show	2023
8	Wednesday	Show	2022
8	Invincible	Show	2021
8	Andor	Show	2022
9	House of the Dragon	Show	2022
7	The Lord of the Rings: The Rings of Power	Show	2022
5	She-Hulk: Attorney at Law	Show	2022
9	Squid Game	Show	2021
8	The Sandman	Show	2022
8	Ms. Marvel	Show	2022
9	WandaVision	Show	2021
9	The Mandalorian	Show	2019
8	The Falcon and the Winter Soldier	Show	2021
9	The Boys	Show	2019
9	Star Wars: The Clone Wars	Show	2008
9	Peacemaker	Show	2022
8	Moon Knight	Show	2022
9	Loki	Show	2021
9	Game of Thrones	Show	2011
8	Cobra Kai	Show	2018
7	Obi-Wan Kenobi	Show	2022
8	Star Wars: Rebels	Show	2014
7	The Book of Boba Fett	Show	2021
7	What If...?	Show	2021
6	It	Show	1990
\.


--
-- Data for Name: media_writers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media_writers (ordering, media_id, writer_id) FROM stdin;
1	372	54
1	953	1253
1	830	115
1	1052	303
1	1452	1350
1	1459	2351
2	1144	2351
3	445	571
1	986	2366
1	1318	208
2	25	2414
2	1540	651
4	1318	857
2	1125	2414
1	806	2419
3	1115	1018
2	431	1070
1	1319	1071
2	445	1142
4	1242	2430
2	1196	2430
3	1388	445
1	613	2439
1	1126	2439
1	1037	2439
2	539	223
1	1087	593
1	725	208
1	944	2439
1	1039	2439
1	279	2443
4	1115	253
2	1270	2443
1	718	2448
1	752	2448
2	1399	2448
2	1303	154
2	744	153
1	1101	2455
1	1246	152
1	1191	2462
1	1190	2462
2	646	2465
3	102	2491
1	1345	2491
1	1030	2491
1	485	2491
1	927	2491
3	471	2506
1	1571	7587
1	945	303
1	819	11
1	820	253
1	697	153
1	1324	390
3	743	3307
1	753	3310
3	431	3318
2	353	3318
1	530	3319
1	738	3319
1	526	3319
1	1151	154
1	434	3319
1	572	3319
2	687	3319
1	1357	3325
3	1090	3325
1	1058	3325
1	1253	17
1	876	3325
2	274	3327
1	1449	3377
2	935	3380
1	1024	11
2	1005	3380
1	219	3393
2	492	3393
1	1420	3413
1	259	3416
1	195	3447
1	374	3447
1	1541	3449
2	1180	3456
1	836	3469
1	189	3469
1	621	2506
1	194	54
1	455	303
1	1572	6043
2	1022	86
2	1572	7594
3	1572	5922
1	414	156
2	337	651
3	1541	988
1	1031	879
1	861	223
2	1403	904
1	977	1018
1	264	1025
1	850	1062
1	1557	45
1	535	397
1	815	153
3	1403	56
1	216	52
2	1311	223
1	10	124
1	222	52
1	867	156
4	1218	2545
3	1219	2545
2	264	2551
2	1300	2551
3	219	2551
2	977	253
2	1567	2552
1	33	2557
2	894	2572
1	78	2584
3	77	2584
1	1303	2589
1	393	156
1	1311	2589
1	607	3768
1	1573	5835
1	647	1350
2	971	651
1	1159	303
2	147	538
1	1417	524
1	383	303
1	149	156
1	1542	988
1	525	879
1	1300	1025
1	353	1070
2	6	1241
2	716	223
2	969	398
3	253	1238
1	1558	173
2	1558	233
1	1564	1086
1	352	397
1	745	153
1	1366	11
1	217	52
1	1083	113
1	1376	323
1	1424	465
1	949	397
1	951	124
1	9	124
1	669	52
1	764	1471
1	53	62
5	263	2401
1	1574	7601
1	43	303
2	1543	988
1	555	476
1	920	527
1	1	476
1	757	1079
2	96	723
1	1344	758
1	1467	156
1	367	39
2	367	398
1	1113	879
2	283	896
2	261	936
1	86	1062
1	1026	476
1	261	1226
1	263	1238
1	1353	11
2	1023	538
1	476	156
1	65	153
2	65	52
1	483	153
1	159	153
1	75	397
1	857	113
1	853	3593
1	486	3593
6	1230	3597
1	1386	3599
1	1411	4035
1	24	4040
2	266	4045
2	291	4045
2	965	4045
2	1354	4045
1	881	45
3	685	4053
1	1247	4092
1	465	4095
2	496	4096
3	1158	4101
1	347	4136
3	400	4149
1	564	52
1	147	5562
1	665	1609
1	182	385
1	458	589
2	458	588
1	355	589
1	474	152
2	355	588
1	491	303
1	38	39
2	38	398
1	64	153
1	164	879
2	317	936
1	410	11
1	160	153
1	510	208
2	704	113
1	858	113
1	882	45
1	522	52
1	1139	54
2	262	4691
3	615	4702
1	1405	4791
1	269	4804
2	441	1486
1	940	1982
1	1225	1983
2	940	1731
2	946	5477
3	946	5478
2	943	5478
3	942	5478
1	604	418
2	1533	651
3	1239	738
1	473	154
1	855	879
1	1001	1018
3	569	1071
2	17	1177
2	694	153
1	1472	156
2	859	593
1	68	153
1	559	616
1	1567	694
4	1567	868
1	703	113
1	856	113
2	1001	253
1	880	45
1	568	52
1	755	476
1	877	170
1	801	11
2	66	153
2	369	253
1	369	1018
1	69	153
1	1510	1944
1	1503	5486
1	1519	5513
2	242	5571
2	173	5571
2	243	5571
2	241	5571
3	187	5571
2	1439	5571
2	223	5571
2	224	5571
3	1045	5571
2	311	5572
3	311	5573
1	1112	5574
2	1112	5575
3	1112	5576
1	964	5577
1	544	5577
2	752	5578
3	752	5579
2	718	5579
1	1399	5579
4	752	5580
2	1090	5581
1	1276	5582
3	679	5582
1	351	5583
1	805	5584
1	799	5585
1	798	5585
1	1085	5586
1	1305	52
4	1464	737
2	1150	933
2	1207	990
2	148	651
2	1464	33
3	1534	1505
1	1517	5544
2	1162	5554
2	5	5610
1	712	5611
2	712	5612
3	56	5612
3	1021	5612
1	608	5612
1	611	5612
3	712	5613
4	712	5614
1	1403	5615
2	524	5616
1	1107	5617
1	714	5618
1	859	5618
1	832	5618
4	161	5618
1	1009	5618
1	851	5619
4	1127	5619
1	767	5619
2	851	5620
5	1127	5620
2	767	5620
3	767	5621
1	244	5621
4	767	5622
1	211	5623
1	212	5624
2	525	5625
7	1158	1351
1	412	1084
2	1534	651
1	358	1084
2	863	1088
1	1110	253
2	599	5648
2	600	5648
2	602	5648
2	875	5648
2	1231	5648
1	1505	1352
2	125	651
1	952	476
1	868	1305
1	1064	1071
1	1298	1078
2	51	1088
1	114	303
1	760	376
1	421	538
1	869	1305
1	1065	1071
1	427	1088
1	982	1350
1	1015	156
1	749	303
1	1010	1305
3	359	153
2	457	883
1	312	1071
1	1163	3964
1	1090	3968
1	1077	3981
1	417	3981
4	1158	3988
1	1054	4033
1	289	4035
1	290	4035
1	1482	5255
2	1482	5256
1	254	5260
2	254	5261
4	513	5263
5	1038	5269
3	999	5269
3	1392	5269
6	1196	5269
2	910	5269
3	16	5271
4	1292	5278
2	1127	5278
2	1444	5281
1	1453	1350
1	1454	1350
1	1455	1350
1	1451	1350
1	538	45
1	1456	1350
1	1057	1352
1	397	208
3	1013	1379
1	707	1379
1	1095	1379
2	37	1452
2	280	1452
1	720	1456
1	146	1456
2	545	1456
1	784	616
1	870	1305
1	649	593
1	750	1045
3	625	738
1	1348	1071
1	1206	1071
4	1068	1078
2	618	1078
1	582	1084
1	573	1084
1	575	1084
2	572	1084
1	679	1084
1	691	1084
1	1277	1088
2	426	1088
1	480	1093
1	1249	1166
1	317	1226
1	939	1253
1	995	1283
2	622	1283
2	484	1305
2	1042	1315
1	708	1315
2	80	1315
2	705	1315
3	1062	1315
1	163	1323
1	478	1456
2	1076	1456
1	1082	1465
1	327	1465
1	1395	1477
1	1483	1477
1	509	1477
1	889	1505
1	302	5281
1	1358	5284
1	305	5284
2	1358	5285
2	305	5285
3	67	5288
1	230	5291
1	588	5292
3	433	5294
1	1053	5294
3	1238	5295
3	313	5295
1	1093	5295
1	207	62
1	629	1443
4	626	738
1	1180	1091
1	710	3469
1	541	3469
2	1166	3469
1	1204	3486
3	209	3486
1	119	3486
1	1271	3504
1	1272	3504
1	1003	3527
1	1132	3536
1	829	3536
1	650	3540
1	1044	3540
1	1245	3548
1	923	3548
1	924	3548
4	49	3554
2	50	3554
2	780	3554
1	201	3562
1	699	3562
2	487	3563
2	142	3571
2	681	3571
3	797	3571
2	351	3577
1	594	3577
1	1359	3577
2	623	5531
1	388	5531
2	127	5532
1	623	5532
1	1507	5532
3	127	5533
2	683	5533
1	128	5534
2	128	5535
3	128	5536
3	683	5537
4	683	5538
3	623	5538
1	155	5539
2	388	5539
1	1251	5539
1	389	5540
2	1033	5541
1	311	5541
1	1017	5541
1	1118	5541
2	832	5541
1	1115	5542
2	1115	5543
1	494	5544
1	112	5544
5	1115	5544
1	796	5544
1	1096	398
1	1473	33
3	84	738
3	627	738
1	680	1018
2	276	1071
1	540	616
4	895	329
1	955	1354
3	85	738
2	172	1323
1	1086	1062
1	768	510
1	1316	1307
1	1011	1323
3	1016	738
1	328	156
1	748	303
1	1051	303
1	3	62
3	3	616
2	742	144
1	370	593
2	898	153
1	171	588
2	171	589
1	174	253
2	976	651
2	944	2592
2	1039	2592
2	1126	2592
2	1037	2592
1	852	2593
1	481	2593
1	1210	2602
1	1426	2610
1	1393	2610
1	1390	2610
1	515	2610
1	1466	2610
1	1428	2610
1	1270	2621
2	279	2621
1	973	2661
1	804	2661
1	213	2661
1	1355	2661
1	1106	2661
1	769	2663
1	1067	2690
2	617	2690
1	438	2690
2	1066	2690
1	1176	2690
1	390	2690
2	1470	2690
1	1469	2690
2	533	2690
1	1186	2702
3	886	2722
1	1408	2722
2	521	5986
1	169	5987
2	169	5988
1	1400	5989
1	677	6251
1	1089	6252
2	1092	6252
1	926	6253
1	356	6254
1	30	6254
1	814	6255
1	357	6255
3	30	6256
1	928	6257
1	929	6257
1	1240	6258
1	935	6259
1	1005	6259
3	935	6260
1	1070	6261
2	1070	6262
1	936	6262
2	338	2743
1	809	2752
1	931	2769
2	686	2779
2	287	2779
1	885	2785
2	18	2792
2	1551	6263
2	679	2792
1	864	2792
1	406	2799
2	1334	2799
2	621	2816
2	471	2816
2	1269	2860
1	527	2860
2	607	2865
2	1297	2865
3	1567	2900
3	1292	2907
1	1127	2907
1	777	2914
1	1436	2921
2	613	2922
1	1536	651
1	92	3942
3	503	3947
1	1162	3964
2	1268	3964
1	1161	3964
1	329	5303
2	1391	5305
1	105	5311
1	1346	5311
1	468	5316
3	629	5316
2	732	5346
1	728	5378
1	661	5378
1	660	5378
1	659	5378
1	97	5378
1	1500	5469
1	1218	5469
2	1500	5470
3	1500	5471
2	1389	5473
1	1184	5473
1	205	5474
2	205	5475
1	946	5476
1	1029	5496
3	399	5497
2	1029	5497
1	576	5497
2	1433	5497
1	1438	5497
4	399	5498
3	1029	5498
2	576	5498
3	1433	5498
2	1438	5498
1	580	5499
1	729	5500
1	730	5500
1	731	5500
2	731	5501
3	731	5502
1	1537	651
2	826	29
1	251	3201
2	1538	651
1	1130	3219
2	667	3221
1	1098	3239
1	1097	3239
2	1193	3242
2	1194	3242
4	592	3242
1	1195	3242
2	325	3242
2	350	3255
1	257	3255
2	722	3264
2	408	3264
2	581	3264
2	91	3264
2	551	3264
3	667	3264
2	1514	3264
1	722	3265
1	1020	3265
1	408	3265
1	581	3265
1	91	3265
1	551	3265
1	667	3265
1	1514	3265
1	375	3274
2	995	3298
1	622	3298
2	1247	3306
1	83	3306
2	743	3306
1	484	3306
2	755	3306
1	825	3306
1	452	3577
1	487	3593
1	1059	3593
1	1330	3593
1	1331	3593
1	267	3593
1	1141	3593
1	1056	3593
1	1465	3593
1	1553	3602
1	137	3602
2	530	3602
2	733	3602
3	513	3614
2	1507	3621
3	851	3621
3	1222	3621
4	1214	3629
1	1457	3650
2	1093	3690
1	1033	3690
1	1032	3690
1	591	3690
1	961	3690
3	162	3690
2	1539	398
1	998	5684
2	1167	5685
2	999	5685
2	1392	5685
2	998	5685
1	1294	5686
3	86	5687
2	1294	5687
3	711	5687
1	590	5688
1	103	5688
3	189	5688
3	918	5688
2	189	5689
2	710	5689
2	105	5690
1	631	5690
1	592	5691
1	186	5691
2	592	5692
2	186	5692
1	1193	5693
1	1194	5693
3	592	5693
1	1313	5693
1	325	5693
1	12	5694
1	687	5694
1	734	5694
1	80	5694
2	1527	5695
1	106	5695
1	593	5695
1	605	5695
3	1527	5696
2	106	5696
2	593	5696
2	605	5696
2	582	5697
3	175	5698
1	1267	5698
1	1269	5698
1	98	5698
1	978	5698
1	319	5699
4	946	5479
3	943	5479
4	942	5479
1	1374	5480
1	1049	5481
1	818	5482
2	818	5483
2	819	5484
2	1110	5485
2	820	5485
2	1175	5486
2	1170	5486
2	1171	5486
2	1254	5486
3	1170	5487
2	252	5488
2	253	5488
3	263	5488
2	1352	5488
2	1122	5488
1	1048	5488
2	1034	5488
2	598	5488
1	252	5489
1	253	5489
2	263	5489
1	1122	5489
2	1048	5489
1	1034	5489
1	598	5489
1	1352	5489
1	1501	5491
2	1501	5492
3	1288	5495
2	813	5495
2	1449	5503
3	1449	5504
4	1449	5505
1	1450	5506
1	878	5507
1	54	5508
3	1010	5509
1	461	5509
1	460	5510
2	460	5511
2	850	5512
1	723	5513
1	1243	5514
1	1421	5515
2	1421	5516
2	463	5517
1	646	5517
3	463	5518
4	597	5519
1	192	5519
2	188	5519
1	1183	5519
1	1342	5519
1	8	5519
1	274	5520
2	1132	5521
1	1325	5522
1	324	5523
1	993	5524
2	324	5524
1	996	5525
1	493	5525
1	842	5525
1	495	5525
1	624	5526
2	203	5527
1	287	5527
3	686	5528
3	287	5528
1	1281	5529
2	1197	5529
3	226	5530
1	715	5530
1	11	5530
2	175	5530
2	7	5530
2	1281	5530
1	127	5531
1	683	5531
1	925	5544
1	912	5544
1	913	5544
1	684	5545
2	73	5545
2	614	5545
1	704	5545
1	705	5545
2	392	5546
2	1083	5546
2	1427	5546
3	1136	5547
1	391	5547
1	107	5547
1	108	5547
2	1348	5548
1	1068	5548
2	1068	5549
3	1348	5549
1	644	5550
1	688	5550
1	846	5550
1	641	5550
1	118	5550
1	1326	5551
2	685	5551
1	717	5551
2	1326	5552
1	681	5553
1	1332	5553
1	321	5553
3	1268	5554
2	1163	5554
2	1161	5554
1	617	5555
1	533	5555
1	1470	5555
1	1066	5555
1	1137	5556
1	941	5557
1	772	5558
1	545	5559
1	399	5560
2	399	5561
2	966	5562
1	1328	5562
1	785	5563
1	956	5563
1	400	5564
2	400	5565
1	445	5566
1	1069	5567
1	82	5568
1	831	5568
1	524	5569
1	553	5569
2	250	5569
1	790	5569
3	172	5570
2	1011	5570
1	242	5570
1	173	5570
1	243	5570
1	241	5570
2	187	5570
1	1439	5570
1	223	5570
1	224	5570
2	1045	5570
4	172	5571
3	1011	5571
1	1188	5587
1	1189	5587
2	815	5587
1	1187	5587
1	1207	5587
3	1438	5587
1	686	5588
1	1317	5588
1	1264	5589
1	1262	5589
1	1263	5589
1	746	5590
1	293	5590
2	293	5591
2	282	5591
1	282	5592
3	282	5593
1	1012	5594
4	282	5594
1	1474	5595
2	24	5596
3	24	5597
4	24	5598
1	442	5599
2	352	5600
1	176	5601
1	1173	5602
1	496	5603
3	1126	5603
1	744	5603
3	598	5603
3	732	5603
2	983	5603
1	1522	5604
2	745	5604
1	1516	5604
2	1522	5605
3	745	5605
2	1516	5605
2	1366	5606
1	1329	5607
1	1545	5608
2	494	5608
2	925	5608
2	1329	5608
1	1468	5609
1	304	5626
1	1213	5627
1	58	5628
1	157	5628
1	698	5628
3	213	5628
1	158	5628
1	59	5628
1	1506	5628
2	158	5629
2	59	5629
2	58	5629
2	157	5629
2	698	5629
4	213	5629
1	313	5629
2	1506	5629
1	250	5630
3	1315	5630
1	19	5630
1	6	5630
1	1135	5631
1	1446	5631
1	229	5632
1	134	5632
1	663	5632
3	549	5632
1	152	5632
1	847	5632
2	570	5633
1	215	5633
1	596	5634
2	596	5635
1	1286	5636
3	596	5636
1	298	5637
1	387	5638
1	791	5638
1	700	5638
1	193	5638
2	903	5638
2	193	5639
1	504	5640
1	170	5640
2	217	5640
1	334	5641
2	334	5642
3	334	5643
1	1369	5644
1	1368	5644
2	1368	5645
3	1368	5646
1	599	5647
1	600	5647
1	602	5647
1	875	5647
1	1231	5647
1	1153	5647
1	1154	5647
2	1369	5647
1	1370	5647
4	1222	5647
2	1153	5648
2	1154	5648
3	1369	5648
2	1370	5648
5	1222	5648
5	294	5649
1	1371	5649
1	610	5649
1	792	5650
1	161	5650
2	1371	5650
4	67	5650
1	1378	5651
3	75	5652
1	511	5652
2	112	5652
1	377	5653
3	112	5653
2	677	5653
1	382	5653
1	840	5653
1	381	5653
1	378	5653
1	379	5653
1	841	5653
1	884	5654
1	1000	5654
2	577	5654
1	99	5654
2	113	5654
2	1062	5654
4	407	5655
2	48	5655
1	102	5655
3	113	5655
1	1223	5656
1	1419	5657
1	1203	5658
1	1287	5658
1	1278	5659
1	1179	5659
1	1410	5660
1	131	5661
1	1333	5661
2	219	5662
1	512	5663
1	220	5663
3	1352	5663
2	1038	5663
1	407	5663
1	514	5663
5	513	5663
4	1352	5664
3	1038	5664
2	407	5664
2	514	5664
6	513	5664
2	512	5664
2	220	5664
2	322	5665
4	220	5665
3	322	5666
5	220	5666
1	900	5667
1	743	5668
2	1424	5669
2	1415	5670
1	1288	5670
2	8	5670
2	75	5671
2	949	5671
2	404	5672
3	1175	5672
3	1254	5672
2	433	5672
1	1071	5672
1	1562	5673
1	233	5673
1	320	5673
2	2	5673
1	542	5673
1	950	5674
2	950	5675
1	1397	5676
1	221	5676
1	942	5677
1	1178	5677
1	943	5677
1	323	5677
1	1412	5678
2	1119	5678
2	10	5678
2	9	5678
1	1418	5678
2	1267	5679
1	49	5679
2	669	5679
1	1266	5679
1	692	5679
3	1267	5680
2	692	5680
2	49	5680
3	669	5680
2	1266	5680
1	277	5681
1	915	5682
3	407	5683
3	48	5683
2	102	5683
1	249	5683
1	1167	5684
1	999	5684
1	1392	5684
1	469	5700
2	469	5701
2	103	5702
1	256	5703
1	584	5703
1	907	5703
1	1215	5704
1	585	5704
1	1074	5705
1	866	5706
2	866	5707
3	866	5708
1	586	5709
1	503	5709
1	444	5709
2	586	5710
2	503	5710
2	444	5710
1	1367	5711
1	960	5712
2	1367	5712
1	808	5713
1	1145	5714
1	587	5715
1	1335	5716
2	1244	5717
1	1025	5718
3	958	5719
2	1026	5719
1	566	5720
2	566	5721
3	566	5722
1	773	5723
2	1465	5724
1	1129	5725
2	846	5726
1	645	5726
1	733	5727
3	733	5728
2	991	5728
3	1000	5728
1	1076	5728
1	1228	5729
1	1125	5729
1	188	5729
2	4	5730
1	440	5731
1	55	5731
2	56	5732
1	780	5732
4	56	5733
1	534	5734
1	1471	5734
1	537	5734
2	537	5735
2	534	5735
2	1471	5735
2	1395	5736
1	1022	5737
1	724	5738
1	802	5738
2	1523	5739
2	920	5739
3	920	5740
1	1211	5740
1	902	5741
1	467	5741
1	1221	5742
2	1221	5743
3	1221	5744
1	693	5745
1	1563	5746
1	1404	5746
1	275	5747
1	922	5748
2	923	5749
2	924	5749
2	988	5750
4	629	5750
1	380	5750
1	283	5751
1	471	5752
3	621	5752
4	621	5753
5	621	5754
6	621	5755
1	472	5756
2	989	5756
7	621	5756
1	156	5761
1	1447	5761
1	181	5761
1	1540	5762
1	1533	5762
2	439	5762
1	1534	5762
1	337	5762
1	971	5762
1	911	5762
1	976	5762
3	1538	5762
2	911	5763
1	1261	5764
2	816	5764
2	1261	5765
1	1551	5766
1	1552	5766
2	555	5766
1	1265	5766
2	1265	5767
1	168	5767
3	1265	5768
2	168	5768
1	990	5769
2	990	5770
3	454	5771
1	883	5771
3	990	5771
1	909	5772
3	49	5773
1	50	5773
4	851	5773
3	151	5773
1	1205	5774
2	474	5775
3	474	5776
1	1289	5777
2	960	5777
1	695	5778
1	60	5778
1	620	5779
1	61	5779
2	61	5780
2	620	5780
1	62	5781
1	71	5781
2	62	5782
2	1071	5782
1	1121	5783
1	1463	5784
3	804	5785
3	1355	5785
1	1391	5785
1	556	5786
1	786	5786
1	1072	5787
1	1073	5788
2	992	5789
1	1291	5789
2	725	5790
3	510	5790
1	991	5791
1	350	5791
2	257	5791
1	1116	5791
1	475	5792
2	741	5793
2	1089	5793
1	1413	5793
1	1433	5794
4	1196	5795
1	63	5795
2	179	5796
2	904	5796
2	209	5798
1	1515	5798
1	209	5799
2	1515	5799
1	477	5800
2	477	5801
2	1530	5802
2	126	5802
3	1124	5803
2	64	5803
1	694	5804
1	66	5805
1	67	5806
2	67	5807
1	1296	5807
1	479	5808
1	812	5808
2	479	5809
2	1118	5810
1	1307	5811
1	654	5812
1	678	5812
1	29	5812
1	966	5812
2	934	5812
1	295	5812
1	28	5812
1	36	5812
1	1014	5812
1	737	5813
1	696	5814
2	696	5815
1	633	5815
1	1209	5816
1	1050	5817
1	992	5818
3	992	5819
4	992	5820
1	57	5821
2	480	5822
1	1520	5823
1	115	5823
1	577	5823
1	100	5823
1	569	5823
1	578	5823
1	557	5823
1	676	5823
1	1234	5824
2	1234	5825
1	1237	5826
2	1237	5827
1	571	5828
2	1211	5828
1	619	5828
3	1211	5829
2	619	5829
2	852	5830
1	726	5831
2	726	5832
3	726	5833
1	482	5834
1	595	5834
1	1385	5835
3	261	5835
3	317	5835
2	1385	5836
3	1385	5837
1	1208	5838
1	1292	5839
2	1292	5840
2	485	5841
1	933	5842
1	938	5843
2	93	5844
1	1164	5845
1	396	5846
1	994	5846
2	519	5846
2	709	5846
1	94	5847
1	651	5847
2	94	5848
2	651	5848
1	184	5849
3	254	5849
1	558	5850
2	184	5850
1	1019	5850
1	145	5850
1	199	5850
1	200	5850
1	673	5850
2	1357	5851
3	184	5851
2	558	5851
2	1019	5851
2	145	5851
2	199	5851
2	200	5851
2	673	5851
4	184	5852
1	95	5852
5	184	5853
2	95	5853
1	122	5854
1	124	5854
1	120	5854
1	488	5854
2	122	5855
2	124	5855
2	120	5855
2	488	5855
1	448	5856
1	775	5856
2	874	5856
2	448	5857
2	775	5857
1	874	5857
3	995	5858
4	995	5859
5	995	5860
6	995	5861
3	622	5862
4	622	5863
5	622	5864
6	622	5865
7	622	5866
4	1541	5867
2	1542	5867
1	1543	5867
1	336	5867
2	302	5867
1	1569	5868
1	489	5868
1	280	5869
1	153	5869
1	1099	5869
2	161	5870
3	161	5871
2	918	5872
1	492	5873
1	70	5874
2	70	5875
1	198	5876
3	558	5876
1	980	5876
3	145	5876
2	71	5877
1	1216	5878
1	508	5879
1	795	5879
2	1253	5880
3	1253	5881
3	496	5882
1	499	5883
1	500	5883
1	497	5883
1	498	5883
1	501	5884
1	548	5884
1	502	5885
1	934	5885
1	162	5886
2	162	5887
1	72	5888
2	72	5889
2	1024	5890
1	890	5891
1	891	5891
3	698	5892
2	163	5892
4	698	5893
1	1528	5894
3	163	5894
1	1529	5894
2	1528	5895
4	163	5895
2	1529	5895
4	503	5896
1	997	5897
1	1134	5898
2	997	5898
2	1379	5898
3	875	5898
1	560	5899
1	1165	5900
2	398	5901
1	506	5902
2	782	5902
3	1116	5902
1	430	5903
2	430	5904
3	430	5905
1	180	5906
1	1224	5906
2	665	5907
1	1123	5907
1	1444	5907
2	1123	5908
3	1123	5909
3	1007	5910
1	1443	5910
1	963	5910
3	1443	5911
2	509	5915
1	1570	5916
2	1569	5916
1	562	5916
1	73	5917
1	635	5918
1	1322	5919
2	1322	5920
1	439	5921
3	1322	5921
2	615	5922
2	425	5922
1	185	5923
3	651	5924
1	1363	5924
4	651	5925
2	1363	5925
1	74	5926
1	898	5926
2	74	5927
3	74	5928
1	1043	5928
4	74	5929
5	74	5930
6	74	5931
3	220	2929
4	219	2929
4	3	2938
1	1045	2941
1	871	2941
1	1046	2941
2	454	2964
1	265	2964
1	1416	2964
2	385	2964
1	532	2964
1	463	2976
3	52	2976
1	451	2997
1	763	3002
1	765	3003
1	794	3003
2	1186	3017
1	296	3037
1	987	3037
1	315	3037
2	304	3037
1	662	3037
1	1301	3037
1	561	3037
1	348	3037
1	258	3037
1	1340	3037
1	914	3037
1	1280	3037
1	543	3037
2	221	3058
1	1175	3065
1	1170	3065
1	1171	3065
1	433	3065
1	1254	3065
1	518	3065
1	919	3068
1	918	3068
1	916	3068
1	917	3068
3	361	3093
2	769	3138
3	1146	3150
2	759	3151
3	760	3151
1	1119	3152
3	384	3152
1	45	3171
1	1150	3171
1	1282	3201
1	260	3201
1	837	3201
1	616	3201
2	55	3201
3	1026	3201
4	84	3201
4	85	3201
4	1016	3201
1	937	3690
1	1199	3690
1	779	3695
2	580	3696
1	670	3700
1	16	3701
1	401	3716
1	339	3718
8	621	3727
1	778	3755
1	811	3755
1	303	3755
2	794	3755
1	365	3755
1	1297	3768
1	262	3771
1	1337	3771
1	1284	3771
3	597	3772
1	1227	3782
3	580	3785
2	319	3788
4	1391	3817
1	1079	3823
2	589	3835
1	1244	3835
1	4	3835
1	362	3835
1	35	3835
1	589	3836
2	594	3836
1	126	3836
1	1425	3861
1	1389	3861
2	1184	3861
1	1379	3865
1	1375	3928
1	266	3929
1	291	3929
1	965	3929
1	1354	3929
1	1321	3939
1	190	4149
1	47	4149
1	218	4149
1	1120	4149
1	554	4149
3	1093	4158
1	464	4222
2	1359	4249
4	1038	4286
5	1196	4286
1	910	4286
1	111	4307
2	272	4342
1	1423	4342
1	271	4342
1	1360	4342
2	800	4343
3	205	4348
1	1323	4348
1	1226	4348
2	1288	4352
1	813	4352
1	1521	4384
1	236	4384
1	823	4384
1	897	4384
1	800	4396
1	1299	4460
1	1309	4502
2	356	4522
2	357	4522
2	30	4522
1	1532	4539
1	1078	4539
1	1314	4539
3	778	4627
1	1152	4627
1	1036	4666
1	1140	4804
3	1127	4828
2	1036	4828
2	579	4908
1	1435	5133
1	1460	5133
1	1440	5136
1	1441	5140
3	1464	5210
1	314	5211
5	1464	5211
1	1464	5212
6	1464	5213
1	1478	5240
1	747	5240
1	1479	5243
2	98	5243
1	618	5243
2	1479	5244
1	1546	5245
1	1302	5245
1	1480	5245
1	1548	5246
1	721	5246
2	409	5246
1	1114	5246
1	843	5246
2	1480	5246
3	1068	5246
1	7	5246
1	854	5246
1	1060	5246
1	276	5246
1	1481	5247
2	1481	5248
2	510	5932
1	345	5933
1	292	5933
1	270	5934
4	1230	5935
5	1230	5936
1	1088	5937
2	1088	5938
1	901	5939
1	210	5939
3	350	5939
3	210	5940
1	702	5941
1	165	5942
1	76	5943
4	77	5943
1	77	5944
2	77	5945
1	166	5946
2	78	5947
2	516	5948
1	701	5948
1	516	5949
2	701	5949
1	79	5950
2	885	5951
2	336	5952
3	336	5953
4	336	5954
5	336	5955
1	652	5956
2	652	5957
3	652	5958
1	614	5959
2	857	5960
2	180	5961
3	705	5961
1	574	5961
2	1279	5961
1	1308	5962
2	1272	5963
2	518	5964
2	639	5965
1	642	5965
1	228	5965
1	343	5966
2	343	5967
2	13	5968
3	343	5968
1	429	5968
2	1315	5968
2	232	5968
2	822	5968
1	1081	5969
1	981	5969
1	632	5970
1	1273	5970
1	539	5971
2	861	5971
1	716	5971
1	519	5971
1	709	5971
2	396	5972
3	519	5972
3	709	5972
4	519	5973
1	653	5974
2	653	5975
3	653	5976
4	294	5976
4	653	5977
3	294	5977
1	1523	5978
2	538	5978
1	547	5978
1	1018	5978
1	1402	5978
2	881	5978
2	882	5978
2	880	5978
2	108	5978
1	17	5979
1	967	5979
1	520	5979
2	1191	5980
2	1190	5980
3	1191	5981
3	1190	5981
1	196	5982
2	196	5983
3	196	5984
1	521	5985
1	1006	5989
2	1006	5990
1	1063	5991
1	1007	5991
1	1008	5991
2	1007	5992
2	1008	5992
2	1063	5992
2	564	5993
2	522	5994
1	81	5995
1	523	5995
1	310	5995
2	81	5996
2	523	5996
2	310	5996
2	170	5997
2	711	5998
1	96	5999
1	132	6000
1	133	6001
1	1356	6002
1	1336	6003
1	1092	6004
3	186	6004
3	567	6005
1	187	6005
2	1546	6006
1	835	6006
1	567	6006
1	1476	6006
1	322	6006
1	135	6006
2	567	6007
2	636	6008
2	1476	6009
1	1027	6010
1	1461	6011
1	368	6011
1	1047	6012
2	1047	6013
1	565	6014
1	294	6015
1	735	6015
2	294	6016
2	735	6016
1	1091	6017
2	1091	6018
2	569	6019
1	570	6020
3	570	6021
1	1274	6022
1	1275	6022
3	572	6022
2	1274	6023
2	1275	6023
4	572	6023
2	573	6024
1	454	6024
3	573	6025
4	573	6026
2	575	6027
3	576	6028
1	1351	6028
2	1100	6029
2	1053	6029
3	862	6029
2	1128	6029
1	1100	6030
3	1053	6030
2	862	6030
1	1128	6030
4	1053	6031
5	1053	6032
1	1040	6033
1	1222	6034
2	110	6034
3	1154	6034
1	110	6035
4	1154	6035
2	1222	6035
5	1154	6036
1	1236	6036
1	1004	6037
2	1004	6038
1	204	6039
1	1219	6039
1	1384	6039
3	1150	6039
1	1258	6040
2	101	6041
3	1379	6042
1	579	6043
1	409	6044
1	1028	6044
2	1028	6045
1	318	6046
1	886	6056
1	148	6056
1	1535	6056
2	1169	6057
3	1177	6057
5	942	6058
3	1169	6058
2	1177	6058
2	549	6058
4	1169	6059
3	1207	6060
5	1529	6063
1	1177	6063
4	1508	6063
2	879	6064
1	331	6065
2	331	6066
1	630	6067
1	402	6068
2	402	6069
1	446	6069
2	395	6069
2	446	6070
1	395	6071
1	628	6072
1	447	6073
1	1252	6074
1	1143	6074
1	845	6074
1	449	6075
1	908	6076
1	450	6076
1	403	6076
1	404	6076
3	404	6077
4	404	6078
2	406	6079
1	1334	6079
2	1108	6080
3	1108	6081
1	89	6082
1	1111	6083
1	1117	6083
2	629	6083
3	618	6083
1	1398	6083
1	872	6083
2	15	6083
2	1398	6084
1	1362	6084
3	1398	6085
2	1362	6085
1	637	6087
1	634	6087
1	1201	6087
1	639	6088
1	90	6089
1	415	6091
2	1195	6092
1	1155	6093
2	1155	6094
3	1155	6095
1	1239	6096
1	625	6096
1	626	6096
1	627	6096
1	84	6096
1	85	6096
1	1016	6096
2	1239	6097
2	625	6097
2	626	6097
2	627	6097
2	84	6097
2	85	6097
2	1016	6097
1	151	6098
2	870	6098
1	39	6099
2	835	6099
2	151	6099
2	1179	6100
1	1259	6100
2	1043	6100
2	150	6101
2	809	6102
3	809	6103
1	1166	6104
2	836	6105
3	1166	6105
1	689	6106
1	968	6107
2	689	6107
1	420	6108
2	420	6109
1	419	6110
1	862	6110
3	1128	6110
1	816	6111
1	1038	6112
1	793	6112
3	1196	6113
2	363	6114
1	948	6114
1	203	6114
3	903	6115
1	301	6115
2	301	6116
3	301	6117
4	301	6118
1	422	6119
1	1257	6120
2	1257	6121
2	1417	6122
2	1360	6123
2	942	6124
5	973	6124
1	549	6124
4	955	6124
1	671	6125
1	1445	6126
1	284	6127
2	284	6128
3	626	6129
1	1434	6130
2	1434	6131
3	1434	6132
4	1434	6133
1	1136	6134
2	1136	6135
2	1299	6136
1	424	6137
2	424	6138
1	425	6139
3	1147	6140
1	899	6140
1	426	6141
1	863	6142
1	51	6142
3	863	6143
2	427	6144
2	1277	6145
3	427	6145
2	1218	6146
2	1077	6147
2	1057	6147
2	1220	6147
1	787	6148
1	1214	6148
2	787	6149
2	1214	6149
3	1214	6150
1	308	6151
1	979	6151
1	887	6151
2	411	6152
2	152	6152
1	411	6153
3	152	6153
1	930	6154
1	1312	6155
2	753	6156
2	1152	6157
3	1152	6158
1	428	6159
2	428	6160
1	354	6161
1	1255	6161
1	888	6162
2	888	6163
2	1020	6164
3	1020	6165
1	1021	6166
1	664	6166
2	1021	6167
1	1158	6168
2	1158	6169
5	1158	6170
6	1158	6171
1	1364	6172
2	1364	6173
1	603	6174
2	603	6175
1	1422	6176
1	299	6177
1	1513	6177
2	299	6178
2	1513	6178
3	299	6179
1	1442	6180
2	1442	6181
2	1060	6182
1	1061	6182
1	1477	6182
2	312	6183
1	206	6184
1	766	6185
2	766	6186
3	250	6187
3	766	6187
2	691	6188
1	52	6188
3	231	6188
1	1349	6189
2	52	6189
2	231	6189
3	1110	6190
1	297	6191
1	154	6192
1	335	6193
2	335	6194
1	983	6195
1	1109	6196
1	117	6196
1	817	6196
1	873	6196
1	1381	6197
2	1547	6198
2	610	6198
4	454	6199
5	454	6200
3	692	6201
4	692	6202
1	771	6203
3	276	6205
1	762	6206
3	759	6206
1	758	6206
1	552	6206
1	761	6206
2	758	6207
1	759	6208
2	760	6208
2	761	6209
1	44	6210
3	761	6210
1	238	6210
2	762	6211
3	762	6212
1	1526	6213
1	1394	6213
2	763	6213
2	764	6213
2	347	6214
1	1200	6215
1	1475	6216
2	144	6216
1	1347	6217
1	1380	6217
2	1181	6218
2	1096	6219
3	1539	6219
3	1096	6220
2	1052	6221
1	848	6222
2	848	6223
1	456	6223
3	848	6224
2	456	6224
2	182	6225
1	656	6226
2	92	6227
1	657	6228
1	984	6229
1	849	6229
2	984	6230
2	849	6230
1	985	6231
2	985	6232
1	457	6233
1	208	6234
2	3	6235
1	431	6236
1	1293	6237
1	432	6237
1	2	6238
2	1349	6239
1	272	6240
1	459	6241
1	892	6242
1	1147	6243
2	1147	6244
1	658	6245
2	1174	6246
1	1013	6247
2	1013	6248
1	25	6249
2	354	6250
1	26	6251
1	27	6251
1	1197	6263
2	358	6264
1	1304	6265
1	1341	6265
1	359	6266
2	359	6267
1	191	6268
1	31	6268
2	191	6269
2	31	6269
2	1146	6270
1	1146	6271
1	234	6272
1	240	6272
1	1055	6272
1	1241	6273
1	349	6274
1	360	6274
2	360	6275
1	1144	6276
1	139	6277
1	32	6278
1	1103	6279
1	1104	6280
1	361	6280
2	1104	6281
1	1105	6282
2	361	6283
1	341	6284
2	341	6285
1	138	6286
1	306	6286
2	138	6287
2	306	6287
2	801	6288
3	801	6289
1	273	6290
2	273	6291
3	273	6292
1	363	6293
1	833	6294
2	680	6295
1	1041	6296
1	1235	6296
1	443	6297
2	443	6298
1	1133	6299
1	37	6299
2	1298	6300
3	1298	6301
1	606	6302
2	606	6303
1	903	6304
2	968	6305
1	1156	6306
2	313	6307
1	140	6308
1	742	6309
2	1102	6310
1	40	6311
1	141	6312
4	759	6313
1	719	6314
1	896	6315
2	896	6316
1	41	6317
1	179	6318
1	969	6319
1	655	6320
2	371	6321
2	837	6322
1	838	6323
2	838	6324
2	372	6325
2	194	6325
1	338	6326
3	338	6327
1	330	6328
1	373	6329
2	373	6330
1	682	6331
2	682	6332
1	142	6333
1	797	6334
2	797	6335
1	143	6336
2	143	6337
1	839	6337
3	143	6338
2	839	6338
1	376	6339
1	346	6340
2	346	6341
1	1458	6342
1	227	6343
1	1084	6343
1	1338	6344
1	340	6344
1	281	6344
1	776	6345
2	776	6346
1	1283	6347
2	412	6348
3	973	6348
3	412	6349
4	973	6349
3	20	6350
1	894	6350
1	974	6351
1	1396	6351
1	975	6351
1	42	6352
1	144	6353
1	770	6354
1	1361	6355
1	1382	6356
2	1382	6357
1	893	6358
1	1437	6359
2	893	6359
2	44	6360
2	1397	6361
1	125	6361
2	1536	6361
1	384	6362
2	384	6363
1	385	6364
1	741	6365
3	741	6366
2	86	6367
2	316	6368
1	87	6368
1	88	6368
2	527	6368
2	87	6369
2	88	6369
1	1279	6370
2	952	6371
1	435	6371
1	436	6371
1	225	6372
2	225	6373
2	22	6374
3	225	6374
2	953	6375
1	316	6376
1	1415	6376
3	316	6377
1	437	6383
2	788	6384
2	1286	6384
2	437	6384
1	226	6385
2	226	6386
2	228	6387
3	228	6388
4	228	6389
1	643	6390
1	640	6390
1	638	6390
1	278	6391
2	278	6392
1	285	6393
2	604	6394
3	604	6395
4	604	6396
1	1448	6397
1	788	6398
1	268	6399
2	230	6400
1	1285	6401
2	326	6402
1	22	6402
1	288	6402
2	1086	6403
1	231	6404
1	13	6405
1	232	6405
1	822	6405
2	1225	6406
3	1225	6407
4	1225	6408
1	1142	6409
2	792	6410
3	792	6411
1	235	6412
2	111	6413
2	236	6414
2	823	6414
1	895	6415
2	895	6416
3	895	6417
1	237	6418
1	15	6418
2	237	6419
2	1318	6420
3	1318	6421
5	1318	6422
1	1124	6423
2	1124	6424
1	1157	6425
1	116	6426
2	1436	6427
2	868	6428
2	1010	6429
1	528	6430
2	955	6431
1	824	6432
1	1388	6433
1	1431	6433
1	1429	6433
2	1387	6433
2	1429	6434
1	1387	6434
4	1387	6435
2	1388	6436
2	1431	6436
3	1431	6437
1	202	6438
1	1212	6438
1	1339	6439
2	1339	6440
1	239	6441
2	239	6442
2	1508	6443
2	323	6443
3	1508	6444
3	323	6444
4	323	6445
1	286	6445
5	323	6446
2	286	6446
2	1535	6447
2	886	6447
1	713	6448
1	129	6449
2	129	6450
2	778	6451
1	1430	6452
3	1391	6453
5	1391	6454
1	394	6455
2	956	6456
3	17	6457
4	17	6458
1	18	6458
5	17	6459
6	17	6460
3	18	6461
1	245	6462
2	245	6463
3	245	6464
1	1406	6465
2	1406	6466
3	310	6467
1	1327	6468
1	1315	6469
3	286	6470
1	136	6471
2	136	6472
1	957	6473
1	246	6474
1	247	6475
2	247	6476
1	810	6477
2	810	6478
1	947	6478
1	821	6478
1	413	6479
2	413	6480
1	300	6481
1	20	6482
2	20	6483
1	172	6484
3	173	6485
1	1290	6486
1	826	6487
1	666	6488
2	440	6489
3	440	6490
1	1035	6491
1	921	6492
1	668	6493
2	668	6494
1	1172	6495
1	1217	6496
1	959	6497
2	958	6497
2	959	6498
1	958	6498
1	531	6499
1	597	6499
2	531	6500
2	597	6500
1	1148	6501
2	1148	6502
1	1320	6503
1	774	6504
2	774	6505
2	897	6506
2	251	6507
2	1242	6508
1	1242	6509
1	1306	6510
2	1306	6511
1	1268	6512
1	1160	6513
1	612	6514
2	174	6515
4	263	6516
1	672	6517
1	1238	6518
2	1238	6519
1	860	6520
1	1080	6521
2	1080	6522
3	1080	6523
2	1041	6524
1	1414	6525
1	21	6526
2	827	6526
2	255	6526
1	827	6527
1	255	6527
2	21	6527
1	1409	6528
2	1409	6529
1	674	6530
2	674	6531
3	674	6532
1	109	6532
4	674	6533
2	109	6533
1	441	6534
1	326	6535
1	1233	6536
1	962	6537
2	327	6538
2	963	6539
1	175	6540
2	664	6541
3	664	6542
2	1353	6543
3	1353	6544
1	333	6545
2	1256	6546
3	1256	6547
1	344	6548
2	344	6549
3	940	6550
1	1504	6551
1	1508	6558
3	955	1601
2	415	1616
3	413	1624
2	973	1632
2	213	1632
2	804	1632
2	1355	1632
2	1106	1632
1	405	1641
1	636	1641
2	719	1652
1	906	1652
2	210	1671
1	101	1698
1	1102	1710
1	1383	1713
1	1168	1722
3	1429	1722
3	1387	1722
2	1035	1731
2	513	1731
3	1218	1744
2	1219	1744
1	1220	1744
2	532	1757
2	265	1760
3	385	1760
1	386	1760
1	307	1760
1	1023	1761
2	481	1761
1	56	1763
1	183	1771
1	121	1771
1	123	1771
1	177	1771
1	178	1771
2	506	1779
1	782	1779
2	1116	1779
1	150	1796
2	864	1798
1	685	1798
1	615	1798
1	1230	1817
1	1138	1819
1	93	1852
1	1256	1866
3	896	1866
3	443	1882
1	690	1882
1	648	1882
1	711	1882
1	14	1882
2	438	1882
2	12	1882
1	954	1882
1	1229	1883
1	751	1883
3	136	1884
3	1242	1890
1	904	1890
1	1196	1890
2	16	1891
2	1320	1895
1	727	1905
2	1511	1916
1	989	1938
1	1260	1944
1	1248	1944
1	48	2269
2	300	2278
1	23	2288
1	1174	2325
1	113	2339
2	884	2339
2	1000	2339
3	577	2339
2	99	2339
1	1062	2339
1	1401	1964
3	1035	1982
1	513	1982
1	5	2008
3	142	2009
3	681	2009
2	1173	2009
4	797	2009
1	879	2015
3	1522	2035
1	1372	2035
1	1531	2041
1	932	2041
1	490	2041
1	332	2041
1	563	2041
1	371	2041
1	970	2041
1	1407	2068
2	1443	2068
1	398	2094
1	34	2107
1	828	2118
1	1108	2118
1	1042	2118
2	1413	2118
1	1181	2125
2	1230	2143
1	1232	2143
3	1230	2144
1	988	2157
2	1156	2164
2	595	2167
1	392	2190
3	1083	2190
1	1427	2190
1	732	2221
1	739	2234
1	366	2234
1	1169	2234
1	706	2236
1	416	2236
1	834	2236
1	342	2246
1	1509	6561
1	1511	6564
3	1511	6565
4	1511	6566
3	1513	6574
4	1513	6575
5	1513	6576
1	1530	6711
2	1519	7387
4	1522	7398
3	1523	7403
2	1524	7405
1	1524	7406
1	1525	7407
2	1526	7414
1	1527	7415
3	1528	7423
3	1529	7423
4	1528	7424
4	1529	7424
3	1536	7440
2	1537	7441
1	1538	7441
1	1539	7442
2	1541	7450
3	1543	7455
2	1545	7469
3	1546	7476
4	1546	7477
1	1547	7480
3	1549	7485
4	1549	7486
1	1549	7487
2	1549	7488
1	1550	7494
2	1550	7495
1	1554	7499
2	1554	7500
1	1555	7505
2	1555	7506
3	1555	7507
1	1556	7508
1	1559	7513
1	1560	7519
1	1561	7529
1	1565	7558
1	1566	7558
1	1568	7582
1	1575	7601
1	1576	7601
1	1579	4025
1	1580	5631
1	1581	4149
2	1581	7637
1	1582	1944
1	1583	1402
2	1583	7641
3	1583	3540
1	1584	6475
2	1584	6476
3	1584	3872
1	1585	7645
1	1586	7654
1	1587	7660
1	1588	1760
1	1589	7672
2	1589	7673
1	1590	7683
1	1591	7692
1	1592	1884
1	1593	7703
2	1593	6008
1	1594	7710
2	1594	7711
1	1595	7716
1	1596	5603
2	1596	6238
1	1597	879
2	1597	156
1	1598	2921
2	1598	7739
1	1599	3447
1	1600	3447
1	1601	3599
1	1602	7755
2	1602	7754
1	1603	6353
2	1603	616
3	1603	3318
4	1603	1070
1	1604	7760
1	1605	6402
1	1606	466
2	1606	208
1	1607	7766
2	1607	616
1	1608	5630
1	1609	3201
2	1609	6539
1	1610	3201
1	1611	6402
1	1612	5968
2	1612	3413
3	1612	7135
1	1613	5968
1	1614	7777
1	1615	3393
1	1616	5873
2	1616	3393
1	1617	4539
1	1618	6076
2	1618	7782
1	1619	896
1	1620	7791
1	1621	7793
1	1622	5538
2	1622	6039
1	1623	6243
2	1623	6244
3	1623	5519
1	1624	7800
2	1624	2643
1	1625	5711
2	1625	5712
1	1626	7802
2	1626	6017
3	1626	6018
1	1627	7803
1	1628	6147
1	1629	7807
2	1629	7808
1	1630	2236
1	1631	7816
1	1632	7822
1	1633	7826
2	1633	7827
1	1634	3700
2	1634	5839
3	1634	5840
4	1634	5278
1	1635	7833
1	1636	2236
1	1638	6461
1	1639	7857
2	1639	7858
1	1640	7866
2	1640	7867
1	1641	7873
2	1641	7874
1	1642	7878
1	1643	223
1	1644	1071
2	1644	6183
1	1645	7601
1	1646	7889
1	1647	7892
1	1648	7892
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.people (id, name, birth_date, death_date) FROM stdin;
2331	Heidi Kozak	1963-06-22	\N
551	Benjamin Bratt	1963-12-16	\N
655	William Fichtner	1956-11-27	\N
380	Jason Patric	1966-06-17	\N
659	Sean Patrick Flanery	1965-10-11	\N
883	George A. Romero	1940-02-04	2017-07-16
2332	Fran Kranz	1983-07-13	\N
45	Luc Besson	1959-03-18	\N
2333	Paul Kratka	1955-12-23	\N
2341	Nancy Kyes	1949-12-19	\N
2342	Jake La Botz	1968-11-23	\N
2343	Shia LaBeouf	1986-06-11	\N
2423	Jason Lively	1968-03-12	\N
2424	Ron Livingston	1967-06-05	\N
2425	Danny Lloyd	1972-10-13	\N
2426	Harry Lloyd	1983-11-17	\N
2430	Bob Logan	\N	\N
680	Scott Glenn	1939-01-26	\N
2431	Lindsay Lohan	1986-07-02	\N
2450	Diego Luna	1979-12-29	\N
2451	Patti LuPone	1949-04-21	\N
2452	Hamilton Luske	1903-10-16	1968-02-19
2453	Tommy Luske	1947-02-12	1990-01-19
2454	Jane Lynch	1960-07-14	\N
2455	Jonathan Lynn	1943-04-03	\N
2456	Sergi López	1965-12-22	\N
2457	Simon MacCorkindale	1952-02-12	2010-10-14
2458	James MacDonald	1906-05-19	1991-02-01
2459	Kelly Macdonald	1976-02-23	\N
2460	Sterling Macer Jr.	1963-11-28	\N
2461	Matthew Macfadyen	1974-10-17	\N
2462	Seth MacFarlane	1973-10-26	\N
2463	Jack MacGowran	1918-10-13	1973-01-30
2464	Steven Mackintosh	1967-04-30	\N
2465	Angus MacLane	1975-04-13	\N
893	Roy Scheider	1932-11-10	2008-02-10
2470	Richard Madden	1986-06-18	\N
2473	Sharon Maguire	1960-11-28	\N
2474	Sean Maher	1975-04-16	\N
2475	Marjorie Main	1890-02-22	1975-04-10
2476	Mako	1933-12-10	2006-07-21
2477	Art Malik	1952-11-13	\N
2478	Jena Malone	1984-11-21	\N
2479	Aasif Mandvi	1966-03-05	\N
2480	Costas Mandylor	1965-09-03	\N
2481	Louis Mandylor	1966-09-13	\N
2482	Tyler Mane	1966-12-08	\N
2483	Joe Manganiello	1976-12-28	\N
2484	Silvana Mangano	1930-04-21	1989-12-16
2485	Byron Mann	1967-08-13	\N
2486	Danny Mann	1951-07-28	\N
2487	Gabriel Mann	1972-05-14	\N
2488	David Manners	1900-04-29	1998-12-23
2489	Lesley Manville	1956-03-12	\N
2490	Kate Mara	1983-02-27	\N
2491	Kelly Marcel	1974-01-10	\N
2492	Adam Marcus	1968-08-21	\N
2493	Miriam Margolyes	1941-05-18	\N
2494	Lisa Marie	1968-12-05	\N
2495	Eli Marienthal	1986-03-06	\N
2496	Jason Marin	1974-07-25	\N
2497	Dan Marino	1961-09-15	\N
2498	John Marley	1907-10-17	1984-05-22
2499	Marc Maron	1963-09-27	\N
2500	Richard Marquand	1937-09-22	1987-09-04
2501	Christopher Rodriguez Marquette	1984-10-03	\N
2502	Kenneth Mars	1935-04-04	2011-02-12
2503	Eddie Marsan	1968-06-09	\N
2504	Matthew Marsden	1973-03-03	\N
2505	Jean Marsh	1934-07-01	\N
2506	Jeff 'Swampy' Marsh	1960-12-09	\N
2507	E.G. Marshall	1914-06-18	1998-08-24
2508	Neil Marshall	1970-05-25	\N
2509	Rob Marshall	1960-10-17	\N
2510	Vanessa Marshall	1969-10-19	\N
2511	Andrea Martin	1947-01-15	\N
2512	Lelia Martin	1932-08-22	\N
2513	Margo Martindale	1951-07-18	\N
2514	Adrian Martinez	1972-01-20	\N
2515	Steve Martino	1959-07-21	\N
2516	Masasa Moyo	1970-01-23	\N
2517	Richard Masur	1948-11-20	\N
2518	Hans Matheson	1975-08-07	\N
2519	Thom Mathews	1958-11-28	\N
2520	Marlee Matlin	1965-08-24	\N
2521	Liesel Matthews	1984-03-14	\N
5600	Scott Spiegel	1957-12-24	2025-09-01
4	Humphrey Bogart	1899-12-25	1957-01-14
384	Joe Pesci	1943-02-09	\N
390	Roman Polanski	1933-08-18	\N
308	Michael Ironside	1950-02-12	\N
326	Ang Lee	1954-10-23	\N
394	Bill Pullman	1953-12-17	\N
396	Kathleen Quinlan	1954-11-19	\N
2522	Lisa Maxwell	1963-11-24	\N
5316	Marc Guggenheim	1970-09-24	\N
5317	Andrew Kreisberg	1971-04-23	\N
5318	Colin Donnell	1982-10-09	\N
5319	David Ramsey	1971-11-17	\N
5320	Susanna Thompson	1958-01-27	\N
5321	Paul Blackthorne	1969-03-05	\N
5322	Willa Holland	1991-06-18	\N
5323	Emily Bett Rickards	1991-07-24	\N
5324	Colton Haynes	1988-07-13	\N
5325	Manu Bennett	1969-10-10	\N
5326	John Barrowman	1967-03-11	\N
5327	Echo Kellum	1982-08-29	\N
5328	Rick Gonzalez	1979-06-30	\N
5329	Juliana Harkavy	1985-01-01	\N
5330	Kirk Acevedo	1971-11-27	\N
5331	Sea Shimooka	1995-02-06	\N
5332	Katherine McNamara	1995-11-22	\N
5333	Ben Lewis	1985-09-30	\N
7587	JT Mollner	\N	\N
2	John Belushi	1949-01-24	1982-03-05
330	John Leguizamo	1960-07-22	\N
377	Gwyneth Paltrow	1972-09-27	\N
383	Ron Perlman	1950-04-13	\N
389	Martha Plimpton	1970-11-16	\N
393	Jonathan Pryce	1947-06-01	\N
2603	Daryl Mitchell	1965-07-16	\N
7588	Cooper Hoffman	2003-03-20	\N
341	Andie MacDowell	1958-04-21	\N
397	Sam Raimi	1959-10-23	\N
395	Dennis Quaid	1954-04-09	\N
22	Robert Mitchum	1917-08-06	1997-07-01
23	Paul Newman	1925-01-26	2008-09-26
13	Clark Gable	1901-02-01	1960-11-16
15	Cary Grant	1904-01-18	1986-11-29
19	Vivien Leigh	1913-11-05	1967-07-07
20	Peter Lorre	1904-06-26	1964-03-23
21	James Mason	1909-05-15	1984-07-27
130	Ryan Phillippe	1974-09-10	\N
307	Jeremy Irons	1948-09-19	\N
309	Famke Janssen	1964-11-05	\N
2344	Tyler Labine	1978-04-29	\N
612	Mark Dacascos	1964-02-26	\N
7589	Garrett Wareing	2001-08-31	\N
11	Stanley Kubrick	1928-07-26	1999-03-07
14	Judy Garland	1922-06-10	1969-06-22
5	Marlon Brando	1924-04-03	2004-07-01
7	Audrey Hepburn	1929-05-04	1993-01-20
31	Gong Li	1965-12-31	\N
255	R. Lee Ermey	1944-03-24	2018-04-15
9	Grace Kelly	1929-11-12	1982-09-14
205	David Bowie	1947-01-08	2016-01-10
183	Alan Arkin	1934-03-26	2023-06-29
3006	Rade Serbedzija	1946-07-27	\N
5696	Joseph Raso	\N	\N
7590	Tut Nyuot	\N	\N
530	Steven Berkoff	1937-08-03	\N
532	Halle Berry	1966-08-14	\N
537	Whit Bissell	1909-10-25	1996-03-05
485	André the Giant	1946-05-19	1993-01-27
1411	Justin Bartha	1978-07-21	\N
222	James Coburn	1928-08-31	2002-11-18
327	Brandon Lee	1965-02-01	1993-03-31
298	Philip Seymour Hoffman	1967-07-23	2014-02-02
312	James Earl Jones	1931-01-17	2024-09-09
328	Christopher Lee	1922-05-27	2015-06-07
337	Ray Liotta	1954-12-18	2022-05-26
1412	Peter Bartlett	1942-08-28	\N
1413	Peter Barton	1956-07-19	\N
1414	Laurie Bartram	1958-05-16	2007-05-25
1415	Jay Baruchel	1982-04-09	\N
1416	Bill Baucom	1910-05-05	1981-03-16
1417	Cate Bauer	1922-08-27	\N
1418	Adam Beach	1972-11-11	\N
1419	Gary Beach	1947-10-10	2018-07-17
1420	Kate Beahan	1974-10-12	\N
1421	Charlie Bean	1970-08-10	\N
2345	Ronald Lacey	1935-09-28	1991-05-15
2346	Bert Lahr	1895-08-13	1967-12-04
1091	Mark Neveldine	1973-05-11	\N
2347	Don Lake	1956-11-26	\N
2348	Phil LaMarr	1967-01-24	\N
7591	Ben Wang	2000-01-01	\N
10	Olivia de Havilland	1916-07-01	2020-07-26
314	Raul Julia	1940-03-09	1994-10-24
459	J.T. Walsh	1943-09-28	1998-02-27
3266	Yorick van Wageningen	1964-04-16	\N
3267	George Waggner	1894-09-07	1984-12-11
3268	Hynden Walch	1971-02-01	\N
3269	Gregory Walcott	1928-01-13	2015-03-20
7592	Josh Hamilton	1969-06-09	\N
1422	John Beasley	1943-06-26	2023-05-30
59	Jennifer Connelly	1970-12-12	\N
1423	Kathryn Beaumont	1938-06-27	\N
7593	Madeline Sharafian	1993-02-01	\N
802	Toshirô Mifune	1920-04-01	1997-12-24
233	Matt Damon	1970-10-08	\N
1348	Harry Anderson	1952-10-14	2018-04-16
536	Theodore Bikel	1924-05-02	2015-07-21
538	Shane Black	1961-12-16	\N
7594	Mark Hammer	\N	\N
1349	Jeff Anderson	1970-04-21	\N
1359	Evelyn Ankers	1918-08-17	1985-08-29
1360	Nimród Antal	1973-11-30	\N
1376	Rene Auberjonois	1940-06-01	2019-12-08
1361	Lee Arenberg	1962-07-18	\N
1377	Eleanor Audley	1905-11-19	1991-11-25
1378	Steve Austin	1964-12-18	\N
1362	Adam Arkin	1956-08-19	\N
1363	Fred Armisen	1966-12-04	\N
1364	Richard Armitage	1971-08-22	\N
1365	Robert Armstrong	1890-11-19	1973-04-20
1366	Newt Arnold	1922-02-22	2000-02-12
1367	Bea Arthur	1922-05-13	2009-04-25
1368	Tadanobu Asano	1973-11-27	\N
1369	Kelly Asbury	1960-01-15	2020-06-26
1370	Lorraine Ashbourne	1961-01-07	\N
1371	Elizabeth Ashley	1939-08-30	\N
1372	Shawn Ashmore	1979-10-07	\N
1373	John Ashton	1948-02-22	2024-09-26
1374	William Atherton	1947-07-30	\N
1375	Tom Atkins	1935-11-13	\N
3707	Ryan Simpkins	1998-03-25	\N
1379	David Ayer	1968-01-18	\N
1380	Reiko Aylesworth	1972-12-09	\N
1381	Leah Ayres	1957-05-28	\N
1382	Brian Backer	1956-12-05	\N
1383	Hermione Baddeley	1906-11-13	1986-08-19
1384	Diedrich Bader	1966-12-24	\N
1385	Bae Doona	1979-10-11	\N
1386	Jonathan Bailey	1988-04-25	\N
1387	Chieko Baisho	1941-06-29	\N
1388	Betsy Baker	1955-05-08	\N
1389	Dee Bradley Baker	1962-08-31	\N
1390	Dylan Baker	1959-10-07	\N
1391	Joe Baker	1928-12-14	2001-05-16
1392	Kenny Baker	1934-08-24	2016-08-13
1393	Kyle Balda	1971-03-09	\N
1394	Eric Balfour	1977-04-24	\N
1395	Pedro Pascal	1975-04-02	\N
1396	Eric Bana	1968-08-09	\N
2349	Michael Landes	1972-09-18	\N
651	Adam Sandler	1966-09-09	\N
666	Miloš Forman	1932-02-18	2018-04-13
7595	Yonas Kibreab	2010-06-17	\N
25	Laurence Olivier	1907-05-22	1989-07-11
119	Matthew McConaughey	1969-11-04	\N
125	Jack Nicholson	1937-04-22	\N
171	James Woods	1947-04-18	\N
180	Julie Andrews	1935-10-01	\N
295	Dan Hedaya	1940-07-24	\N
300	Lauren Holly	1963-10-28	\N
318	Patsy Kensit	1968-03-04	\N
392	Kelly Preston	1962-10-13	2020-07-12
447	Lea Thompson	1961-05-31	\N
455	Vince Vaughn	1970-03-28	\N
3814	Katie Cassidy	1986-11-25	\N
1397	Tony Bancroft	1967-07-31	\N
1398	Claes Bang	1967-04-28	\N
1399	Teresa Banham	\N	\N
1400	Jonathan Banks	1947-01-31	\N
1401	Don Barclay	1892-12-26	1975-10-16
1402	Ike Barinholtz	1977-02-18	\N
1424	Jim Beaver	1950-08-12	\N
1425	Demián Bichir	1963-08-01	\N
1426	Kimberly Beck	1956-01-09	\N
1427	Vincent Beck	1924-08-15	1984-07-24
1428	Walt Becker	1968-09-16	\N
7596	Remy Edgerly	\N	\N
531	Elizabeth Berridge	1962-05-02	\N
535	Kathryn Bigelow	1951-11-27	\N
539	Cate Blanchett	1969-05-14	\N
590	Dabney Coleman	1932-01-03	2024-05-16
598	Joseph Cotten	1905-05-15	1994-02-06
846	Maria Pitillo	1966-01-08	\N
599	Courteney Cox	1964-06-15	\N
605	Billy Crudup	1968-07-08	\N
675	Victor Garber	1949-03-16	\N
1429	Irene Bedard	1967-07-22	\N
1430	Emma Bell	1986-12-17	\N
1431	Jamie Bell	1986-03-14	\N
1432	Kristen Bell	1980-07-18	\N
1433	Tobin Bell	1942-08-07	\N
1434	William Brent Bell	1980-09-17	\N
1435	Clé Bennett	1981-07-13	\N
1436	Jeff Bennett	1962-10-02	\N
1437	Jodi Benson	1961-10-10	\N
1438	Lyriq Bent	1979-01-03	\N
923	Timothy Spall	1957-02-27	\N
986	Anthony Zerbe	1936-05-20	\N
1008	George Chakiris	1932-09-16	\N
1439	Blaze Berdahl	1980-09-06	\N
1440	Jeff Bergman	1960-07-10	\N
1441	Mary Kay Bergman	1961-06-05	1999-11-11
87	Whoopi Goldberg	1955-11-13	\N
115	David Lynch	1946-01-20	2025-01-15
1083	Brian Cox	1946-06-01	\N
127	Al Pacino	1940-04-25	\N
160	John Travolta	1954-02-18	\N
182	Anne Archer	1947-08-24	\N
189	Hank Azaria	1964-04-25	\N
262	Sally Field	1946-11-06	\N
301	Ian Holm	1931-09-12	2020-06-19
388	Donald Pleasence	1919-10-05	1995-02-02
409	Alan Rickman	1946-02-21	2016-01-14
446	Fred Thompson	1942-08-19	2015-11-01
1442	Xander Berkeley	1955-12-16	\N
1443	Greg Berlanti	1972-05-24	\N
1444	Daniel Bernhardt	1965-08-31	\N
1445	Kevin Bernhardt	1961-04-02	\N
1446	Sarah Berry	1969-05-31	\N
1447	Ahmed Best	1973-08-19	\N
1448	Eve Best	1971-07-31	\N
1449	Paul Bettany	1971-05-27	\N
1450	Susanne Bier	1960-04-15	\N
1451	Robert Bierman	\N	\N
1452	Paul Feig	1962-09-17	\N
1453	Peter Billingsley	1971-04-16	\N
1454	Barbara Bingham	\N	\N
1455	Patricia Birch	1934-10-16	\N
2350	Jessie Royce Landis	1896-11-25	1972-02-02
533	Bibi Besch	1942-02-01	1996-09-07
594	Jeff Conaway	1950-10-05	2011-05-27
601	Peter Coyote	1941-10-10	\N
671	Zsa Zsa Gabor	1917-02-06	2016-12-18
672	Charlotte Gainsbourg	1971-07-21	\N
911	Martin Short	1950-03-26	\N
2351	Christopher Landon	1975-02-27	\N
2352	Ruth Landshoff	1904-01-07	1966-01-19
924	Tori Spelling	1973-05-16	\N
1006	Tantoo Cardinal	1950-07-20	\N
2353	Hope Lange	1933-11-28	2003-12-19
2354	Victor Lanoux	1936-06-18	2017-05-04
2355	Yorgos Lanthimos	1973-09-23	\N
2356	Liza Lapira	1981-12-03	\N
7597	Young Dylan	2009-03-04	\N
169	John Woo	1946-09-22	\N
6	Alec Guinness	1914-04-02	2000-08-05
37	Patricia Arquette	1968-04-08	\N
38	Rowan Atkinson	1955-01-06	\N
39	Dan Aykroyd	1952-07-01	\N
162	Skeet Ulrich	1970-01-20	\N
185	Rosanna Arquette	1959-08-10	\N
277	Jami Gertz	1965-10-28	\N
296	Mariel Hemingway	1961-11-22	\N
407	Denise Richards	1971-02-17	\N
454	Casper Van Dien	1968-12-18	\N
4042	Bob Persichetti	1973-01-17	\N
4043	Jefferson Hall	1977-12-06	\N
4044	Deepika Padukone	1986-01-05	\N
4045	Rodo Sayagues	\N	\N
4046	Maika Monroe	1993-05-29	\N
4047	Riley Keough	1989-05-29	\N
4048	Aaron Michael Drozin	1998-05-30	\N
4088	Jason Cope	\N	\N
2357	Alexandra Maria Lara	1978-11-12	\N
541	Hart Bochner	1956-10-03	\N
565	Gary Busey	1944-06-29	\N
592	Robbie Coltrane	1950-03-30	2022-10-14
604	Scatman Crothers	1910-05-22	1986-11-21
668	William Forsythe	1955-06-07	\N
767	Denis Leary	1957-08-18	\N
2358	Linda Larkin	1970-03-20	\N
2359	Brie Larson	1989-10-01	\N
2360	Eric Larson	1905-09-03	1988-10-25
830	Anna Paquin	1982-07-24	\N
918	Maggie Smith	1934-12-28	2024-09-27
2361	Ashley Laurence	1966-05-28	\N
2362	Mélanie Laurent	1983-02-21	\N
2363	Hugh Laurie	1959-06-11	\N
2364	Linda Lavin	1937-10-15	2024-12-29
2365	Carolyn Lawrence	1967-02-13	\N
2366	Marc Lawrence	1959-10-22	\N
40	Kevin Bacon	1958-07-08	\N
42	Antonio Banderas	1960-08-10	\N
44	Kim Basinger	1953-12-08	\N
46	Kenneth Branagh	1960-12-10	\N
47	Matthew Broderick	1962-03-21	\N
48	Pierce Brosnan	1953-05-16	\N
49	Sandra Bullock	1964-07-26	\N
50	Steve Buscemi	1957-12-13	\N
51	Nicolas Cage	1964-01-07	\N
52	James Cameron	1954-08-16	\N
54	John Carpenter	1948-01-16	\N
56	Jim Carrey	1962-01-17	\N
2367	Mr. Lawrence	1969-01-01	\N
57	Phoebe Cates	1963-07-16	\N
58	George Clooney	1961-05-06	\N
61	Kevin Costner	1955-01-18	\N
63	Russell Crowe	1964-04-07	\N
2368	Josh Lawson	1981-07-22	\N
64	Tom Cruise	1962-07-03	\N
65	Jamie Lee Curtis	1958-11-22	\N
66	John Cusack	1966-06-28	\N
67	Claire Danes	1979-04-12	\N
68	Geena Davis	1956-01-21	\N
2369	Paul Le Mat	1945-09-22	\N
69	Robert De Niro	1943-08-17	\N
70	Johnny Depp	1963-06-09	\N
75	David Duchovny	1960-08-07	\N
76	Clint Eastwood	1930-05-31	\N
154	Oliver Stone	1946-09-15	\N
187	Richard Attenborough	1923-08-29	2014-08-24
234	Anthony Daniels	1946-02-21	\N
2370	Erwin Leder	1951-07-30	\N
2371	J. Lee Thompson	1914-08-01	2002-08-30
2372	Lee Byung-hun	1970-07-12	\N
2373	Lee Jung-jae	1972-12-15	\N
7598	Brandon Moon	\N	\N
274	Andy Garcia	1956-04-12	\N
387	Jada Pinkett Smith	1971-09-18	\N
451	Chris Tucker	1971-08-31	\N
481	Jane Alexander	1939-10-28	\N
109	Jude Law	1972-12-29	\N
111	Heather Locklear	1961-09-25	\N
116	Madonna	1958-08-16	\N
118	Jenny McCarthy-Wahlberg	1972-11-01	\N
134	Keanu Reeves	1964-09-02	\N
135	Christina Ricci	1980-02-12	\N
136	Molly Ringwald	1968-02-18	\N
137	Tim Robbins	1958-10-16	\N
138	Julia Roberts	1967-10-28	\N
139	Mimi Rogers	1956-01-27	\N
141	Mia Sara	1967-06-19	\N
142	Susan Sarandon	1946-10-04	\N
144	Martin Scorsese	1942-11-17	\N
146	Charlie Sheen	1965-09-03	\N
145	Kristin Scott Thomas	1960-05-24	\N
147	Elisabeth Shue	1963-10-06	\N
148	Alicia Silverstone	1976-10-04	\N
149	Christian Slater	1969-08-18	\N
159	Jennifer Tilly	1958-09-16	\N
168	Bruce Willis	1955-03-19	\N
214	Kim Cattrall	1956-08-21	\N
228	Tim Curry	1946-04-19	\N
276	Teri Garr	1944-12-11	2024-10-29
283	Hugh Grant	1960-09-09	\N
292	Noah Hathaway	1971-11-13	\N
4159	Travis Tope	1991-11-11	\N
4160	Angelique Cabral	1979-01-28	\N
381	Sean Penn	1960-08-17	\N
391	Pete Postlethwaite	1946-02-07	2011-01-02
410	John Ritter	1948-09-17	2003-09-11
4161	Selina Lo	1991-05-08	\N
4162	Susan Heyward	1982-11-19	\N
4163	Jessica McNamee	1986-02-21	\N
4164	Mike Moh	1983-08-19	\N
4165	Julian Black Antelope	1975-06-08	\N
4166	Alicia Vikander	1988-10-03	\N
4167	Jai Courtney	1986-03-15	\N
4168	Kaya Scodelario	1992-03-13	\N
4169	Stephen Farrelly	1978-01-28	\N
4170	Azhar Usman	1975-12-23	\N
4171	Reggie Watts	1972-03-23	\N
4172	T.J. Miller	1981-06-04	\N
4173	Kimberly Hébert Gregory	1973-12-07	\N
4174	Eiza González	1990-01-30	\N
4175	Adelaide Kane	1990-08-09	\N
4176	Tyler Mann	1993-01-15	\N
6867	Cody Ziglar	\N	\N
2374	Peggy Lee	1920-05-26	2002-01-21
567	Red Buttons	1919-02-05	2006-07-13
596	Robert Conrad	1935-03-01	2020-02-08
665	Claire Forlani	1971-12-17	\N
673	Peter Gallagher	1955-08-19	\N
2375	Will Yun Lee	1971-03-22	\N
2376	Erica Leerhsen	1976-02-14	\N
946	Rachel Ticotin	1958-11-01	\N
2377	Rachelle Lefevre	1979-02-01	\N
2378	Michael Lehmann	1957-03-30	\N
2379	David Leitch	1975-11-16	\N
2380	John D. LeMay	1962-05-29	\N
976	Oprah Winfrey	1954-01-29	\N
2381	Michael Lembeck	1948-06-25	\N
2382	Kasi Lemmons	1961-02-24	\N
1009	Sonny Chiba	1939-01-23	2021-08-19
7599	JP Karliak	1981-05-11	\N
16	Alfred Hitchcock	1899-08-13	1980-04-29
74	Michael Douglas	1944-09-25	\N
212	Emmanuelle Béart	1963-08-14	\N
17	Akira Kurosawa	1910-03-23	1998-09-06
106	Val Kilmer	1959-12-31	2025-04-01
161	Liv Tyler	1977-07-01	\N
172	Renée Zellweger	1969-04-25	\N
181	Ann-Margret	1941-04-28	\N
188	Pernilla August	1958-02-13	\N
194	Ellen Barkin	1954-04-16	\N
195	Angela Bassett	1958-08-16	\N
196	Sean Bean	1959-04-17	\N
198	Tom Berenger	1949-05-31	\N
199	Michael Biehn	1956-07-31	\N
200	Juliette Binoche	1964-03-09	\N
201	Thora Birch	1982-03-11	\N
202	Linda Blair	1959-01-22	\N
324	Fritz Lang	1890-12-05	1976-08-02
413	Mickey Rourke	1952-09-16	\N
441	Patrick Swayze	1952-08-18	2009-09-14
448	Billy Bob Thornton	1955-08-04	\N
207	Jeff Bridges	1949-12-04	\N
206	Bruce Boxleitner	1950-05-12	\N
208	Mel Brooks	1926-06-28	\N
209	Clancy Brown	1959-01-05	\N
210	Tim Burton	1958-08-25	\N
211	Gabriel Byrne	1950-05-12	\N
213	Michael Caine	1933-03-14	\N
223	Francis Ford Coppola	1939-04-07	\N
224	James Cromwell	1940-01-27	\N
235	Daniel Day-Lewis	1957-04-29	\N
250	Jennifer Ehle	1969-12-29	\N
280	Valeria Golino	1965-10-22	\N
299	Gaby Hoffmann	1982-01-08	\N
4204	Caleb Landry Jones	1989-12-07	\N
4205	Neil Ellice	1990-08-15	\N
4206	Ginger Gonzaga	1983-05-17	\N
4207	Joseph Kosinski	1974-05-03	\N
4208	Jonathan Groff	1985-03-26	\N
4209	Maung Maung Khin	\N	\N
4210	Nick Jonas	1992-09-16	\N
4211	Pankaj Tripathi	1976-09-05	\N
4212	Devery Jacobs	1993-08-08	\N
2383	Melissa Leo	1960-09-14	\N
563	Ellen Burstyn	1932-12-07	\N
669	Meg Foster	1948-05-14	\N
679	Sarah Michelle Gellar	1977-04-14	\N
2384	Joshua Leonard	1975-06-17	\N
2385	John R. Leonetti	1956-07-04	\N
934	Sting	1951-10-02	\N
2386	Chauncey Leopardi	1981-06-14	\N
2387	Logan Lerman	1992-01-19	\N
2388	Michael Lerner	1941-06-22	2023-04-08
2389	Mark L. Lester	1946-11-26	\N
1147	Sean Hayes	1970-06-26	\N
1199	Paul Mazursky	1930-04-25	2014-06-30
2390	Richard Lester	1932-01-19	\N
7600	Maya Erskine	1987-05-07	\N
18	Bruce Lee	1940-11-27	1973-07-20
164	Mark Wahlberg	1971-06-05	\N
186	Sean Astin	1971-02-25	\N
227	Macaulay Culkin	1980-08-26	\N
237	Danny DeVito	1944-11-17	\N
241	Michael Dorn	1952-12-09	\N
240	Amanda Donohoe	1962-06-29	\N
297	Lance Henriksen	1940-05-05	\N
404	Ving Rhames	1959-05-12	\N
414	Kurt Russell	1951-03-17	\N
453	Kathleen Turner	1954-06-19	\N
4296	Rob Delaney	1977-01-19	\N
4297	Ezra Miller	1992-09-30	\N
4298	Ma Dong-seok	1971-03-01	\N
1507	Shane Brolly	1970-03-06	\N
4299	Rebecca Henderson	1980-06-04	\N
4300	Bentley Kalu	1985-04-07	\N
4301	Joe Taslim	1981-06-23	\N
4302	Ismael Cruz Cordova	1987-04-07	\N
4303	Natalia Dyer	1995-01-13	\N
2391	Louis Leterrier	1973-06-17	\N
522	Monica Bellucci	1964-09-30	\N
589	Joel Coen	1954-11-29	\N
595	Harry Connick Jr.	1967-09-11	\N
600	Ronny Cox	1938-07-23	\N
674	James Gandolfini	1961-09-18	2013-06-19
917	Kurtwood Smith	1943-07-03	\N
2392	Rudolf Lettinger	1865-10-26	1937-03-21
2393	Tracy Letts	1965-07-04	\N
2394	Tony Leung Chiu-wai	1962-06-27	\N
1007	Vincent Cassel	1966-11-23	\N
1026	Dexter Fletcher	1966-01-31	\N
1034	Ruth Gordon	1896-10-30	1985-08-28
1036	Rodney A. Grant	1959-03-09	\N
1161	Michael Jeter	1952-08-26	2003-03-30
1200	Mark McGrath	1968-03-15	\N
2395	Ken Leung	1970-01-21	\N
2396	Brian Levant	1952-08-06	\N
2397	Harvey Levin	1950-09-02	\N
2398	Jerry Levine	1957-03-12	\N
2399	Ted Levine	1957-05-29	\N
2400	Eugene Levy	1946-12-17	\N
2401	Shawn Levy	1968-07-23	\N
2402	Gary Lewis	1958-11-30	\N
2403	Jenifer Lewis	1957-01-25	\N
2404	Johnny Lewis	1983-10-29	2012-09-26
2406	Li Bingbing	1973-02-27	\N
2407	Allison Liddi-Brown	1959-08-02	\N
2408	Nikolaj Lie Kaas	1973-05-22	\N
2409	Jonathan Liebesman	1976-09-15	\N
2410	Cody Lightning	1986-08-08	\N
2411	Shad Moss	1987-03-09	\N
2412	Kevin Lima	1962-06-12	\N
2413	Doug Liman	1965-07-24	\N
2414	Justin Lin	1971-10-11	\N
2415	Chad Lindberg	1976-11-01	\N
2416	Viveca Lindfors	1920-12-29	1995-10-25
2417	Mark Linn-Baker	1954-06-17	\N
2418	Alex D. Linz	1989-01-03	\N
2419	Steven Lisberger	1951-04-24	\N
2420	Dwight H. Little	1956-01-13	\N
2421	Sam Liu	\N	\N
2422	Blake Lively	1987-08-25	\N
7601	Paul Thomas Anderson	1970-06-26	\N
184	David Arquette	1971-09-08	\N
264	Linda Fiorentino	1958-03-09	\N
322	Christopher Lambert	1957-03-29	\N
411	Eric Roberts	1956-04-18	\N
4415	Isabella Blake-Thomas	2002-09-21	\N
4416	Sasheer Zamata	1986-05-06	\N
4417	Jameela Jamil	1986-02-25	\N
4418	Phoebe Waller-Bridge	1985-07-14	\N
4419	Georgina Campbell	1992-06-12	\N
4420	Ray Fisher	1987-09-08	\N
4421	Christopher Abbott	1986-02-10	\N
4422	Maisie Williams	1997-04-15	\N
4423	Emilia Clarke	1986-10-23	\N
4424	Jaz Sinclair	1994-07-22	\N
4425	Jack Bright	\N	\N
4426	James Russell	1983-09-03	\N
4427	Jordan Vogt-Roberts	1984-09-22	\N
4428	Zoey Deutch	1994-11-10	\N
4429	Sarah-Sofie Boussnina	1990-12-28	\N
4430	Eugene Lee Yang	1986-01-18	\N
4431	Jacob Latimore	1996-08-10	\N
4432	Imari Williams	1977-05-03	\N
4433	Charlie Murphy	1987-11-30	\N
4434	Isaac Hempstead Wright	1999-04-09	\N
4435	Hasan Minhaj	1985-09-23	\N
4436	Corey Hawkins	1988-10-22	\N
4437	Anna Sawai	1992-06-11	\N
4438	Travina Springer	1982-07-09	\N
4439	Ariana DeBose	1991-01-25	\N
4440	Taylour Paige	1990-10-05	\N
4441	Milo Manheim	2001-03-06	\N
4442	Teyana Taylor	1990-12-10	\N
4443	Olivia Deeble	2002-08-04	\N
4444	Iwan Rheon	1985-05-13	\N
4445	Stephanie Beatriz	1981-02-10	\N
2088	Phil Harris	1904-06-24	1995-08-11
2089	Rosemary Harris	1927-09-19	\N
2090	Sean Harris	1966-01-07	\N
2091	Wood Harris	1969-10-17	\N
2092	Linda Harrison	1945-07-26	\N
2093	Mary Harron	1953-01-12	\N
2094	Lee Harry	\N	\N
534	Richard Beymer	1938-02-20	\N
555	James Brolin	1940-07-18	\N
561	Billie Burke	1884-08-05	1970-05-15
566	Jake Busey	1971-06-15	\N
572	Kate Capshaw	1953-11-03	\N
718	Jennifer Love Hewitt	1979-02-21	\N
720	Hulk Hogan	1953-08-11	2025-07-24
719	Ciarán Hinds	1953-02-09	\N
721	Hal Holbrook	1925-02-17	2021-01-23
722	Sterling Holloway	1905-01-14	1992-11-22
723	Tobe Hooper	1943-01-25	2017-08-26
724	Bob Hoskins	1942-10-26	2014-04-29
725	Whitney Houston	1963-08-09	2012-02-11
727	C. Thomas Howell	1966-12-07	\N
129	Michelle Pfeiffer	1958-04-29	\N
291	Neil Patrick Harris	1973-06-15	\N
332	Jack Lemmon	1925-02-08	2001-06-27
406	Ariana Richards	1979-09-11	\N
449	Marisa Tomei	1964-12-04	\N
576	Dana Carvey	1955-06-02	\N
591	Toni Collette	1972-11-01	\N
593	Chris Columbus	1958-09-10	\N
602	Richard Crenna	1926-11-30	2003-01-17
664	Glenn Ford	1916-05-01	2006-08-30
728	Ernie Hudson	1945-12-17	\N
729	Tom Hulce	1953-12-06	\N
730	Bonnie Hunt	1961-09-22	\N
670	William Friedkin	1935-08-29	2023-08-07
707	Ian Hart	1964-10-08	\N
27	Anthony Quinn	1915-04-21	2001-06-03
305	John Hurt	1940-01-22	2017-01-25
405	Giovanni Ribisi	1974-12-17	\N
452	Robin Tunney	1972-06-19	\N
2303	Dana Kimmell	1959-10-25	\N
687	Heather Graham	1970-01-29	\N
690	Erin Gray	1950-01-07	\N
691	Seth Green	1974-02-08	\N
694	Christopher Guest	1948-02-05	\N
695	Carla Gugino	1971-08-29	\N
773	Jet Li	1963-04-26	\N
2304	Isao Kimura	1923-06-22	1981-07-04
2305	Takuya Kimura	1972-11-13	\N
2306	Richard Kind	1956-11-22	\N
2307	Adrienne King	1955-07-21	\N
2308	Morgana King	1930-07-04	2018-03-22
2309	Melanie Kinnaman	1953-12-18	\N
697	Lukas Haas	1976-04-16	\N
2310	Roy Kinnear	1934-01-08	1988-09-20
2311	Eartha Kitt	1927-01-17	2008-12-25
2312	Rudolf Klein-Rogge	1885-11-24	1955-05-29
2313	Randal Kleiser	1946-07-20	\N
2314	Tom Knight	\N	\N
2315	Keira Knightley	1985-03-26	\N
2316	Don Knotts	1924-07-21	2006-02-24
2317	Beyoncé	1981-09-04	\N
2318	Patric Knowles	1911-11-11	1995-12-23
2319	Erik Knudsen	1988-03-25	\N
2320	Sidse Babett Knudsen	1968-11-22	\N
2405	Kevin Lewis	\N	\N
2584	Nicholas Meyer	1945-12-24	\N
2585	Lars Mikkelsen	1964-05-06	\N
2586	Mads Mikkelsen	1965-11-22	\N
2587	Lillian Miles	1907-08-01	1972-02-27
2588	Vera Miles	1929-08-23	\N
2589	John Milius	1944-04-11	\N
4594	Mari Yamamoto	1986-02-04	\N
4595	Ed Oxenbould	2001-06-01	\N
4596	Lily Sullivan	1993-09-08	\N
4597	Alistair Sewell	\N	\N
4598	Gideon Adlon	1997-03-30	\N
4599	Kaitlyn Dias	1999-05-11	\N
4600	Olivia DeJonge	1998-04-30	\N
4601	Kirby Howell-Baptiste	1987-02-07	\N
4602	Oakes Fegley	2004-11-11	\N
4603	Benjamin Flores Jr.	2002-07-23	\N
4604	Kingsley Ben-Adir	1986-11-20	\N
4605	Maddie Ziegler	2002-09-30	\N
4606	Rina Sawayama	1990-08-16	\N
4607	Daniel Zovatto	1991-06-28	\N
4608	Carrie Coon	1981-01-24	\N
4609	Kayleigh Styles	\N	\N
4610	Sturgill Simpson	1978-06-08	\N
4611	Priyanshu Painyuli	1988-08-29	\N
4612	Claudia Doumit	1992-04-21	\N
2432	Alison Lohman	1979-09-18	\N
580	Maxwell Caulfield	1959-11-23	\N
581	Jim Caviezel	1968-09-26	\N
2433	Kristanna Loken	1979-10-08	\N
814	Mr. T	1952-05-21	\N
2434	Michael Lombard	1934-08-08	2020-08-13
2435	Justin Long	1978-06-02	\N
2436	Eva Longoria	1975-03-15	\N
2437	George Lopez	1961-04-23	\N
2438	Gerry Lopez	1948-11-07	\N
2439	Phil Lord	1975-07-12	\N
2440	Darlene Love	1938-07-26	\N
2441	Yuri Lowenthal	1971-03-05	\N
2442	Peggy Lu	1963-02-22	\N
2443	Jon Lucas	1975-10-29	\N
2444	Josh Lucas	1971-06-20	\N
2445	Matt Lucas	1974-03-05	\N
2446	Ludacris	1977-09-11	\N
2447	Barbara Luddy	1908-05-25	1979-04-01
2448	Baz Luhrmann	1962-09-17	\N
2449	Joanna Lumley	1946-05-01	\N
320	Elias Koteas	1961-03-11	\N
417	Ridley Scott	1937-11-30	\N
473	Michelle Yeoh	1962-08-06	\N
2680	Alec Newman	1974-11-27	\N
2681	James L. Newman	\N	\N
2682	Thandiwe Newton	1972-11-06	\N
2683	McG	1968-08-09	\N
2684	Marisol Nichols	1973-11-02	\N
2685	Nichelle Nichols	1932-12-28	2022-07-30
2686	Rachel Nichols	1980-01-08	\N
2687	Denise Nickerson	1957-04-01	2019-07-10
2688	Bill Nighy	1949-12-12	\N
2689	John Noble	1948-08-20	\N
2690	Christopher Nolan	1970-07-30	\N
2691	Kerry Noonan	1960-01-25	\N
2692	Stephen Norrington	1964-08-03	\N
2693	Graham Norton	1963-04-04	\N
2694	Jim Norton	1938-01-04	\N
2695	Noomi Rapace	1979-12-28	\N
2696	Michael Nouri	1945-12-09	\N
2697	Don Novello	1943-01-01	\N
2698	Phillip Noyce	1950-04-29	\N
2699	Michael Nyqvist	1960-11-08	2017-06-27
2700	Dave O'Brien	1912-05-31	1969-11-08
2701	Margaret O'Brien	1937-01-15	\N
2702	Richard O'Brien	1942-03-25	\N
2703	Deirdre O'Connell	1951-12-30	\N
2704	Derrick O'Connor	1941-01-03	2018-06-29
2705	Frances O'Connor	1967-06-12	\N
2729	Barret Oliver	1973-08-24	\N
2730	Elizabeth Olsen	1989-02-16	\N
2731	Kaitlin Olson	1975-08-18	\N
4689	Albert Tsai	2004-08-05	\N
4690	Ella Jay Basco	2006-09-17	\N
4691	Mia Goth	1993-10-25	\N
4692	Camila Cabello	1997-03-03	\N
4693	Ronny Chieng	1985-11-21	\N
4694	Clark Backo	1993-09-05	\N
4695	Danielle Brooks	1989-09-17	\N
4696	Abby Ryder Fortson	2008-03-14	\N
4697	Kurt Egyiawan	\N	\N
4698	Taylor Russell	1994-07-18	\N
4699	Hayden Rolence	2004-07-15	\N
4700	Abubakar Salim	1993-01-07	\N
4701	Cara Delevingne	1992-08-12	\N
2732	Renee Olstead	1989-06-18	\N
4702	Kemp Powers	1973-10-30	\N
4703	Abby Quinn	1996-04-14	\N
4704	Harry Lawtey	1996-10-26	\N
4705	Awkwafina	1988-06-02	\N
4707	Samantha Scaffidi	1989-03-03	\N
843	Joaquin Phoenix	1974-10-28	\N
434	Terence Stamp	1938-07-22	2025-08-17
844	Slim Pickens	1919-06-28	1983-12-08
903	Rufus Sewell	1967-10-29	\N
422	Ally Sheedy	1962-06-13	\N
8	Charlton Heston	1923-10-04	2008-04-05
60	Sean Connery	1930-08-25	2020-10-31
232	Willem Dafoe	1955-07-22	\N
2562	Gerald McRaney	1947-08-19	\N
2563	Peter McRobbie	1943-01-31	\N
2564	Ian McShane	1942-09-29	\N
2565	Jamie McShane	1964-07-18	\N
2566	Graham McTavish	1961-01-04	\N
2567	James McTeigue	1967-12-29	\N
2568	Russell Means	1939-11-10	2012-10-22
2569	Derek Mears	1972-04-29	\N
2570	Olivier Megaton	1965-08-06	\N
2571	Fred Melamed	1956-05-13	\N
2572	Theodore Melfi	1970-10-27	\N
2573	Harry Melling	1989-03-17	\N
2574	Ben Mendelsohn	1969-04-03	\N
2575	Eva Mendes	1974-03-05	\N
2576	Idina Menzel	1971-05-30	\N
2577	Stephen Merchant	1974-11-24	\N
2578	Burgess Meredith	1907-11-16	1997-09-09
2579	Olga Merediz	1956-02-15	\N
2772	Chris Parnell	1967-02-05	\N
2773	Paul A. Partain	1946-11-22	2005-01-28
2774	John Pasquin	1944-11-30	\N
2775	Scott Patterson	1958-09-11	\N
2776	Mark Patton	1958-09-22	\N
2777	Scott Paulin	1950-02-13	\N
2778	Sara Paxton	1988-04-25	\N
2779	Alexander Payne	1961-02-10	\N
2780	Bruce Payne	1958-11-22	\N
2781	John Payne	1912-05-28	1989-12-06
2782	Malachi Pearson	1980-06-12	\N
2783	Bob Peck	1945-08-23	1999-04-04
2784	Josh Peck	1986-11-10	\N
2785	Simon Pegg	1970-02-14	\N
2786	Michael Peña	1976-01-13	\N
2787	Austin Pendleton	1940-03-27	\N
2788	Kal Penn	1977-04-23	\N
2789	Sergio Peris-Mencheta	1975-04-07	\N
2790	Rhea Perlman	1948-03-31	\N
2791	Valerie Perrine	1943-09-03	\N
2792	Bob Peterson	1961-01-18	\N
2793	Ian Petrella	1974-12-17	\N
2794	Brad Peyton	1978-05-27	\N
2795	Jennifer Phang	1975-10-28	\N
2796	Mackenzie Phillips	1959-11-10	\N
508	Anne Bancroft	1931-09-17	2005-06-06
510	Clive Barker	1952-10-05	\N
62	Wes Craven	1939-08-02	2015-08-30
77	Cary Elwes	1962-10-26	\N
3107	Philip Stone	1924-04-14	2003-06-15
3108	Eric Stonestreet	1971-09-09	\N
2849	Brett Ratner	1969-03-28	\N
2850	Gina Ravera	1966-05-20	\N
2851	Donnell Rawlings	1968-12-06	\N
2852	Elizabeth Reaser	1975-07-02	\N
2853	James Rebhorn	1948-09-01	2014-03-21
2854	Lance Reddick	1962-06-07	2023-03-17
2855	Helen Reddy	1941-10-25	2020-09-29
2856	William Redfield	1927-01-25	1976-08-16
2857	Alan Reed	1907-08-20	1977-06-14
2858	Christopher Reed	1967-10-17	\N
2859	Peyton Reed	1964-07-03	\N
2860	Matt Reeves	1966-04-27	\N
2861	Scott Reeves	1966-05-16	\N
2862	Kelly Reilly	1977-07-18	\N
2863	Wolfgang Reitherman	1909-06-26	1985-05-22
2864	Ivan Reitman	1946-10-27	2022-02-12
2865	Jason Reitman	1977-10-19	\N
2866	Ric Reitz	1955-09-08	\N
2867	Chris Renaud	1966-12-05	\N
2868	Jon Renfield	\N	\N
2869	Charles Renn	\N	\N
2870	Patrick Renna	1979-03-03	\N
2871	Jeremy Renner	1971-01-07	\N
2872	Callum Keith Rennie	1960-09-14	\N
2873	Natalia Reyes	1987-02-06	\N
2874	Cynthia Rhodes	1956-11-21	\N
2875	Hari Rhodes	1932-04-10	1992-01-15
2876	Matthew Rhys	1974-11-08	\N
2877	John Rhys-Davies	1944-05-05	\N
2878	Kyle Richards	1969-01-11	\N
2879	Cameron Richardson	1979-09-11	\N
2880	Kevin Michael Richardson	1964-10-25	\N
2881	Marie Richardson	1959-06-06	\N
2882	Peter Mark Richman	1927-04-16	2021-01-14
2883	Deon Richmond	1978-04-02	\N
2884	Andy Richter	1966-10-28	\N
2885	Don Rickles	1926-05-08	2017-04-06
2886	Bridgette Ridenour	1971-09-14	\N
2887	Judith Ridley	1946-09-15	\N
2888	Peter Riegert	1947-04-11	\N
511	Majel Barrett	1932-02-23	2008-12-18
512	Lionel Barrymore	1878-04-28	1954-11-15
513	Billy Barty	1924-10-25	2000-12-23
514	Jason Bateman	1969-01-14	\N
3109	Ken Stott	1955-10-19	\N
3110	Beatrice Straight	1914-08-02	2001-04-07
3111	Lee Strasberg	1901-09-17	1982-02-17
3112	Colin Strause	1976-11-08	\N
3113	Greg Strause	1975-01-16	\N
3114	Russell Streiner	1940-02-06	\N
3115	KaDee Strickland	1975-12-14	\N
3116	Elaine Stritch	1925-02-02	2014-07-17
3117	Susan Stroman	1954-10-17	\N
3118	Robert Stromberg	1965-07-16	\N
3119	Johnny Strong	1974-07-22	\N
3120	Mark Strong	1963-08-05	\N
3121	Carel Struycken	1948-07-30	\N
3122	Mel Stuart	1928-09-02	2012-08-09
3123	Wes Studi	1947-12-17	\N
3124	Michael Stuhlbarg	1968-07-05	\N
3125	Jim Sturgess	1978-05-16	\N
3126	Tom Sturridge	1985-12-05	\N
3127	Jeremy Suarez	1990-07-06	\N
3128	Alison Sudol	1984-12-23	\N
3129	Bunta Sugawara	1933-08-16	2014-11-28
3130	Erik Per Sullivan	1991-07-12	\N
3131	Susan Jennifer Sullivan	1962-11-05	\N
3132	Cree Summer	1969-07-07	\N
3133	Jeremy Sumpter	1989-02-05	\N
3134	Matthew Sunderland	\N	\N
3135	Jeremy Swift	1960-06-27	\N
3136	Tilda Swinton	1960-11-05	\N
3137	Jeannot Szwarc	1939-11-21	2025-01-14
3138	Eduardo Sánchez	1968-12-20	\N
3139	Catherine Taber	1979-12-30	\N
3141	Saïd Taghmaoui	1973-07-19	\N
3142	Hitoshi Takagi	1925-02-26	2004-02-11
3143	Akira Takarada	1934-04-29	2022-03-14
3144	Minami Takayama	1964-05-05	\N
3145	Lyle Talbot	1902-02-08	1996-03-02
3146	Jill Talley	1962-12-19	\N
3147	Lee Tamahori	1950-04-22	\N
3148	Russ Tamblyn	1934-12-30	\N
3149	Mayumi Tanaka	1955-01-15	\N
3150	Emma Tammi	1982-02-26	\N
3151	Jay Tarses	1939-07-03	\N
3152	Genndy Tartakovsky	1970-01-17	\N
3153	Jun Tatara	1917-08-04	2006-09-30
3154	Patrick Tatopoulos	1957-09-25	\N
3155	Fred Tatasciore	1967-06-15	\N
3156	Audrey Tautou	1976-08-09	\N
3157	Alan Taylor	1965-06-03	\N
3158	Don Taylor	1920-12-13	1998-12-29
3159	Holland Taylor	1943-01-14	\N
3160	James Arnold Taylor	1969-07-22	\N
3161	Jeannine Taylor	1954-06-02	\N
3162	Noah Taylor	1969-09-04	\N
3163	Sam Taylor-Johnson	1967-03-04	\N
3164	Maureen Teefy	1953-10-26	\N
3165	Andy Tennant	1955-06-15	\N
3166	David Tennant	1971-04-18	\N
3167	Minori Terada	1942-11-07	2024-03-14
3168	Lee Tergesen	1965-07-08	\N
3169	Paul Terry	1985-11-07	\N
3170	Phyllis Thaxter	1919-11-20	2012-08-14
3171	Justin Theroux	1971-08-10	\N
3172	Ernest Thesiger	1879-01-15	1961-01-14
3173	Betty Thomas	1947-07-27	\N
3174	Craig Thomas	\N	\N
3175	Dave Thomas	1949-05-20	\N
3176	Eddie Kaye Thomas	1980-10-30	\N
3177	Ellen Thomas	1964-02-03	\N
3178	Robin Thomas	1949-02-12	\N
3179	Sean Patrick Thomas	1970-12-17	\N
3180	Marsha Thomason	1976-01-19	\N
3181	Questlove	1971-01-20	\N
3182	Bill Thompson	1913-07-08	1971-07-15
315	Boris Karloff	1887-11-23	1969-02-02
3183	Brian Thompson	1959-08-28	\N
3184	Kenan Thompson	1978-05-10	\N
3185	Helen Thomson	\N	\N
3186	Michelle Thrush	1967-02-06	\N
3187	Michael Thurmeier	\N	\N
3188	Greg Tiernan	1965-06-19	\N
3189	Theresa Tilly	1953-11-06	\N
3190	Bruce Timm	1961-02-05	\N
3191	Ashley Tisdale	1985-07-02	\N
3192	Stacy Title	1964-02-21	2021-01-11
3193	Stephen Tobolowsky	1951-05-30	\N
3194	Keiko Toda	1957-09-12	\N
3195	Tony Todd	1954-12-04	2024-11-06
3196	Lauren Tom	1959-08-04	\N
3197	David Tomlinson	1917-05-07	2000-06-24
3198	Philip Tonge	1897-04-26	1959-01-28
3199	Eijirô Tôno	1907-09-17	1994-09-08
3200	Gordon Tootoosis	1941-10-25	2011-07-05
3201	Guillermo del Toro	1964-10-09	\N
3202	Shaun Toub	1958-02-15	\N
3203	Steve Toussaint	1965-03-22	\N
3204	Dan Trachtenberg	1981-05-11	\N
3205	Sam Trammell	1969-01-29	\N
3206	Henry Travers	1874-03-04	1965-10-18
3207	Arthur Treacher	1894-07-22	1975-12-14
3208	Gary Trousdale	1960-06-08	\N
3209	Verne Troyer	1969-01-01	2018-04-21
3210	Michael Trucco	1970-06-22	\N
3211	Rachel True	1966-11-15	\N
3212	Raoul Max Trujillo	1955-05-08	\N
3213	Natalie Trundy	1940-08-05	2019-12-05
3214	Yoshio Tsuchiya	1927-05-18	2017-02-08
3215	Keiko Tsushima	1926-02-07	2012-08-01
3216	Brett Tucker	1972-05-21	\N
3217	Alan Tudyk	1971-03-16	\N
3218	Paige Turco	1965-05-17	\N
3219	Guinevere Turner	1968-05-23	\N
3220	Tina Turner	1939-11-26	2023-05-24
3221	Tom Tykwer	1965-05-23	\N
3222	Tyrese Gibson	1978-12-30	\N
3223	Leslie Uggams	1943-05-25	\N
3224	Gaspard Ulliel	1984-11-25	2022-01-19
3225	Martin Umbach	1956-03-16	\N
3226	Lee Unkrich	1967-08-08	\N
3227	Karl Urban	1972-06-07	\N
3228	Stephen Ure	1958-03-28	\N
3229	Susan Ursitti	1957-09-17	\N
3230	Brenda Vaccaro	1939-11-18	\N
3231	Holly Valance	1983-05-11	\N
3232	Steve Valentine	1966-10-26	\N
3233	Maila Nurmi	1922-12-11	2008-01-10
3234	Emily VanCamp	1986-05-12	\N
3235	Phillip Van Dyke	1984-06-13	\N
3236	Dick Van Patten	1928-12-09	2015-06-23
3237	Luis Van Rooten	1906-11-29	1973-06-17
3238	Edward Van Sloan	1882-11-01	1964-03-06
3239	Nia Vardalos	1962-09-24	\N
3240	Valentina Vargas	1964-12-31	\N
3241	Indira Varma	1973-09-27	\N
3242	Matthew Vaughn	1971-03-07	\N
2951	Bill Sage	1962-04-03	\N
82	Michael J. Fox	1961-06-09	\N
1856	Bill Fagerbakke	1957-10-04	\N
1857	Michelle Fairley	1963-07-11	\N
1858	Donald Faison	1974-06-22	\N
1859	James Apaumut Fall	\N	\N
1890	Paul Fisher	\N	\N
515	Kathy Bates	1948-06-28	\N
516	Belinda Bauer	1950-06-13	\N
517	Michael Bay	1965-02-17	\N
518	Jennifer Beals	1963-12-19	\N
3243	Emmanuelle Vaugier	1976-06-23	\N
3244	Alexa PenaVega	1988-08-27	\N
3245	Paz Vega	1976-01-02	\N
3246	Conrad Veidt	1893-01-22	1943-04-03
3247	Patricia Velasquez	1971-01-31	\N
85	Gina Gershon	1962-06-10	\N
335	Matthew Lillard	1970-01-24	\N
98	Helen Hunt	1963-06-15	\N
91	Teri Hatcher	1964-12-08	\N
95	Dustin Hoffman	1937-08-08	\N
96	Anthony Hopkins	1937-12-31	\N
97	Ron Howard	1954-03-01	\N
99	Elizabeth Hurley	1965-06-10	\N
2027	Frank Grillo	1965-06-08	\N
104	Harvey Keitel	1939-05-13	\N
2028	Rupert Grint	1988-08-24	\N
2029	Sylvester Groth	1958-03-31	\N
2226	Wen Jiang	1963-01-05	\N
107	Kevin Kline	1947-10-24	\N
3248	Diane Venora	1952-08-10	\N
2706	Kevin J. O'Connor	1963-11-15	\N
519	Ned Beatty	1937-07-06	2021-06-13
520	Bonnie Bedelia	1948-03-25	\N
521	Ralph Bellamy	1904-06-17	1991-11-29
523	Jim Belushi	1954-06-15	\N
108	Diane Lane	1965-01-22	\N
157	Charlize Theron	1975-08-07	\N
253	Roland Emmerich	1955-11-10	\N
258	Peter Falk	1927-09-16	2011-06-23
225	Denise Crosby	1957-11-24	\N
242	Brad Dourif	1950-03-18	\N
259	Chris Farley	1964-02-15	1997-12-18
110	David Lean	1908-03-25	1991-04-16
248	Robert Duvall	1931-01-05	\N
128	Bill Paxton	1955-05-17	2017-02-25
131	River Phoenix	1970-08-23	1993-10-31
158	Uma Thurman	1970-04-29	\N
243	Robert Downey Jr.	1965-04-04	\N
249	Anthony Edwards	1962-07-19	\N
260	Terry Farrell	1963-11-19	\N
254	Robert Englund	1947-06-06	\N
263	David Fincher	1962-08-28	\N
265	Laurence Fishburne	1961-07-30	\N
266	Carrie Fisher	1956-10-21	2016-12-27
267	Bridget Fonda	1964-01-27	\N
269	Vivica A. Fox	1964-07-30	\N
271	Brendan Fraser	1968-12-03	\N
270	Jonathan Frakes	1952-08-19	\N
272	Stephen Fry	1957-08-24	\N
88	Jeff Goldblum	1952-10-22	\N
92	Ethan Hawke	1970-11-06	\N
244	Fran Drescher	1957-09-30	\N
245	Richard Dreyfuss	1947-10-29	\N
256	Emilio Estevez	1962-05-12	\N
257	Rupert Everett	1959-05-29	\N
261	Corey Feldman	1971-07-16	\N
304	Holly Hunter	1958-03-20	\N
303	John Hughes	1950-02-18	2009-08-06
282	John Goodman	1952-06-20	\N
306	William Hurt	1950-03-20	2022-03-13
310	Jean-Pierre Jeunet	1953-09-03	\N
311	Don Johnson	1949-12-15	\N
313	Jeffrey Jones	1946-09-28	\N
317	Michael Keaton	1951-09-05	\N
319	Walter Koenig	1936-09-14	\N
321	Alice Krige	1954-06-28	\N
323	John Landis	1950-08-03	\N
325	Heather Langenkamp	1964-07-17	\N
329	Spike Lee	1957-03-20	\N
340	Bela Lugosi	1882-10-17	1956-08-16
342	Shirley MacLaine	1934-04-24	\N
2155	Paul Hoen	1961-12-28	\N
344	William H. Macy	1950-03-13	\N
2156	Rick Hoffman	1970-06-12	\N
525	Annette Bening	1958-05-29	\N
349	Mary Stuart Masterson	1966-06-28	\N
352	Frances McDormand	1957-06-23	\N
354	Gates McFadden	1949-03-02	\N
356	Rose McGowan	1973-09-05	\N
355	Kelly McGillis	1957-07-09	\N
358	Dina Meyer	1968-12-22	\N
345	Michael Madsen	1957-09-25	2025-07-03
357	Colm Meaney	1953-05-30	\N
360	Sal Mineo	1939-01-10	1976-02-12
362	Matthew Modine	1959-03-22	\N
364	Dermot Mulroney	1963-10-31	\N
366	Liam Neeson	1952-06-07	\N
363	Alfred Molina	1953-05-24	\N
365	Eddie Murphy	1961-04-03	\N
367	Sam Neill	1947-09-14	\N
368	Judd Nelson	1959-11-28	\N
369	Olivia Newton-John	1948-09-26	2022-08-08
373	Nick Nolte	1941-02-08	\N
374	Chris O'Donnell	1970-06-26	\N
375	Peter O'Toole	1932-08-02	2013-12-14
372	Leonard Nimoy	1931-03-26	2015-02-27
378	Sarah Jessica Parker	1965-03-25	\N
376	Frank Oz	1944-05-25	\N
382	Anthony Perkins	1932-04-04	1992-09-12
526	Robby Benson	1956-01-21	\N
527	Peter Berg	1964-03-11	\N
528	Sandahl Bergman	1951-11-14	\N
540	Joan Blondell	1906-08-30	1979-12-25
333	Téa Leoni	1966-02-25	\N
279	Danny Glover	1946-07-22	\N
287	Mark Hamill	1951-09-25	\N
288	Daryl Hannah	1960-12-03	\N
289	Woody Harrelson	1961-07-23	\N
290	Ed Harris	1950-11-28	\N
359	Bette Midler	1945-12-01	\N
361	Helen Mirren	1945-07-26	\N
398	Harold Ramis	1944-11-21	2014-02-24
416	Liev Schreiber	1967-10-04	\N
423	Martin Sheen	1940-08-03	\N
126	Gary Oldman	1958-03-21	\N
385	Wolfgang Petersen	1941-03-14	2022-08-12
403	Paul Reubens	1952-08-27	2023-07-30
415	Rene Russo	1954-02-17	\N
418	Jerry Seinfeld	1954-04-29	\N
2242	Freddie Jones	1927-09-12	2019-07-09
419	Tom Selleck	1945-01-29	\N
421	William Shatner	1931-03-22	\N
424	Gary Sinise	1955-03-17	\N
425	Marina Sirtis	1955-03-29	\N
427	Helen Slater	1963-12-15	\N
426	Tom Skerritt	1933-08-25	\N
430	Talisa Soto	1967-03-27	\N
435	Eric Stoltz	1961-09-30	\N
436	David Strathairn	1949-01-26	\N
438	Tami Stronach	1972-07-31	\N
439	Donald Sutherland	1935-07-17	2024-06-20
420	Peter Sellers	1925-09-08	1980-07-24
440	Kiefer Sutherland	1966-12-21	\N
442	D.B. Sweeney	1961-11-14	\N
444	David Thewlis	1963-03-20	\N
445	Emma Thompson	1959-04-15	\N
443	Lili Taylor	1967-02-20	\N
503	John Badham	1939-08-25	\N
504	Stuart Baird	1947-01-14	\N
505	Kathy Baker	1950-06-08	\N
506	Ralph Bakshi	1938-10-29	\N
12	Henry Fonda	1905-05-16	1982-08-12
400	Vanessa Redgrave	1937-01-30	\N
402	Jean Reno	1948-07-30	\N
399	Robert Redford	1936-08-18	2025-09-16
486	Francesca Annis	1945-05-14	\N
487	David Anspaugh	1946-09-24	\N
489	Michael Apted	1941-02-10	2021-01-08
491	Asia Argento	1975-09-20	\N
492	Bess Armstrong	1953-12-11	\N
493	Jack Arnold	1912-10-14	1992-03-17
494	Tom Arnold	1959-03-06	\N
495	Linden Ashby	1960-05-23	\N
497	Mary Astor	1906-05-03	1987-09-25
498	Frankie Avalon	1940-09-18	\N
499	John G. Avildsen	1935-12-21	2017-06-16
500	Lew Ayres	1908-12-28	1996-12-30
464	Wil Wheaton	1972-07-29	\N
501	Shabana Azmi	1950-09-18	\N
462	Peter Weller	1947-06-24	\N
502	Amitabh Bachchan	1942-10-11	\N
465	Billy Wilder	1906-06-22	2002-03-27
466	Gene Wilder	1933-06-11	2016-08-29
467	Michael Wincott	1958-01-21	\N
468	Kate Winslet	1975-10-05	\N
469	Reese Witherspoon	1976-03-22	\N
470	BD Wong	1960-10-24	\N
475	Billy Zane	1966-02-24	\N
476	Robert Zemeckis	1951-05-14	\N
477	Ian Abercrombie	1934-09-11	2012-01-26
478	F. Murray Abraham	1939-10-24	\N
482	Tim Allen	1953-06-13	\N
483	Maria Conchita Alonso	1957-06-29	\N
480	Casey Affleck	1975-08-12	\N
484	Don Ameche	1908-05-31	1993-12-06
457	Jon Voight	1938-12-29	\N
456	Paul Verhoeven	1938-07-18	\N
458	Christopher Walken	1943-03-31	\N
461	Lesley Ann Warren	1946-08-16	\N
471	Elijah Wood	1981-01-28	\N
474	Sean Young	1959-11-20	\N
472	Robin Wright	1966-04-08	\N
507	Martin Balsam	1919-11-04	1996-02-13
5362	Jay Ali	1982-03-29	\N
542	Ward Bond	1903-04-09	1960-11-05
543	Jan de Bont	1943-10-22	\N
545	Stephen Boyd	1931-07-04	1977-06-02
546	Danny Boyle	1956-10-20	\N
2427	Gene Lockhart	1891-07-17	1957-03-31
2428	Gary Lockwood	1937-02-21	\N
2429	Annie Ross	1930-07-26	2020-07-21
3478	Juno Temple	1989-07-21	\N
3672	Alex Hassell	1980-09-17	\N
3673	Lee Sun-kyun	1975-03-02	2023-12-27
3688	Dhanush	1983-07-28	\N
547	Lorraine Bracco	1954-10-02	\N
548	Eric Braeden	1941-04-03	\N
549	Jonathan Brandis	1976-04-13	2003-11-12
677	John Gavin	1931-04-08	2018-02-09
2466	Fred MacMurray	1908-08-30	1991-11-05
2467	Robert MacNaughton	1966-12-19	\N
2468	Tress MacNeille	1951-06-20	\N
2469	Peter Macon	1982-05-18	\N
3647	50 Cent	1975-07-06	\N
3817	Julius Onah	1983-02-10	\N
3818	Jessica Chastain	1977-03-24	\N
3819	Fantasia Barrino	1984-06-30	\N
3820	Wilson Bethel	1984-02-24	\N
550	Nicoletta Braschi	1960-04-19	\N
552	Martin Brest	1951-08-08	\N
553	Wilford Brimley	1934-09-27	2020-08-01
554	Jim Broadbent	1949-05-24	\N
2471	Aki Maeda	1985-07-11	\N
2472	Patrick Magee	1922-03-31	1982-08-14
81	Jodie Foster	1962-11-19	\N
35	Woody Allen	1935-11-30	\N
190	Adam Baldwin	1962-02-27	\N
41	Fairuza Balk	1974-05-21	\N
43	Drew Barrymore	1975-02-22	\N
53	Neve Campbell	1973-10-03	\N
55	Tia Carrere	1967-01-02	\N
71	Bo Derek	1956-11-20	\N
72	Leonardo DiCaprio	1974-11-11	\N
78	Ralph Fiennes	1962-12-22	\N
79	Colin Firth	1960-09-10	\N
80	Harrison Ford	1942-07-13	\N
86	Mel Gibson	1956-01-03	\N
93	Salma Hayek	1966-09-02	\N
114	Dolph Lundgren	1957-11-03	\N
133	Parker Posey	1968-11-08	\N
140	Winona Ryder	1971-10-29	\N
204	Helena Bonham Carter	1966-05-26	\N
221	Glenn Close	1947-03-19	\N
90	Tom Hanks	1956-07-09	\N
203	Brian Blessed	1936-10-09	\N
94	Anne Heche	1969-05-25	2022-08-11
32	Armin Mueller-Stahl	1930-12-17	\N
556	Josh Brolin	1968-02-12	\N
557	Albert Brooks	1947-07-22	\N
558	Avery Brooks	1948-10-02	\N
559	Jim Brown	1936-02-17	2023-05-18
562	Raymond Burr	1917-05-21	1993-09-12
568	James Caan	1940-03-26	2022-07-06
569	Simon Callow	1949-06-13	\N
570	John Candy	1950-10-30	1994-03-04
571	Frank Capra	1897-05-18	1991-09-03
573	Robert Carlyle	1961-04-14	\N
574	David Carradine	1936-12-08	2009-06-03
575	Veronica Cartwright	1949-04-20	\N
577	John Cassavetes	1929-12-09	1989-02-03
3955	Cho Yeo-jeong	1981-02-10	\N
3957	Alessandro Carloni	\N	\N
524	Roberto Benigni	1952-10-27	\N
564	LeVar Burton	1957-02-16	\N
578	Nick Cassavetes	1959-05-21	\N
579	Joanna Cassidy	1945-08-02	\N
496	Edward Asner	1929-11-15	2021-08-29
662	James Foley	1953-12-28	2025-05-06
717	Werner Herzog	1942-09-05	\N
726	Leslie Howard	1893-04-03	1943-06-01
731	Linda Hunt	1945-04-02	\N
582	John Cazale	1935-08-12	1978-03-12
584	Josh Charles	1971-09-15	\N
585	Rae Dawn Chong	1961-02-28	\N
586	Tommy Chong	1938-05-24	\N
587	Andrew Dice Clay	1957-09-29	\N
588	Ethan Coen	1957-09-21	\N
597	Sofia Coppola	1971-05-14	\N
606	Jon Cryer	1965-04-16	\N
607	Ice Cube	1969-06-15	\N
608	Kieran Culkin	1982-09-30	\N
609	Alan Cumming	1965-01-27	\N
610	Peter Cushing	1913-05-26	1994-08-11
611	Henry Czerny	1959-02-08	\N
613	Charles Dance	1946-10-10	\N
615	Joe Dante	1946-11-28	\N
616	Frank Darabont	1959-01-28	\N
617	Robert Davi	1951-06-26	\N
618	Jaye Davidson	1968-03-21	\N
619	Embeth Davidtz	1965-08-11	\N
620	Jeremy Davies	1969-10-08	\N
621	Warwick Davis	1970-02-03	\N
622	Bruce Davison	1946-06-28	\N
623	Ellen DeGeneres	1958-01-26	\N
624	Dom DeLuise	1933-08-01	2009-05-04
626	Dana Delany	1956-03-13	\N
627	Jonathan Demme	1944-02-22	2017-04-26
628	Patrick Dempsey	1966-01-13	\N
629	Judi Dench	1934-12-09	\N
630	Brian Dennehy	1938-07-09	2020-04-15
631	Bruce Dern	1936-06-04	\N
632	Shannen Doherty	1971-04-12	2024-07-13
634	James Doohan	1920-03-03	2005-07-20
635	Stephen Dorff	1973-07-29	\N
636	Olympia Dukakis	1931-06-20	2021-05-01
637	Keir Dullea	1936-05-30	\N
638	Faye Dunaway	1941-01-14	\N
639	Griffin Dunne	1955-06-08	\N
640	Charles Durning	1923-02-28	2012-12-24
641	Charles S. Dutton	1951-01-30	\N
642	Shelley Duvall	1949-07-07	2024-07-11
643	George Dzundza	1945-07-19	\N
644	Christopher Eccleston	1964-02-16	\N
645	Aaron Eckhart	1968-03-12	\N
646	Carmen Electra	1972-04-20	\N
647	Hector Elizondo	1936-12-22	\N
648	Denholm Elliott	1922-05-31	1992-10-06
649	Noah Emmerich	1965-02-27	\N
650	David Prowse	1935-07-01	2020-11-29
652	Mia Farrow	1945-02-09	\N
653	José Ferrer	1912-01-08	1992-01-26
1	Lauren Bacall	1924-09-16	2014-08-12
33	John Cleese	1939-10-27	\N
654	Miguel Ferrer	1955-02-07	2017-01-19
656	Harvey Fierstein	1954-06-06	\N
353	Malcolm McDowell	1943-06-13	\N
657	Albert Finney	1936-05-09	2019-02-07
658	Fionnula Flanagan	1941-12-10	\N
660	Louise Fletcher	1934-07-21	2022-09-23
661	Lara Flynn Boyle	1970-03-24	\N
408	Joely Richardson	1965-01-09	\N
663	Peter Fonda	1940-02-23	2019-08-16
676	James Garner	1928-04-07	2014-07-19
678	Ben Gazzara	1930-08-28	2012-02-03
681	John Glover	1944-08-07	\N
684	Louis Gossett Jr.	1936-05-27	2024-03-29
688	Kelsey Grammer	1955-02-21	\N
689	Richard E. Grant	1957-05-05	\N
693	Charles Grodin	1935-04-21	2021-05-18
2710	Brian O'Halloran	1969-12-20	\N
2711	Jack O'Halloran	1943-04-08	\N
3864	Carey Mulligan	1985-05-28	\N
529	Elizabeth Berkley	1972-07-28	\N
544	Barry Bostwick	1945-02-24	\N
614	Jeff Daniels	1955-02-19	\N
682	Bobcat Goldthwait	1962-05-26	\N
784	John Mahoney	1940-06-20	2018-02-04
226	Billy Crystal	1948-03-14	\N
278	Crispin Glover	1964-04-20	\N
347	John Malkovich	1953-12-09	\N
785	Tina Majorino	1985-02-07	\N
786	Joe Mantegna	1947-11-13	\N
294	Goldie Hawn	1945-11-21	\N
229	Joan Cusack	1962-10-11	\N
275	Janeane Garofalo	1964-09-28	\N
285	Gene Hackman	1930-01-30	2025-02-17
463	Joanne Whalley	1961-08-25	\N
29	Orson Welles	1915-05-06	1985-10-10
83	Morgan Freeman	1937-06-01	\N
122	Julianne Moore	1960-12-03	\N
166	Sigourney Weaver	1949-10-08	\N
26	Gregory Peck	1916-04-05	2003-06-12
216	Stockard Channing	1944-02-13	\N
230	Beverly D'Angelo	1951-11-15	\N
386	Robert Picardo	1953-10-27	\N
239	Laura Dern	1967-02-10	\N
331	Jennifer Jason Leigh	1962-02-05	\N
339	Julia Louis-Dreyfus	1961-01-13	\N
346	Virginia Madsen	1961-09-11	\N
370	Brigitte Nielsen	1963-07-15	\N
412	Tim Roth	1961-05-14	\N
450	Jeanne Tripplehorn	1963-06-10	\N
460	Sela Ward	1956-07-11	\N
787	Cheech Marin	1946-07-13	\N
788	Penny Marshall	1943-10-15	2018-12-17
3	Ingrid Bergman	1915-08-29	1982-08-29
220	Chow Yun-Fat	1955-05-18	\N
2712	Paige O'Hara	1956-05-10	\N
34	Brad Pitt	1963-12-18	\N
105	Nicole Kidman	1967-06-20	\N
101	Tommy Lee Jones	1946-09-15	\N
84	Richard Gere	1949-08-31	\N
121	Demi Moore	1962-11-11	\N
155	Sharon Stone	1958-03-10	\N
176	Karen Allen	1951-10-05	\N
197	Kate Beckinsale	1973-07-26	\N
217	Chevy Chase	1943-10-08	\N
246	Minnie Driver	1970-01-31	\N
286	Corey Haim	1971-12-23	2010-03-10
2713	Dan O'Herlihy	1919-05-02	2005-02-17
433	Brent Spiner	1949-02-02	\N
560	Betty Buckley	1947-07-03	\N
583	Lon Chaney Jr.	1906-02-10	1973-07-12
603	Bing Crosby	1903-05-03	1977-10-14
633	Richard Donner	1930-04-24	2021-07-05
488	Christina Applegate	1971-11-25	\N
490	Eve Arden	1908-04-30	1990-11-12
889	Eva Marie Saint	1924-07-04	\N
890	George Sanders	1906-07-03	1972-04-25
891	Chris Sarandon	1942-07-24	\N
30	Natalie Wood	1938-07-20	1981-11-29
293	Rutger Hauer	1944-01-23	2019-07-19
892	Devon Sawa	1978-09-07	\N
667	John Forsythe	1918-01-29	2010-04-01
268	Jane Fonda	1937-12-21	\N
686	Elliott Gould	1938-08-29	\N
28	James Stewart	1908-05-20	1997-07-02
36	Jennifer Aniston	1969-02-11	\N
73	Cameron Diaz	1972-08-30	\N
120	Ewan McGregor	1971-03-31	\N
152	Steven Spielberg	1946-12-18	\N
167	Robin Williams	1951-07-21	2014-08-11
175	Joan Allen	1956-08-20	\N
218	Don Cheadle	1964-11-29	\N
273	Edward Furlong	1977-08-02	\N
281	Cuba Gooding Jr.	1968-01-02	\N
302	Dennis Hopper	1936-05-17	2010-05-29
336	Richard Linklater	1960-07-30	\N
431	Sissy Spacek	1949-12-25	\N
479	Joss Ackland	1928-02-29	2023-11-19
24	Maureen O'Hara	1920-08-17	2015-10-24
170	Ed Wood	1924-10-10	1978-12-10
165	Denzel Washington	1954-12-28	\N
219	Cher	1946-05-20	\N
236	Brian De Palma	1940-09-11	\N
343	Elle Macpherson	1964-03-29	\N
215	Jackie Chan	1954-04-07	\N
334	Juliette Lewis	1973-06-21	\N
153	Sylvester Stallone	1946-07-06	\N
238	Gérard Depardieu	1948-12-27	\N
284	Jennifer Grey	1960-03-26	\N
338	Christopher Lloyd	1938-10-22	\N
348	Sophie Marceau	1966-11-17	\N
231	Vincent D'Onofrio	1959-06-30	\N
247	Kirsten Dunst	1982-04-30	\N
252	Sam Elliott	1944-08-09	\N
251	Danny Elfman	1953-05-29	\N
350	Heather Matarazzo	1982-11-10	\N
351	Samantha Mathis	1970-05-12	\N
371	Leslie Nielsen	1926-02-11	2010-11-28
379	Dolly Parton	1946-01-19	\N
401	John C. Reilly	1965-05-24	\N
428	Wesley Snipes	1962-07-31	\N
429	Paul Sorvino	1939-04-13	2022-07-25
432	James Spader	1960-02-07	\N
437	Meryl Streep	1949-06-22	\N
2714	Jason O'Mara	1972-08-06	\N
2715	Shaquille O'Neal	1972-03-06	\N
895	Rob Schneider	1963-10-31	\N
2716	Ed O'Neill	1946-04-12	\N
4032	Cheyenne Jackson	1975-07-12	\N
979	Kari Wuhrer	1967-04-28	\N
89	Linda Hamilton	1956-09-26	\N
100	Samuel L. Jackson	1948-12-21	\N
102	Milla Jovovich	1975-12-17	\N
103	Ashley Judd	1968-04-19	\N
112	Jennifer Lopez	1969-07-24	\N
113	George Lucas	1944-05-14	\N
117	Steve Martin	1945-08-14	\N
123	Bill Murray	1950-09-21	\N
124	Mike Myers	1963-05-25	\N
132	Natalie Portman	1981-06-09	\N
143	Arnold Schwarzenegger	1947-07-30	\N
150	Will Smith	1968-09-25	\N
151	Kevin Spacey	1959-07-26	\N
156	Quentin Tarantino	1963-03-27	\N
163	Jean-Claude Van Damme	1960-10-18	\N
174	Jenny Agutter	1952-12-20	\N
173	Ben Affleck	1972-08-15	\N
177	Nancy Allen	1950-06-24	\N
178	Kirstie Alley	1951-01-12	2022-12-05
179	Ursula Andress	1936-03-19	\N
192	Stephen Baldwin	1966-05-12	\N
193	Christian Bale	1974-01-30	\N
191	Alec Baldwin	1958-04-03	\N
980	Noah Wyle	1971-06-04	\N
4370	Luke Pasqualino	1990-02-19	\N
2717	Genevieve O'Reilly	1977-01-06	\N
1113	Kimberly J. Brown	1984-11-16	\N
1114	Saffron Burrows	1972-10-22	\N
1115	Scott Caan	1976-08-23	\N
4528	Jack Lowden	1990-06-02	\N
1264	Gwen Stefani	1969-10-03	\N
1265	Julia Stiles	1981-03-28	\N
1266	Peter Strauss	1947-02-20	\N
1267	Nicole Sullivan	1970-04-21	\N
4388	Tess Malis Kincaid	\N	\N
2720	Shane Obedzinski	1982-07-26	\N
2721	Bob Odenkirk	1962-10-22	\N
4716	Jasmin Savoy Brown	1994-03-21	\N
2722	Steve Oedekerk	1961-11-27	\N
2723	Nick Offerman	1970-06-26	\N
2724	George Ogilvie	1931-03-05	2020-04-05
2725	Sandra Oh	1971-07-20	\N
2726	Sophie Okonedo	1968-08-11	\N
1403	Christopher Daniel Barnes	1972-11-07	\N
1404	Sacha Baron Cohen	1971-10-13	\N
1405	Adriana Barraza	1956-03-05	\N
1406	Bill Barretta	1964-06-19	\N
1407	Marco Barricelli	1958-08-02	\N
1408	Chris Barrie	1960-03-28	\N
1409	Diana Barrows	1971-01-23	\N
1410	Roger Bart	1962-09-29	\N
1479	Bono	1960-05-10	\N
2727	Ken Olandt	1958-04-22	\N
2728	Jay Oliva	1976-01-01	\N
2804	Pitof	1957-07-04	\N
683	Tony Goldwyn	1960-05-20	\N
685	Michael Gough	1916-11-23	2011-03-17
696	Fred Gwynne	1926-07-10	1993-07-02
714	Jim Henson	1936-09-24	1990-05-16
692	Graham Greene	1952-06-22	2025-09-01
715	Edward Herrmann	1943-07-21	2014-12-31
716	Barbara Hershey	1948-02-05	\N
698	Anthony Michael Hall	1968-04-14	\N
699	Philip Baker Hall	1931-09-10	2022-06-12
700	Geri Horner	1972-08-06	\N
701	George Hamilton	1939-08-12	\N
702	John Hannah	1962-04-23	\N
703	Marcia Gay Harden	1959-08-14	\N
704	Renny Harlin	1959-03-15	\N
705	Richard Harris	1930-10-01	2002-10-25
706	Rex Harrison	1908-03-05	1990-06-02
708	Josh Hartnett	1978-07-21	\N
709	David Hasselhoff	1952-07-17	\N
710	Nigel Hawthorne	1929-04-05	2001-12-26
711	Sterling Hayden	1916-03-26	1986-05-23
712	John Heard	1946-03-07	2017-07-21
713	Tippi Hedren	1930-01-19	\N
4706	Lilimar	2000-06-02	\N
2656	Michael Murphy	1938-05-05	\N
2657	Brian Murray	1937-09-10	\N
2658	Don Murray	1929-07-31	2024-02-02
2845	Anthony Rapp	1971-10-26	\N
2523	Jodhi May	1975-05-08	\N
2524	Les Mayfield	1959-11-30	\N
2525	Peter Mayhew	1944-05-19	2019-04-30
2526	James McAvoy	1979-04-21	\N
2527	Chi McBride	1961-09-23	\N
2528	Simon McBurney	1957-08-25	\N
2529	Frances Lee McCain	1944-07-28	\N
2530	Rory McCann	1969-04-24	\N
2531	Melissa McCarthy	1970-08-26	\N
2532	Jesse McCartney	1987-04-09	\N
2533	Zahn McClarnon	1966-10-24	\N
2534	Marc McClure	1957-03-31	\N
2535	Warren McCollum	1918-11-30	1987-12-21
2536	Bill McCutcheon	1924-05-23	2002-01-09
2537	Martine McCutcheon	1976-05-14	\N
2538	Audra McDonald	1970-07-03	\N
2539	Kevin McDonald	1961-05-16	\N
2540	Neal McDonough	1966-02-13	\N
2541	Michael McElhatton	1963-09-12	\N
2542	Connie Riet	1969-09-09	\N
2543	Darren McGavin	1922-05-07	2006-02-25
2544	Everett McGill	1945-10-21	\N
2545	Tom McGrath	1964-08-07	\N
2546	Gavin Rossdale	1965-10-30	\N
2547	Joel McHale	1971-11-20	\N
2548	Tim McInnerny	1956-09-18	\N
2549	John McIntire	1907-06-27	1991-01-30
2550	Rose McIver	1988-10-10	\N
2551	Adam McKay	1968-04-17	\N
2552	Michael McKean	1947-10-17	\N
2553	Jacqueline McKenzie	1967-10-24	\N
2554	Kevin McKidd	1973-08-09	\N
2555	Kate McKinnon	1984-01-06	\N
2556	Zoe McLellan	1974-11-06	\N
2557	Tom McLoughlin	1950-07-19	\N
2558	Julian McMahon	1968-07-27	2025-07-02
2559	Kenneth McMillan	1932-07-02	1989-01-08
2560	Kevin McNally	1956-04-27	\N
2561	Ian McNeice	1950-10-02	\N
2580	Ryan Merriman	1983-04-10	\N
2581	Chris Messina	1974-08-11	\N
2582	Laurie Metcalf	1955-06-16	\N
2583	Jason Mewes	1974-06-12	\N
2590	Lee Millar	1924-06-13	1980-09-21
2591	Aubree Miller	1979-01-15	\N
2592	Christopher Miller	1975-09-23	\N
2593	Frank Miller	1957-01-27	\N
2594	Jason Miller	1939-04-22	2001-05-13
2595	Jean Miller	1904-04-13	1989-10-31
2596	Kristen Miller	1976-08-20	\N
2597	Wentworth Miller	1972-06-02	\N
2598	Steve Miner	1951-06-18	\N
2599	Rob Minkoff	1962-08-11	\N
2600	Vincente Minnelli	1903-02-28	1986-07-25
2601	Lexi Alexander	1974-08-23	\N
2602	Lin-Manuel Miranda	1980-01-16	\N
2604	Elizabeth Mitchell	1970-03-27	\N
2605	Mike Mitchell	1970-10-18	\N
2606	Thomas Mitchell	1892-07-10	1962-12-17
2607	Rhona Mitra	1976-08-09	\N
2608	Akihiro Miwa	1935-05-15	\N
2609	Seiji Miyaguchi	1913-11-14	1985-04-12
2610	Hayao Miyazaki	1941-01-05	\N
2611	Jason Momoa	1979-08-01	\N
2612	Taylor Momsen	1993-07-26	\N
2613	Dominic Monaghan	1976-12-08	\N
2614	Paolo Montalban	1973-05-21	\N
2615	Chris Month	1953-02-06	\N
2616	Sheri Moon Zombie	1970-09-26	\N
2617	John Moore	1970-01-01	\N
2618	Mandy Moore	1984-04-10	\N
2619	Melanie Paxson	1972-09-26	\N
2620	Rich Moore	1963-05-10	\N
2621	Scott Moore	\N	\N
2622	Pierre Morel	1964-05-12	\N
2623	Antonio Moreno	1887-09-24	1987-02-15
2624	Cindy Morgan	1954-09-29	2023-12-30
2625	Frank Morgan	1890-06-01	1949-09-18
2626	Jeffrey Dean Morgan	1966-04-22	\N
2627	Robbi Morgan	1961-07-19	\N
2628	Tracy Morgan	1968-11-10	\N
2629	Trevor Morgan	1986-11-26	\N
2630	Robert Morley	1908-05-26	1992-06-03
2631	Haviland Morris	1959-09-14	\N
2632	John Morris	1984-10-02	\N
2633	Phil Morris	1959-04-04	\N
2634	Jennifer Morrison	1979-04-12	\N
2635	Kenny Morrison	1974-12-31	\N
2636	Temuera Morrison	1960-12-26	\N
2637	Tommy Morrison	1969-01-02	2013-09-01
2638	Emily Mortimer	1971-12-01	\N
2639	Joe Morton	1947-10-18	\N
2640	Rocky Morton	1955-02-20	\N
2641	Samantha Morton	1977-05-13	\N
2642	William Moseley	1987-04-27	\N
2643	Scott Mosier	1971-03-05	\N
2644	Josh Mostel	1946-12-21	\N
2645	Jonathan Mostow	1961-11-28	\N
2646	Anson Mount	1973-02-25	\N
2647	Wagner Moura	1976-06-27	\N
2648	Martin Mull	1943-08-18	2024-06-27
2649	Peter Mullan	1959-11-02	\N
2650	Lochlyn Munro	1966-02-12	\N
2651	Warren Munson	1933-11-30	\N
2652	Ana Ofelia Murguía	1933-12-08	2023-12-31
2653	Cillian Murphy	1976-05-25	\N
2654	Donna Murphy	1959-03-07	\N
2655	Doug Murphy	\N	\N
2659	Joel Murray	1963-04-17	\N
2660	Andy Muschietti	1973-08-26	\N
2661	John Musker	1953-11-08	\N
2662	Kim Myers	1966-02-15	\N
2663	Daniel Myrick	1962-11-30	\N
2664	Parminder Nagra	1975-10-05	\N
2665	Takashi Naitô	1955-05-27	\N
2666	Jack Nance	1943-12-21	1996-12-30
2667	Charles Napier	1936-04-12	2011-10-05
2668	Kevin Nash	1959-07-09	\N
2669	Mari Natsuki	1952-05-02	\N
2670	David Naughton	1951-02-13	\N
2671	Edwin Neal	1945-07-12	\N
2672	Stacey Nelkin	1959-09-10	\N
2673	Jerry Nelson	1934-07-10	2012-08-24
2674	John Allen Nelson	1959-08-28	\N
2675	Mark Nelson	1955-09-26	\N
2676	Tim Blake Nelson	1964-05-11	\N
2677	Franco Nero	1941-11-23	\N
2678	James Nesbitt	1965-01-15	\N
2679	Bob Newhart	1929-09-05	2024-07-18
2707	Una O'Connor	1880-10-22	1959-02-04
2708	Judith O'Dea	1945-04-20	\N
2709	Cathy O'Donnell	1923-07-06	1970-04-11
2718	Ed O'Ross	1946-07-04	\N
2719	Colleen O'Shaughnessey	1971-09-15	\N
2750	Alfie Allen	1986-09-12	\N
6212	Ken Kaufman	\N	\N
6362	Amos Vernon	\N	\N
3727	Bob Bowen	\N	\N
7308	Gabe Snyder	\N	\N
3249	Vera-Ellen	1921-02-16	1981-08-30
3250	Gore Verbinski	1964-03-16	\N
3251	Maribel Verdú	1970-10-02	\N
3252	Tom Verica	1964-05-13	\N
3253	Renee Victor	1953-06-15	\N
3254	John Viener	1972-07-10	\N
3255	Denis Villeneuve	1967-10-03	\N
3256	Pruitt Taylor Vince	1960-07-05	\N
3257	Goran Visnjic	1972-09-09	\N
3258	Mike Vitar	1978-12-21	\N
3259	Hans Heinrich von Twardowski	1898-05-04	1958-11-19
3260	Gustav von Wangenheim	1895-02-18	1975-10-14
3261	Arnold Vosloo	1962-06-16	\N
3262	Yuliya Vysotskaya	1973-08-16	\N
3263	Luna Lauren Velez	1964-11-02	\N
7466	Zeke Alton	\N	\N
1456	Brad Bird	1957-09-24	\N
1457	Jack Black	1969-08-28	\N
1458	Lewis Black	1948-08-30	\N
1459	Lucas Black	1982-11-29	\N
1460	Sidney Blackmer	1895-07-12	1973-10-06
1461	Aaron Blaise	1968-02-17	\N
1462	Ronee Blakley	1945-08-24	\N
1463	Tempestt Bledsoe	1973-08-01	\N
1464	Corbin Bleu	1989-02-21	\N
1465	Neill Blomkamp	1979-09-17	\N
1466	Orlando Bloom	1977-01-13	\N
1467	Verna Bloom	1938-08-07	2019-01-09
1468	Susan Blu	1948-07-12	\N
3264	Lilly Wachowski	1967-12-29	\N
3265	Lana Wachowski	1965-06-21	\N
3270	Benjamin Walker	1982-06-21	\N
3271	Eric Walker	1970-01-31	\N
3272	Paul Walker	1973-09-12	2013-11-30
3273	Robert Wall	1939-08-22	2022-01-30
3274	Tommy Lee Wallace	1949-09-06	\N
3275	Dee Wallace	1948-12-14	\N
3276	Eli Wallach	1915-12-07	2014-06-24
3277	David Walliams	1971-08-20	\N
3278	Tracey Walter	1947-11-25	\N
3279	Julie Walters	1950-02-22	\N
3280	Mark Walton	1968-10-24	\N
3281	Christoph Waltz	1956-10-04	\N
3282	Sam Wanamaker	1919-06-14	1993-12-18
3283	Patrick Warburton	1964-11-14	\N
3284	Roger Ward	1937-07-24	\N
3285	Simon Ward	1941-10-19	2012-07-20
3286	Zack Ward	1970-08-31	\N
3287	Jack Warden	1920-09-18	2006-07-19
3288	Ruth Warrick	1915-06-29	2005-01-15
3289	David Warshofsky	1961-02-23	\N
3290	John David Washington	1984-07-28	\N
3291	Kerry Washington	1977-01-31	\N
3292	Craig Wasson	1954-03-15	\N
3293	Ken Watanabe	1959-10-21	\N
3294	Mark Waters	1964-06-30	\N
3295	Emma Watson	1990-04-15	\N
3296	Naomi Watts	1968-09-28	\N
3297	Damon Wayans Jr.	1982-11-18	\N
3298	Shawn Wayans	1971-01-19	\N
3299	Keith Wayne	1945-01-16	1995-09-09
3300	Blayne Weaver	1976-04-09	\N
3301	Jacki Weaver	1947-05-25	\N
3302	Hugo Weaving	1960-04-04	\N
3303	Nicholas Webster	1912-07-24	2006-08-12
3304	Chris Wedge	1957-03-20	\N
3305	Scott Weinger	1975-10-05	\N
3306	Chris Weitz	1969-11-30	\N
3307	Paul Weitz	1965-11-19	\N
3308	Frank Welker	1946-03-12	\N
3309	Titus Welliver	1962-03-12	\N
3310	Simon Wells	1961-10-19	\N
3311	David Wenham	1965-09-21	\N
3312	Martha Wentworth	1889-06-02	1974-03-08
3313	Billy West	1952-04-16	\N
3314	Dominic West	1969-10-15	\N
3315	Jemima West	1987-08-11	\N
3316	Simon West	1961-07-17	\N
3317	Justin Whalin	1974-09-06	\N
3318	Jim Wheat	1952-01-01	\N
3319	Joss Whedon	1964-06-23	\N
3320	Shea Whigham	1969-01-05	\N
3321	Ben Whishaw	1980-10-14	\N
3322	Betty White	1922-01-17	2021-12-31
3323	Julie White	1961-06-04	\N
3324	Michael Jai White	1967-11-10	\N
3325	Mike White	1970-06-28	\N
3326	Richard White	1953-08-04	\N
3327	Stiles White	\N	\N
3328	Thelma White	1910-12-04	2005-01-04
3329	Billie Whitelaw	1932-06-06	2014-12-21
3330	John Whitesell	1953-12-02	\N
3331	Bradley Whitford	1959-10-10	\N
3332	Isiah Whitlock Jr.	1954-09-13	\N
3333	Steve Whitmire	1958-09-24	\N
3334	James Whitmore	1921-10-01	2009-02-06
3335	Johnny Whitworth	1975-10-31	\N
3336	Mary Wickes	1910-06-13	1995-10-22
3337	Robert Wiene	1873-04-25	1938-07-17
3338	Lisa Wilcox	1964-04-27	\N
3339	Tom Wilkinson	1948-02-05	2023-12-30
3340	Fred Willard	1933-09-18	2020-05-15
3341	Warren William	1894-12-02	1948-09-24
3342	Chris Williams	1968-04-23	\N
3343	Cindy Williams	1947-08-22	2023-01-25
3344	Gary Anthony Williams	1966-03-14	\N
3345	Jesse Williams	1981-08-05	\N
3346	Kimberly Williams-Paisley	1971-09-14	\N
3347	Lynn 'Red' Williams	1962-12-19	\N
3348	Michael C. Williams	1973-07-25	\N
3349	Michael K. Williams	1966-11-22	2021-09-06
3350	Michelle Williams	1980-09-09	\N
3351	Olivia Williams	1968-07-26	\N
3352	Paul Williams	1940-09-19	\N
3353	Rhoda Williams	1930-07-03	2006-03-08
3354	Steven Williams	1949-01-07	\N
3355	Zelda Williams	1989-07-31	\N
3356	Mykelti Williamson	1957-03-04	\N
3357	Nicol Williamson	1936-09-14	2011-12-16
3358	Bridgette Wilson-Sampras	1973-09-25	\N
3359	Kristen Wilson	1969-09-04	\N
3360	Lambert Wilson	1958-08-03	\N
3361	Mara Wilson	1987-07-24	\N
3362	Patrick Wilson	1973-07-03	\N
3363	Rainn Wilson	1966-01-20	\N
3364	Robert Brian Wilson	1962-03-08	\N
3365	Stuart Wilson	1946-12-25	\N
3366	Penelope Wilton	1946-06-03	\N
3367	Paul Winfield	1939-05-22	2004-03-07
3368	Leslie Wing	1963-09-16	\N
3369	Kitty Winn	1944-02-21	\N
3370	Katheryn Winnick	1977-12-17	\N
3371	Mary Elizabeth Winstead	1984-11-28	\N
3372	Ray Winstone	1957-02-19	\N
3373	Alex Winter	1965-07-17	\N
3374	Dean Winters	1964-07-20	\N
3375	Kirk Wise	1963-08-24	\N
3376	Robert Wise	1914-09-10	2005-09-14
3377	Len Wiseman	1973-03-04	\N
3378	Tom Wlaschiha	1973-06-20	\N
3379	Benedict Wong	1971-06-03	\N
3380	James Wong	1959-04-20	\N
3381	John Wood	1930-07-05	2011-08-06
3382	Peggy Wood	1892-02-09	1978-03-18
3383	Charlayne Woodard	1953-12-29	\N
3384	Bokeem Woodbine	1973-04-13	\N
3385	Danny Woodburn	1964-07-26	\N
3386	Shailene Woodley	1991-11-15	\N
3387	Ilene Woods	1929-05-05	2010-07-01
3388	John Woodvine	1929-07-21	\N
3389	Jo Anne Worley	1937-09-06	\N
3390	Sam Worthington	1976-08-02	\N
3391	Fay Wray	1907-09-15	2004-08-08
3392	Ben Wright	1915-05-05	1989-07-02
3393	Edgar Wright	1974-04-18	\N
3394	Jason Wright	1971-02-01	\N
3395	Jeffrey Wright	1965-12-07	\N
3396	Joe Wright	1972-08-25	\N
3397	N'Bushe Wright	1970-09-20	\N
3398	Samuel E. Wright	1946-11-20	2021-05-24
3399	Steven Wright	1955-12-06	\N
3400	Tandi Wright	1970-05-04	\N
3401	Daniel Wu	1974-09-30	\N
3402	Wu Jing	1974-04-03	\N
3403	Kristy Wu	1982-10-11	\N
3404	Vivian Wu	1966-02-05	\N
1488	Rob Bowman	1960-05-15	\N
1489	Billy Boyd	1968-08-28	\N
1490	Guy Boyd	1943-04-15	\N
1491	Harry Bradbeer	\N	\N
1492	David Bradley	1942-04-17	\N
1493	Doug Bradley	1954-09-07	\N
1494	Zach Braff	1975-04-06	\N
1495	Alice Braga	1983-04-15	\N
1496	Steven Brand	1969-06-26	\N
1497	Andre Braugher	1962-07-01	2023-12-11
1498	Lucille Bremer	1917-02-21	1996-04-16
1499	Eileen Brennan	1932-09-03	2013-07-28
3405	Robert Wuhl	1951-10-09	\N
3406	Martin Wuttke	1962-02-08	\N
3407	William Wyler	1902-07-01	1981-07-27
3408	George Wyner	1945-10-20	\N
3409	Ed Wynn	1886-11-09	1966-06-19
3410	Keenan Wynn	1916-07-26	1986-10-14
3411	Amanda Wyss	1960-11-24	\N
3412	Kevin Yagher	1962-06-23	\N
3413	Boaz Yakin	1966-06-20	\N
3414	Kappei Yamaguchi	1965-05-23	\N
3415	Tarô Yamamoto	1974-11-11	\N
3416	Takashi Yamazaki	1964-06-12	\N
3417	David Yarovesky	\N	\N
3418	David Yates	1963-10-08	\N
3419	Anton Yelchin	1989-03-11	2016-06-19
3420	Donnie Yen	1963-07-27	\N
3421	Dwight Yoakam	1956-10-23	\N
3422	Keiko Yokozawa	1952-09-02	\N
3423	Susannah York	1939-01-09	2011-01-15
3424	Hidetaka Yoshioka	1970-08-12	\N
3425	Burt Young	1940-04-30	2023-10-08
3426	Carleton Young	1905-10-21	1994-11-07
3427	Karen Young	1958-09-29	\N
3428	Keone Young	1947-09-06	\N
3429	Richard Young	1955-12-17	\N
3430	William Allen Young	1954-01-24	\N
3431	Yu Nan	1978-09-05	\N
3432	Ronny Yu	1950-07-01	\N
3433	Ron Yuan	1973-02-20	\N
3434	Wah Yuen	1950-09-02	\N
3435	Jennifer Yuh Nelson	1972-05-07	\N
3436	Rick Yune	1971-08-22	\N
3437	Odette Annable	1985-05-10	\N
3438	William Zabka	1965-10-20	\N
3439	David Zayas	1962-08-15	\N
3440	Kevin Zegers	1984-09-19	\N
3441	Zeno Robinson	1993-10-25	\N
3442	Mai Zetterling	1925-05-24	1994-03-17
3443	Ziyi Zhang	1979-02-09	\N
3444	Joey Zimmerman	1986-06-10	\N
3445	Joseph Zito	1946-05-14	\N
3446	Adrian Zmed	1954-03-04	\N
3447	Rob Zombie	1965-01-12	\N
3448	Ayelet Zurer	1969-06-28	\N
3449	Jerry Zucker	1950-03-11	\N
3450	Harald Zwart	1965-07-01	\N
3451	Joel Zwick	1942-01-11	\N
3452	Terry Zwigoff	1949-05-18	\N
3453	Jonas Åkerlund	1965-11-10	\N
3454	Brett Kelly	1993-10-30	\N
3455	Will Kemp	1977-06-29	\N
3456	Brian Taylor	\N	\N
3457	Conrad Vernon	1968-07-11	\N
3458	Cody Cameron	1965-02-28	\N
3459	Christopher Knights	1972-10-18	\N
3460	Simon J. Smith	1968-09-16	\N
3461	Kyle Gallner	1986-10-22	\N
3462	Brian Tee	1977-03-15	\N
3463	Mahershala Ali	1974-02-16	\N
3464	Danny Pino	1974-04-15	\N
3465	Kat Dennings	1986-06-13	\N
3467	Miyu Irino	1988-02-19	\N
3468	Maulik Pancholy	1974-01-18	\N
3469	Michael Dougherty	1974-10-28	\N
3470	Nicholas Braun	1988-05-01	\N
3471	Dominic Cooper	1978-06-02	\N
3472	Sharon Duncan-Brewster	1976-02-08	\N
3473	Amaury Nolasco	1970-12-24	\N
3474	Rupert Wyatt	1972-10-26	\N
3475	Drake	1986-10-24	\N
3476	Corey Stoll	1976-03-14	\N
3477	Daniel Fathers	1966-03-23	\N
3479	Zhang Jin	1974-05-19	\N
3480	Mohan Kapur	1965-10-27	\N
3481	Wendi McLendon-Covey	1969-10-10	\N
3482	Steven Pasquale	1976-11-18	\N
3483	Yang Dong-geun	1979-06-01	\N
3484	Sally Hawkins	1976-04-27	\N
3486	John Krasinski	1979-10-20	\N
3487	Terry Notary	1968-08-14	\N
3488	Farhan Akhtar	1974-01-10	\N
3489	Chukwudi Iwuji	1975-10-15	\N
3490	Thomas Brodie-Sangster	1990-05-16	\N
3491	Pablo Schreiber	1978-04-26	\N
3492	Jason Spisak	1973-08-29	\N
3493	Derek Luke	1974-04-24	\N
3494	Mike Vogel	1979-07-17	\N
3495	Brandon T. Jackson	1984-03-07	\N
3496	Shun Oguri	1982-12-26	\N
3497	Navid Negahban	1968-06-02	\N
3498	Justin K. Thompson	\N	\N
3499	Phil Hendrie	1952-09-01	\N
3500	Rachel McAdams	1978-11-17	\N
3501	Luke Ford	1981-03-26	\N
3502	Rey Lucas	\N	\N
3503	Óscar Jaenada	1975-05-04	\N
3504	Bryan Bertino	1977-10-17	\N
3505	Rhys Darby	1974-03-21	\N
3506	Michael Fassbender	1977-04-02	\N
3507	John Oliver	1977-04-23	\N
3508	Courtenay Taylor	1969-07-19	\N
3509	Kathryn Hahn	1973-07-23	\N
3510	Tracy Reed	1942-09-21	2012-05-02
3511	Cayden Boyd	1994-05-24	\N
3512	America Ferrera	1984-04-18	\N
3513	Franky G	1965-10-30	\N
3514	Dominique McElligott	1986-03-05	\N
3515	Sara Zwangobani	\N	\N
3516	Alexander Gould	1994-05-04	\N
3517	Jen Taylor	1973-02-17	\N
3518	Morena Baccarin	1979-06-02	\N
3519	JB Blanc	1969-02-13	\N
3520	Robert Walker	1961-01-14	2015-04-01
3521	Chelsea Marguerite	\N	\N
3522	John Cena	1977-04-23	\N
3523	Omar Sy	1978-01-20	\N
3524	Eric Bauza	1979-12-07	\N
3525	Megan Fox	1986-05-16	\N
3526	Sarah Shahi	1980-01-10	\N
3527	Kevin Munroe	1972-10-26	\N
3528	Tim Kang	1973-03-16	\N
3529	Lou Taylor Pucci	1985-07-27	\N
3530	Amanda Seyfried	1985-12-03	\N
3531	Aaron Ruell	1976-06-23	\N
3532	Tom Hiddleston	1981-02-09	\N
3533	David Harbour	1975-04-10	\N
3534	Sam Hargrave	1982-11-26	\N
3535	Sienna Miller	1981-12-28	\N
3536	Mike Flanagan	1978-05-20	\N
3537	George Clinton	1941-07-22	\N
3538	Aaron Taylor-Johnson	1990-06-13	\N
3539	Glenn Howerton	1976-04-13	\N
3540	Rawson Marshall Thurber	1975-02-09	\N
3541	Antony Starr	1975-10-25	\N
3542	Elle Fanning	1998-04-09	\N
3543	Kristen Schaal	1978-01-24	\N
3544	Sarah Vowell	1969-12-27	\N
3545	Tim Story	1970-03-13	\N
3546	Kathryn Newton	1997-02-08	\N
3547	Anthony Mackie	1978-09-23	\N
3548	David Lowery	1980-12-26	\N
3549	Alexa Davalos	1982-05-28	\N
3550	Abigail Breslin	1996-04-14	\N
3551	Rob Corddry	1971-02-04	\N
3552	Amanda Righetti	1983-04-04	\N
3553	Chaske Spencer	1975-03-09	\N
3554	Colin Trevorrow	1976-09-13	\N
3555	Ryunosuke Kamiki	1993-05-19	\N
3556	Masiela Lusha	1985-10-23	\N
3557	Lake Bell	1979-03-24	\N
2083	William Harrigan	1894-03-26	1966-02-01
2084	Danielle Harris	1977-06-01	\N
3558	Alysia Reiner	1970-07-21	\N
3559	Wesley Singerman	1990-08-23	\N
3560	Cobie Smulders	1982-04-03	\N
3561	Matthew Gray Gubler	1980-03-09	\N
3562	Garth Jennings	1972-03-04	\N
3563	Darren Lynn Bousman	1979-01-11	\N
3564	Courtney Henggeler	1978-12-11	\N
3565	Tatiana Maslany	1985-09-22	\N
3566	Liliana Mumy	1994-04-16	\N
3567	Neil Burger	1963-11-22	\N
3568	Jessica Lucas	1985-09-24	\N
3569	Rupert Evans	1976-03-09	\N
3570	Keith Silverstein	1970-12-24	\N
3571	Danny McBride	1976-12-29	\N
3572	Ava DuVernay	1972-08-24	\N
3573	Sofia Boutella	1982-04-03	\N
3574	Enrico Casarosa	1971-11-20	\N
3575	Zachary Levi	1980-09-29	\N
3576	Michelle Monaghan	1976-03-23	\N
3577	Jared Bush	1974-06-12	\N
3578	Ed Helms	1974-01-24	\N
3579	Omari Hardwick	1974-01-09	\N
3580	Chris Hemsworth	1983-08-11	\N
3581	Lewis Tan	1987-02-04	\N
3582	Michael Dorman	1981-04-26	\N
3583	Reid Scott	1977-11-19	\N
3584	Julius Avery	\N	\N
3585	Mark Cuban	1958-07-31	\N
3586	Joel Kinnaman	1979-11-25	\N
3587	Daniel Espinosa	1977-03-23	\N
3588	Dave Bautista	1969-01-18	\N
3589	Robin Budd	1967-03-18	\N
3590	Carolyn Minnott	1938-02-20	\N
3591	Edgar Ramírez	1977-03-25	\N
3592	Cameron Monaghan	1993-08-16	\N
3593	Leigh Whannell	1977-01-17	\N
3594	Page Kennedy	1976-11-23	\N
3595	Maggie Grace	1983-09-21	\N
3596	Lee Pace	1979-03-25	\N
3597	Paul Tibbitt	1968-05-13	\N
3598	Marcus Nispel	1963-05-26	\N
3599	Zach Cregger	1981-03-01	\N
3600	Eva Green	1980-07-06	\N
3601	Kevin Alejandro	1976-04-07	\N
3602	Drew Goddard	1975-02-26	\N
3603	Samuel Bayer	1965-02-17	\N
3604	Diane Kruger	1976-07-15	\N
3605	Oscar Isaac	1979-03-09	\N
3606	Taylor Lautner	1992-02-11	\N
3607	Stephanie Szostak	1975-06-12	\N
3608	Leonardo Nam	1979-11-05	\N
3609	Benedict Cumberbatch	1976-07-19	\N
3610	Pharrell Williams	1973-04-05	\N
3611	Charlie Cox	1982-12-15	\N
3612	Paola Núñez	1978-04-08	\N
3613	Jay Ryan	1981-08-29	\N
3614	Jon Watts	1981-06-28	\N
3615	Burn Gorman	1974-09-01	\N
3616	Keegan-Michael Key	1971-03-22	\N
3617	Michael Stahl-David	1982-10-28	\N
3618	Nikki Reed	1988-05-17	\N
3619	Fernanda Andrade	1984-03-08	\N
3620	Philip Haldiman	1977-09-25	\N
3621	Rob Letterman	1970-10-31	\N
3622	Kelly Clarkson	1982-04-24	\N
3623	Atsushi Watanabe	1898-04-09	1977-02-27
3624	Wes Ball	1980-10-28	\N
3625	Vanessa Hudgens	1988-12-14	\N
3626	Oh Yeong-su	1944-10-19	\N
3627	Priyanka Chopra Jonas	1982-07-18	\N
3628	Takashi Shimizu	1972-07-27	\N
3629	S.J. Clarkson	\N	\N
3630	Courtney Halverson	1989-06-14	\N
3631	María Cecilia Botero	1955-05-13	\N
3632	Kieran Bew	1980-08-18	\N
3633	Josh Hutcherson	1992-10-12	\N
3634	Michael Gracey	1976-01-06	\N
3635	Rafe Spall	1983-03-10	\N
3636	Rachel Hurd-Wood	1990-08-17	\N
3637	Riccardo Scamarcio	1979-11-13	\N
3638	Larry the Cable Guy	1963-02-17	\N
3639	Sterling K. Brown	1976-04-05	\N
3640	Toks Olagundoye	1975-09-16	\N
3641	Jon Bernthal	1976-09-20	\N
3642	Devon Bostick	1991-11-13	\N
3643	Russell Brand	1975-06-04	\N
3644	Justin Hartley	1977-01-29	\N
3645	Ariel Gade	1997-05-01	\N
3646	Danielle Panabaker	1987-09-19	\N
3648	Jin Au-Yeung	1982-06-04	\N
3649	Josh Gad	1981-02-23	\N
3650	Johannes Roberts	1976-05-24	\N
3651	Adam Pally	1982-03-18	\N
3652	Krysten Ritter	1981-12-16	\N
3653	Genesis Rodriguez	1987-07-29	\N
3654	Rey Gallegos	\N	\N
3655	Jessica Barth	1980-07-12	\N
3656	Alexandra Daddario	1986-03-16	\N
3657	Jeremy Garelick	1975-11-30	\N
3658	Sharon Horgan	1970-07-13	\N
3659	Ally Maki	1986-12-29	\N
3660	Noma Dumezweni	1969-07-28	\N
3661	O-T Fagbenle	1981-01-22	\N
3662	Emily Blunt	1983-02-23	\N
3663	J.A. Bayona	1975-05-09	\N
3664	Moon Bloodgood	1975-09-20	\N
3665	Bobby Moynihan	1977-01-31	\N
3666	Michael Spierig	1976-04-29	\N
3667	Peter Spierig	1976-04-29	\N
3668	Ben Wheatley	1972-05-07	\N
3669	Emma Stone	1988-11-06	\N
3670	Svetlana Khodchenkova	1983-01-21	\N
3671	Yvette Nicole Brown	1971-08-12	\N
3674	Kari Wahlgren	1977-07-13	\N
3675	Olivia Wilde	1984-03-10	\N
3676	Chelsea Handler	1975-02-25	\N
3677	Jemaine Clement	1974-01-10	\N
3678	Troy Kotsur	1968-07-24	\N
3679	Randall Park	1974-03-23	\N
3680	Tian Jing	1988-07-21	\N
3681	Skyler Samuels	1994-04-14	\N
3682	Adepero Oduye	1978-01-11	\N
3683	Kristen Wiig	1973-08-22	\N
3684	Travis Knight	1973-09-13	\N
3685	Munetaka Aoki	1980-03-14	\N
3686	Randy Couture	1963-06-22	\N
3687	Garrett Hedlund	1984-09-03	\N
3689	Carolina Gaitan	1984-04-04	\N
3690	Simon Kinberg	1973-08-02	\N
3691	Logan Marshall-Green	1976-11-01	\N
3692	Jay Ellis	1981-12-27	\N
3693	Ty Simpkins	2001-08-06	\N
3694	Skandar Keynes	1991-09-05	\N
3695	James Nguyen	1966-09-01	\N
3696	Josh Safdie	1984-04-03	\N
3697	Rachel House	1971-10-20	\N
3698	Tyler Perry	1969-09-14	\N
3699	Francis Lawrence	1971-03-26	\N
3700	Jonathan Levine	1976-06-18	\N
3701	Anna Boden	1976-09-20	\N
3702	Alyson Stoner	1993-08-11	\N
3703	J.B. Smoove	1965-12-16	\N
3704	Chris Geere	1981-03-18	\N
3705	Rita Ora	1990-11-26	\N
3706	Jennifer Carpenter	1979-12-07	\N
3708	Patrick Seitz	1978-03-17	\N
3709	Radivoje Bukvic	1979-11-11	\N
3710	D.J. Cotrona	1980-05-23	\N
3711	Max Burkholder	1997-11-01	\N
3712	Joaquín Cosio	1962-10-06	\N
3713	Al Madrigal	1971-07-04	\N
732	Kim Hunter	1922-11-12	2002-09-11
3714	Zac Efron	1987-10-18	\N
733	Olivia Hussey	1951-04-17	2024-12-27
734	Anjelica Huston	1951-07-08	\N
735	John Huston	1906-08-05	1987-08-28
736	David Hyde Pierce	1959-04-03	\N
737	Eric Idle	1943-03-29	\N
738	Peter Jackson	1961-10-31	\N
739	Derek Jacobi	1938-10-22	\N
740	Angelina Jolie	1975-06-04	\N
741	Neil Jordan	1950-02-25	\N
742	Madeline Kahn	1942-09-29	1999-12-03
743	Carol Kane	1952-06-18	\N
3715	Genie Kim	\N	\N
3716	David Robert Mitchell	1974-10-19	\N
3717	Travis Fimmel	1979-07-15	\N
3718	Tommy Wiseau	1955-10-03	\N
3719	Juliette Danielle	1980-12-08	\N
3720	Olga Kurylenko	1979-11-14	\N
3721	Tony Jaa	1976-02-05	\N
3722	Miranda Cosgrove	1993-05-14	\N
3723	Élodie Yung	1981-02-22	\N
3724	Kristen Connolly	1980-07-12	\N
3725	Lucas Till	1990-08-10	\N
3726	Dave Filoni	1974-06-07	\N
3728	Diora Baird	1983-04-06	\N
3729	Sibel Kekilli	1980-06-16	\N
3730	Evan Peters	1987-01-20	\N
3731	Alice Eve	1982-02-06	\N
3732	Dan Stevens	1982-10-10	\N
3733	David Bruckner	1977-01-01	\N
3734	Omar Chaparro	1974-11-26	\N
3735	Selena Gomez	1992-07-22	\N
3736	Mindy Kaling	1979-06-24	\N
3737	Glen Powell	1988-10-21	\N
3738	Demi Lovato	1992-08-20	\N
3739	Shantel VanSanten	1985-07-25	\N
3740	Adam Wingard	1982-12-03	\N
3741	Jon Heder	1977-10-26	\N
3742	Ivana Baquero	1994-06-11	\N
3743	Mehcad Brooks	1980-10-25	\N
3744	Joey King	1999-07-30	\N
3745	Britt Robertson	1990-04-18	\N
3746	Jaume Collet-Serra	1974-03-23	\N
3747	LeBron James	1984-12-30	\N
3748	Evangeline Lilly	1979-08-03	\N
3749	Matt Passmore	1973-12-24	\N
3750	Jim Parsons	1973-03-24	\N
3751	Jack McBrayer	1973-05-27	\N
3752	Bobb'e J. Thompson	1996-02-28	\N
3753	Will.i.am	1975-03-15	\N
3754	Brett Gelman	1976-10-06	\N
3755	Jordan Peele	1979-02-21	\N
3756	Rob Riggle	1970-04-21	\N
3757	Alyssa Sutherland	1982-09-23	\N
3758	Anna Mastro	\N	\N
3759	Joachim Rønning	1972-05-30	\N
3760	David Sheftell	1987-01-09	\N
3761	Rochelle Aytes	1976-05-17	\N
3762	Olivia Colman	1974-01-30	\N
3763	Robert F. Hughes	1961-10-19	\N
3764	Zach Gilford	1982-01-14	\N
3765	Channing Tatum	1980-04-26	\N
3766	Joe Dempsie	1987-06-22	\N
3767	Paul Nakauchi	1959-04-19	\N
3768	Gil Kenan	1976-10-16	\N
3769	Kuranosuke Sasaki	1968-02-04	\N
3770	Chris O'Dowd	1979-10-09	\N
3772	James Wan	1977-02-26	\N
3773	Aisha Hinds	1975-11-13	\N
3774	Sophia Ali	1995-11-07	\N
3775	Michael-Leon Wooley	1971-03-29	\N
3776	Jimmy Bennett	1996-02-09	\N
3777	Andrew Douglas	1952-08-10	\N
3778	Robert Pattinson	1986-05-13	\N
3779	Ahna O'Reilly	1984-09-21	\N
3780	Tom Bennett	1979-12-12	\N
3781	Leslie Odom Jr.	1981-08-06	\N
3782	Barry Jenkins	1979-11-19	\N
3783	Jose Pablo Cantillo	1979-03-30	\N
3784	Keir Gilchrist	1992-09-28	\N
3785	Benny Safdie	1986-02-24	\N
3786	Joss Stone	1987-04-11	\N
3787	Jamie Chung	1983-04-10	\N
3788	Duncan Jones	1971-05-30	\N
3789	Zach Mills	1995-12-26	\N
3790	Chris Pine	1980-08-26	\N
3791	Eddie Redmayne	1982-01-06	\N
3792	Saoirse Ronan	1994-04-12	\N
3793	Joel Courtney	1996-01-31	\N
3794	Jaimie Alexander	1984-03-12	\N
3795	Toby Kebbell	1982-07-09	\N
3796	Samantha Droke	1987-11-08	\N
3797	Zawe Ashton	1984-07-21	\N
3798	Jaden Smith	1998-07-08	\N
3799	Nate Torrence	1977-12-01	\N
3800	Jesse Moss	1983-05-04	\N
3801	Max Minghella	1985-09-16	\N
3802	Amy Seimetz	1981-11-25	\N
3803	Jake T. Austin	1994-12-03	\N
3804	Matt Berry	1974-05-02	\N
3805	Diego Boneta	1990-11-29	\N
3806	Richard Ayoade	1977-05-23	\N
3807	Harrison Gilbertson	1993-06-29	\N
3808	Ruth Negga	1982-01-07	\N
3809	Keke Palmer	1993-08-26	\N
3810	Dennis Widmyer	\N	\N
3811	Kellan Lutz	1985-03-15	\N
3812	Alison Brie	1982-12-29	\N
3813	Kevin Kölsch	\N	\N
3815	Booboo Stewart	1994-01-21	\N
3816	Pilou Asbæk	1982-03-02	\N
3821	Chadwick Boseman	1976-11-29	2020-08-28
3822	Trystan Gravelle	1981-05-04	\N
3823	Sian Heder	1977-06-23	\N
3824	Alexander Ludwig	1992-05-07	\N
3825	Arian Moayed	1980-04-15	\N
3826	Tornike Bziava	1980-07-01	\N
3827	Tiya Sircar	1982-05-16	\N
3828	Bahar Soomekh	1975-03-30	\N
3829	Robert Sheehan	1988-01-07	\N
3830	Rachael Taylor	1984-07-11	\N
3831	Mary Mouser	1996-05-09	\N
3832	Adrianne Palicki	1983-05-06	\N
3833	Brandon Scott Jones	1984-06-06	\N
3834	Olivia Munn	1980-07-03	\N
3835	Jennifer Lee	1971-10-22	\N
3836	Phil Johnston	1971-10-26	\N
3837	Matt Peters	\N	\N
3838	Ben Barnes	1981-08-20	\N
3839	Vincent Martella	1992-10-15	\N
3840	Alessandra Mastronardi	1986-02-18	\N
3841	Denis Ménochet	1976-09-18	\N
3842	Jennifer Hudson	1981-09-12	\N
3843	Sophia Di Martino	1983-11-15	\N
3844	Lucien Laviscount	1992-06-09	\N
3845	Antonio Tarver	1968-11-21	\N
3846	Jake Weary	1990-02-14	\N
3847	Daniel Weyman	\N	\N
3848	Kelsey Mann	1974-11-16	\N
3849	Jordan Fry	1993-06-07	\N
3850	Leven Rambin	1990-05-17	\N
3851	Juliet Rylance	1979-07-26	\N
3852	Phyllida Lloyd	1957-06-17	\N
3853	Saleka Shyamalan	1996-08-01	\N
3854	Chloë Grace Moretz	1997-02-10	\N
3855	Susan Kelechi Watson	1981-11-11	\N
3856	Maya Hawke	1998-07-08	\N
3857	Alex Pettyfer	1990-04-10	\N
2246	Mark Jones	1953-01-17	\N
744	Tchéky Karyo	1953-10-04	\N
3858	Riki Lindhome	1979-03-05	\N
745	Danny Kaye	1911-01-18	1987-03-03
3859	Katie Leung	1987-08-08	\N
746	Catherine Keener	1959-03-23	\N
747	David Keith	1954-05-08	\N
748	DeForest Kelley	1920-01-20	1999-06-11
749	Persis Khambatta	1948-10-02	1998-08-18
750	Ben Kingsley	1943-12-31	\N
751	Takeshi Kitano	1947-01-18	\N
752	Wayne Knight	1955-08-07	\N
753	Charlie Korsmo	1978-07-20	\N
3860	Espen Sandberg	1971-06-17	\N
3861	Paul King	1960-11-20	\N
3862	Sebastian Stan	1982-08-13	\N
3863	Lauren Cohan	1982-01-07	\N
3865	David Soren	1973-04-19	\N
3866	Jeremy Shada	1997-01-21	\N
3867	Antje Traue	1981-01-18	\N
3868	Sharlto Copley	1973-11-27	\N
3869	Georgie Henley	1995-07-09	\N
3870	Travis Van Winkle	1982-11-04	\N
3871	Andy Samberg	1978-08-18	\N
3872	Akiva Schaffer	1977-12-01	\N
3873	Rosemarie DeWitt	1971-10-26	\N
3874	Sylvia Hoeks	1983-06-01	\N
3875	Spencer Locke	1991-09-20	\N
3876	Justin Baldoni	1984-01-24	\N
3877	Aaron Yoo	1979-05-12	\N
3878	Beau Garrett	1982-12-28	\N
3879	Jennifer Holland	1987-11-09	\N
3880	Amber Midthunder	1997-04-26	\N
3881	Joaquim Dos Santos	1977-06-22	\N
3882	Liu Yifei	1987-08-25	\N
3883	Jonah Hill	1983-12-20	\N
3884	Ryan Whitney	1998-04-24	\N
3885	Tobias Segal	1986-05-12	\N
3886	Rhys Coiro	1979-03-12	\N
3887	Spencer Fox	1993-05-10	\N
3888	Marielle Heller	1979-10-01	\N
3889	Jackson Rathbone	1984-12-14	\N
3890	Amber Heard	1986-04-22	\N
3891	David Slade	1969-09-26	\N
3892	Jayma Mays	1979-07-16	\N
3893	Rob Morgan	1973-02-24	\N
3894	Domhnall Gleeson	1983-05-12	\N
3895	Lucas Grabeel	1984-11-23	\N
3896	Tim Heidecker	1976-02-03	\N
3897	Jason Mantzoukas	1972-12-18	\N
3898	Tony Revolori	1996-04-28	\N
3899	Noam Murro	1961-08-16	\N
3900	Taylor Dooley	1993-02-26	\N
3901	Jeff Fowler	1978-07-27	\N
3902	Ariel Winter	1998-01-28	\N
3903	Aaron Horvath	1980-08-19	\N
3904	Denise Gough	1980-02-28	\N
3905	Matt Smith	1982-10-28	\N
3906	Paula Patton	1975-12-05	\N
3907	Gina Rodriguez	1984-07-30	\N
3908	Natalie Dormer	1982-02-11	\N
3909	Annie Mumolo	1973-07-10	\N
3910	Tika Sumpter	1980-06-20	\N
3911	Nathan Mitchell	1988-12-06	\N
3912	Dave Green	1983-01-01	\N
3913	Margarita Levieva	1980-02-09	\N
3914	Kyle Newacheck	1984-01-23	\N
3915	Danai Gurira	1978-02-14	\N
3916	John Legend	1978-12-28	\N
3917	Ward Horton	1976-01-14	\N
3918	Imogen Poots	1989-06-03	\N
3919	Matt Lanter	1983-04-01	\N
3920	Halle Bailey	2000-03-27	\N
3921	Tim Miller	1964-10-10	\N
3922	Jacky Ido	1977-05-14	\N
3923	Rami Malek	1981-05-12	\N
3924	Ngô Thanh Vân	1979-02-26	\N
3925	Sosie Bacon	1992-03-15	\N
3926	Matt Ryan	1981-04-11	\N
3927	Jessica Williams	1989-07-31	\N
3928	Simon Phillips	1980-05-07	\N
3929	Fede Alvarez	1978-02-09	\N
3930	Nick Kroll	1978-06-05	\N
3931	Luke Evans	1979-04-15	\N
3932	Tori Kelly	1992-12-14	\N
3933	Gugu Mbatha-Raw	1983-04-21	\N
3934	Lee Isaac Chung	1978-10-19	\N
3935	Laith Nakli	1969-12-01	\N
3936	Hannah Waddingham	1974-07-28	\N
3937	Nat Wolff	1994-12-17	\N
3938	John Mulaney	1982-08-26	\N
3939	Zoe Lister-Jones	1982-09-01	\N
3940	Jake Abel	1987-11-18	\N
3941	Annabelle Wallis	1984-09-05	\N
3942	Josh Boone	1979-04-05	\N
3943	Tiffany Haddish	1979-12-03	\N
3944	Nasim Pedrad	1981-11-18	\N
3945	Alex Wolff	1997-11-01	\N
3946	Gillian Jacobs	1982-10-19	\N
3947	Chris Miller	1968-01-20	\N
3948	Janelle Monáe	1985-12-01	\N
3949	Ari Sandel	1974-09-05	\N
3950	Pierre Coffin	1967-03-16	\N
3951	Okwui Okpokwasili	1972-08-06	\N
3952	Charlie Barnett	1988-02-04	\N
3953	Stephen Amell	1981-05-08	\N
3954	Jermaine Fowler	1988-05-16	\N
3956	Christopher Jackson	1975-09-30	\N
3958	Ana de Armas	1988-04-30	\N
3959	Cynthia Addai-Robinson	1985-01-12	\N
3960	Liana Liberato	1995-08-20	\N
3961	Isabella Leong	1988-06-23	\N
3962	Miles Teller	1987-02-20	\N
3963	Roger Craig Smith	1975-08-11	\N
3964	Sean Anders	1969-06-19	\N
3965	Gabriel Luna	1982-12-05	\N
3966	Camille Cottin	1978-12-01	\N
3967	Jessie T. Usher	1992-02-29	\N
3968	Tony Leondis	1972-03-24	\N
3969	Colin Jost	1982-06-29	\N
3970	Dylan Minnette	1996-12-29	\N
3971	Rooney Mara	1985-04-17	\N
3972	Bailee Madison	1999-10-15	\N
3973	Max Charles	2003-08-18	\N
3974	Tessa Thompson	1983-10-03	\N
3975	Shila Ommi	1968-04-22	\N
3976	Tip 'T.I.' Harris	1980-09-25	\N
3977	Andrew Garfield	1983-08-20	\N
3978	China Anne McClain	1998-08-25	\N
3979	Jamie Dornan	1982-05-01	\N
3980	Raúl Castillo	1977-08-30	\N
3981	Greta Gerwig	1983-08-04	\N
3982	Teresa Palmer	1986-02-26	\N
3983	Mick Wingert	1974-07-04	\N
3984	Ed Speleers	1988-04-07	\N
3985	Kenneth Nkosi	1973-05-10	\N
3986	Kristofer Hivju	1978-12-07	\N
3987	Summer Bishil	1988-07-17	\N
3988	Nathan Greno	1975-03-22	\N
3989	Chin Han	1969-11-27	\N
3990	Maria Dizzia	1974-12-29	\N
3991	Michael Chaves	1984-11-03	\N
3992	Riz Ahmed	1982-12-01	\N
3994	Mia Wasikowska	1989-10-25	\N
3995	DeWanda Wise	1984-05-30	\N
3996	Marc Webb	1974-08-31	\N
3997	Nonso Anozie	1978-11-17	\N
3998	Hudson Thames	1994-03-19	\N
3999	Dave Franco	1985-06-12	\N
4000	Chelsea Peretti	1978-02-20	\N
4001	Chace Crawford	1985-07-18	\N
4002	Pierre Perifel	\N	\N
4003	Georges St-Pierre	1981-05-19	\N
4005	Taylor Kitsch	1981-04-08	\N
4006	Josh Segarra	1986-06-03	\N
4007	Scott Haze	1983-06-28	\N
754	Yaphet Kotto	1939-11-16	2021-03-15
4008	Dave B. Mitchell	1969-07-25	\N
4009	Dakota Goyo	1999-08-22	\N
4010	Daniel Henney	1979-11-28	\N
4011	Alan Ritchson	1982-11-28	\N
4012	Aramis Knight	1999-10-03	\N
4013	Moises Arias	1994-04-18	\N
4014	Lamorne Morris	1983-08-14	\N
4015	Valorie Curry	1986-02-12	\N
4016	Khalid Abdalla	1981-10-26	\N
4017	Zach Woods	1984-09-25	\N
4018	Emun Elliott	1983-11-28	\N
4019	Heather Sossaman	1987-04-25	\N
4020	Shiloh Fernandez	1985-02-26	\N
4021	Andrea Riseborough	1981-11-20	\N
4022	Robert Kazinsky	1983-11-18	\N
4023	Flula Borg	1982-03-28	\N
4024	Utkarsh Ambudkar	1983-12-08	\N
4025	Gerard Johnstone	1976-03-04	\N
4026	Kylee Russell	1996-10-08	\N
4027	Stassi Schroeder	1988-06-24	\N
4028	Regé-Jean Page	1988-04-27	\N
4029	Lee Jin-wook	1981-09-16	\N
4030	Yvonne Strahovski	1982-07-30	\N
755	Kris Kristofferson	1936-06-22	2024-09-28
756	Lisa Kudrow	1963-07-30	\N
757	Swoosie Kurtz	1944-09-06	\N
758	Neil LaBute	1963-03-19	\N
759	Anthony LaPaglia	1959-01-31	\N
760	Nathan Lane	1956-02-03	\N
761	Frank Langella	1938-01-01	\N
762	Angela Lansbury	1925-10-16	2022-10-11
763	Queen Latifah	1970-03-18	\N
764	Piper Laurie	1932-01-22	2023-10-14
765	Martin Lawrence	1965-04-16	\N
766	Cloris Leachman	1926-04-30	2021-01-26
768	Mimi Leder	1952-01-26	\N
769	Jason Scott Lee	1966-11-19	\N
770	Janet Leigh	1927-07-06	2004-10-03
771	Jared Leto	1971-12-26	\N
772	Barry Levinson	1942-04-06	\N
774	Laura Linney	1964-02-05	\N
775	John Lithgow	1945-10-19	\N
776	Cleavon Little	1939-06-01	1992-10-22
777	Jon Lovitz	1957-07-21	\N
778	Sidney Lumet	1924-06-25	2011-04-09
779	Kelly Lynch	1959-01-31	\N
780	Adrian Lyne	1941-03-04	\N
781	Kyle MacLachlan	1959-02-22	\N
782	Ralph Macchio	1961-11-04	\N
783	Tobey Maguire	1975-06-27	\N
789	Tim Matheson	1947-12-31	\N
790	Joseph Mazzello	1983-09-21	\N
791	Catherine McCormack	1972-04-03	\N
792	Dylan McDermott	1961-10-26	\N
793	Ian McDiarmid	1944-08-11	\N
794	Christopher McDonald	1955-02-15	\N
795	Mary McDonnell	1952-04-28	\N
796	Roddy McDowall	1928-09-17	1998-10-03
797	Natascha McElhone	1969-12-14	\N
798	John C. McGinley	1959-08-03	\N
799	Patrick McGoohan	1928-03-19	2009-01-13
800	John McTiernan	1951-01-08	\N
801	Dale Midkiff	1959-07-01	\N
803	Jonny Lee Miller	1972-11-15	\N
804	Hayley Mills	1946-04-18	\N
805	Ricardo Montalban	1920-11-25	2009-01-14
806	Dudley Moore	1935-04-19	2002-03-27
807	Agnes Moorehead	1900-12-06	1974-04-30
808	Rick Moranis	1953-04-18	\N
809	Rita Moreno	1931-12-11	\N
810	Cathy Moriarty	1960-11-29	\N
811	Pat Morita	1932-06-28	2005-11-24
812	David Morse	1953-10-11	\N
813	Viggo Mortensen	1958-10-20	\N
815	Kathy Najimy	1957-02-06	\N
816	Bebe Neuwirth	1958-12-31	\N
817	Mike Newell	1942-03-28	\N
818	Connie Nielsen	1965-07-03	\N
819	Chuck Norris	1940-03-10	\N
820	Edward Norton	1969-08-18	\N
821	Danny Nucci	1968-09-15	\N
822	Catherine O'Hara	1954-03-04	\N
823	Annette O'Toole	1952-04-01	\N
824	Edward James Olmos	1947-02-24	\N
825	Jerry Orbach	1935-10-20	2004-12-28
826	Miranda Otto	1967-12-16	\N
827	Jack Palance	1919-02-18	2006-11-10
828	Chazz Palminteri	1952-05-15	\N
829	Joe Pantoliano	1951-09-12	\N
831	Mandy Patinkin	1952-11-30	\N
832	Robert Patrick	1958-11-05	\N
833	Will Patton	1954-06-14	\N
834	Guy Pearce	1967-10-05	\N
835	Amanda Peet	1972-01-11	\N
836	Barry Pepper	1970-04-04	\N
837	Rosie Perez	1964-09-06	\N
838	Elizabeth Perkins	1960-11-18	\N
839	Bernadette Peters	1948-02-28	\N
840	Lori Petty	1963-10-14	\N
841	Elizabeth Peña	1959-09-23	2014-10-14
842	Mekhi Phifer	1974-12-29	\N
845	Bronson Pinchot	1959-05-20	\N
847	Oliver Platt	1960-01-12	\N
848	Amanda Plummer	1957-03-23	\N
849	Christopher Plummer	1929-12-13	2021-02-05
850	Sydney Pollack	1934-07-01	2008-05-26
851	Kevin Pollak	1957-10-30	\N
852	Annie Potts	1952-10-28	\N
853	CCH Pounder	1952-12-25	\N
854	Vincent Price	1911-05-27	1993-10-25
855	Jürgen Prochnow	1941-06-10	\N
856	Alex Proyas	1963-09-23	\N
857	Richard Pryor	1940-12-01	2005-12-10
858	Randy Quaid	1950-10-01	\N
859	Claude Rains	1889-11-09	1967-05-30
860	Charlotte Rampling	1946-02-05	\N
861	Michael Rapaport	1970-03-20	\N
862	John Ratzenberger	1947-04-06	\N
863	Stephen Rea	1946-10-31	\N
864	Lynn Redgrave	1943-03-08	2010-05-02
865	Donna Reed	1921-01-27	1986-01-14
866	Oliver Reed	1938-02-13	1999-05-02
867	Christopher Reeve	1952-09-25	2004-10-10
869	Judge Reinhold	1957-05-21	\N
870	Paul Reiser	1956-03-30	\N
871	James Remar	1953-12-31	\N
872	Lee Remick	1935-12-14	1991-07-02
873	Debbie Reynolds	1932-04-01	2016-12-28
874	Jonathan Rhys Meyers	1977-07-27	\N
875	Miranda Richardson	1958-03-03	\N
876	Diana Rigg	1938-07-20	2020-09-10
877	Joan Rivers	1933-06-08	2014-09-04
878	Chris Rock	1965-02-07	\N
879	Robert Rodriguez	1968-06-20	\N
880	Nicolas Roeg	1928-08-15	2018-11-23
881	Mark Rolston	1956-12-07	\N
882	Robert Romanus	1956-07-17	\N
884	Mickey Rooney	1920-09-23	2014-04-06
885	Katharine Ross	1940-01-29	\N
886	Gena Rowlands	1930-06-19	2024-08-14
887	Alan Ruck	1956-07-01	\N
888	Geoffrey Rush	1951-07-06	\N
894	Maximilian Schell	1930-12-08	2014-02-01
896	Joel Schumacher	1939-08-29	2020-06-22
897	Til Schweiger	1963-12-19	\N
898	David Schwimmer	1966-11-02	\N
4031	Constance Wu	1982-03-22	\N
4033	Lee Cronin	1973-06-01	\N
4034	Bobby Campo	1983-03-09	\N
4035	Damien Leone	1982-01-29	\N
4036	Luke Grimes	1984-01-21	\N
4037	Heo Sung-tae	1977-10-20	\N
4038	Gemma Chan	1982-11-29	\N
4039	Griffin Matthews	1981-12-25	\N
4040	Chloé Zhao	1982-03-31	\N
899	Campbell Scott	1961-07-19	\N
900	George C. Scott	1927-10-18	1999-09-22
901	Tony Scott	1944-06-21	2012-08-19
902	Chloë Sevigny	1974-11-18	\N
904	Tom Shadyac	1958-12-11	\N
905	Tony Shalhoub	1953-10-09	\N
906	Omar Sharif	1932-04-10	2015-07-10
907	Robert Shaw	1927-08-09	1978-08-28
908	Wallace Shawn	1943-11-12	\N
909	Sam Shepard	1943-11-05	2017-07-27
910	Talia Shire	1946-04-25	\N
912	Bryan Singer	1965-09-17	\N
913	Lori Singer	1957-11-06	\N
914	Tom Sizemore	1961-11-29	2023-03-03
915	Stellan Skarsgård	1951-06-13	\N
916	Charles Martin Smith	1953-10-30	\N
919	Jimmy Smits	1955-07-09	\N
920	Steven Soderbergh	1963-01-14	\N
921	P.J. Soles	1950-07-17	\N
922	Barry Sonnenfeld	1953-04-01	\N
925	Jerry Springer	1944-02-13	2023-04-27
926	Nick Stahl	1979-12-05	\N
927	Harry Dean Stanton	1926-07-14	2017-09-15
928	Imelda Staunton	1956-01-09	\N
929	Rod Steiger	1925-04-14	2002-07-09
930	Fisher Stevens	1963-11-27	\N
931	Patrick Stewart	1940-07-13	\N
932	David Ogden Stiers	1942-10-31	2018-03-03
933	Ben Stiller	1965-11-30	\N
935	Dean Stockwell	1936-03-05	2021-11-07
936	Matt Stone	1971-05-26	\N
937	Peter Stormare	1953-08-27	\N
938	Gloria Stuart	1910-07-04	2010-09-26
939	George Takei	1937-04-20	\N
940	Jeffrey Tambor	1944-07-08	\N
941	Jessica Tandy	1909-06-07	1994-09-11
942	Rod Taylor	1930-01-11	2015-01-07
943	Henry Thomas	1971-09-09	\N
944	Jonathan Taylor Thomas	1981-09-08	\N
945	Richard Thomas	1951-06-13	\N
947	Rip Torn	1931-02-06	2019-07-09
948	Danny Trejo	1944-05-16	\N
949	Stanley Tucci	1960-11-11	\N
950	John Turturro	1957-02-28	\N
951	Tracey Ullman	1959-12-30	\N
952	Peter Ustinov	1921-04-16	2004-03-28
953	Dick Van Dyke	1925-12-13	\N
954	Jim Varney	1949-06-15	2000-02-10
955	Robert Vaughn	1932-11-22	2016-11-11
956	Reginald VelJohnson	1952-08-16	\N
957	Abe Vigoda	1921-02-24	2016-01-26
958	Robert Wagner	1930-02-10	\N
959	M. Emmet Walsh	1935-03-22	2024-03-19
960	Ray Walston	1914-11-02	2001-01-01
961	David Warner	1941-07-29	2022-07-24
962	Emily Watson	1967-01-14	\N
963	Carl Weathers	1948-01-14	2024-02-02
964	Peter Weir	1944-08-21	\N
965	Rachel Weisz	1970-03-07	\N
966	Ming-Na Wen	1963-11-20	\N
967	Adam West	1928-09-19	2017-06-09
968	James Whale	1889-07-22	1957-05-29
969	Forest Whitaker	1961-07-15	\N
970	Dianne Wiest	1948-03-28	\N
971	Billy Dee Williams	1937-04-06	\N
972	JoBeth Williams	1948-12-06	\N
973	Vanessa Williams	1963-03-18	\N
974	Rita Wilson	1956-10-26	\N
975	Thomas F. Wilson	1959-04-15	\N
977	Shelley Winters	1920-08-18	2006-01-14
978	Alicia Witt	1975-08-21	\N
981	Amy Yasbeck	1962-09-12	\N
982	Bolo Yeung	1946-07-03	\N
983	Michael York	1942-03-27	\N
984	Pia Zadora	1954-05-04	\N
985	Steve Zahn	1967-11-13	\N
987	Catherine Zeta-Jones	1969-09-25	\N
988	David Zucker	1947-10-16	\N
989	Daphne Zuniga	1962-10-28	\N
990	Edward Zwick	1952-10-08	\N
991	Olivia d'Abo	1969-01-22	\N
992	Max von Sydow	1929-04-10	2020-03-08
993	Emile Ardolino	1943-05-09	1993-11-20
994	Margaret Avery	1944-01-20	\N
995	Hoyt Axton	1938-03-25	1999-10-26
996	Steve Bisley	1951-12-26	\N
997	Björk	1965-11-21	\N
998	Rubén Blades	1948-07-16	\N
999	Ray Bolger	1904-01-10	1987-01-15
1000	Peter Boyle	1935-10-18	2006-12-12
1001	Ewen Bremner	1972-01-23	\N
1002	Richard Briers	1934-01-14	2013-02-17
1003	Christie Brinkley	1954-02-02	\N
1004	Roscoe Lee Browne	1925-05-02	2007-04-11
1005	Sebastian Cabot	1918-07-06	1977-08-22
1010	Sarita Choudhury	1966-08-18	\N
1011	Thomas Haden Church	1960-06-17	\N
1012	Lee J. Cobb	1911-12-08	1976-02-11
1013	Richard Conte	1910-03-24	1975-04-15
1014	Ben Cross	1947-12-16	2020-08-18
1015	George Cukor	1899-07-07	1983-01-24
1016	Michael Curtiz	1886-12-24	1962-04-10
1017	Tyne Daly	1946-02-21	\N
1018	Dean Devlin	1962-08-27	\N
1019	Roger Donaldson	1945-11-15	\N
1020	Christine Ebersole	1953-02-21	\N
1021	Richard Edson	1954-01-01	\N
1022	Lisa Eilbacher	1956-05-05	\N
1023	Giancarlo Esposito	1958-04-26	\N
1024	Richard Farnsworth	1920-09-01	2000-10-06
1025	Will Ferrell	1967-07-16	\N
1027	Frederic Forrest	1936-12-23	2023-06-23
1028	James Franciscus	1934-01-31	1991-07-08
1029	Brenda Fricker	1945-02-17	\N
1030	Sidney J. Furie	1933-02-25	\N
1031	Zach Galligan	1964-02-14	\N
1032	Michael Gambon	1940-10-19	2023-09-27
1033	Julian Glover	1935-03-27	\N
1035	Gloria Grahame	1923-11-28	1981-10-05
1037	Sydney Greenstreet	1879-12-27	1954-01-18
1038	Paul Guilfoyle	1949-04-28	\N
1039	Arsenio Hall	1955-02-12	\N
1040	Lasse Hallström	1946-06-02	\N
1041	Margaret Hamilton	1902-12-09	1985-05-16
1042	Harry Hamlin	1951-10-30	\N
1043	Adam Hann-Byrd	1982-02-23	\N
1044	Dorian Harewood	1950-08-06	\N
1045	Amy Heckerling	1954-05-07	\N
1046	Paul Henreid	1908-01-10	1992-03-29
1047	Gregory Hines	1946-02-14	2003-08-09
1048	Judd Hirsch	1935-03-15	\N
1049	Sandrine Holt	1972-11-19	\N
1050	Trevor Howard	1913-09-29	1988-01-07
1051	Tab Hunter	1931-07-11	2018-07-08
1052	Alfred Abel	1879-03-11	1937-12-12
1053	Tzi Ma	1962-06-10	\N
1054	John Carroll Lynch	1963-08-01	\N
1055	Stephen Lang	1952-07-11	\N
1056	Paris Themmen	1959-06-25	\N
1057	David Jackson	1963-12-31	\N
4041	Cristin Milioti	1985-08-16	\N
4049	Lupita Nyong'o	1983-03-01	\N
4050	Luca Marinelli	1984-10-22	\N
4051	Wunmi Mosaku	1986-07-31	\N
4052	Amy Schumer	1981-06-01	\N
4053	Josh Cooley	1979-05-23	\N
4054	Jake Johnson	1978-05-28	\N
4055	Go Ah-sung	1992-08-10	\N
4056	Joel Fry	1984-05-20	\N
4057	Jennifer Nettles	1974-09-12	\N
1058	Shannon Elizabeth	1973-09-07	\N
1059	Emmy Rossum	1986-09-12	\N
1060	Mena Suvari	1979-02-13	\N
1061	Joe Johnston	1950-05-13	\N
1062	Gary Ross	1956-11-03	\N
1063	Malcolm D. Lee	1970-01-11	\N
1064	Muse Watson	1948-07-20	\N
1065	Alexander Skarsgård	1976-08-25	\N
1066	Chris McKay	1973-11-11	\N
1067	Michael Jordan	1963-02-17	\N
1068	Rachel Talalay	1958-07-16	\N
1069	Anthony C. Ferrante	1969-07-30	\N
1070	Ken Wheat	1950-01-01	\N
1071	Christopher McQuarrie	1968-10-25	\N
1072	Matthew Wood	1972-08-15	\N
1073	Ed Begley	1901-03-25	1970-04-28
1074	Jordi Mollà	1968-07-01	\N
1075	Rob Cohen	1949-03-12	\N
1076	Peter MacDonald	1939-06-20	\N
1077	Troy Miller	\N	\N
1078	James Mangold	1963-12-16	\N
1079	Kevin Smith	1970-08-02	\N
1080	F.W. Murnau	1888-12-28	1931-03-11
1081	Michael Clarke Duncan	1957-12-10	2012-09-03
1082	Marilyn Ghigliotti	1961-08-10	\N
1084	Andrew Stanton	1965-12-03	\N
1085	Anne Hathaway	1982-11-12	\N
1086	Gavin Hood	1963-05-12	\N
1087	George T. Miller	1943-11-28	2023-02-17
1088	George Miller	1945-03-03	\N
1089	Franka Potente	1974-07-22	\N
1090	Adam Scott	1973-04-03	\N
1092	Jason Alexander	1959-09-23	\N
1093	Walter Murch	1943-07-12	\N
1094	Steve Binder	1932-12-12	\N
1095	Mark Addy	1964-01-14	\N
1096	Christina Aguilera	1980-12-18	\N
1097	Jessica Alba	1981-04-28	\N
1098	Will Arnett	1970-05-04	\N
1099	Tyra Banks	1973-12-04	\N
1100	Christine Baranski	1952-05-02	\N
1101	Michael Beach	1963-10-30	\N
1102	Jason Behr	1973-12-30	\N
1103	Maria Bello	1967-04-18	\N
1104	Gil Bellows	1967-06-28	\N
1105	Wes Bentley	1978-09-04	\N
1106	Julie Benz	1972-05-01	\N
1107	Leslie Bibb	1973-11-17	\N
1108	Jessica Biel	1982-03-03	\N
1109	Jason Biggs	1978-05-12	\N
1110	Selma Blair	1972-06-23	\N
1111	Mary J. Blige	1971-01-11	\N
1112	Adrien Brody	1973-04-14	\N
1116	Bruno Campos	1973-12-03	\N
1117	Linda Cardellini	1975-06-25	\N
1118	Charisma Carpenter	1970-07-23	\N
1119	Michael Chiklis	1963-08-30	\N
1120	Stephen Collins	1947-10-01	\N
1121	Penélope Cruz	1974-04-28	\N
1122	Jane Curtin	1947-09-06	\N
1123	Kristin Davis	1965-02-23	\N
1124	Vin Diesel	1967-07-18	\N
1125	Snoop Dogg	1971-10-20	\N
1126	Tate Donovan	1963-09-25	\N
1127	Peter Facinelli	1973-11-26	\N
1128	Joey Fatone	1977-01-28	\N
1129	Oded Fehr	1970-11-23	\N
1130	Conchata Ferrell	1943-03-28	2020-10-12
1131	Frances Fisher	1952-05-11	\N
1132	Dave Foley	1963-01-04	\N
1133	Scott Foley	1972-07-15	\N
1134	June Foray	1917-09-18	2017-07-26
1135	Ben Foster	1980-10-29	\N
1136	Jamie Foxx	1967-12-13	\N
1137	Jennifer Garner	1972-04-17	\N
1138	Brad Garrett	1960-04-14	\N
1139	Thomas Gibson	1962-07-03	\N
1140	Peri Gilpin	1961-05-27	\N
1141	David Alan Grier	1956-06-30	\N
1142	Buddy Hackett	1924-08-31	2003-06-30
1143	Colin Hanks	1977-11-24	\N
1144	Alyson Hannigan	1974-03-24	\N
1145	Steve Harris	1965-12-03	\N
1146	Isaac Hayes	1942-08-20	2008-08-10
1148	Jill Hennessy	1968-11-25	\N
1149	Brian Henson	1963-11-03	\N
1150	Laura Harring	1964-03-03	\N
1151	Katie Holmes	1978-12-18	\N
1152	Peter Horton	1953-08-20	\N
1153	Djimon Hounsou	1964-04-24	\N
1154	Terrence Howard	1969-03-11	\N
1155	Kelly Hu	1968-02-13	\N
1156	Kate Hudson	1979-04-19	\N
1157	Oliver Hudson	1976-09-07	\N
1158	Jason Isaacs	1963-06-06	\N
1159	Thomas Jane	1969-02-22	\N
1160	Allison Janney	1959-11-19	\N
1162	Elton John	1947-03-25	\N
1163	Grace Jones	1948-05-19	\N
1164	January Jones	1978-01-05	\N
1165	Vinnie Jones	1965-01-05	\N
1166	Spike Jonze	1969-10-22	\N
1167	Stacy Keach	1941-06-02	\N
1168	Jamie Kennedy	1970-05-25	\N
1169	Justin Kirk	1969-05-28	\N
1170	Chris Klein	1979-03-14	\N
1171	Lenny Kravitz	1964-05-26	\N
1172	Mila Kunis	1983-08-14	\N
1173	Ashton Kutcher	1978-02-07	\N
1174	LL Cool J	1968-01-14	\N
1175	Mary Lambert	1951-10-13	\N
1176	Ali Larter	1976-02-28	\N
1177	John Lasseter	1957-01-12	\N
1178	Sanaa Lathan	1971-09-19	\N
1179	Lucy Lawless	1968-03-29	\N
1180	Heath Ledger	1979-04-04	2008-01-22
1181	Jason Lee	1970-04-25	\N
1182	Jane Leeves	1961-04-18	\N
1183	Lucy Liu	1968-12-02	\N
1184	Eric Lloyd	1986-05-19	\N
1185	Jake Lloyd	1989-03-05	\N
1186	Tone Loc	1966-03-03	\N
1187	Robert Loggia	1930-01-03	2015-12-04
1188	Lorna Luft	1952-11-21	\N
1189	Natasha Lyonne	1979-04-04	\N
1190	Bernie Mac	1957-10-05	2008-08-09
1191	Angus Macfadyen	1963-09-21	\N
1192	Norm MacDonald	1959-10-17	2021-09-14
1193	Wendie Malick	1950-12-13	\N
1194	Camryn Manheim	1961-03-08	\N
1195	Leslie Mann	1972-03-26	\N
1196	James Marsden	1973-09-18	\N
1197	Garry Marshall	1934-11-13	2016-07-19
1198	Paula Marshall	1964-06-12	\N
1201	Tim McGraw	1967-05-01	\N
1202	Ian McKellen	1939-05-25	\N
1203	Tim Meadows	1961-02-05	\N
1204	Christopher Meloni	1961-04-02	\N
1205	Sam Mendes	1965-08-01	\N
1206	Breckin Meyer	1974-05-07	\N
1207	Dash Mihok	1974-05-24	\N
4058	Charlie Rowe	1996-04-23	\N
4059	Katrina Bowden	1988-09-19	\N
1208	Beverley Mitchell	1981-01-22	\N
1337	William Alland	1916-03-04	1997-11-11
1338	Barbara Jo Allen	1906-09-02	1974-09-14
1339	Roger Allers	1949-06-29	\N
1340	Diane Almeida	\N	\N
1341	Joaquim de Almeida	1957-03-15	\N
1342	Laz Alonso	1974-03-25	\N
1343	Joe Alves	1936-05-21	\N
1344	John Amos	1939-12-27	2024-08-21
1345	Nikki Amuka-Bird	1976-02-27	\N
1346	Elena Anaya	1975-07-17	\N
1209	Shemar Moore	1970-04-20	\N
1210	Esai Morales	1962-10-01	\N
1211	Carrie-Anne Moss	1967-08-21	\N
1212	Elisabeth Moss	1982-07-24	\N
1213	Bridget Moynahan	1971-04-28	\N
1214	Patrick Muldoon	1968-09-27	\N
1215	Frankie Muniz	1985-12-05	\N
1216	Brittany Murphy	1977-11-10	2009-12-20
1217	Craig T. Nelson	1944-04-04	\N
1218	Thomas Ian Nicholas	1980-07-10	\N
1219	Alessandro Nivola	1972-06-28	\N
1220	Brandy Norwood	1979-02-11	\N
1221	Jerry O'Connell	1974-02-17	\N
1222	Rosie O'Donnell	1962-03-21	\N
1223	Jodi Lyn O'Keefe	1978-10-10	\N
1224	Jacqueline Obradors	1966-10-06	\N
1225	Haley Joel Osment	1988-04-10	\N
1226	Trey Parker	1969-10-19	\N
1227	Sarah Paulson	1974-12-17	\N
1228	Kimberly Peirce	1967-09-08	\N
1229	Monica Potter	1971-06-30	\N
1230	Freddie Prinze Jr.	1976-03-08	\N
1231	Theresa Randle	1964-12-27	\N
1232	Norman Reedus	1969-01-06	\N
1233	Tara Reid	1975-11-08	\N
1234	Tim Reid	1944-12-19	\N
1235	Carl Reiner	1922-03-20	2020-06-29
1236	Gloria Reuben	1964-06-09	\N
1237	Simon Rex	1974-07-20	\N
1238	Ryan Reynolds	1976-10-23	\N
1239	Caroline Rhea	1964-04-13	\N
1240	Busta Rhymes	1972-05-20	\N
1241	Guy Ritchie	1968-09-10	\N
1242	Jay Roach	1957-06-14	\N
1243	Sam Rockwell	1968-11-05	\N
1244	Ray Romano	1957-12-21	\N
1245	Rebecca Romijn	1972-11-06	\N
1246	Joe Roth	1948-06-13	\N
1247	Keri Russell	1976-03-23	\N
1248	Jason Schwartzman	1980-06-26	\N
1249	Seann William Scott	1976-10-03	\N
1250	Vinessa Shaw	1976-07-19	\N
1251	Lin Shaye	1943-10-12	\N
1252	Marley Shelton	1974-04-12	\N
1253	Ron Shelton	1945-09-15	\N
1254	Sinbad	1956-11-10	\N
1255	John Singleton	1968-01-06	2019-04-28
1256	Jeremy Sisto	1974-10-06	\N
1257	Amy Smart	1976-03-26	\N
1258	Kerr Smith	1972-03-09	\N
1259	Leelee Sobieski	1983-06-10	\N
1260	David Spade	1964-07-22	\N
1261	Scott Speedman	1975-09-01	\N
1262	Jason Statham	1967-07-26	\N
1263	Mary Steenburgen	1953-02-08	\N
1268	Hilary Swank	1974-07-30	\N
1269	Maura Tierney	1965-02-03	\N
1270	Justin Timberlake	1981-01-31	\N
1271	Lily Tomlin	1939-09-01	\N
1272	Jon Turteltaub	1963-08-08	\N
1273	Alanna Ubach	1975-10-03	\N
1274	Gabrielle Union	1972-10-29	\N
1275	Wilmer Valderrama	1980-01-30	\N
1276	Amber Valletta	1974-02-09	\N
1277	Mario Van Peebles	1957-01-15	\N
1278	Courtney B. Vance	1960-03-12	\N
1279	Sofía Vergara	1972-07-10	\N
1280	Donnie Wahlberg	1969-08-17	\N
1281	Estella Warren	1978-12-23	\N
1282	Keenen Ivory Wayans	1958-06-08	\N
1283	Marlon Wayans	1972-07-23	\N
1284	Harland Williams	1962-11-14	\N
1285	Luke Wilson	1971-09-21	\N
1286	Owen Wilson	1968-11-18	\N
1287	Russell Wong	1963-03-01	\N
1288	Alfre Woodard	1952-11-08	\N
1289	Lisa Zane	1961-04-05	\N
1290	Ian Ziering	1964-03-30	\N
1291	Maurice LaMarche	1958-03-30	\N
1292	Alex Zamm	1962-03-14	\N
1293	Karl Freund	1890-01-16	1969-05-03
1294	Dick Warlock	1940-02-05	\N
1295	Elsa Lanchester	1902-10-28	1986-12-26
1296	Doug Hutchison	1960-05-26	\N
1297	Donal Logue	1966-02-27	\N
1298	Steve Barron	1956-05-04	\N
1299	William Sadler	1950-04-13	\N
1300	Rachael Harris	1968-01-12	\N
1301	Aleks Paunovic	1969-06-29	\N
1302	Tom Noonan	1951-04-12	\N
1303	Herbert Ross	1927-05-13	2001-10-09
1304	John Vernon	1932-02-24	2005-02-01
1305	Tony Gilroy	1956-09-11	\N
1306	Jonathan Tucker	1982-05-31	\N
1307	Elizabeth Banks	1974-02-10	\N
1308	Jsu Garcia	1963-10-06	\N
1309	Dan Molina	1959-07-18	\N
1310	Tom Conway	1904-09-15	1967-04-22
1311	Leonor Varela	1972-12-29	\N
1312	Bonnie Aarons	1960-09-09	\N
1313	Hiam Abbass	1960-11-30	\N
1314	Jon Abrahams	1977-10-29	\N
1315	J.J. Abrams	1966-06-27	\N
1316	Brad Abrell	1965-06-01	\N
1317	Jensen Ackles	1978-03-01	\N
1318	Piotr Adamczyk	1972-03-21	\N
1319	Amy Adams	1974-08-20	\N
1320	Brandon Quintin Adams	1979-08-22	\N
1321	Edie Adams	1927-04-16	2008-10-15
1322	Julie Adams	1926-10-17	2019-02-03
1323	Andrew Adamson	1966-12-01	\N
1324	Paul Adelstein	1969-04-29	\N
1325	Scott Adkins	1976-06-17	\N
1326	Scott Adsit	1965-11-26	\N
1327	Steve Agee	1969-02-26	\N
1328	Shohreh Aghdashloo	1952-05-11	\N
1329	Liam Aiken	1990-01-07	\N
1330	Malin Akerman	1978-05-12	\N
1331	Adewale Akinnuoye-Agbaje	1967-08-22	\N
1332	Claude Akins	1926-05-25	1994-01-27
1333	Lori Alan	1966-07-18	\N
1334	Carlos Alazraqui	1962-07-20	\N
1335	Jack Albertson	1907-06-16	1981-11-25
1336	Damián Alcázar	1953-01-08	\N
4060	Carla Jeffery	1993-07-10	\N
4061	Ray Nicholson	1992-02-20	\N
4062	Aubrey Plaza	1984-06-26	\N
4063	Tenoch Huerta	1981-01-29	\N
4064	Scott Eastwood	1986-03-21	\N
4065	Lars Klevberg	1980-01-01	\N
4066	Katie Featherston	1982-10-20	\N
4067	Abby Elliott	1987-06-16	\N
4068	Kiernan Shipka	1999-11-10	\N
4069	Johnny Simmons	1986-11-28	\N
4070	Úrsula Corberó	1989-08-11	\N
4071	Jennifer Lawrence	1990-08-15	\N
4072	Ashley Greene	1987-02-21	\N
4073	Freddie Stroma	1987-01-08	\N
4074	Katherine Waterston	1980-03-03	\N
1347	Anthony Anderson	1970-08-15	\N
4075	Avan Jogia	1992-02-09	\N
1350	Paul W.S. Anderson	1965-03-04	\N
1351	Stephen J. Anderson	1970-06-05	\N
1352	Wes Anderson	1969-05-01	\N
1353	Masanobu Andô	1975-05-19	\N
1354	Mark Andrews	1968-09-12	\N
1355	Michelle Ang	1983-10-17	\N
1356	Michael Angarano	1987-12-03	\N
1357	Heather Angel	1909-02-09	1986-12-13
1358	Álex Angulo	1953-04-12	2014-07-20
4076	Kodi Smit-McPhee	1996-06-13	\N
4077	Cristela Alonzo	1979-01-06	\N
4078	Léa Seydoux	1985-07-01	\N
4079	Isaiah Mustafa	1974-02-11	\N
4080	Aya Cash	1982-07-13	\N
4081	Annie Murphy	1986-12-19	\N
4082	Donald Glover	1983-09-25	\N
4083	Daniel Kaluuya	1989-02-24	\N
4084	Nazanin Boniadi	1980-05-22	\N
4085	Claudia Kim	1985-01-25	\N
4086	Elissa Knight	1975-04-15	\N
4087	Isabelle Fuhrman	1997-02-25	\N
4089	Jennifer Cody	1969-11-10	\N
4090	Colby Minifie	1992-01-31	\N
4091	Justin Simien	1983-05-07	\N
4092	Gareth Edwards	1975-06-01	\N
4093	Leah Lewis	1996-12-09	\N
4094	Dakota Blue Richards	1994-04-11	\N
4095	Oren Peli	1970-01-21	\N
4096	Destin Daniel Cretton	1978-11-23	\N
4097	Armie Hammer	1986-08-28	\N
4098	Rebel Wilson	1980-03-02	\N
4099	Maia Mitchell	1993-08-18	\N
4100	Olive Gray	1994-12-03	\N
4101	Don Hall	1969-03-08	\N
4102	Ethan Spaulding	1972-01-01	\N
4103	Zachary Gordon	1998-02-15	\N
4104	Kris Pearn	\N	\N
4105	Cassidy Freeman	1982-04-22	\N
4106	Greta Lee	1983-03-07	\N
4107	Taylor Gray	1993-09-07	\N
4108	Aaron Moten	1989-02-28	\N
4109	Lucas Hedges	1996-12-12	\N
4110	Dev Patel	1990-04-23	\N
4111	Ben Schwartz	1981-09-15	\N
4112	Hannah Murray	1989-07-01	\N
4113	Taylor Swift	1989-12-13	\N
4114	Raymond Ochoa	2001-10-12	\N
4115	Maxim Baldry	1996-01-05	\N
4116	Stephanie Sigman	1987-02-28	\N
4117	Betty Gilpin	1986-07-21	\N
4118	Matt Bettinelli-Olpin	1978-02-19	\N
4119	Morgan Turner	1999-04-29	\N
4120	Tallulah Evans	1999-04-04	\N
4121	Zoë Kravitz	1988-12-01	\N
4122	Fala Chen	1982-02-24	\N
4123	Thomas Kail	1978-01-20	\N
4124	Garrett Clayton	1991-03-19	\N
4125	Lucy Boynton	1994-01-17	\N
4126	Corin Hardy	1975-01-06	\N
4127	Logan Miller	1992-02-18	\N
4128	Michael Morris	1974-05-28	\N
4129	Emily Beecham	1984-05-12	\N
4130	Dan Levy	1983-08-09	\N
4131	Christopher Mintz-Plasse	1989-06-20	\N
4132	Brooklyn Decker	1987-04-12	\N
4133	Karen Gillan	1987-11-28	\N
4134	Michael Jelenic	1977-05-12	\N
4135	Annalise Basso	1998-12-02	\N
4136	Sia	1975-12-18	\N
4137	Alden Ehrenreich	1989-11-22	\N
4138	Nina Dobrev	1989-01-09	\N
4139	Will Poulter	1993-01-28	\N
4140	Dean Israelite	1984-09-20	\N
4141	Julee Cerda	1978-01-29	\N
4142	Ali Ahn	1991-07-24	\N
4143	Tyler Gillett	1982-03-06	\N
4144	André Holland	1979-12-28	\N
4145	Gina Carano	1982-04-16	\N
4146	Nicola Peltz Beckham	1995-01-09	\N
4147	Lior Raz	1971-11-24	\N
4148	Quinton Aaron	1984-08-15	\N
4149	Gary Dauberman	1976-07-16	\N
4150	Tommy Wirkola	1979-12-06	\N
4151	Nora Arnezeder	1989-05-08	\N
4152	Elisa Lasowski	1986-11-15	\N
4153	Rosie Huntington-Whiteley	1987-04-18	\N
4154	Kim Joo-ryung	1976-07-15	\N
4155	Ann Akinjirin	1984-05-28	\N
4156	David F. Sandberg	1981-01-21	\N
4157	Uzo Aduba	1981-02-10	\N
4158	Josh Trank	1984-02-19	\N
4177	Yulia Snigir	1983-06-02	\N
4178	Camilla Luddington	1983-12-15	\N
4179	Jamie Campbell Bower	1988-11-22	\N
4180	Lil Rel Howery	1979-12-17	\N
4181	Michael Hall D'Addario	1997-03-03	\N
4182	Austin Butler	1991-08-17	\N
4183	Simon McQuoid	\N	\N
4184	Steve McQueen	1969-10-09	\N
4185	Tahar Rahim	1981-07-04	\N
4186	Rafael Casal	1985-08-08	\N
4187	David Blue Garcia	\N	\N
4188	Gemma Arterton	1986-02-02	\N
4189	Ellie Kemper	1980-05-02	\N
4190	Chrissie Fit	1984-04-03	\N
4191	Patrick Gibson	1995-04-19	\N
4192	Gerard McMurray	\N	\N
4193	Ryan Lee	1996-10-04	\N
4194	Cameron Boyce	1999-05-28	2019-07-06
4195	Jacob Hopkins	2002-03-04	\N
4196	Cassie Scerbo	1990-03-30	\N
4197	Asa Butterfield	1997-04-01	\N
4198	Aidan Turner	1983-06-19	\N
4199	Manuel Garcia-Rulfo	1981-02-25	\N
4200	Madhur Mittal	1987-01-20	\N
4201	Stefanie Scott	1996-12-06	\N
4202	Shelley Hennig	1987-01-02	\N
4203	Adèle Exarchopoulos	1993-11-22	\N
4213	Lili Sepe	1997-01-13	\N
4214	Fawad Khan	1981-11-29	\N
4215	Mathew Baynton	1980-11-18	\N
4216	Oliver Jackson-Cohen	1986-10-24	\N
4217	Amirah Vann	1980-06-24	\N
4218	Lashana Lynch	1987-11-27	\N
4219	Clare Foley	2001-09-24	\N
4220	Sakura Andô	1986-02-18	\N
4221	Owain Arthur	1983-03-05	\N
4222	Chris Butler	1974-02-14	\N
4223	Bella Heathcote	1987-05-27	\N
4224	Jacob Anderson	1990-06-18	\N
4225	Eric André	1983-04-04	\N
4226	Matthew Needham	1984-04-13	\N
4227	Oona Chaplin	1986-06-04	\N
4228	Gabriel Basso	1994-12-11	\N
4229	Yara Shahidi	2000-02-10	\N
4230	Carlos López Estrada	1988-09-12	\N
4231	Beanie Feldstein	1993-06-24	\N
4232	May Calamawy	1986-10-28	\N
4233	Sonequa Martin-Green	1985-03-21	\N
4234	Hailee Steinfeld	1996-12-11	\N
4235	Allison Tolman	1981-11-18	\N
4236	Skylar Astin	1987-09-23	\N
4237	Zenobia Shroff	1965-05-27	\N
4238	Matt Jones	1981-11-01	\N
4239	Nathan Stewart-Jarrett	1985-12-04	\N
4240	Jenny Slate	1982-03-25	\N
4241	David Dastmalchian	1977-07-21	\N
4242	Anthony Carrigan	1983-01-02	\N
4243	Andy Bean	1984-10-07	\N
4244	Nathalie Emmanuel	1989-03-02	\N
4245	Billy Eichner	1978-09-18	\N
4246	Janae Caster	\N	\N
4247	Killian Scott	1985-07-06	\N
4248	Deborah Ann Woll	1985-02-07	\N
4249	Dana Ledoux Miller	\N	\N
4250	Dean-Charles Chapman	1997-09-07	\N
4251	Ashley Zukerman	1983-12-30	\N
4252	Dane DeHaan	1986-02-06	\N
4253	Kiana Madeira	1992-11-04	\N
4254	Miles Bakshi	2002-12-19	\N
4255	Janet Montgomery	1985-10-29	\N
4256	Sydney Sweeney	1997-09-12	\N
4257	William Jackson Harper	1980-02-08	\N
4258	Mason Gooding	1996-11-14	\N
4259	Hannibal Buress	1983-02-04	\N
4260	Aubrey Shea	1993-11-27	\N
4262	Benjamin Renner	1983-11-14	\N
4263	Darrell Britt-Gibson	1986-08-04	\N
4264	Josh Helman	1986-02-22	\N
4265	Stefania LaVie Owen	1997-12-15	\N
4266	Aneurin Barnard	1987-05-08	\N
4267	Jason Hand	\N	\N
4268	Micah Sloat	1981-05-08	\N
4269	Billy Magnussen	1985-04-20	\N
4270	Jack Reynor	1992-01-23	\N
4271	Troye Sivan	1995-06-05	\N
4272	Boyd Holbrook	1981-09-01	\N
4273	Gal Gadot	1985-04-30	\N
4274	Lily Collins	1989-03-18	\N
4275	Nick Bruno	\N	\N
4276	Ike Amadi	1979-11-26	\N
4277	Jeff Bennett	\N	\N
4278	Santino Fontana	1982-03-21	\N
4279	Freida Pinto	1984-10-18	\N
4280	Robert Capron	1998-07-09	\N
4281	Liam Hemsworth	1990-01-13	\N
4282	Harvey Guillén	1990-05-03	\N
4283	Pom Klementieff	1986-05-03	\N
4284	Niles Fitch	2001-07-12	\N
4285	Adaku Ononogbo	1979-07-09	\N
4286	Jared Stern	\N	\N
4287	Daren Kagasoff	1987-09-16	\N
4288	Jordan Nagai	2000-02-05	\N
4289	Harriet Dyer	1988-10-17	\N
4290	Anders Holm	1981-05-29	\N
4291	Meredith Hagner	1987-05-31	\N
4292	Artt Butler	1969-10-13	\N
4293	Jonas Bloquet	1992-07-10	\N
4294	Skylan Brooks	1999-02-12	\N
4295	Lio Tipton	1988-11-09	\N
4304	Samara Weaving	1992-02-23	\N
4305	Thomas Middleditch	1982-03-10	\N
4306	Vicky Krieps	1983-10-04	\N
4307	Sophia Takal	1986-05-12	\N
4308	Margot Robbie	1990-07-02	\N
4309	Jodie Comer	1993-03-11	\N
4310	Hayley Kiyoko	1991-04-03	\N
4311	Lady Gaga	1986-03-28	\N
4312	Steven Yeun	1983-12-21	\N
4313	Eugene Cordero	1978-07-18	\N
4314	Fawn Veerasunthorn	\N	\N
4315	Marwan Kenzari	1983-01-16	\N
4316	Jack Whitehall	1988-07-07	\N
4317	Arturo Perez Jr.	\N	\N
4318	David James	1972-10-28	\N
4319	Brian Tyree Henry	1982-03-31	\N
4320	Ben Schnetzer	1990-02-08	\N
4321	Morgan Davies	2001-11-27	\N
4322	Leon Wadham	\N	\N
4323	Joe Tippett	1982-03-01	\N
4324	Becky G	1997-03-02	\N
4325	Sophia Anne Caruso	2001-07-11	\N
4326	LaKeith Stanfield	1991-08-12	\N
4327	Joel Crawford	\N	\N
4328	Gwilym Lee	1983-11-24	\N
4329	Timothée Chalamet	1995-12-27	\N
4330	Cody Horn	1987-06-12	\N
4331	Dusan Brown	2001-12-02	\N
4332	Noah Centineo	1996-05-09	\N
4333	Ali Fazal	1986-10-15	\N
4334	David Alvarez	1994-05-11	\N
4335	Colton Osborne	\N	\N
4336	Whitney Moore	1989-06-22	\N
4337	Alan Bagh	1985-05-30	\N
4338	Karim El Hakim	\N	\N
4339	Adam Sessa	\N	\N
4340	Ben Aldridge	1985-11-12	\N
4341	Ruby Rose	1986-03-20	\N
4342	Robert Eggers	1983-07-07	\N
4343	Daniel Scheinert	1987-06-07	\N
4344	Madelyn Cline	1997-12-21	\N
4345	Elsie Fisher	2003-04-03	\N
4346	Noah Ringer	1997-11-18	\N
4347	Louis Minnaar	\N	\N
4348	Damien Chazelle	1985-01-19	\N
4349	Olivia Newman	\N	\N
4350	Kit Harington	1986-12-26	\N
4351	Gaia Wise	1999-12-04	\N
4352	Tom Gormican	1980-04-02	\N
4353	Carla Juri	1985-01-02	\N
4354	Reinaldo Marcus Green	1981-12-16	\N
4355	Tucker Albrizzi	2000-02-25	\N
4356	Paul Walter Hauser	1986-10-15	\N
4357	Ron Funches	1983-03-12	\N
4358	Mackenzie Foy	2000-11-10	\N
4359	Kaitlyn Dever	1996-12-21	\N
4360	Vanessa Haywood	\N	\N
4361	Manny Jacinto	1987-08-19	\N
4362	Jillian Bell	1984-04-25	\N
4363	Rick Morales	\N	\N
4364	Kid Cudi	1984-01-30	\N
4365	Mandla Gaduka	\N	\N
4366	Dana Gaier	1997-02-05	\N
4367	Thomas Mann	1991-09-27	\N
4368	Matt Lintz	2001-05-23	\N
4369	Godfrey Gao	1984-09-22	2019-11-27
4371	Iko Uwais	1983-02-12	\N
4372	Rose Leslie	1987-02-09	\N
4373	Daniel Durant	1989-12-24	\N
4374	Caitlin Gerard	1988-07-26	\N
4375	Catherine Corcoran	1992-05-30	\N
4376	Ronda Rousey	1987-02-01	\N
4377	Kit Young	1994-10-24	\N
4378	Jordan Fisher	1994-04-24	\N
4379	Owen Campbell	1994-06-09	\N
4380	Charlie Wright	1999-10-22	\N
4381	Betty Gabriel	1981-01-06	\N
4382	Rohan Campbell	1997-09-23	\N
4383	Ashley Hinshaw	1988-12-11	\N
4384	Ryan Coogler	1986-05-23	\N
4385	Vanessa Bayer	1981-11-14	\N
4386	Nico Tortorella	1988-07-30	\N
4387	Alexandra Shipp	1991-07-16	\N
4389	Eugene Khumbanyiwa	1976-12-26	\N
4390	Annet Mahendru	1989-08-21	\N
4391	Marielle Jaffe	1989-06-23	\N
4392	Rachel Bloom	1987-04-03	\N
4393	Abbi Jacobson	1984-02-01	\N
4394	Jade Anouka	1989-06-12	\N
4395	Roland Møller	1972-05-28	\N
4396	Daniel Kwan	1988-02-10	\N
4397	Lucas Dawson	\N	\N
4398	Freddie Fox	1989-04-05	\N
4399	Olivia Luccardi	1989-05-17	\N
4400	Noah Lomax	2001-11-07	\N
4401	Luke Bracey	1989-04-26	\N
4402	Ella Purnell	1996-09-17	\N
4403	Ludi Lin	1987-11-11	\N
4404	Adam Driver	1983-11-19	\N
4405	Emjay Anthony	2003-06-01	\N
4406	Mehwish Hayat	1988-01-06	\N
4407	Teyonah Parris	1987-09-22	\N
4408	Sam Claflin	1986-06-27	\N
4409	Stephanie Hsu	1990-11-25	\N
4410	Ross Lynch	1995-12-29	\N
4411	Emma Myers	2002-04-02	\N
4412	Kumail Nanjiani	1978-02-21	\N
4413	Nick Robinson	1995-03-22	\N
4414	Asia Kate Dillon	1984-11-15	\N
4446	Jason Derulo	1989-09-21	\N
4447	Jonathan Majors	1989-09-07	\N
4448	Jessica Henwick	1992-08-30	\N
4449	Gwendoline Christie	1978-10-28	\N
4450	Dylan O'Brien	1991-08-26	\N
4451	Bayardo De Murguia	1983-11-09	\N
4452	Nicki Minaj	1982-12-08	\N
4453	Raphi Henley	\N	\N
4454	Theo James	1984-12-16	\N
4455	Edward Davis	1989-08-20	\N
4456	Angus Cloud	1998-07-10	2023-07-31
4457	Anna Baryshnikov	1992-05-22	\N
4458	Ariana Grande	1993-06-26	\N
4459	Will Peltz	1986-05-30	\N
4460	Rose Glass	\N	\N
4461	Jake Lacy	1985-02-14	\N
4462	Lizze Broadway	1998-02-16	\N
4463	Griffin Gluck	2000-08-24	\N
4464	Ser'Darius Blain	1987-03-10	\N
4465	Odeya Rush	1997-05-12	\N
4466	Jacob Wysocki	1990-06-20	\N
4467	Carolina Bartczak	1985-10-05	\N
4468	Faye Marsay	1986-12-30	\N
4469	Sophie Turner	1996-02-21	\N
4470	Jodie Turner-Smith	1986-11-07	\N
4471	Zoë Chao	1985-09-19	\N
4472	Ben Lamb	1989-01-24	\N
4473	Ramy Youssef	1991-03-26	\N
4474	Ki Hong Lee	1986-09-30	\N
4475	Raffey Cassidy	2001-11-12	\N
4476	Dylan Gelula	1994-05-07	\N
4477	Shamier Anderson	1991-05-06	\N
4478	Moses Storm	1990-05-06	\N
4479	John DeLuca	1986-04-25	\N
4480	Abbey Lee	1987-06-12	\N
4481	Tom Blyth	1995-02-02	\N
4482	Angourie Rice	2001-01-01	\N
4483	Alex Russell	1987-12-11	\N
4484	Elizabeth Blackmore	1987-01-06	\N
4485	Jamie Clayton	1978-01-15	\N
4486	Dayo Okeniyi	1988-06-14	\N
4487	John Boyega	1992-03-17	\N
4488	Okieriete Onaodowan	1987-08-16	\N
4489	Zendaya	1996-09-01	\N
4490	Taissa Farmiga	1994-08-17	\N
4491	Angel Manuel Soto	1983-01-28	\N
4492	Erin Moriarty	1994-06-24	\N
4493	Sam Richardson	1984-01-12	\N
4494	Chandler Kinney	2000-08-03	\N
4495	Michaela Coel	1988-10-01	\N
4496	Vanessa Kirby	1988-04-18	\N
4497	Kylie Bunbury	1989-01-30	\N
4498	Ben Kientz	\N	\N
4499	Jenna Kanell	1991-11-12	\N
4500	Amandla Stenberg	1998-10-23	\N
4501	Gracie Gillam	1992-05-04	\N
4502	Michael Sarnoski	\N	\N
4503	Moe Dunford	1987-12-11	\N
4504	David G. Derrick Jr.	1978-06-22	\N
4505	Ryan Potter	1995-09-12	\N
4506	Jane Levy	1989-12-29	\N
4507	Brandon Sklenar	1990-06-26	\N
4508	Letitia Wright	1993-10-31	\N
4509	Percy Hynes White	2001-10-08	\N
4510	Andrew Koji	1987-11-10	\N
4511	Cathy Yan	1983-01-25	\N
4512	Rosa Salazar	1985-07-16	\N
4513	Steven Caple Jr.	1988-02-16	\N
4514	Suki Waterhouse	1992-01-05	\N
4515	Chloe Bennet	1992-04-18	\N
4516	Synnøve Macody Lund	1976-05-24	\N
4517	Tom Holland	1996-06-01	\N
4518	Brady Noon	2005-12-30	\N
4519	Charlie Plummer	1999-05-24	\N
4520	Diane Guerrero	1986-07-21	\N
4521	Madison Wolfe	2002-10-16	\N
4522	Leigh Janiak	1980-02-01	\N
4523	Riley Griffiths	1997-05-14	\N
4524	Ellora Torchia	1992-04-28	\N
4525	Harry Styles	1994-02-01	\N
4526	Orion Lee	1980-07-10	\N
4527	Tahirah Sharif	1985-07-27	\N
4529	Tanner Buchanan	1998-12-08	\N
4530	Tinatin Dalakishvili	1991-03-02	\N
4531	Allison Williams	1988-04-13	\N
4532	James Laurin	\N	\N
4533	Lily James	1989-04-05	\N
4534	Saba Mubarak	1976-04-10	\N
4535	Nimra Bucha	1980-11-21	\N
4536	Caleel Harris	2003-04-19	\N
4537	Brenton Thwaites	1989-08-10	\N
4538	Kiersey Clemons	1993-12-17	\N
4539	Ari Aster	1986-07-15	\N
4540	Karan Soni	1989-01-08	\N
4541	Stuart Allan	1999-11-28	\N
4542	Tim Robinson	1981-05-23	\N
4543	Jason Mitchell	1987-01-05	\N
4544	Varada Sethu	1992-05-12	\N
4545	Dacre Montgomery	1994-11-22	\N
4546	Victor Ortiz	1987-01-31	\N
4547	Lauren Ridloff	1978-04-06	\N
4548	Sabrina Carpenter	1999-05-11	\N
4549	Bilall Fallah	1986-01-04	\N
4550	John Bradley	1988-09-15	\N
4551	Jake Castorena	\N	\N
4552	Tom Davis	1969-04-27	\N
4553	Shameik Moore	1995-05-04	\N
4554	Jason Liles	1987-07-04	\N
4555	Jerrod Carmichael	1987-06-22	\N
4556	Yuki Yamada	1990-09-18	\N
4557	Naomi Scott	1993-05-06	\N
4558	Harvey Scrimshaw	2001-11-17	\N
4559	Tornike Gogrichiani	1986-10-10	\N
4560	Jack Griffo	1996-12-11	\N
4561	Jon Rudnitsky	1989-11-22	\N
4562	Misty Copeland	1982-09-10	\N
4563	Danielle Macdonald	1991-05-19	\N
4564	Callum Turner	1990-02-15	\N
4565	Ted Sutherland	1997-03-16	\N
4566	Daveed Diggs	1982-01-24	\N
4567	Katie Sarife	1993-07-01	\N
4568	Ali Wong	1982-04-19	\N
4569	Chris Mason	1991-02-14	\N
4570	Liz Carr	1972-04-21	\N
4571	Sonoya Mizuno	1986-07-01	\N
4572	Barry Keoghan	1992-10-18	\N
4573	Jack Quaid	1992-04-24	\N
4574	Tye Sheridan	1996-11-11	\N
4575	Emilia Jones	2002-02-23	\N
4576	Elizabeth Debicki	1990-08-24	\N
4577	Jack Kesy	1986-08-27	\N
4578	Samson Kayo	1991-06-20	\N
4579	Mackenzie Davis	1987-04-01	\N
4580	Scott Chambers	2000-03-05	\N
4581	Kelly Marie Tran	1989-01-17	\N
4582	Jang Hye-jin	1975-09-05	\N
4583	Ed Skrein	1983-03-29	\N
4584	Piper Curda	1997-08-16	\N
4585	Ryan Guzman	1987-09-21	\N
4586	Aurora Perrineau	1994-09-23	\N
4587	Thomas Barbusca	2003-03-03	\N
4588	Mena Massoud	1991-09-17	\N
4589	Melissa Barrera	1990-07-04	\N
4590	Mike Faist	1992-01-05	\N
4591	Sunita Mani	1986-12-13	\N
4592	Gayle Rankin	1989-08-01	\N
4593	Emma Tremblay	2004-04-21	\N
4613	Sarah Yarkin	1993-05-28	\N
4614	Liza Soberano	1998-01-04	\N
4615	Virginia Gardner	1995-04-18	\N
4616	Jon Bass	1989-09-22	\N
4617	Joivan Wade	1993-08-02	\N
4618	Haley Lu Richardson	1995-03-07	\N
4619	Kimiko Glenn	1989-06-27	\N
4620	James Acaster	1985-01-09	\N
4621	Dascha Polanco	1982-12-03	\N
4622	Ruairi O'Connor	1991-07-09	\N
4623	Asher Angel	2002-09-06	\N
4624	Hannah John-Kamen	1989-09-07	\N
4625	Issa Rae	1985-01-12	\N
4626	Oona Laurence	2002-08-01	\N
4627	Nia DaCosta	1989-11-08	\N
4628	Ben Platt	1993-09-24	\N
4629	Joseph Quinn	1994-01-26	\N
4630	Huma Qureshi	1986-07-28	\N
4631	Adil El Arbi	1988-06-30	\N
4632	Ryan Oliva	1975-07-14	\N
4633	David Corenswet	1993-07-08	\N
4634	Honor Kneafsey	2004-08-05	\N
4635	Josh O'Connor	1990-05-20	\N
4636	Ivanna Sakhno	1997-11-14	\N
4637	Simu Liu	1989-04-19	\N
4638	Lucy Fry	1992-03-13	\N
4639	Dove Cameron	1996-01-15	\N
4640	Meg Donnelly	2000-07-25	\N
4642	Casey Hartnett	1990-12-19	\N
4643	Jenna Ortega	2002-09-27	\N
4644	Melanie Liburd	1987-11-11	\N
4645	Xolo Maridueña	2001-06-09	\N
4646	Minami Hamabe	2000-08-29	\N
4647	Christina Sotta	\N	\N
4648	Margaret Qualley	1994-10-23	\N
4649	Kyle Soller	1983-07-01	\N
4650	Lukas Gage	1995-05-28	\N
4651	Olivia Cooke	1993-12-27	\N
4652	Taylor John Smith	1995-05-13	\N
4653	Owen Teague	1998-12-08	\N
4654	Storm Reid	2003-07-01	\N
4655	Justin Copeland	\N	\N
4656	Y'lan Noel	1988-08-19	\N
4657	Da'Vine Joy Randolph	1986-05-21	\N
4658	Jacob Tremblay	2006-10-05	\N
4659	Hannah Quinlivan	1993-08-12	\N
4660	Ansel Elgort	1994-03-14	\N
4661	Drew Matthews	\N	\N
4662	Thomasin McKenzie	2000-07-26	\N
4663	Mckenna Grace	2006-06-25	\N
4664	Jasmine Cephas Jones	1989-07-21	\N
4665	Isabela Merced	2001-07-10	\N
4666	Michael Rianda	1984-12-25	\N
4667	Talitha Eliana Bateman	2001-09-04	\N
4668	Gabriel Bateman	2004-09-10	\N
4669	Sarah Jeffery	1996-04-03	\N
4670	Brandon Perea	1995-05-25	\N
4671	Lulu Wilson	2005-10-07	\N
4672	Caleb McLaughlin	2001-10-13	\N
4673	Saniyya Sidney	2006-10-30	\N
4674	Courtney Eaton	1996-01-06	\N
4675	Trevante Rhodes	1990-02-10	\N
4676	Ross Butler	1990-05-17	\N
4677	Ben Hardy	1991-01-02	\N
4678	Adria Arjona	1992-04-25	\N
4679	Saagar Shaikh	1986-11-29	\N
4680	Trevor Tordjman	1995-11-22	\N
4681	Yoson An	1992-06-23	\N
4682	Josh Green	1992-02-28	\N
4683	Keean Johnson	1996-10-25	\N
4684	Leigh Gill	1980-01-01	\N
4685	Im Si-wan	1988-12-01	\N
4686	Tom Bateman	1989-03-15	\N
4687	Bianca Santos	1990-07-26	\N
4688	Pete Ploszek	1987-01-20	\N
4708	Daisy Ridley	1992-04-10	\N
4709	Julian Dennison	2002-10-26	\N
4710	Nell Hudson	1990-11-19	\N
4711	Nick Biskupek	\N	\N
4712	Taron Egerton	1989-11-10	\N
4713	Reed Shannon	2000-09-22	\N
4714	Ashton Sanders	1995-10-24	\N
4715	Matt Cornett	1998-10-06	\N
4717	Andi Matichak	1994-05-03	\N
4718	David Errigo Jr.	1986-06-29	\N
4719	Sydney Lemmon	1990-08-10	\N
4720	RJ Cyler	1995-03-21	\N
4721	Tenzing Norgay Trainor	2001-09-04	\N
4722	Hunter Doohan	1994-01-18	\N
4723	Hannah Emily Anderson	1989-09-01	\N
4724	Odessa A'zion	2000-06-17	\N
4725	Adam Bessa	1991-11-11	\N
4726	Jeremy Ray Taylor	2003-06-02	\N
4727	Yahya Abdul-Mateen II	1986-07-15	\N
4728	Sadie Sink	2002-04-16	\N
4729	Madison Iseman	1997-02-14	\N
4730	Kit Connor	2004-03-08	\N
4731	Jack Champion	2004-11-16	\N
4732	Millie Bobby Brown	2004-02-19	\N
4733	Aryan Simhadri	2006-05-06	\N
4734	Phillipa Soo	1990-05-31	\N
4735	Natasha Rothwell	1980-10-18	\N
4736	Elizabeth Lail	1992-03-25	\N
4737	Ellie Grainger	\N	\N
4738	Laura Harrier	1990-03-28	\N
4739	Anthony Gonzalez	2004-09-23	\N
4740	Shalom Brune-Franklin	1994-08-18	\N
4741	London Thor	1997-02-09	\N
4742	Ritu Arya	1988-09-17	\N
4743	Ethan Slater	1992-06-02	\N
4744	Lewis Pullman	1993-01-29	\N
4745	Ilya Naishuller	1983-11-19	\N
4746	Maddie Phillips	1994-09-06	\N
4747	Jennifer Kluska	\N	\N
4748	Natasia Demetriou	1984-01-15	\N
4749	Mabel Cadena	1990-09-23	\N
4750	Neel Sethi	2003-12-22	\N
4751	Anya Taylor-Joy	1996-04-16	\N
4752	Jaeden Martell	2003-01-04	\N
4753	Levi Miller	2002-09-30	\N
4754	Zazie Beetz	1991-06-01	\N
4755	Nicholas Galitzine	1994-09-29	\N
4756	Marissa Bode	2000-08-28	\N
4757	Chiara Aurelia	2002-09-13	\N
4758	Archie Madekwe	1995-02-10	\N
4759	Jonah Hauer-King	1995-05-30	\N
4760	Finn Wolfhard	2002-12-23	\N
4761	Sophie McIntosh	\N	\N
4762	Leslie Grace	1995-01-07	\N
4763	Yvette Monreal	1992-07-09	\N
4764	Devyn Nekoda	2000-12-12	\N
4765	Florence Pugh	1996-01-03	\N
4766	Morfydd Clark	1990-03-17	\N
4767	Tom Glynn-Carney	1995-02-07	\N
4768	Choi Woo-shik	1990-03-26	\N
4769	Darby Camp	2007-07-14	\N
4770	Sophia Lillis	2002-02-13	\N
4771	Jason Drucker	2005-09-20	\N
4772	Pearce Joza	2002-09-06	\N
4773	Park Seo-joon	1988-12-16	\N
4774	Sunny Suljic	2005-08-10	\N
4775	Conor McGregor	1988-07-14	\N
4776	Tomer Capone	1985-07-15	\N
4777	Ashley Liao	2001-10-21	\N
4778	Harris Dickinson	1996-06-24	\N
4779	Sarah Voigt	1985-10-29	\N
4780	Emily Rudd	1993-02-24	\N
4781	Dominique Fishback	1991-03-22	\N
4782	Ava Morse	2005-11-16	\N
4783	Charles Melton	1991-01-04	\N
4784	Dallas McKennon	1919-07-19	2009-07-14
4785	Judah Lewis	2001-05-22	\N
4786	Brittany O'Grady	1992-06-02	\N
4787	Jack Dylan Grazer	2003-09-03	\N
4788	Julia Butters	2009-04-15	\N
4789	Sofia Carson	1993-04-10	\N
4790	Lex Scott Davis	1991-02-26	\N
4791	Rhys Frake-Waterfield	1991-06-28	\N
4792	Bowen Yang	1990-11-06	\N
4793	Ariel Martin	2000-11-22	\N
4794	Ariel Donoghue	2010-03-10	\N
4795	Winston Duke	1986-11-15	\N
4796	Mariela Garriga	1989-09-01	\N
4797	Emily Tosta	1998-03-26	\N
4798	Madelyn Grace	2006-12-17	\N
4799	Charlie Heaton	1994-02-06	\N
4800	Daniela Melchior	1996-11-01	\N
4801	Madeleine McGraw	2008-12-22	\N
4802	Hala Finley	2009-05-18	\N
4803	Cressida Bonas	1989-02-18	\N
4804	Parker Finn	1987-03-18	\N
4805	Park So-dam	1991-09-08	\N
4806	Drew Starkey	1993-11-04	\N
4807	Lewis MacDougall	2002-06-05	\N
4808	Natasha Rose Mills	\N	\N
4809	Nik Dodani	1993-12-19	\N
4810	Henry Golding	1987-02-05	\N
4811	Lilly Singh	1988-09-26	\N
4812	Brianna Hildebrand	1996-08-14	\N
4813	Joshua Colley	2002-01-20	\N
4814	Kyle Allen	1994-10-10	\N
4815	Joe Keery	1992-04-24	\N
4816	O'Shea Jackson Jr.	1991-02-24	\N
4817	Anthony Ramos	1991-11-01	\N
4818	Tati Gabrielle	1996-01-25	\N
4819	Brigette Lundy-Paine	1994-08-10	\N
4820	Julian Hilliard	2011-06-20	\N
4821	Gustav Lindh	1995-06-04	\N
4822	Danielle Ronald	\N	\N
4823	Kailey Hyman	1996-02-15	\N
4824	Danny Ramirez	1992-09-17	\N
4825	Darren Barnet	1991-04-27	\N
4826	Lily-Rose Depp	1999-05-27	\N
4827	Jackson A. Dunn	2003-12-09	\N
4828	Jeff Rowe	1986-07-09	\N
4829	Harry Collett	2004-01-17	\N
4830	Henry Zaga	1995-03-30	\N
4831	Samuel Adewunmi	1994-06-18	\N
4832	Dafne Keen	2005-01-04	\N
4833	Georgie Farmer	2001-05-26	\N
4834	Jenna Davis	2004-05-05	\N
4835	Caleb Eberhardt	1990-06-05	\N
4836	Kris Wu	1990-11-06	\N
4837	Natasha Liu Bordizzo	1994-08-25	\N
4838	Justice Smith	1995-08-09	\N
4839	Alexa Nisenson	2006-06-08	\N
4840	Milly Alcock	2000-04-11	\N
4841	Katy O'Brian	1989-02-12	\N
4842	Tony Bellew	1982-11-30	\N
4843	Noah Schnapp	2004-10-03	\N
4844	Laurence Ubong Williams	\N	\N
4845	Ferdia Walsh-Peelo	1999-10-12	\N
4846	Emily Carey	2003-04-30	\N
4847	Joonas Suotamo	1986-10-03	\N
4848	Moses Sumney	1992-05-19	\N
4849	Alexis Louder	1991-08-24	\N
4850	Jessica Allain	1997-02-17	\N
4851	Mamoudou Athie	1988-07-25	\N
4852	Ruby Barnhill	2004-07-16	\N
4853	Lidya Jewett	2007-01-19	\N
4854	Tom Taylor	2001-07-16	\N
4855	Ema Horvath	1994-01-28	\N
4856	Nev Scharrel	2009-01-14	\N
4857	Robert Aramayo	1992-11-06	\N
4858	Vivienne Acheampong	1983-11-30	\N
4859	Kate Kennedy	1992-04-01	\N
4860	Lana Condor	1997-05-11	\N
4861	Lara McDonnell	2003-11-07	\N
4862	Samantha Jayne	\N	\N
4863	Bennett Taylor	\N	\N
4864	Leah Jeffries	2009-09-25	\N
4865	James Godfrey	1997-01-09	\N
4866	Lyric Ross	2003-09-30	\N
4867	Gaten Matarazzo	2002-09-08	\N
4868	Saverio Raimondo	1984-01-20	\N
4869	Lia McHugh	2005-11-18	\N
4870	Jaboukie Young-White	1994-07-24	\N
4871	Miya Cech	2007-03-04	\N
4872	Erin Kellyman	1998-10-17	\N
4873	Peyton Elizabeth Lee	2004-05-22	\N
4874	Halsey	1994-09-29	\N
4875	Karen Fukuhara	1992-02-10	\N
4876	Ruby Rose Turner	2005-10-16	\N
4877	Cynthia Erivo	1987-01-08	\N
4878	Anderson .Paak	1986-02-08	\N
4879	Cailey Fleming	2007-03-28	\N
4880	Rudhraksh Jaiswal	2003-09-19	\N
4881	Olivia Scott Welch	1998-02-11	\N
4882	Eliza Scanlen	1999-01-06	\N
4883	Ewan Mitchell	1997-03-08	\N
4884	Jamie Flatters	2000-07-07	\N
4885	Lily Donoghue	1998-01-19	\N
4886	Grace Song	2001-03-30	\N
4887	Blu Hunt	1995-07-11	\N
4888	Priah Ferguson	2006-10-01	\N
4889	Calah Lane	2009-04-20	\N
4890	Noah Jupe	2005-02-25	\N
4891	Ravi Cabot-Conyers	2011-02-10	\N
4892	Jorge Lendeborg Jr.	1996-01-21	\N
4893	David Shannon	\N	\N
4894	David Howard Thornton	1979-11-30	\N
4895	Hyein Park	1997-08-25	\N
4896	Nicky Jam	1981-03-17	\N
4897	Sarah Catherine Hook	1995-04-21	\N
4898	Aaron Pierre	1994-06-07	\N
4899	Lyon Daniels	2007-06-14	\N
4900	Ariana Greenblatt	2007-08-27	\N
4901	Blitz Bazawule	1982-04-19	\N
4902	Nomzamo Mbatha	1990-07-13	\N
4903	Lovie Simone	1998-11-22	\N
4904	Sasha Lane	1995-09-29	\N
4905	Adam Faison	1990-09-14	\N
4906	Naomi Ackie	1992-11-02	\N
4907	Samina Ahmed	1950-02-11	\N
4908	Domee Shi	1989-09-08	\N
4909	Auli'i Cravalho	2000-11-22	\N
4910	Dua Lipa	1995-08-22	\N
4911	Belissa Escobedo	1998-09-16	\N
4912	Park Hae-soo	1981-11-21	\N
4913	Owen Asztalos	2005-07-15	\N
4914	Katherine Langford	1996-04-29	\N
4915	Brooklynn Prince	2010-05-04	\N
4916	Kyliegh Curran	2005-12-10	\N
4917	Akira Akbar	2006-10-02	\N
4918	Nicolas Cantu	2003-09-08	\N
4919	Andy Walken	2006-04-26	\N
4920	Khris Davis	1987-12-21	\N
4921	Cameron Crovetti	2008-03-12	\N
4922	Billy Barratt	2007-06-16	\N
4923	Gregory Diaz IV	2005-05-02	\N
4924	Jharrel Jerome	1997-10-09	\N
4925	Brian Hull	1991-08-28	\N
4926	Kingston Foster	2010-07-26	\N
4927	Fionn Whitehead	1997-07-18	\N
4928	Xochitl Gomez	2006-04-29	\N
4929	Rhenzy Feliz	1997-10-26	\N
4930	Post Malone	1995-07-04	\N
4931	Thalia Tran	2006-05-20	\N
4932	Sofia Asir	1994-02-07	\N
4933	Misha Osherovich	\N	\N
4934	Chloe Lea	2005-11-04	\N
4935	Millicent Simmonds	2003-03-06	\N
4936	Emma Mackey	1996-01-04	\N
4937	Christian Convery	2009-11-10	\N
4938	Florian Munteanu	1990-10-13	\N
4939	Joy Sunday	1995-04-17	\N
4940	Yasmeen Fletcher	2003-03-01	\N
4941	Natasha Culzac	1986-08-21	\N
4942	Bella Ramsey	2003-09-25	\N
4943	Tamara Smart	2005-06-14	\N
4944	Jacob Batalon	1996-06-06	\N
4945	Charlie Vickers	1992-02-10	\N
4946	Brandon Flynn	1993-10-11	\N
4947	Ella Balinska	1996-10-04	\N
4948	Jamie Bailey	\N	\N
4949	Evan Alex	2008-05-05	\N
4950	Jack Veal	2007-06-12	\N
4951	Cailee Spaeny	1998-07-24	\N
4952	Sharlene Martin	1953-01-14	\N
4953	Ever Anderson	2007-11-03	\N
4954	Shamon Brown Jr.	2004-07-17	\N
4955	Lauren LaVera	1994-06-14	\N
4956	Amber Doig-Thorne	\N	\N
4957	Sofia Wylie	2004-01-07	\N
4958	Daisy Edgar-Jones	1998-05-24	\N
4959	Milly Shapiro	2002-07-16	\N
4960	Nathan Blair	2005-12-06	\N
4961	McCabe Slye	1998-08-01	\N
4962	Faly Rakotohavana	2003-04-26	\N
4963	Emma D'Arcy	1992-06-27	\N
4964	KiKi Layne	1991-12-10	\N
4965	Freya Allan	2001-09-06	\N
4966	Yerin Ha	1995-06-26	\N
4967	Kylie Cantrall	2005-06-25	\N
4968	Shuya Sophia Cai	2008-04-22	\N
4969	YaYa Gosselin	2009-01-26	\N
4970	Bethany Antonia	1997-12-25	\N
4971	Eman Esfandi	1994-09-27	\N
4972	Sasha Calle	1995-08-07	\N
4973	Mark Molloy	\N	\N
4974	Violet McGraw	2011-04-22	\N
4975	Shahadi Wright Joseph	2005-04-30	\N
4976	Vivien Lyra Blair	2012-06-04	\N
4977	Phoebe Campbell	1997-09-11	\N
4978	Francesca Hayward	1992-07-04	\N
4979	Park Sung-hoon	1985-02-18	\N
4980	Ayo Edebiri	1995-10-03	\N
4981	Jessica Darrow	1995-01-07	\N
4982	Ryan Kiera Armstrong	2010-03-10	\N
4983	Patti Harrison	1990-10-31	\N
4984	Rosalie Chiang	2005-10-01	\N
4985	Dylan Henry Lau	2009-04-01	\N
4986	Fabien Frankel	1994-04-06	\N
4987	Archie Renaux	1997-11-22	\N
4988	Whitney Peak	2003-01-28	\N
4989	Kit Clarke	1998-02-19	\N
4990	Mauro Castillo	1978-06-06	\N
4991	Renata Vaca	1999-03-26	\N
4992	Keith Thomas	\N	\N
4993	Paul Mescal	1996-02-02	\N
4994	Colton Ryan	1995-06-10	\N
4995	Steve Hickner	\N	\N
4996	Evan Whitten	2009-07-08	\N
4997	Chance Perdomo	1996-10-19	2024-03-29
4998	Huck Milner	2007-08-14	\N
4999	Gabriella Baldacchino	2001-12-23	\N
5000	Quintessa Swindell	1997-02-07	\N
5001	Clinton Liberty	1998-06-04	\N
5002	Lotus Blossom	2007-10-31	\N
5003	Rish Shah	1997-12-18	\N
5004	Phylicia Pearl Mpasi	1993-11-16	\N
5005	Markella Kavenagh	2000-01-30	\N
5006	Mason Thames	2007-07-10	\N
5007	Celeste O'Connor	1998-12-02	\N
5008	Nell Verlaque	2000-10-19	\N
5009	Micah Abbey	2007-11-08	\N
5010	Kang Ae-shim	1963-02-28	\N
5011	Demi Singleton	2007-02-27	\N
5012	Isaiah Russell-Bailey	2006-12-09	\N
5013	Alyssa Wapanatâhk	1998-01-15	\N
5014	Hoyeon	1994-06-23	\N
5015	Hunter Schafer	1998-12-31	\N
5016	Wesley Kimmel	2009-12-15	\N
5017	Ferdia Shaw	2004-06-29	\N
5018	Aoife Hinds	1991-11-30	\N
5019	Kelly Yu	1989-11-07	\N
5020	Leah Brady	2012-11-07	\N
5021	Fred Hechinger	1999-12-02	\N
5022	Bad Bunny	1994-03-10	\N
5023	Dominique Thorne	1997-06-11	\N
5024	Gregory Mann	2008-10-16	\N
5025	David Jonsson	1993-09-04	\N
5026	Wi Ha-joon	1991-08-05	\N
5027	Robert Timothy Smith	2011-06-28	\N
5028	Julia Fox	1990-02-02	\N
5029	Aleyse Shannon	1996-05-16	\N
5030	Jahzir Bruno	2009-07-18	\N
5031	Faoileann Cunningham	\N	\N
5032	Jalen Thomas Brooks	2001-10-11	\N
5033	Dara Reneé	2000-11-07	\N
5034	Vilhelm Blomgren	1991-07-17	\N
5035	Izaac Wang	2007-10-22	\N
5036	Elliott Fullam	2005-09-02	\N
5037	Roman Griffin Davis	2007-03-05	\N
5038	Ali Khan	2001-05-18	\N
5039	Alexander Molony	2006-09-12	\N
5040	Javon 'Wanna' Walton	2006-07-22	\N
5041	Benjamin Evan Ainsworth	2008-09-25	\N
5042	Harry Trevaldwyn	1994-02-14	\N
5043	Emma Laird	1998-09-08	\N
5044	Ethann Isidore	2007-01-25	\N
5045	Megan Richards	\N	\N
5046	Jojo Regina	2011-04-11	\N
5047	Emma Corrin	1995-12-13	\N
5048	Piper Rubio	2015-09-16	\N
5049	Kensington Tallman	2008-08-06	\N
5050	Marlow Barkley	2008-11-18	\N
5051	Mireille Gagné	\N	\N
5052	Julia Rehwald	1995-11-22	\N
5053	Moosa Mostafa	2008-02-25	\N
5054	Andrew Diaz	2007-09-19	\N
5055	Terry Hu	1995-12-25	\N
5056	Alisha Weir	2009-09-26	\N
5057	Rachel Zegler	2001-05-03	\N
5058	Josh Rivera	1995-05-01	\N
5060	Laurel Marsden	2001-10-04	\N
5061	Naomi J. Ogawa	1996-08-24	\N
5062	Christopher Briney	1998-03-24	\N
5063	Malia Baker	2006-12-18	\N
5064	Nikolai Leon	\N	\N
5065	Spike Fearn	2000-12-09	\N
5066	Neda Margrethe Labba	\N	\N
5067	Kaylee Hottle	2008-05-01	\N
5068	Logan Kim	2007-03-07	\N
5069	Zoey Luna	2001-07-23	\N
5070	Leo Woodall	1996-09-14	\N
5071	Megan Thee Stallion	1995-02-15	\N
5072	Reneé Rapp	2000-01-10	\N
5073	Alyla Browne	2010-04-07	\N
5074	Maria Taylor	\N	\N
5075	Morgan Dudley	2001-07-09	\N
5076	Maitreyi Ramakrishnan	2001-12-29	\N
5078	Dane DiLiegro	1988-08-06	\N
5079	Elizabeth Dulau	\N	\N
5080	Joshua Pickering	2007-12-06	\N
5081	Nell Fisher	2011-11-02	\N
5082	Phia Saban	1998-09-19	\N
5083	Yinka Olorunnife	1990-01-30	\N
5084	Asa Germann	1997-12-27	\N
5085	Sinclair Daniel	1997-04-05	\N
5086	Derek Luh	1992-06-24	\N
5087	Tyroe Muhafidin	2006-01-30	\N
5088	Sophia Nomvete	1990-06-24	\N
5089	Addison Rae	2000-10-06	\N
5090	Gabrielle Echols	2005-03-17	\N
5091	Xelia Mendes-Jones	\N	\N
5092	Kyra Tantao	1996-10-27	\N
5093	Emma Berman	2008-08-01	\N
5094	Jude Hill	2010-08-01	\N
5095	Walker Scobell	2009-01-05	\N
5096	Stormee Kipp	\N	\N
5097	Iman Vellani	2002-08-12	\N
5098	Meng'er Zhang	1987-04-22	\N
5099	Miles Gutierrez-Riley	1998-09-17	\N
5100	Josh Heuston	1996-11-18	\N
5101	Alaqua Cox	1997-02-13	\N
5102	Chris Cordell	\N	\N
5103	Anupam Tripathi	1988-11-02	\N
5104	Tristan Allerick Chen	2007-07-13	\N
5105	Damir Kovic	\N	\N
5106	Jacobi Jupe	2013-07-01	\N
5107	Aileen Wu	\N	\N
5108	Joe Locke	2003-09-24	\N
5109	Zachary Hing	\N	\N
5110	Emma Jenkins-Purro	1998-11-09	\N
5111	Antonia Salib	1995-08-02	\N
5112	Ren Watabe	1999-03-06	\N
5113	Craig David Dowsett	\N	\N
5114	Amie Donald	2010-01-29	\N
5115	Henry Eikenberry	1998-11-15	\N
5116	Dakota Beavers	\N	\N
5117	Kristen Cui	2013-08-06	\N
5118	Mila Davis-Kent	2012-05-13	\N
5119	Zhou Xun	1974-10-18	\N
5120	Peter DeSouza-Feighoney	2011-01-01	\N
5121	Jesse Nasmith	\N	\N
5122	Dominic Sessa	2002-10-25	\N
5123	Olivia O'Neill	2008-07-27	\N
5124	Allegra Nocita	\N	\N
5125	Lauren Brady	2012-11-07	\N
5126	Mackenzie Mills	\N	\N
5127	Madeline Kelman	\N	\N
5128	Callum Sywyk	\N	\N
5129	Ben Harris	\N	\N
5130	Jo Yu-ri	2001-10-22	\N
5131	Sumayyah Nuriddin-Green	\N	\N
5132	Will Catlett	1982-10-16	\N
5133	Oz Perkins	1974-02-02	\N
5134	Blair Underwood	1964-08-25	\N
5135	J.C. Chandor	1973-11-24	\N
5136	Jacques Audiard	1952-04-30	\N
5137	Karla Sofía Gascón	1972-03-31	\N
5138	Adriana Paz	1980-01-13	\N
5139	Mark Ivanir	1968-09-06	\N
5140	Sean Baker	1971-02-26	\N
5141	Mikey Madison	1999-03-25	\N
5142	Mark Eydelshteyn	2002-02-18	\N
5143	Yura Borisov	1992-12-08	\N
5144	Karren Karagulian	1969-01-01	\N
5145	Vache Tovmasyan	1986-07-15	\N
5146	Darya Ekamasova	1984-05-20	\N
5147	Aleksei Serebryakov	1964-06-03	\N
5148	Tarsem Singh	1961-05-06	\N
5149	Mare Winningham	1959-05-16	\N
5150	Rupert Sanders	1971-03-16	\N
5151	Cedric Nicolas-Troyan	1969-03-09	\N
5152	Rob Brydon	1965-05-03	\N
5153	Jenna Elfman	1971-09-30	\N
5154	Timothy Dalton	1946-03-21	\N
5155	Miguel Arteta	1965-08-29	\N
5156	J.D. Pardo	1980-09-07	\N
5157	Xosha Roquemore	1984-12-11	\N
5158	Shira Haas	1995-05-11	\N
5159	Carl Lumbly	1951-08-14	\N
5160	Matt Dillon	1964-02-18	\N
5161	Rob Lowe	1964-03-17	\N
5162	Leif Garrett	1961-11-08	\N
5163	Kelvin Harrison Jr.	1994-07-23	\N
5164	Tiffany Boone	1987-08-27	\N
5165	Blue Ivy Carter	2012-01-07	\N
5166	Emmy Raver-Lampman	1988-09-05	\N
5167	Bobby Naderi	1984-11-19	\N
5168	Måns Mårlind	1969-07-29	\N
5169	Björn Stein	1970-11-17	\N
5170	Michael Ealy	1973-08-03	\N
5171	India Eisley	1993-10-29	\N
5172	Anna Foerster	1971-01-01	\N
5173	Lara Pulver	1980-09-01	\N
5174	James Faulkner	1948-07-18	\N
5175	Eric Mabius	1971-04-22	\N
5176	James Purefoy	1964-06-03	\N
5177	Martin Crewes	1968-01-01	\N
5178	Alexander Witt	1952-04-10	\N
5179	Russell Mulcahy	1953-06-23	\N
5180	Ashanti	1980-10-13	\N
5181	Christopher Egan	1984-06-29	\N
5182	Kim Coates	1958-02-21	\N
5183	Shawn Roberts	1984-04-02	\N
5184	Boris Kodjoe	1973-03-08	\N
5185	Aryana Engineer	2001-03-06	\N
5186	Johann Urb	1977-01-24	\N
5187	Eoin Macken	1983-02-21	\N
5188	William Levy	1980-08-29	\N
5189	Robbie Amell	1988-04-21	\N
5190	Tom Hopper	1985-01-28	\N
5191	Jessica Rothe	1987-05-28	\N
5192	Israel Broussard	1994-08-22	\N
5193	Suraj Sharma	1993-03-21	\N
5194	Steve Zissis	1975-12-17	\N
5195	Colin O'Brien	2010-10-15	\N
5196	Sarah Levy	1986-09-10	\N
5197	Young Mazino	1991-08-27	\N
5198	Powers Boothe	1948-06-01	2017-05-14
5199	Joanna Pacula	1957-12-30	\N
5200	Jason Priestley	1969-08-28	\N
5201	Jon Tenney	1961-12-16	\N
5202	Zabryna Guevara	1972-01-12	\N
5203	Nikki M. James	1981-06-03	\N
5204	Genneya Walton	1999-02-22	\N
5205	Arty Froushan	1993-04-16	\N
5206	Clark Johnson	1954-09-10	\N
5207	Michael Gandolfini	1999-05-10	\N
5208	Kamar de los Reyes	1967-11-08	2023-12-24
5209	Brenda Blethyn	1946-02-20	\N
5210	Terry Gilliam	1940-11-22	\N
5211	Terry Jones	1942-02-01	2020-01-21
5212	Graham Chapman	1941-01-08	1989-10-04
5213	Michael Palin	1943-05-05	\N
5214	Julia Garner	1994-02-01	\N
5215	Sam Jaeger	1977-01-29	\N
5216	Yōji Matsuda	1967-10-19	\N
5217	Yuriko Ishida	1969-10-03	\N
5218	Yūko Tanaka	1955-04-29	\N
5219	Kaoru Kobayashi	1951-09-04	\N
5220	Masahiko Nishimura	1960-12-12	\N
5221	Mitsuko Mori	1920-05-09	2012-11-10
5222	Hisaya Morishige	1913-05-04	2009-11-10
5223	Fred Williamson	1938-03-05	\N
5224	Gavin O'Connor	1963-12-24	\N
5225	Halston Sage	1993-05-10	\N
5226	Austin Abrams	1996-09-02	\N
5227	Jake Schreier	1981-09-29	\N
5228	Chris Penn	1965-10-10	2006-01-24
5229	Lawrence Tierney	1919-03-15	2002-02-26
5230	Charles Crichton	1910-08-06	1999-09-14
5716	Matt Leslie	\N	\N
5864	Dave Polsky	\N	\N
4641	Fra Fee	1987-05-20	\N
6011	Kevin Jarre	1954-08-06	2011-04-03
6171	Joe Mateo	\N	\N
2733	Timothy Olyphant	1968-05-20	\N
2734	Takehiko Ono	1942-08-01	\N
2735	Deobia Oparei	1971-12-07	\N
2736	Leland Orser	1960-08-06	\N
2737	Kenny Ortega	1950-04-18	\N
2738	John Ortiz	1968-05-23	\N
2739	Mark Osborne	1970-09-17	\N
2740	Peter Ostrum	1957-11-01	\N
2741	Patton Oswalt	1969-01-27	\N
2742	Cheri Oteri	1962-09-19	\N
2743	Dominique Othenin-Girard	1958-02-13	\N
2744	Maria Ouspenskaya	1876-07-28	1949-12-03
2745	Peter Outerbridge	1966-06-30	\N
2746	Clive Owen	1964-10-03	\N
2747	Harriet Owen	1986-10-22	\N
2748	Lloyd Owen	1966-04-14	\N
2749	Reginald Owen	1887-08-04	1972-11-05
2751	David Oyelowo	1976-04-01	\N
2752	Sergio Pablos	\N	\N
2753	Jared Padalecki	1982-07-19	\N
2754	José Padilha	1967-08-01	\N
2755	Ken Page	1954-01-20	2024-09-30
2756	Patrick Page	1962-04-27	\N
2757	Sam Page	1976-11-05	\N
2758	Nestor Paiva	1905-06-30	1966-09-09
2759	Betsy Palmer	1926-11-01	2015-05-29
2760	Hayden Panettiere	1989-08-21	\N
2761	Archie Panjabi	1972-05-31	\N
2762	Irina Pantaeva	1967-10-31	\N
2763	Dean Parisot	1952-07-06	\N
2764	Ray Park	1974-08-23	\N
2765	Lar Park Lincoln	1961-05-12	\N
2766	Eleanor Parker	1922-06-26	2013-12-09
2767	Molly Parker	1972-06-30	\N
2768	Nicole Ari Parker	1970-10-07	\N
2769	Ol Parker	1969-06-02	\N
2770	James Parks	1968-11-16	\N
2771	Michael Parks	1940-04-24	2017-05-09
2797	Sam Phillips	1962-01-28	\N
2798	Siân Phillips	1933-05-14	\N
2799	Todd Phillips	1970-12-20	\N
2800	Elliot Page	1987-02-21	\N
2801	Rosamund Pike	1979-01-27	\N
2802	Alison Pill	1985-11-27	\N
2803	Roddy Piper	1954-04-17	2015-07-31
2805	Violante Placido	1976-05-01	\N
2806	Jesse Plemons	1988-04-02	\N
2807	Suzanne Pleshette	1937-01-31	2008-01-19
2808	Joan Plowright	1929-10-28	2025-01-16
2809	Glenn Plummer	1961-08-18	\N
2810	Amy Poehler	1971-09-16	\N
2811	Priscilla Pointer	1924-05-18	2025-04-28
2812	Michael J. Pollard	1939-05-30	2019-11-21
2813	John Polson	1965-09-06	\N
2814	Anna Popplewell	1988-12-16	\N
2815	Ted Post	1918-03-31	2013-08-20
2816	Dan Povenmire	1963-09-18	\N
2817	Chris Pratt	1979-06-21	\N
2818	Harve Presnell	1933-09-14	2009-06-30
2819	Michael Pressman	1950-07-01	\N
2820	Louis Prima	1910-12-07	1978-08-24
2821	Gina Prince-Bythewood	1969-06-10	\N
2822	Robert Prosky	1930-12-13	2008-12-08
2823	Dominic Purcell	1970-02-17	\N
2824	Amrish Puri	1932-06-22	2005-01-12
2825	Missi Pyle	1972-11-16	\N
2826	Joe Pytka	1938-11-04	\N
2827	Maggie Q	1979-05-22	\N
2828	Shaobo Qin	1982-06-04	\N
2829	Steven Quale	1965-11-30	\N
2830	Ke Huy Quan	1971-08-20	\N
2831	Troy Quane	\N	\N
2832	Anthony Quayle	1913-09-07	1989-10-20
2833	Valérie Quennessen	1957-12-03	1989-03-19
2834	Zachary Quinto	1977-06-02	\N
2835	Alan Rachins	1942-10-03	2024-11-02
2836	Daniel Radcliffe	1989-07-23	\N
2837	Eric Radomski	1950-01-01	\N
2838	Jason Raize	1975-07-20	2004-02-03
2839	Efren Ramirez	1973-10-02	\N
2840	Bruce Ramsay	1966-12-31	\N
2841	Peter Ramsey	1962-12-23	\N
2842	Tony Randel	1956-05-29	\N
2843	Andrew Rannells	1978-08-23	\N
2846	Phylicia Rashad	1948-06-19	\N
2847	Victor Rasuk	1984-01-15	\N
2848	Elden Henson	1977-08-30	\N
2889	Sam Riley	1980-01-08	\N
2890	Jason Ritter	1980-02-17	\N
2891	Thelma Ritter	1902-02-14	1969-02-05
2893	Jerome Robbins	1918-10-11	1998-07-29
2894	Emma Roberts	1991-02-10	\N
2895	Larry Roberts	1926-09-28	1992-07-17
2896	Cliff Robertson	1923-09-09	2011-09-10
2897	Andrew Robinson	1942-02-14	\N
2898	Craig Robinson	1971-10-25	\N
2899	Adam Robitel	1978-05-28	\N
2900	Harry Shearer	1943-12-23	\N
2901	Charles Rocket	1949-08-24	2005-10-07
2902	Karel Roden	1962-05-18	\N
2903	Adam Rodriguez	1975-04-02	\N
2904	Jordan Rodrigues	1992-07-20	\N
2905	Michelle Rodriguez	1978-07-12	\N
2906	Emily Roeske	1991-07-15	\N
2907	Seth Rogen	1982-04-15	\N
2909	Al Roker	1954-08-20	\N
2910	Lou Romano	1972-04-15	\N
2911	Michael Rooker	1955-04-06	\N
2912	Stephen Root	1951-11-17	\N
2913	Anika Noni Rose	1972-09-06	\N
2914	Bernard Rose	1960-08-04	\N
2915	Stuart Rosenberg	1927-08-11	2007-03-15
2916	Rick Rosenthal	1949-06-15	\N
2917	Matt Ross	1970-01-03	\N
2918	Shavar Ross	1971-03-04	\N
2919	Theo Rossi	1975-06-04	\N
2920	Carlo Rota	1961-04-17	\N
2921	Eli Roth	1972-04-18	\N
2922	Rodney Rothman	\N	\N
2923	Brandon Routh	1979-10-09	\N
2924	Kelly Rowland	1981-02-11	\N
2925	Richard Roxburgh	1962-01-23	\N
2926	Deep Roy	1957-12-01	\N
2927	Daphne Rubin-Vega	1969-11-18	\N
3771	Ti West	1980-10-05	\N
1469	Albert Pyun	1953-05-19	2022-11-26
1470	Steve Blum	1960-04-29	\N
1471	James Bobin	1972-06-01	\N
1472	Eric Bogosian	1953-04-24	\N
1473	John Boles	1895-10-27	1969-02-27
1474	Uwe Boll	1965-06-22	\N
1475	Matt Bomer	1977-10-11	\N
1476	Beulah Bondi	1888-05-03	1981-01-11
1477	Bong Joon-ho	1969-09-14	\N
1478	Hugh Bonneville	1963-11-10	\N
1480	Alex Borstein	1971-02-15	\N
1481	Kate Bosworth	1983-01-02	\N
1482	Niki Botelho	1969-03-03	\N
1483	Sam Bottoms	1955-10-17	2008-12-16
1484	Raoul Bova	1971-08-14	\N
1485	Julie Bowen	1970-03-03	\N
1486	David Bowers	1970-06-28	\N
1487	Judi Bowker	1954-04-06	\N
1500	Spencer Breslin	1992-05-18	\N
1501	Jeremy Brett	1933-11-03	1995-09-12
1502	Craig Brewer	1971-12-06	\N
1503	Jordana Brewster	1980-04-26	\N
1504	Maia Brewton	1977-09-30	\N
1505	Steven Brill	1962-05-27	\N
1506	Adam Brody	1979-12-15	\N
1508	Sydney Bromley	1909-07-24	1987-08-14
1509	Richard Brooker	1954-11-20	2013-04-08
1510	Billy Brown	1970-10-30	\N
1511	Emily Browning	1988-12-07	\N
1512	Ricou Browning	1930-02-16	2023-02-27
1513	Tod Browning	1880-07-12	1962-10-06
1514	Larry Bryggman	1938-12-21	\N
1515	Greg Bryk	1972-08-19	\N
1516	Hugh Keays-Byrne	1947-05-18	2020-12-02
1517	Daniel Brühl	1978-06-16	\N
1970	Michael Gladis	1977-08-30	\N
1971	Paul Gleason	1939-05-04	2006-05-27
1972	Brendan Gleeson	1955-03-29	\N
1973	Jack Gleeson	1992-05-20	\N
1974	Iain Glen	1961-06-24	\N
1975	Tamara Glynn	1968-12-06	\N
1976	Alexander Godunov	1949-11-28	1995-05-18
1977	Dave Goelz	1946-07-16	\N
1978	Walton Goggins	1971-11-10	\N
1979	Eric Goldberg	1955-05-01	\N
1980	Mark Goldblatt	\N	\N
1981	Renée Elise Goldsberry	1971-01-02	\N
1982	Jonathan Goldstein	1968-09-02	\N
1983	Alejandro G. Iñárritu	1963-08-15	\N
1984	Meagan Good	1981-08-08	\N
1985	Caroline Goodall	1959-11-13	\N
1986	Matthew Goode	1978-04-03	\N
1987	Michael Pataki	1938-01-16	2010-04-15
1988	Dody Goodman	1914-10-28	2008-06-22
1989	Barbara Goodson	1949-08-16	\N
1990	Ginnifer Goodwin	1978-05-22	\N
1991	Joseph Gordon-Levitt	1981-02-17	\N
1992	Christopher Gorham	1974-08-14	\N
1993	Robert Hy Gorman	1980-04-03	\N
1994	Ryan Gosling	1980-11-12	\N
1995	Raja Gosnell	1958-12-09	\N
1996	Luke Goss	1968-09-29	\N
1997	Gilbert Gottfried	1955-02-28	2022-04-12
1998	Ellie Cornell	1963-12-15	\N
1999	Everardo Valerio Gout	\N	\N
2000	Topher Grace	1978-07-12	\N
2001	Lauren Graham	1967-03-16	\N
2002	Stephen Graham	1973-08-03	\N
2003	Holliday Grainger	1988-03-27	\N
2004	Alexander Granach	1890-04-18	1945-03-14
2005	Beth Grant	1949-09-18	\N
2006	Charley Grapewin	1869-12-20	1956-02-02
2007	F. Gary Gray	1969-07-17	\N
2008	James Gray	1969-04-14	\N
2009	David Gordon Green	1975-04-09	\N
2010	Kerri Green	1967-01-14	\N
2011	Shon Greenblatt	1967-05-13	\N
2012	Ellen Greene	1951-02-22	\N
2014	Shecky Greene	1926-04-08	2023-12-31
2015	Paul Greengrass	1955-08-13	\N
2016	Brad Greenquist	1959-10-08	\N
2017	Bruce Greenwood	1956-08-12	\N
2018	Judy Greer	1975-07-20	\N
2019	Kevin Greutert	1965-03-31	\N
2020	Kevin Grevioux	1973-10-09	\N
2021	Michael Greyeyes	1967-06-04	\N
2022	Jon Gries	1957-06-17	\N
2023	Eddie Griffin	1968-07-15	\N
2024	Hugh Griffith	1912-05-30	1980-05-14
2025	Rachel Griffiths	1968-12-18	\N
2026	Richard Griffiths	1947-07-31	2013-03-28
2030	Ioan Gruffudd	1973-10-06	\N
2031	Adrian Grünberg	1975-03-14	\N
2032	Luca Guadagnino	1971-08-10	\N
2033	Christopher Guard	1953-12-05	\N
2034	Dominic Guard	1956-06-18	\N
2035	Christian Gudegast	1970-02-09	\N
2036	Lance Guest	1960-07-21	\N
2037	Robert Guillaume	1927-11-30	2017-10-24
2038	Sienna Guillory	1975-03-16	\N
2039	Tom Guiry	1981-10-12	\N
2040	Clu Gulager	1928-11-16	2022-08-05
2041	James Gunn	1966-08-05	\N
2042	Moses Gunn	1929-10-02	1993-12-16
2043	Sean Gunn	1974-05-22	\N
2044	Bob Gunton	1945-11-15	\N
2045	Mark Gustafson	1959-09-19	2024-02-01
2046	Luis Guzmán	1956-08-28	\N
2047	Edmund Gwenn	1877-09-26	1959-09-06
2048	Jake Gyllenhaal	1980-12-19	\N
2049	Maggie Gyllenhaal	1977-11-16	\N
2050	David Hackl	1973-02-07	\N
2051	Bill Hader	1978-06-07	\N
2052	Marianne Hagan	1966-12-08	\N
2053	Julie Hagerty	1955-06-15	\N
2054	Tony Hale	1970-09-30	\N
2055	Jack Haley	1897-08-09	1979-06-06
2056	Jackie Earle Haley	1961-07-14	\N
2057	Albert Hall	1937-11-10	\N
2058	Klay Hall	1958-09-11	\N
2059	Michael C. Hall	1971-02-01	\N
2060	Porter Hall	1888-09-18	1953-10-06
2061	Rebecca Hall	1982-05-03	\N
2062	Regina Hall	1970-12-12	\N
2063	Charles Hallahan	1943-07-29	1997-11-25
2064	Murray Hamilton	1923-03-24	1986-09-01
2065	Jon Hamm	1971-03-10	\N
2066	Daran Norris	1964-11-01	\N
2067	James Hampton	1936-07-09	2021-04-07
2068	John Lee Hancock	1956-12-15	\N
2069	David Hand	1900-01-23	1986-10-11
2070	Taylor Handley	1984-06-01	\N
2071	Anne Haney	1934-03-04	2001-05-26
2072	Daniel Hansen	\N	\N
2073	Gunnar Hansen	1947-03-04	2015-11-07
2074	Haya Harareet	1931-09-20	2021-02-03
2075	Diana Hardcastle	1949-07-12	\N
2076	Karl Hardman	1927-03-22	2007-09-22
2077	Cory Hardrict	1979-11-09	\N
2078	Catherine Hardwicke	1955-10-21	\N
2079	George Hardy	1954-10-16	\N
2080	Tom Hardy	1977-09-15	\N
2081	David Harewood	1965-12-08	\N
2082	Elisabeth Harnois	1979-05-26	\N
2085	Estelle Harris	1928-04-22	2022-04-02
2086	Jared Harris	1961-08-24	\N
2087	Naomie Harris	1976-09-06	\N
2095	Kevin Hart	1979-07-06	\N
2096	Phil Hartman	1948-09-24	1998-05-28
2097	Forrester Harvey	1884-06-26	1945-12-14
2098	Kotoe Hatsui	1929-01-08	1990-09-21
2099	Cole Hauser	1975-03-22	\N
2100	Jack Hawkins	1910-09-14	1973-07-18
2101	Richard Haydn	1905-03-10	1985-04-25
2102	Patricia Hayes	1909-12-22	1998-09-19
2103	Dennis Haysbert	1954-06-02	\N
2104	Lena Headey	1973-10-03	\N
2105	Shari Headley	1964-07-15	\N
2106	Mark Heap	1957-05-13	\N
2107	Rob Hedden	1954-03-02	\N
2108	O.P. Heggie	1877-09-16	1936-02-07
2109	Wolfgang Heinz	1900-05-17	1984-10-30
2110	Brigitte Helm	1906-03-17	1996-06-11
2111	Martin Henderson	1974-10-08	\N
2112	Saffron Henderson	1965-09-25	\N
2113	Shirley Henderson	1965-11-24	\N
2114	Stephen McKinley Henderson	1949-08-31	\N
2115	Christina Hendricks	1975-05-03	\N
2116	Aksel Hennie	1975-10-29	\N
2117	Lenny Henry	1958-08-29	\N
2118	Jonathan Hensleigh	1959-02-13	\N
2119	Shuler Hensley	1967-03-06	\N
2120	Taraji P. Henson	1970-09-11	\N
2121	Stephen Herek	1958-11-10	\N
2122	Jay Hernandez	1978-02-20	\N
2123	Rowdy Herrington	1951-01-01	\N
2124	Grant Heslov	1963-05-15	\N
2125	Jared Hess	1979-07-18	\N
2126	Sandra Hess	1968-03-27	\N
2127	Peter Hewitt	1962-10-09	\N
2128	William Hickey	1927-09-19	1997-06-29
2129	Anthony Hickox	1959-01-30	\N
2130	Catherine Hicks	1951-08-06	\N
2131	Dan Hicks	1951-07-19	2020-06-30
2132	Leonard Hicks	1918-02-24	1971-08-08
2133	Noriko Hidaka	1962-05-31	\N
2134	Bokuzen Hidari	1894-02-20	1971-05-26
2135	Clare Higgins	1955-11-10	\N
2136	John Michael Higgins	1963-02-12	\N
2137	Freddie Highmore	1992-02-14	\N
2138	Rumi Hiiragi	1987-08-01	\N
2139	Bernard Hill	1944-12-17	2024-05-05
2140	Conleth Hill	1964-11-24	\N
2141	Dana Hill	1964-05-06	1996-07-15
2142	Marianna Hill	1942-02-09	\N
2143	Tim Hill	1958-05-31	\N
2144	Stephen Hillenburg	1961-08-21	2018-11-26
2145	Cheryl Hines	1965-09-21	\N
2146	Pat Hingle	1924-07-19	2009-01-03
2147	Akihiko Hirata	1927-12-26	1984-07-25
2148	Emile Hirsch	1985-03-13	\N
2149	Wai Ching Ho	1943-11-16	\N
2150	Judith Hoag	1968-06-29	\N
2151	Valerie Hobson	1917-04-14	1998-11-13
2152	Kane Hodder	1955-04-08	\N
2153	Aldis Hodge	1986-09-20	\N
2154	Edwin Hodge	1985-01-26	\N
2157	P.J. Hogan	1962-11-30	\N
2158	Laurie Holden	1969-12-17	\N
2159	Tom Hollander	1967-08-25	\N
2160	Polly Holliday	1937-07-02	\N
2161	Stanley Holloway	1890-10-01	1982-01-30
2162	Taylor Holmes	1878-05-15	1959-09-30
2163	Mark Holton	1958-07-19	\N
2164	Ishirô Honda	1911-05-05	1993-02-28
2165	James Hong	1929-02-22	\N
2166	Randeep Hooda	1976-08-20	\N
2167	Tom Hooper	1972-10-05	\N
2168	Stephen Hopkins	1958-11-01	\N
2169	Jeffrey Hornaday	1956-05-03	\N
2170	Nicholas Hoult	1989-12-07	\N
2171	Danny Huston	1962-05-14	\N
2172	Carice van Houten	1976-09-05	\N
2173	Arliss Howard	1954-10-18	\N
2174	Bryce Dallas Howard	1981-03-02	\N
2175	Byron Howard	1968-12-26	\N
2176	Jeremy Howard	1981-06-12	\N
2177	Ken Howard	1944-03-28	2016-03-23
2178	Kevyn Major Howard	1956-01-27	2025-02-14
2179	David Huddleston	1930-09-17	2016-08-02
2180	Barnard Hughes	1915-07-16	2006-07-10
2181	Miko Hughes	1986-02-22	\N
2182	Patrick Hughes	1978-05-13	\N
2183	Michiel Huisman	1981-07-18	\N
2184	Mary-Margaret Humes	1954-04-04	\N
2185	Charlie Hunnam	1980-04-10	\N
2186	Richard Hunt	1951-08-17	1992-01-07
2187	Bill Hunter	1940-02-27	2011-05-21
2188	Sam Huntington	1982-04-01	\N
2189	Anna Hutchison	1986-02-08	\N
2190	Willard Huyck	1945-09-08	\N
2191	Michael Hyatt	1970-02-17	\N
2192	Jonathan Hyde	1948-05-21	\N
2193	Wilfrid Hyde-White	1903-05-12	1991-05-06
2194	Rhys Ifans	1967-07-22	\N
2195	Gabriel Iglesias	1976-07-15	\N
2196	Yoshio Inaba	1920-07-15	1998-04-20
2197	Ralph Ineson	1969-12-15	\N
2198	Diana Lee Inosanto	1966-05-29	\N
2199	Bill Irwin	1950-04-11	\N
2200	James Isaac	1960-06-05	2012-05-06
2201	Robert Iscove	1947-07-04	\N
2202	Maia Morgenstern	1962-05-01	\N
2203	Giselle Itié	1981-10-03	\N
2204	Edward Ivory	1927-04-28	\N
2205	Eddie Izzard	1962-02-07	\N
2206	Wolfman Jack	1939-01-21	1995-07-01
2207	Hugh Jackman	1968-10-12	\N
2208	Mick Jackson	1943-10-04	\N
2209	Wilfred Jackson	1906-06-24	1988-08-07
2210	Gregory Jacobs	1968-08-14	\N
2211	Peter Jacobson	1965-03-24	\N
2212	Sam Jaffe	1891-03-10	1984-03-24
2213	Dean Jagger	1903-11-07	1991-02-05
2214	Clifton James	1920-05-29	2017-04-15
2215	Kevin James	1965-04-26	\N
2216	Lennie James	1965-10-11	\N
2217	Annabel Jankel	1955-06-01	\N
2218	Tony Jay	1933-02-02	2006-08-13
2219	Eddie Jemison	1963-11-25	\N
2220	Richard Jeni	1957-04-14	2007-03-10
2221	Patty Jenkins	1971-07-24	\N
2222	Richard Jenkins	1947-05-04	\N
2223	Ashley Jensen	1969-08-11	\N
2224	Vicky Jenson	1960-03-04	\N
2225	Ken Jeong	1969-07-13	\N
2227	Zita Johann	1904-07-14	1993-09-24
2228	Scarlett Johansson	1984-11-22	\N
2229	Johnny Knoxville	1971-03-11	\N
2230	Glynis Johns	1923-10-05	2024-01-04
2232	Dwayne Johnson	1972-05-02	\N
2233	Eric Johnson	1979-08-07	\N
2234	Mark Steven Johnson	1964-10-30	\N
2235	Mike Johnson	\N	\N
2236	Rian Johnson	1973-12-17	\N
2237	Tim Johnson	1961-08-27	\N
2238	Tor Johnson	1903-10-19	1971-05-12
2239	Doug Jones	1960-05-24	\N
2240	Duane Jones	1936-02-02	1988-07-22
2241	Felicity Jones	1983-10-17	\N
2243	Gemma Jones	1942-12-04	\N
2244	Kirk Jones	1964-10-31	\N
2245	Leslie Jones	1967-09-07	\N
2247	Rashida Jones	1976-02-25	\N
2248	Renée Jones	1958-10-15	\N
2249	Toby Jones	1966-09-07	\N
2250	Tom Jones	1940-06-07	\N
2251	Michael B. Jordan	1987-02-09	\N
2252	Richard Jordan	1937-07-19	1993-08-30
2908	J.B. Rogers	\N	\N
7375	Shea Couleé	1989-02-08	\N
3485	Sam Witwer	1977-10-20	\N
5334	Joseph David-Jones	1993-12-22	\N
5335	LaMonica Garrett	1975-05-23	\N
5336	Jed Whedon	1975-07-18	\N
5337	Maurissa Tancharoen	1975-11-28	\N
5338	Brett Dalton	1983-01-07	\N
5339	Iain De Caestecker	1987-12-29	\N
5340	Elizabeth Henstridge	1987-09-11	\N
5341	Nick Blood	1982-03-20	\N
5342	Henry Simmons	1970-07-01	\N
5343	Luke Mitchell	1985-04-17	\N
5344	Natalia Cordova-Buckley	1982-11-25	\N
5345	Jeff Ward	1986-12-30	\N
5346	Geoff Johns	1973-01-25	\N
5347	Grant Gustin	1990-01-14	\N
5348	Candice Patton	1985-06-24	\N
5349	Rick Cosnett	1983-04-06	\N
5350	Carlos Valdes	1989-04-20	\N
5351	Tom Cavanagh	1963-10-26	\N
5352	Jesse L. Martin	1969-01-18	\N
5353	Keiynan Lonsdale	1991-12-19	\N
5354	Neil Sandilands	1975-05-01	\N
5355	Hartley Sawyer	1985-01-25	\N
5356	Danielle Nicolet	1973-11-24	\N
5357	Jessica Parker Kennedy	1984-10-03	\N
5358	Efrat Dor	1983-01-06	\N
5359	Toby Leonard Moore	1981-04-28	\N
5360	Vondie Curtis-Hall	1950-09-30	\N
5361	Stephen Rider	1979-09-25	\N
5363	Ali Adler	1967-05-30	\N
5364	Melissa Benoist	1988-10-04	\N
5365	Chyler Leigh	1982-04-10	\N
5366	Jeremy Jordan	1984-11-20	\N
5367	Calista Flockhart	1964-11-11	\N
5368	Floriana Lima	1981-03-26	\N
5369	Chris Wood	1988-04-14	\N
5370	Katie McGrath	1983-01-03	\N
5371	Jesse Rath	1989-02-11	\N
5372	Nicole Maines	1997-10-07	\N
5373	April Parker Jones	1976-03-06	\N
5374	Azie Tesfai	\N	\N
5375	Andrea Brooks	1989-03-03	\N
5376	Julie Gonzalo	1981-09-09	\N
5377	Staz Nair	1991-06-17	\N
5378	Melissa Rosenberg	1962-08-28	\N
5379	Mike Colter	1976-08-26	\N
5424	Jason R. Moore	\N	\N
5425	Michael Nathanson	\N	\N
5426	Jamie Ray Newman	1978-04-02	\N
5427	Josh Stewart	1977-02-06	\N
5428	Giorgia Whigham	1997-08-18	\N
5429	Josh Schwartz	1976-08-06	\N
5430	Stephanie Savage	1969-08-07	\N
5431	Lyrica Okano	1994-11-09	\N
5432	Ariela Barer	1998-10-14	\N
5433	Gregg Sulkin	1992-05-29	\N
5434	Allegra Acosta	2002-12-12	\N
5435	Angel Parker	1980-10-17	\N
5436	Ryan Sands	\N	\N
5437	Annie Wersching	1977-03-28	2023-01-29
5438	Kip Pardue	1975-09-23	\N
5439	Ever Carradine	1974-08-06	\N
5440	James Marsters	1962-08-20	\N
5441	Brigid Brannagh	1972-08-03	\N
5442	Kevin Weisman	1970-12-29	\N
5443	Brittany Ishibashi	1980-11-02	\N
5444	James Yaegashi	1972-10-10	\N
5445	Clarissa Thibeaux	1990-08-23	\N
5446	Salim Akil	1964-06-22	\N
5447	Cress Williams	1970-07-26	\N
5448	Nafessa Williams	1989-12-04	\N
5449	Christine Adams	1974-08-15	\N
5450	Krondon	1976-07-09	\N
5451	Damon Gupton	1973-01-04	\N
5452	Jordan Calloway	1990-10-18	\N
5453	Caroline Dries	1980-08-19	\N
5454	Rachel Skarsten	1985-04-23	\N
5455	Meagan Tandy	1985-05-03	\N
5456	Camrus Johnson	1994-12-22	\N
5457	Nicole Kang	1991-10-07	\N
5458	Elizabeth Anweis	\N	\N
5459	Brec Bassinger	1999-05-25	\N
5460	Anjelika Washington	1998-05-15	\N
5461	Cameron Gellman	1998-10-10	\N
5462	Trae Romano	2005-05-02	\N
5463	Jake Austin Walker	1997-06-24	\N
5464	Hunter Sansone	1993-12-02	\N
5465	Meg DeLacy	1996-07-09	\N
5466	Neil Jackson	1976-03-05	\N
5467	Christopher James Baker	\N	\N
5468	Dougal Wilson	1971-08-01	\N
5469	Mark Burton	1960-09-23	\N
5470	Jon Foster	1981-09-18	\N
5471	James Lamont	1982-06-15	\N
5472	Carla Tous	2001-01-01	\N
5473	Simon Farnaby	1973-04-02	\N
5474	Josh Campbell	\N	\N
5475	Matt Stuecken	\N	\N
5476	Kristen Buckley	1968-06-09	\N
5477	Brian Regan	\N	\N
5478	Bob Tzudiker	1953-08-28	\N
5479	Noni White	\N	\N
5480	Reginald Rose	1920-12-10	2002-04-19
5481	John Ridley	1964-10-01	\N
5482	Michael Brandt	1968-10-01	\N
5483	Derek Haas	1970-06-30	\N
5484	Arthur C. Clarke	1917-12-16	2008-03-19
5485	Harald Kloser	1956-07-09	\N
5486	Kurt Johnstad	\N	\N
5487	Michael B. Gordon	1976-02-27	\N
5488	Paul Wernick	1972-08-02	\N
5489	Rhett Reese	1969-07-23	\N
5490	Roger Christian	1944-02-25	\N
5491	Corey Mandell	\N	\N
5492	J. David Shapiro	1969-03-18	\N
5493	Richard Tyson	1961-02-13	\N
5494	Sabine Karsenti	1974-09-01	\N
5495	Kevin Etten	\N	\N
5496	Rafe Judkins	1983-01-08	\N
5497	Art Marcum	\N	\N
5498	Matt Holloway	\N	\N
5499	Ronald Bronstein	\N	\N
5500	Danny McBride	\N	\N
5501	Dirk Blackman	\N	\N
5502	Howard McCain	1968-12-21	\N
5503	John Hlavin	\N	\N
5504	J. Michael Straczynski	1954-07-17	\N
5505	Allison Burnett	1958-12-16	\N
5506	Cory Goodman	\N	\N
5507	Nelson Greaves	\N	\N
5508	Ted Griffin	1970-12-21	\N
5509	George Nolfi	1968-06-10	\N
5510	Brian Koppelman	1966-04-27	\N
5511	David Levien	1967-12-09	\N
5512	Olivia Milch	\N	\N
5513	Greg Rucka	1969-11-29	\N
5514	David Seltzer	1940-02-12	\N
5515	Lawrence Hauben	1931-03-03	1985-12-22
5516	Bo Goldman	1932-09-10	2023-07-25
5517	Jason Headley	\N	\N
5518	Keith Bunin	\N	\N
5519	David Leslie Johnson-McGoldrick	\N	\N
5520	Juliet Snowden	\N	\N
5521	Jeff Howard	\N	\N
5522	Kathleen Rowell	\N	\N
5523	Mitchell Kapner	\N	\N
5524	David Lindsay-Abaire	1969-11-30	\N
5525	Kevin Williamson	1965-03-14	\N
5526	Trey Callaway	\N	\N
5527	Barry Fanaro	\N	\N
5528	Jim Taylor	\N	\N
5529	Jeff Vintar	1964-07-03	\N
5530	Akiva Goldsman	1962-07-07	\N
5531	Michael Berg	\N	\N
5532	Michael J. Wilson	1966-01-13	\N
5533	Peter Ackerman	\N	\N
5534	Peter Gaulke	\N	\N
5535	Gerry Swallow	\N	\N
5536	Jim Hecht	1975-09-19	\N
5537	Mike Reiss	1959-09-15	\N
5538	Yoni Brenner	\N	\N
5539	Jason Fuchs	1986-03-05	\N
5540	Quiara Alegría Hudes	1977-09-22	\N
5541	Zak Penn	1968-03-23	\N
5542	Nicolas Wright	1982-03-23	\N
5543	James A. Woods	1979-10-30	\N
5544	James Vanderbilt	1975-11-17	\N
5545	Lawrence Kasdan	1949-01-14	\N
5546	Gloria Katz	1942-10-25	2018-11-25
5547	Jeffrey Boam	1946-11-30	2000-01-26
5548	Jez Butterworth	1969-03-04	\N
5549	John-Henry Butterworth	1976-01-01	\N
5550	E.J. Altbacker	\N	\N
5551	Meg LeFauve	1969-10-19	\N
5552	Dave Holstein	1983-04-08	\N
5553	Scott Teems	\N	\N
5554	John Morris	1969-02-23	\N
5555	Jonathan Nolan	1976-06-06	\N
5556	Anne Rice	1941-10-04	2021-12-11
5557	James Lapine	1949-01-10	\N
5558	R.C. Sherriff	1896-06-06	1975-11-13
5559	Tim McCanlies	\N	\N
5560	Mark Fergus	\N	\N
5561	Hawk Ostby	\N	\N
5562	Drew Pearce	1975-08-24	\N
5563	Lawrence D. Cohen	\N	\N
5564	Chase Palmer	\N	\N
5565	Cary Joji Fukunaga	1977-07-10	\N
5566	Frances Goodrich	1890-12-21	1984-01-29
5567	Christy Hall	\N	\N
5568	Melissa Mathison	1950-06-03	2015-11-04
5569	Caroline Thompson	1956-04-23	\N
5570	Christopher Markus	1969-10-16	\N
5571	Stephen McFeely	1970-02-24	\N
5572	Stuart Zicherman	\N	\N
5573	M. Raven Metzner	\N	\N
5574	Kat Likkel	\N	\N
5575	John Hoberg	\N	\N
5576	Brenda Hsueh	\N	\N
5577	David Berenbaum	\N	\N
5578	Sam Bromell	\N	\N
5579	Craig Pearce	1961-11-30	\N
5580	Jeremy Doner	1972-04-10	\N
5581	Eric Siegel	\N	\N
5582	David Reynolds	1966-08-10	\N
5583	Charise Castro Smith	1983-08-30	\N
5584	Bill Kelly	\N	\N
5585	Jack Thorne	1978-12-06	\N
5586	Michael Allin	\N	\N
5587	Richard Wenk	1956-05-06	\N
5588	Peter Buchman	1967-07-13	\N
5589	Paul Dehn	1912-11-05	1976-09-30
5590	Bragi F. Schut	1973-01-04	\N
5591	Maria Melnik	\N	\N
5592	Will Honley	\N	\N
5593	Daniel Tuch	\N	\N
5594	Oren Uziel	1974-06-28	\N
5595	Charlie Kaufman	1958-11-19	\N
5596	Patrick Burleigh	1984-01-01	\N
5597	Ryan Firpo	\N	\N
5598	Kaz Firpo	1990-08-14	\N
5599	Philip Eisner	\N	\N
5601	William Peter Blatty	1928-01-07	2017-01-12
5602	Peter Sattler	\N	\N
5603	David Callaham	1977-10-24	\N
5604	Creighton Rothenberger	\N	\N
5605	Katrin Benedikt	\N	\N
5606	Frederic Raphael	1931-08-14	\N
5607	Stephen Shields	1987-03-31	\N
5608	Guy Busick	1975-11-01	\N
5609	Bill Dubuque	\N	\N
5610	Ethan Gross	\N	\N
5611	Jonathan Tropper	1970-02-19	\N
5612	T.S. Nowlin	\N	\N
5613	Jennifer Flackett	\N	\N
5614	Mark Levin	1968-08-20	\N
5615	Jack Bernstein	\N	\N
5616	Larry Wilson	1948-01-23	\N
5617	Paul Rudnick	1957-12-29	\N
5618	Matt Lieberman	\N	\N
5619	Dan Hernandez	1983-11-20	\N
5620	Benji Samit	1984-07-21	\N
5621	Ben Queen	\N	\N
5622	Susanna Fogel	1980-10-08	\N
5623	David Simkins	\N	\N
5624	Tiffany Paulsen	\N	\N
5625	Marcel Rodriguez	1974-08-03	\N
5626	Gary Whitta	1972-07-21	\N
5627	Andrew W. Marlowe	1966-12-23	\N
5628	Ted Elliott	1961-07-04	\N
5629	Terry Rossio	1960-07-02	\N
5630	John August	1970-08-04	\N
5631	Rob Lieber	1976-01-28	\N
5632	Linda Woolverton	1952-12-19	\N
5633	Dan O'Bannon	1946-09-30	2009-12-17
5634	David Giler	1943-07-23	2020-12-19
5635	Walter Hill	1942-01-10	\N
5636	Larry Ferguson	\N	\N
5637	Shane Salerno	1972-11-27	\N
5638	John Logan	1961-09-24	\N
5639	Dante Harper	\N	\N
5640	Laeta Kalogridis	1965-08-30	\N
5641	Elan Mastai	\N	\N
5642	Michael Roesch	1974-04-24	\N
5643	Peter Scheerer	1973-12-16	\N
5644	Jon Vitti	\N	\N
5645	Will McRobb	1961-07-02	\N
5646	Chris Viscardi	1962-01-14	\N
5647	Jonathan Aibel	1969-08-06	\N
5648	Glenn Berger	1969-08-26	\N
5649	Randi Mayem Singer	\N	\N
5650	Adam Sztykiel	1978-01-09	\N
5651	Peter Shaffer	1926-05-15	2016-06-06
5652	Alvin Sargent	1927-04-12	2019-05-09
5653	Steve Kloves	1960-03-18	\N
5654	Roberto Orci	1973-07-20	2025-02-25
5655	Jeff Pinkner	1964-11-16	\N
5656	Alan Ball	1957-05-13	\N
5657	David McKenna	1968-08-14	\N
5658	Adam Herz	1972-09-12	\N
5659	Jason Hall	1972-04-28	\N
5660	Sandor Stern	1936-07-13	\N
5661	Scott Kosar	1963-09-26	\N
5662	Joe Cornish	1968-12-20	\N
5663	Chris McKenna	1969-12-03	\N
5664	Erik Sommers	1976-12-16	\N
5665	Andrew Barrer	\N	\N
5666	Gabriel Ferrari	\N	\N
5667	Jeff Loveness	1989-06-06	\N
5668	Todd Alcott	1961-10-22	\N
5669	I.A.L. Diamond	1920-06-27	1988-04-21
5670	Will Beall	1971-12-10	\N
5671	Ivan Raimi	1956-06-21	\N
5672	Shay Hatten	1994-03-18	\N
5673	Eric Heisserer	1970-04-30	\N
5674	Conor McPherson	1971-08-06	\N
5675	Hamish McColl	1962-01-28	\N
5676	Peter Baynham	1963-06-28	\N
5677	Tab Murphy	1963-05-12	\N
5678	Michael McCullers	\N	\N
5679	Rick Jaffa	1956-05-08	\N
5680	Amanda Silver	1963-05-24	\N
5681	Katherine Fugate	1965-07-14	\N
5682	Joseph Minion	\N	\N
5683	Scott Rosenberg	1963-04-24	\N
5684	Patrick Casey	1978-12-19	\N
5685	Josh Miller	1978-09-23	\N
5686	Jerome Armstrong	1949-04-13	2023-06-09
5687	Billy Ray	1971-09-21	\N
5688	David Hayter	1969-02-06	\N
5689	Dan Harris	1979-08-29	\N
5690	Skip Woods	1967-12-04	\N
5691	Ashley Miller	1971-03-16	\N
5692	Zack Stentz	1980-08-21	\N
5693	Jane Goldman	1970-06-11	\N
5694	Chris Terrio	1976-12-31	\N
5695	David Light	\N	\N
5697	Jim Reardon	\N	\N
5698	Mark Bomback	1971-08-29	\N
5699	Charles Leavitt	\N	\N
5700	Lawrence Lasker	1949-10-07	\N
5701	Walter F. Parkes	1951-04-15	\N
5702	Alex Tse	1976-05-20	\N
5703	Ernest Lehman	1915-12-08	2005-07-02
5704	Tony Kushner	1956-07-16	\N
5705	Lucy Alibar	1983-01-01	\N
5706	Norman Krasna	1909-11-07	1984-11-01
5707	Norman Panama	1914-04-21	2003-01-13
5708	Melvin Frank	1913-08-13	1988-10-13
5709	Jeffrey Price	1949-12-18	\N
5710	Peter S. Seaman	1951-10-26	\N
5711	Winnie Holzman	1954-08-18	\N
5712	Dana Fox	1976-09-18	\N
5713	Bob Dolman	1949-04-05	\N
5714	G.O. Parsons	1982-09-02	\N
5715	Roald Dahl	1916-09-13	1990-11-23
5717	Allison Moore	\N	\N
5718	Allan Scott	1939-09-16	\N
5719	Kenya Barris	1973-08-09	\N
5720	Noel Langley	1911-12-25	1980-11-04
5721	Florence Ryerson	1892-09-20	1965-06-08
5722	Edgar Allan Woolf	1881-04-25	1943-12-09
5723	Curt Siodmak	1902-08-10	2000-09-02
5724	Corbett Tuck	1977-03-04	\N
5725	Terence Winter	1960-10-02	\N
5726	Mairghread Scott	1985-09-18	\N
5727	Matthew Michael Carnahan	\N	\N
5728	Damon Lindelof	1973-04-24	\N
5729	Dan Mazeau	1979-08-29	\N
5730	Jeff Stockwell	\N	\N
5731	Travis Beacham	\N	\N
5732	Emily Carmichael	1982-01-27	\N
5733	Kira Snyder	\N	\N
5734	Scott Neustadter	\N	\N
5735	Michael H. Weber	1978-01-13	\N
5736	Han Jin-won	\N	\N
5737	Benedict Fitzgerald	1949-03-09	2024-01-17
5738	Robert Rodat	\N	\N
5739	Matt Cook	\N	\N
5740	Joshua Zetumer	\N	\N
5741	Randall Wallace	1949-07-28	\N
5742	Michael Colton	\N	\N
5743	John Aboud	1973-03-07	\N
5744	Brandon Sawyer	1974-01-07	\N
5745	Craig Titley	\N	\N
5746	Stephen King	1947-09-21	\N
5747	Jeff Buhler	\N	\N
5748	Malcolm Marmorstein	1928-08-09	2020-11-21
5749	Toby Halbrooks	1978-08-16	\N
5750	Michael Goldenberg	1965-01-18	\N
5751	Andrew Lloyd Webber	1948-03-22	\N
5752	Jon Colton Barry	1969-03-12	\N
5753	Jim Bernstein	\N	\N
5754	Joshua Pruett	1978-03-21	\N
5755	Kate Kondell	\N	\N
5756	Jeffrey M. Howard	\N	\N
5757	Bill Roberts	1899-08-02	1974-03-18
5758	Norman Ferguson	1902-09-02	1957-11-04
5759	Jack Kinney	1909-03-29	1992-02-09
5760	T. Hee	1911-03-26	1988-10-30
5761	Jeff Nathanson	1965-10-12	\N
5762	Tim Herlihy	1966-10-09	\N
5763	Tim Dowling	1976-10-26	\N
5764	Michael Wilson	1914-07-01	1978-04-09
5765	Rod Serling	1924-12-25	1975-06-28
5766	William Broyles Jr.	1944-10-08	\N
5767	Lawrence Konner	1949-09-14	\N
5768	Mark Rosenthal	\N	\N
5769	Carl Binder	1960-08-10	\N
5770	Susannah Grant	1963-01-04	\N
5771	Philip LaZebnik	1953-02-08	\N
5772	W. Peter Iliff	1957-11-19	\N
5773	Derek Connolly	\N	\N
5774	Jayson Rothwell	\N	\N
5775	Michael Grais	1948-03-28	\N
5776	Mark Victor	\N	\N
5777	Tony McNamara	1966-12-31	\N
5778	John Gatins	1968-04-16	\N
5779	Jim Thomas	\N	\N
5780	John Thomas	\N	\N
5781	Alex Litvak	\N	\N
5782	Michael Finch	\N	\N
5783	Patrick Aison	\N	\N
5784	Deborah Moggach	1948-06-28	\N
5785	Rob Edwards	1963-06-22	\N
5786	William Goldman	1931-08-12	2018-11-16
5787	Gina Wendkos	1954-10-02	\N
5788	Shonda Rhimes	1970-01-13	\N
5789	Annie DeYoung	\N	\N
5790	Thomas Meehan	1929-08-14	2017-08-21
5791	Jon Spaihts	1970-02-04	\N
5792	Joseph Stefano	1922-05-05	2006-08-25
5793	Michael France	1962-01-04	2013-04-12
5794	Nick Santora	1970-01-01	\N
5795	Tom Wheeler	\N	\N
5796	Tommy Swerdlow	1962-08-15	\N
5797	Anthony Mendez	\N	\N
5798	Scott Beck	1984-10-22	\N
5799	Bryan Woods	1984-09-14	\N
5800	Barry Morrow	1948-06-12	\N
5801	Ronald Bass	1942-03-26	\N
5802	Pamela Ribon	1975-04-04	\N
5803	Sheldon Lettich	1951-01-14	\N
5804	Art Monterastelli	1957-10-24	\N
5805	Matthew Cirulnick	\N	\N
5806	Ryan Engle	1979-01-20	\N
5807	Carlton Cuse	1959-03-22	\N
5808	Qui Nguyen	1976-01-01	\N
5809	Adele Lim	1975-08-15	\N
5810	Ernest Cline	1972-03-29	\N
5811	John Michael Hayes	1919-05-11	2008-11-19
5812	Chris Morgan	1970-12-05	\N
5813	Arthur Hoerl	1891-12-17	1968-02-06
5814	Tim Sheridan	\N	\N
5815	Jim Krieg	1966-01-27	\N
5816	Gregory Allen Howard	1952-01-28	2023-01-27
5817	Ryan Ridley	\N	\N
5818	Max Enscoe	\N	\N
5819	Juliet Giglio	\N	\N
5820	Keith Giglio	\N	\N
5821	Temple Mathews	\N	\N
5822	Gill Dennis	1941-01-25	2015-05-13
5823	Ehren Kruger	1972-10-05	\N
5824	R. Lance Hill	\N	\N
5825	Hilary Henkin	1952-11-19	\N
5826	Anthony Bagarozzi	1971-09-04	\N
5827	Chuck Mondry	1968-03-13	\N
5828	Edward Neumeier	1957-08-24	\N
5829	Michael Miner	1949-11-06	\N
5830	Walon Green	1936-12-15	\N
5831	David Weisberg	\N	\N
5832	Douglas S. Cook	1959-06-26	2015-07-19
5833	Mark Rosner	1952-12-15	\N
5834	Lee Hall	1966-09-20	\N
5835	Pam Brady	1969-07-28	\N
5836	Brian C. Brown	\N	\N
5837	Elliott DiGuiseppi	\N	\N
5838	Angelo Pizzo	\N	\N
5839	Kyle Hunter	\N	\N
5840	Ariel Shaffir	\N	\N
5841	Sue Smith	1959-01-01	\N
5842	Rich Wilkes	1966-08-15	\N
5843	F. Scott Frazier	\N	\N
5844	Robert Gunter	\N	\N
5845	Paul L. Jacobson	\N	2015-07-10
5846	David Newman	1937-02-04	2003-06-27
5847	Leo Benvenuti	1959-10-10	\N
5848	Steve Rudnick	1958-02-24	\N
5849	Don Rhymer	1961-02-23	2012-11-28
5850	Cinco Paul	1964-05-05	\N
5851	Ken Daurio	1971-07-15	\N
5852	Ed Decter	1959-05-19	\N
5853	John J. Strauss	1957-05-12	\N
5854	Patrick Melton	1975-06-18	\N
5855	Marcus Dunstan	1975-09-19	\N
5856	Josh Stolberg	1971-03-07	\N
5857	Peter Goldfinger	1967-06-01	\N
5858	Buddy Johnson	\N	\N
5859	Phil Beauman	\N	\N
5860	Jason Friedberg	1971-10-13	\N
5861	Aaron Seltzer	1974-01-12	\N
5862	Alyson Fouse	1965-11-06	\N
5863	Greg Grabianski	\N	\N
5865	Michael Anthony Snowden	\N	\N
5866	Craig Wayans	\N	\N
5867	Pat Proft	1947-04-03	\N
5868	Steven Zaillian	1953-01-30	\N
5869	David Magee	1962-01-01	\N
5870	Jack Donaldson	\N	\N
5871	Derek Elliott	\N	\N
5872	William Osborne	\N	\N
5873	Michael Bacall	1973-04-19	\N
5874	Mitch Glazer	1953-01-01	\N
5875	Michael O'Donoghue	1940-01-05	1994-11-08
5876	Brian Lynch	1973-06-21	\N
5877	Andrew Green	\N	\N
5878	Paul Webb	\N	\N
5879	Andrew Kevin Walker	1964-08-14	\N
5880	Shinobu Hashimoto	1918-04-18	2018-07-19
5881	Hideo Oguni	1904-07-09	1996-02-05
5882	Andrew Lanham	\N	\N
5883	Thunder Levin	\N	\N
5884	Scotty Mullen	\N	\N
5885	Henry Gayden	1979-12-28	\N
5886	Michael Robert Johnson	\N	\N
5887	Anthony Peckham	\N	\N
5888	Kieran Mulroney	1965-09-24	\N
5889	Michele Mulroney	\N	\N
5890	Diane Johnson	1934-04-28	\N
5891	Joe Eszterhas	1944-11-23	\N
5892	Joe Stillman	1959-08-01	\N
5893	Roger S.H. Schulman	\N	\N
5894	J. David Stem	\N	\N
5895	David N. Weiss	\N	\N
5896	Aron Warner	1961-03-25	\N
5897	Josh Klausner	1969-07-11	\N
5898	Darren Lemke	1969-01-01	\N
5899	Ted Tally	1952-04-09	\N
5900	Michael Hickey	\N	\N
5901	Joseph H. Earle	\N	\N
5902	C. Robert Cargill	1975-09-08	\N
5903	Paul Hernandez	\N	2014-07-27
5904	Bob Schooley	1961-09-01	\N
5905	Mark McCorkle	1961-08-16	\N
5906	Simon Beaufoy	1966-12-26	\N
5907	Evan Spiliotopoulos	1973-01-01	\N
5908	Joe Shrapnel	1976-11-01	\N
5909	Anna Waterhouse	\N	\N
5910	Evan Daugherty	\N	\N
5911	Hossein Amini	1966-01-18	\N
5912	Perce Pearce	1899-09-07	1955-07-04
5913	William Cottrell	1906-11-19	1995-12-22
5914	Larry Morey	1905-03-26	1971-05-08
5915	Kelly Masterson	1950-01-01	\N
5916	Aaron Sorkin	1961-06-09	\N
5917	Jonathan Kasdan	1979-09-30	\N
5918	Joe R. Lansdale	1951-10-28	\N
5919	Doug Miro	1972-01-20	\N
5920	Carlo Bernard	\N	\N
5921	Matt Lopez	\N	\N
5922	Mike Jones	1971-06-01	\N
5923	Allan Loeb	1969-07-25	\N
5924	Timothy Harris	1946-07-21	\N
5925	Herschel Weingrod	1947-10-30	\N
5926	Juel Taylor	1987-05-01	\N
5927	Tony Rettenmaier	\N	\N
5928	Keenan Coogler	\N	\N
5929	Terence Nance	1982-02-10	\N
5930	Jesse Gordon	\N	\N
5931	Celeste Ballard	\N	\N
5932	Ronny Graham	1919-08-26	1999-07-04
5933	Alan B. McElroy	1960-10-01	\N
5934	Graham Yost	1959-09-05	\N
5935	Kent Osborne	1969-08-30	\N
5936	Aaron Springer	1973-09-05	\N
5937	Bruce A. Evans	1946-09-19	\N
5938	Raynold Gideon	\N	\N
5939	Eric Roth	1945-03-22	\N
5940	Will Fetters	\N	\N
5941	Harold Livingston	1924-09-04	2022-04-28
5942	Jack B. Sowards	1929-03-18	2007-07-08
5943	Harve Bennett	1930-08-17	2015-02-25
5944	Steve Meerson	\N	\N
5945	Peter Krikes	\N	\N
5946	David Loughery	1953-03-03	2024-07-09
5947	Denny Martin Flinn	1947-12-21	2007-08-24
5948	Ronald D. Moore	1964-07-05	\N
5949	Brannon Braga	1965-08-14	\N
5950	Michael Piller	1948-05-30	2005-11-01
5951	Doug Jung	\N	\N
5952	Leonard Ripps	\N	\N
5953	Bruce Vilanch	1947-11-23	\N
5954	Rod Warren	\N	1984-10-22
5955	Mitzie Welch	1931-07-25	2014-06-10
5956	Henry Gilroy	1976-11-04	\N
5957	Steven Melching	1968-02-24	\N
5958	Scott Murphy	\N	\N
5959	Leigh Brackett	1915-12-07	1978-03-24
5960	Jonathan Hales	1937-05-10	\N
5961	Michael Arndt	1965-11-11	\N
5962	Robert Harling	1951-11-12	\N
5963	Ben Ketai	1982-07-25	\N
5964	Steve Shibuya	\N	\N
5965	Alan Burnett	1950-02-17	\N
5966	Parker Bennett	\N	\N
5967	Terry Runté	1960-10-07	1994-10-17
5968	Ed Solomon	1960-09-15	\N
5969	Matthew Fogel	\N	\N
5970	David Odell	1943-07-08	\N
5971	Mario Puzo	1920-10-15	1999-07-02
5972	Leslie Newman	\N	\N
5973	Robert Benton	1932-09-29	2025-05-11
5974	Deborah Kaplan	1970-11-11	\N
5975	Harry Elfont	1968-04-05	\N
5976	Jennifer Ventimilia	1966-05-20	\N
5977	Joshua Sternin	1966-12-03	\N
5978	Robert Mark Kamen	1947-10-09	\N
5979	Dan Fogelman	1976-02-19	\N
5980	Alec Sulkin	1973-02-14	\N
5981	Wellesley Wild	1972-04-27	\N
5982	Vince Marcello	\N	\N
5983	Mark Landry	1979-09-03	\N
5984	Robert Horn	\N	\N
5985	Matt Eddy	\N	\N
5986	Billy Eddy	\N	\N
5987	Jeph Loeb	1958-01-29	\N
5988	Matthew Weisman	\N	\N
5989	Todd W. Langen	\N	\N
5990	Bobby Herbeck	1945-01-28	\N
5991	Josh Appelbaum	\N	\N
5992	André Nemec	1972-05-22	\N
5993	Gale Anne Hurd	1955-10-25	\N
5994	William Wisher Jr.	1958-09-01	\N
5995	John Brancato	1958-11-08	\N
5996	Michael Ferris	1961-01-29	\N
5997	Patrick Lussier	1964-01-01	\N
5998	Justin Rhodes	1972-03-26	\N
5999	Kim Henkel	1946-01-19	\N
6000	Sheldon Turner	1970-01-31	\N
6001	Chris Thomas Devlin	\N	\N
6002	Jeff Rendell	\N	\N
6003	Bill Lancaster	1947-11-17	1997-01-04
6004	Don Payne	1964-05-05	2013-03-26
6005	Christopher Yost	1973-02-21	\N
6006	Eric Pearson	1984-12-14	\N
6007	Craig Kyle	1971-11-03	\N
6008	Jennifer Kaytin Robinson	1988-04-04	\N
6009	Joanna Calo	1980-11-18	\N
6010	Kevin Costello	\N	\N
6012	Bonnie Turner	1940-08-28	\N
6013	Terry Turner	1947-12-11	\N
6014	Zach Dean	\N	\N
6015	Lowell Ganz	1948-08-31	\N
6016	Babaloo Mandel	1949-10-13	\N
6017	Jim Cash	1941-01-17	2000-03-25
6018	Jack Epps Jr.	1949-11-03	\N
6019	Eric Warren Singer	1968-08-01	\N
6020	Ronald Shusett	1935-06-28	2024-08-29
6021	Gary Goldman	1953-09-17	\N
6022	Joel Cohen	1963-08-23	\N
6023	Alec Sokolow	\N	\N
6024	Rita Hsiao	\N	\N
6025	Doug Chamberlin	\N	\N
6026	Chris Webb	\N	\N
6027	Stephany Folsom	\N	\N
6028	Ken Nolan	\N	\N
6029	Erich Hoeber	\N	\N
6030	Jon Hoeber	\N	\N
6031	Darnell Metayer	\N	\N
6032	Josh Peters	\N	\N
6033	Ron Friedman	1932-08-01	\N
6034	Maya Forbes	1968-07-23	\N
6035	Wallace Wolodarsky	1963-02-15	\N
6036	Elizabeth Tippet	\N	\N
6037	Edward Kitsis	1971-02-04	\N
6038	Adam Horowitz	1971-12-04	\N
6039	Etan Cohen	1974-03-14	\N
6040	Andrew Niccol	1964-06-10	\N
6041	Morgan Jurgenson	\N	\N
6042	Robert Siegel	1971-11-12	\N
6043	Julia Cho	1975-07-05	\N
6044	Michael Crichton	1942-10-23	2008-11-04
6045	Anne-Marie Martin	1957-11-11	\N
6046	Mark L. Smith	\N	\N
6047	Greg Coolidge	1972-12-28	\N
6048	Kirk Ward	1970-09-23	\N
6049	Shawn Simmons	\N	\N
6050	Colin Woodell	1991-12-20	\N
6051	Mishel Prada	1989-12-23	\N
6052	Ben Robson	1984-02-04	\N
6053	Hubert Point-Du Jour	\N	\N
6054	Nhung Kate	1989-05-15	\N
6055	Ayomide Adegun	\N	\N
6056	Steve Koren	\N	\N
6057	Steve Bloom	\N	\N
6058	Jonathan Roberts	1956-05-10	\N
6059	Jeff Cesario	1953-03-30	\N
6060	Marshall Herskovitz	1952-02-23	\N
6061	Danika Yarosh	1998-10-01	\N
6062	Patrick Heusinger	1981-02-14	\N
6063	Karey Kirkpatrick	1964-12-14	\N
6064	Christopher Rouse	1958-11-28	\N
6065	Dean Lorey	1967-11-17	\N
6066	Jay Huguely	1940-09-21	2008-12-13
6067	Todd Farmer	1968-11-21	\N
6068	Peter Benchley	1940-05-08	2006-02-11
6069	Carl Gottlieb	1938-03-18	\N
6070	Howard Sackler	1929-12-19	1982-10-12
6071	Richard Matheson	1926-02-20	2013-06-23
6072	Michael de Guzman	\N	\N
6073	Ryan Landels	1979-12-11	\N
6074	Diablo Cody	1978-06-14	\N
6075	Randy Kornfield	\N	\N
6076	Derek Kolstad	1974-04-04	\N
6077	Chris Collins	\N	\N
6078	Marc Abrams	\N	\N
6079	Scott Silver	1964-11-30	\N
6080	Greg Taylor	\N	\N
6081	Jim Strain	\N	\N
6082	Justin Marks	1980-04-27	\N
6083	Michael Green	1973-02-18	\N
6084	Glenn Ficarra	1969-05-27	\N
6085	John Requa	1967-01-01	\N
6086	Douglas Booth	1992-07-09	\N
6087	Heath Corson	\N	\N
6088	Bryan Q. Miller	\N	\N
6089	Christopher Murphey	\N	\N
6090	Gordon Liu	1955-08-22	\N
6091	Charles Chiodo	1952-05-24	\N
6092	Karl Gajdusek	1968-07-30	\N
6093	Edgar Wallace	1875-04-01	1932-02-10
6094	James Ashmore Creelman	1894-09-21	1941-09-09
6095	Ruth Rose	1896-01-16	1978-06-08
6096	Fran Walsh	1959-01-10	\N
6097	Philippa Boyens	1962-01-01	\N
6098	Dan Gilroy	1959-06-24	\N
6099	Max Borenstein	1981-06-20	\N
6100	Zach Baylin	1980-01-01	\N
6101	Cheston Hervey	\N	\N
6102	Jim Mahoney	\N	\N
6103	Zach Lewis	\N	\N
6104	Todd Casey	\N	\N
6105	Zach Shields	\N	\N
6106	Andrew Bujalski	1977-04-29	\N
6107	Kari Granlund	\N	\N
6108	Patrick Massett	1962-03-06	\N
6109	John Zinman	1966-03-23	\N
6110	Dean Georgaris	\N	\N
6111	Robert Bolt	1924-08-15	1995-02-20
6112	Seth Grahame-Smith	1976-01-04	\N
6113	William Wheeler	1967-11-20	\N
6114	Robert Gordon	\N	\N
6115	William Nicholson	1948-01-12	\N
6116	Alain Boublil	1941-03-05	\N
6117	Claude-Michel Schönberg	1944-07-06	\N
6118	Herbert Kretzmer	1925-10-05	2020-10-14
6119	Channing Gibson	\N	\N
6120	Paul Guay	\N	\N
6121	Stephen Mazur	\N	\N
6122	Vincenzo Cerami	1940-11-02	2013-07-17
6123	Max Eggers	\N	\N
6124	Irene Mecchi	1949-09-21	\N
6125	Howard Ashman	1950-05-17	1991-03-14
6126	Larry Doyle	1958-11-13	\N
6127	Chris Conkling	1949-03-31	\N
6128	Peter S. Beagle	1939-04-20	\N
6129	Stephen Sinclair	\N	\N
6130	Jeffrey Addiss	1980-11-21	\N
6131	Will Matthews	\N	\N
6132	Phoebe Gittins	\N	\N
6133	Arty Papageorgiou	\N	\N
6134	Janice Fischer	1947-06-09	2011-03-10
6135	James Jeremias	\N	\N
6136	Weronika Tofilska	\N	\N
6137	Elizabeth Berger	1985-07-18	\N
6138	Isaac Aptaker	\N	\N
6139	Jesse Andrews	1982-09-15	\N
6140	Akela Cooper	\N	\N
6141	James McCausland	1944-07-23	2022-02-20
6142	Terry Hayes	1951-10-08	\N
6143	Brian Hannant	1940-02-13	\N
6144	Brendan McCarthy	\N	\N
6145	Nico Lathouris	\N	\N
6146	Billy Frolick	1959-02-12	\N
6147	Noah Baumbach	1969-09-03	\N
6148	Matt Sazama	\N	\N
6149	Burk Sharpless	\N	\N
6150	Claire Parker	\N	\N
6151	Reid Carolin	1982-01-10	\N
6152	Noah Harpster	1976-10-16	\N
6153	Micah Fitzerman-Blue	1982-06-17	\N
6154	Catherine Johnson	1957-10-14	\N
6155	Jonathan Gems	\N	\N
6156	Wendy Wells	1964-04-16	\N
6157	Megan McDonnell	1988-01-05	\N
6158	Elissa Karasik	\N	\N
6159	Bill Walsh	1913-09-30	1975-01-27
6160	Don DaGradi	1911-03-01	1991-08-04
6161	Mike Werb	\N	\N
6162	Nicholas Kazan	1945-09-15	\N
6163	Robin Swicord	1952-10-23	\N
6164	David Mitchell	1969-01-12	\N
6165	Aleksandar Hemon	1964-09-09	\N
6166	Noah Oppenheim	1978-01-01	\N
6167	Grant Pierce Myers	1981-12-04	\N
6168	Jon Bernstein	\N	\N
6169	Michelle Spitz	1967-08-06	2025-01-10
6170	Aurian Redson	\N	\N
6172	Irving Brecher	1914-01-17	2008-11-17
6173	Fred F. Finklehoffe	1910-02-16	1977-10-05
6174	Alan Schoolcraft	\N	\N
6175	Brent Simons	\N	\N
6176	Thea von Harbou	1888-12-27	1954-07-01
6177	Chris Bowman	\N	\N
6178	Hubbel Palmer	\N	\N
6179	Kara Holden	\N	\N
6180	Marc Klein	\N	\N
6181	Jason Keller	1968-12-12	\N
6182	Robert Towne	1934-11-23	2024-07-01
6183	Erik Jendresen	1959-12-22	\N
6184	Patrick Ness	1971-10-17	\N
6185	Dan Harmon	1973-01-03	\N
6186	Rob Schrab	1969-11-12	\N
6187	Pamela Pettler	1952-11-11	\N
6188	Dan Gerson	1966-08-01	2016-02-06
6189	Robert L. Baird	\N	\N
6190	Spenser Cohen	\N	\N
6191	Jessica Postigo	\N	\N
6192	Kevin Droney	\N	\N
6193	Brent V. Friedman	\N	\N
6194	Bryce Zabel	1954-05-17	\N
6195	Greg Russo	\N	\N
6196	Jeremy Adams	1976-09-24	\N
6197	Craig Wright	1965-04-25	\N
6198	Leslie Dixon	1954-11-26	\N
6199	Raymond Singer	1948-12-21	\N
6200	Eugenia Bostwick-Singer	\N	\N
6201	Lauren Hynek	\N	\N
6202	Elizabeth Martin	\N	\N
6203	John L. Balderston	1889-10-22	1954-03-08
6204	Freddie Boath	1991-05-06	\N
6205	Dylan Kussman	1971-01-21	\N
6206	Jerry Juhl	1938-06-28	2005-09-25
6207	Jack Burns	1933-11-15	2020-01-27
6208	Tom Patchett	1940-04-16	\N
6209	Kirk Thatcher	1962-02-14	\N
6210	James V. Hart	1947-01-22	\N
6211	Joseph Mazzarino	1968-06-04	\N
6213	Nicholas Stoller	1976-03-19	\N
6214	Dallas Clayton	\N	\N
6215	Alan Jay Lerner	1918-08-31	1986-06-14
6216	Neil Cuthbert	1951-05-05	\N
6217	David Scarpa	\N	\N
6218	Jerusha Hess	1980-07-12	\N
6219	Douglas Kenney	1946-12-10	1980-08-27
6220	Chris Miller	\N	\N
6221	Robert Klane	1941-10-17	2023-08-29
6222	Jim Kouf	1951-07-24	\N
6223	Cormac Wibberley	1959-10-28	\N
6224	Marianne Wibberley	1965-06-12	\N
6225	Herman Weigel	1950-03-22	\N
6226	Karin Howard	\N	\N
6227	Knate Lee	\N	\N
6228	Mark Lee	\N	\N
6229	Robert Ben Garant	1970-09-14	\N
6230	Thomas Lennon	1970-08-09	\N
6231	David Guion	\N	\N
6232	Michael Handelman	\N	\N
6233	John A. Russo	1939-09-02	\N
6234	David Chaskin	\N	\N
6235	Bruce Wagner	1954-03-22	\N
6236	Brian Helgeland	1961-01-17	\N
6237	Leslie Bohem	1951-09-25	\N
6238	Wesley Strick	1954-02-11	\N
6239	Lloyd Taylor	\N	\N
6240	Sjón	1962-08-27	\N
6241	Henrik Galeen	1881-01-07	1949-07-30
6242	Jeremy Leven	1941-08-16	\N
6243	Ian B. Goldberg	\N	\N
6244	Richard Naing	\N	\N
6245	Ashleigh Powell	\N	\N
6246	Chris Solimine	\N	\N
6247	Gary Scott Thompson	1959-10-07	\N
6248	Erik Bergquist	\N	\N
6249	Daniel Casey	1981-11-15	\N
6250	Michael Colleary	\N	\N
6251	J.K. Rowling	1965-07-31	\N
6252	Mark Frost	1953-11-25	\N
6253	James Dearden	1949-09-14	\N
6254	Phil Graziadei	\N	\N
6255	Zak Olkewicz	1983-12-19	\N
6256	Kate Trefry	\N	\N
6257	Niall Leonard	\N	\N
6258	Jim Uhls	1957-03-25	\N
6259	Glen Morgan	1961-07-12	\N
6260	Jeffrey Reddick	1969-07-12	\N
6261	J. Mackye Gruber	\N	\N
6262	Eric Bress	1968-12-29	\N
6263	Al Reinert	1947-10-18	2018-12-31
6264	Victoria Strouse	\N	\N
6265	Stanley Mann	1928-08-08	2016-01-11
6266	Michael Kozoll	\N	\N
6267	William Sackheim	1919-10-31	2004-12-01
6268	Mikki Daughtry	\N	\N
6269	Tobias Iaconis	\N	\N
6270	Seth Cuddeback	\N	\N
6271	Scott Cawthon	1978-06-04	\N
6272	Christina Hodson	\N	\N
6273	Dean Pitchford	1951-07-29	\N
6274	Garrett Fort	1900-06-05	1945-10-26
6275	Francis E. Faragoh	1898-10-16	1966-07-25
6276	Michael Kennedy	1980-08-30	\N
6277	Michael De Luca	1965-08-13	\N
6278	Victor Miller	1940-05-14	\N
6279	Ron Kurz	1940-11-27	2020-05-07
6280	Martin Kitrosser	1949-08-09	\N
6281	Carol Watson	1952-03-26	\N
6282	Barney Cohen	\N	\N
6283	David Cohen	\N	\N
6284	Manuel Fidello	\N	\N
6285	Daryl Haney	1963-06-21	\N
6286	Damian Shannon	\N	\N
6287	Mark Swift	\N	\N
6288	Michael Herr	1940-04-13	2016-06-23
6289	Gustav Hasford	1947-11-28	1993-01-29
6290	Stuart Beattie	1971-08-04	\N
6291	David Elliot	\N	\N
6292	Paul Lovett	\N	\N
6293	David Howard	\N	\N
6294	Mark Perez	\N	\N
6295	Paul Guyot	\N	\N
6296	Bruce Joel Rubin	1943-03-10	\N
6297	Scott M. Gimple	1971-03-29	\N
6298	Seth Hoffman	\N	\N
6299	Katie Dippold	1980-01-10	\N
6300	Lisa Loomer	\N	\N
6301	Anna Hamilton Phelan	\N	\N
6302	Michael Mitnick	1983-09-07	\N
6303	Robert B. Weide	1959-06-20	\N
6304	David Franzoni	1947-03-04	\N
6305	Melissa Stack	\N	\N
6306	Takeo Murata	1907-06-17	1994-07-19
6307	Simon Barrett	1978-07-19	\N
6308	Sidney Howard	1891-06-26	1939-08-23
6309	Nicholas Pileggi	1933-02-22	\N
6310	Jonás Cuarón	1983-05-21	\N
6311	Bronté Woodard	1940-10-08	1980-08-06
6312	Ken Finkleman	1946-01-31	\N
6313	Jack Rose	1911-11-04	1995-10-20
6314	Jenny Bicks	1963-07-30	\N
6315	Nick Vallelonga	1959-09-13	\N
6316	Brian Hayes Currie	\N	\N
6317	Charles S. Haas	1952-10-22	\N
6318	Michael LeSieur	\N	\N
6319	Danny Rubin	\N	\N
6320	Stephen Susco	1972-10-24	\N
6321	Nicole Perlman	1981-12-10	\N
6322	Patrick McHale	1983-11-17	\N
6323	Robert Schenkkan	1953-03-19	\N
6324	Andrew Knight	\N	\N
6325	Debra Hill	1950-11-10	2005-03-07
6326	Michael Jacobs	\N	\N
6327	Shem Bitterman	\N	\N
6328	Daniel Farrands	1969-09-03	\N
6329	Robert Zappia	\N	\N
6330	Matt Greenberg	\N	\N
6331	Larry Brand	1949-12-16	2019-02-09
6332	Sean Hood	1966-08-13	\N
6333	Jeff Fradley	\N	\N
6334	Paul Brad Logan	1976-03-23	\N
6335	Chris Bernier	\N	\N
6336	Paul Bernbaum	1957-09-15	\N
6337	Jon Cooksey	\N	\N
6338	Ali Matheson	1956-07-05	\N
6339	Dan Berendsen	1963-12-13	\N
6340	Vy Vincent Ngo	\N	\N
6341	Vince Gilligan	1967-02-10	\N
6342	Scott Lobdell	\N	\N
6343	Daniel Waters	1962-11-10	\N
6344	Peter Atkins	1955-11-02	\N
6345	Ben Collins	\N	\N
6346	Luke Piotrowski	\N	\N
6347	Andrew Cosby	\N	\N
6348	Donald McEnery	\N	\N
6349	Bob Shaw	\N	\N
6350	Allison Schroeder	\N	\N
6351	Peter Barsocchini	1952-10-03	\N
6352	Kevin Bisch	\N	\N
6353	Mick Garris	1951-12-04	\N
6354	Jen D'Angelo	1988-07-07	\N
6355	David Hemingson	1964-07-26	\N
6356	Tom J. Astle	1960-04-08	\N
6357	Matt Ember	1961-09-25	\N
6358	Ed Naha	1950-06-10	\N
6359	Tom Schulman	1950-10-20	\N
6360	Malia Scotch Marmo	1955-05-04	\N
6361	Robert Smigel	1960-02-07	\N
6363	Nunzio Randazzo	\N	\N
6364	William Davies	\N	\N
6365	John Turman	\N	\N
6366	James Schamus	1959-09-07	\N
6367	Suzanne Collins	1962-08-10	\N
6368	Peter Craig	1969-11-10	\N
6369	Danny Strong	1974-06-06	\N
6370	Michael Lesslie	1983-11-01	\N
6371	Bob Gale	1951-05-25	\N
6372	Michael Barrie	1946-01-15	\N
6373	Jim Mulholland	\N	\N
6374	Doug Richardson	\N	\N
6375	Jerry Stahl	1953-09-28	\N
6376	Chris Bremner	\N	\N
6377	Joe Carnahan	1969-05-09	\N
6378	James Algar	1912-06-11	1998-02-26
6379	Norman Wright	1910-01-08	2001-07-21
6380	Sam Armstrong	1893-02-05	1976-09-29
6381	Paul Satterfield	1896-03-27	1981-08-14
6382	Graham Heid	1909-11-14	1976-03-01
6383	Sam Hamm	1955-11-19	\N
6384	Warren Skaaren	1946-03-09	1990-12-28
6385	Lee Batchler	1950-11-22	\N
6386	Janet Scott Batchler	1956-02-05	\N
6387	Paul Dini	1957-08-07	\N
6388	Martin Pasko	1954-08-04	2020-05-10
6389	Michael Reaves	1950-09-14	2023-03-20
6390	J.M. DeMatteis	1953-12-15	\N
6391	John William Corrington	1932-10-28	1988-11-24
6392	Joyce Hooper Corrington	1936-08-05	\N
6393	Kenta Fukusaku	1972-09-15	\N
6394	Spike Feresten	1964-09-03	\N
6395	Barry Marder	\N	\N
6396	Andy Robin	\N	\N
6397	Kurt Wimmer	1964-03-09	\N
6398	Michael McDowell	1950-06-01	1999-12-27
6399	Karl Tunberg	1907-03-11	1992-04-03
6400	Roger Avary	1965-08-23	\N
6401	Daniel Petrie Jr.	1951-11-30	\N
6402	Steven E. de Souza	1947-11-17	\N
6403	Anne Spielberg	1949-12-25	\N
6404	Jordan Roberts	1957-06-19	\N
6405	Chris Matheson	1959-12-11	\N
6406	Nicolás Giacobone	1975-01-01	\N
6407	Alexander Dinelaris Jr.	\N	\N
6408	Armando Bó	1978-12-09	\N
6409	Evan Hunter	1926-10-15	2005-07-06
6410	Rory Haines	1984-06-22	\N
6411	Sohrab Noshirvani	\N	\N
6412	Roy Moore	1944-01-17	\N
6413	April Wolfe	\N	\N
6414	Joe Robert Cole	1980-01-01	\N
6415	Charlie Wachtel	\N	\N
6416	David Rabinowitz	\N	\N
6417	Kevin Willmott	1959-08-31	\N
6418	Hampton Fancher	1938-07-18	\N
6419	David Peoples	1940-02-09	\N
6420	Norman Steinberg	1939-06-06	2023-03-15
6421	Andrew Bergman	1945-02-20	\N
6422	Alan Uger	1940-12-24	\N
6423	Christoper Cosby	\N	\N
6424	Mel Friedman	\N	\N
6425	Gareth Dunnet-Alcocer	\N	\N
6426	Anthony McCarten	1961-04-28	\N
6427	Joe Abercrombie	1974-12-31	\N
6428	William Blake Herron	\N	\N
6429	Scott Z. Burns	1962-07-17	\N
6430	Stacey Menear	\N	\N
6431	Steve Purcell	1961-07-30	\N
6432	William Hurlbut	1878-07-13	1957-05-04
6433	Helen Fielding	1958-02-19	\N
6434	Andrew Davies	1936-09-20	\N
6435	Adam Brooks	1956-09-03	\N
6436	Dan Mazer	1971-10-04	\N
6437	Abi Morgan	1968-01-01	\N
6438	Max Landis	1985-08-03	\N
6439	Brian Gunn	1970-08-23	\N
6440	Mark Gunn	\N	\N
6441	Larry McMurty	1936-06-03	2021-03-25
6442	Diana Ossana	1949-08-24	\N
6443	Lorne Cameron	\N	\N
6444	David Hoselton	\N	\N
6445	Steve Bencich	1970-10-31	\N
6446	Ron J. Friedman	\N	\N
6447	Mark O'Keefe	1971-11-29	\N
6448	Jonathan Penner	1962-03-05	\N
6449	Carl Mayer	1894-11-20	1944-07-01
6450	Hans Janowitz	1890-12-02	1954-05-25
6451	Win Rosenfeld	1978-02-22	\N
6452	Stephen Tolkin	\N	\N
6453	Dalan Musson	\N	\N
6454	Peter Glanz	1983-01-28	\N
6455	Bob Carrau	\N	\N
6456	Roberto Aguirre-Sacasa	1973-11-15	\N
6457	Joe Ranft	1960-03-13	2005-08-16
6458	Kiel Murray	\N	\N
6459	Phil Lorin	\N	\N
6460	Jorgen Klubien	1958-05-20	\N
6461	Mike Rich	1959-01-01	\N
6462	Julius J. Epstein	1909-08-22	2000-12-30
6463	Philip G. Epstein	1909-08-22	1952-02-07
6464	Howard Koch	1901-12-12	1995-08-17
6465	Sherri Stoner	1959-07-16	\N
6466	Deanna Oliver	1952-09-27	\N
6467	John Rogers	\N	\N
6468	Justin Kuritzkes	1990-05-05	\N
6469	Ryan Rowe	\N	\N
6470	Ron Anderson	\N	\N
6471	Don Mancini	1963-01-25	\N
6472	John Lafia	1957-04-02	2020-04-29
6473	Tyler Burton Smith	\N	\N
6474	George Goldsmith	\N	\N
6475	Dan Gregor	\N	\N
6476	Doug Mand	1981-11-23	\N
6477	Karen Schaler	\N	\N
6478	Nathan Atkins	1978-09-21	\N
6479	Jean Shepherd	1921-07-26	1999-10-16
6480	Leigh Brown	1939-05-01	1998-07-16
6481	Nick Schenk	1965-11-12	\N
6482	Alex Ross Perry	1984-07-14	\N
6483	Tom McCarthy	1966-06-07	\N
6484	Ann Peacock	\N	\N
6485	Michael Petroni	\N	\N
6486	Robert L. Freedman	1957-07-27	\N
6487	Herman J. Mankiewicz	1897-11-07	1953-03-05
6488	Beverley Cross	1931-04-13	1998-03-20
6489	Phil Hay	1964-07-31	\N
6490	Matt Manfredi	1971-01-01	\N
6491	Erica Rivinoja	\N	\N
6492	Jimmy Warden	1991-11-30	\N
6493	Adrian Molina	1985-08-23	\N
6494	Matthew Aldrich	\N	\N
6495	Menno Meyjes	1954-01-01	\N
6496	Marcus Gardley	1978-01-01	\N
6497	David Sheffield	\N	\N
6498	Barry W. Blaustein	1955-01-01	\N
6499	Chad Hayes	1961-04-21	\N
6500	Carey W. Hayes	1961-04-21	\N
6501	Kevin Brodbin	\N	\N
6502	Frank Cappello	\N	\N
6503	Peter Filardi	\N	\N
6504	Harry Essex	1910-11-29	1997-02-06
6505	Arthur Ross	1920-02-04	2008-11-11
6506	Aaron Covington	1984-06-05	\N
6507	Matthew Robbins	1945-07-15	\N
6508	Kevin Hageman	1974-04-21	\N
6509	Dan Hageman	1976-12-17	\N
6510	David J. Schow	1955-07-13	\N
6511	John Shirley	1953-02-10	\N
6512	Brian Burns	\N	\N
6513	Michael Blake	1945-07-05	2015-05-02
6514	Chad Hodge	1977-01-01	\N
6515	Jeffrey Nachmanoff	1967-03-09	\N
6516	Zeb Wells	1977-04-28	\N
6517	Steven Levenson	\N	\N
6518	Charles Parlapanides	1977-09-28	\N
6519	Vlas Parlapanides	1971-07-26	\N
6520	Peter Tomasi	1967-08-18	\N
6521	Duncan Kennedy	\N	\N
6522	Donna Powers	\N	\N
6523	Wayne Powers	\N	\N
6524	Michael Tolkin	1950-10-17	\N
6525	William Monahan	1960-11-03	\N
6526	Sara Parriott	1953-07-06	\N
6527	Josann McGibbon	\N	\N
6528	Dan Frey	\N	\N
6529	Ru Sommer	\N	\N
6530	Jackie Filgo	\N	\N
6531	Jeff Filgo	\N	\N
6532	Jeff Judah	1960-12-23	\N
6533	Gabe Sachs	\N	\N
6534	Jeff Kinney	1971-02-19	\N
6535	Jeb Stuart	1956-01-21	\N
6536	Eleanor Bergstein	1938-04-17	\N
6537	Brigitte Hales	\N	\N
6538	Terri Tatchell	1978-01-01	\N
6539	Vanessa Taylor	1970-09-24	\N
6540	Brian Duffield	1985-11-05	\N
6541	Adam Cooper	\N	\N
6542	Bill Collage	\N	\N
6543	Terry Southern	1924-05-01	1995-10-29
6544	Peter George	1924-03-26	1966-06-01
6545	Ben Ramsey	\N	\N
6546	Bobby Farrelly	1958-06-17	\N
6547	Bennett Yellin	1959-11-08	\N
6548	Carroll Cartwright	\N	\N
6549	Topper Lilien	\N	\N
6550	Michael Gilio	\N	\N
6551	Micho Robert Rutare	\N	\N
6552	Lindsay LaVanchy	\N	\N
6553	Louis Ozawa Changchien	1975-10-11	\N
6554	Mathieu Amalric	1965-10-25	\N
6555	Bibo Bergeron	1965-07-14	\N
6556	Don Paul	\N	\N
6557	Armand Assante	1949-10-04	\N
6558	Len Blum	1951-12-29	\N
6559	Garry Shandling	1949-11-29	2016-03-24
6560	Wanda Sykes	1964-03-07	\N
6561	Erin Cressida Wilson	1964-02-12	\N
6562	Andrew Burnap	1991-03-05	\N
6563	Megan Burns	1986-06-25	\N
6564	Rowan Joffé	1973-01-01	\N
6565	Enrique López Lavigne	1967-01-16	\N
6566	Jesús Olmo	\N	\N
6567	Harold Perrineau	1963-08-07	\N
6568	Mackintosh Muggleton	1994-02-16	\N
6569	Christopher Storer	1981-07-05	\N
6570	Jeremy Allen White	1991-02-17	\N
6571	Lionel Boyce	1991-05-09	\N
6572	Liza Colón-Zayas	1972-07-15	\N
6573	Matty Matheson	1982-02-07	\N
6574	Neil Widener	\N	\N
6575	Gavin James	\N	\N
6576	Chris Galletta	1981-01-01	\N
6577	Sebastian Hansen	2010-04-06	\N
6578	David Acord	1969-04-07	\N
6579	Matthew Fox	1966-07-14	\N
6580	Benno Fürmann	1972-01-17	\N
6581	Rain	1982-06-25	\N
6582	Richard Roundtree	1942-07-09	2023-10-24
6583	Catherine Schetina	\N	\N
6584	Alex Russell	\N	\N
6585	Duccio Fabbri	\N	\N
6586	Sofya Levitsky-Weitz	\N	\N
6587	Karen Joseph Adcock	\N	\N
6588	Rene Gube	\N	\N
6589	Stacy Osei-Kuffour	1987-04-18	\N
6590	Kelly Galuska	\N	\N
6591	Albert Hughes	1972-04-01	\N
6592	Charlotte Brändström	1959-05-30	\N
6593	Ken Kristensen	\N	\N
6594	Sydney Freeland	1980-10-29	\N
6595	Catriona McKenzie	\N	\N
6596	Josh Feldman	\N	\N
6597	Steven Paul Judd	\N	\N
6598	Ellen Morton	\N	\N
6599	Chantelle M. Wells	\N	\N
6600	Amy Rardin	\N	\N
6601	Kari Skogland	\N	\N
6602	Michael Kastelein	\N	\N
6603	Josef Sawyer	\N	\N
6604	Rhys Thomas	1979-09-18	\N
6605	Bert	\N	\N
6606	Bertie	\N	\N
6607	Elisa Climent	\N	\N
6608	Katie Mathewson	\N	\N
6609	Tanner Bean	\N	\N
6610	Erin Cancino	\N	\N
6611	Heather Quinn	\N	\N
6612	Jenna Noel Frazier	\N	\N
6613	Mohamed Diab	1978-12-07	\N
6614	Justin Benson	1983-06-09	\N
6615	Aaron Moorhead	1987-03-03	\N
6616	Beau DeMayo	\N	\N
6617	Peter Cameron	\N	\N
6618	Sabir Pirzada	\N	\N
6619	Alex Meenehan	\N	\N
6620	Rebecca Kirsch	\N	\N
6621	Matthew Orton	\N	\N
6622	Kate Herron	1987-10-28	\N
6623	Eric Martin	\N	\N
6624	Tom Kauffman	\N	\N
6625	Dan DeLeeuw	\N	\N
6626	Kasra Farahani	1978-03-01	\N
6627	Jason O'Leary	\N	\N
6628	Katharyn Blair	\N	\N
6629	Deborah Chow	1971-01-01	\N
6630	Hannah Friedman	\N	\N
6631	Meera Menon	\N	\N
6632	Sharmeen Obaid-Chinoy	1978-11-12	\N
6633	Fatimah Asghar	\N	\N
6634	Matthew Chauncey	\N	\N
6635	Will Dunn	\N	\N
6636	Kate Gritmon	\N	\N
6637	Freddy Syborn	\N	\N
6638	Ali Selim	\N	\N
6639	Brian Tucker	\N	\N
6640	Michael Bhim	\N	\N
6641	Roxanne Paredes	\N	\N
6642	Carol Banker	\N	\N
6643	Jorma Taccone	1977-03-19	\N
6644	Brandon Trost	1981-08-29	\N
6645	Ged Wright	\N	\N
6646	Brian Schacter	\N	\N
6647	James Madejski	\N	\N
6648	Richard J. Lewis	\N	\N
6649	John Cameron	\N	\N
6650	Suzanne Wrubel	\N	\N
6651	Elizabeth Padden	\N	\N
6652	Kor Adana	\N	\N
6653	Leah Benavides Rodriguez	\N	\N
6654	Jordan Goldberg	\N	\N
6655	Kevin Lau	\N	\N
6656	Monica Owusu-Breen	1968-04-25	\N
6657	Carlito Rodriguez	\N	\N
6658	Steph Green	\N	\N
6659	Kevin Tancharoen	1984-04-23	\N
6660	Peter Hoar	\N	\N
6661	Ali Abbasi	1981-01-01	\N
6662	Jeremy Webb	\N	\N
6663	Liza Johnson	1970-12-13	\N
6664	Jasmila Žbanić	1974-12-19	\N
6665	Nina Lopez-Corrado	\N	\N
6666	Mark Mylod	1965-01-01	\N
6667	Stephen Williams	\N	\N
6668	Halley Gross	1985-12-27	\N
6669	Rachel Goldberg	\N	\N
6670	Gandja Monteiro	\N	\N
6671	Laura Donney	\N	\N
6672	Gia King	\N	\N
6673	Laura Monti	\N	\N
6674	Jason Rostovsky	\N	\N
6675	Giovanna Sarquis	\N	\N
6676	Cameron Squires	\N	\N
6677	Rick Famuyiwa	1973-06-18	\N
6678	Jennifer Getzinger	1967-09-26	\N
6679	Geeta Patel	1975-12-22	\N
6680	Toby Haynes	\N	\N
6681	Ariel Kleiman	1985-04-22	\N
6682	Benjamin Caron	1976-07-02	\N
6683	Susanna White	1960-01-01	\N
6684	Janus Metz Pedersen	1974-09-27	\N
6685	Alonso Ruizpalacios	1978-09-11	\N
6686	Beau Willimon	1977-10-26	\N
6687	Tom Bissell	1974-01-09	\N
6688	Stephen Schiff	\N	\N
6689	Bryan Andrews	\N	\N
6690	Stephan Franck	\N	\N
6691	Ryan Little	\N	\N
6692	Pascal Charrue	\N	\N
6693	Arnaud Delord	\N	\N
6694	Bart Maunoury	\N	\N
6695	Christelle Abgrall	\N	\N
6696	Etienne Mattera	\N	\N
6697	Mollie St. John	\N	\N
6698	Ash Brannon	1969-10-31	\N
6699	David Dunne	\N	\N
6700	Kristina Felske	\N	\N
6701	Henry Jones	\N	\N
6702	Nick Luddington	\N	\N
6703	Graham McNeill	\N	\N
6704	Amanda Overton	\N	\N
6705	Ben St. John	\N	\N
6706	Jennifer Celotta	1971-11-11	\N
6707	Steve Pink	1966-02-03	\N
6708	Michael Jonathan Smith	\N	\N
6709	Joe Piarulli	\N	\N
6710	Luan Thomas	\N	\N
6711	Stacey Harman	\N	\N
6712	Jason Belleville	\N	\N
6713	David Nutter	\N	\N
6714	Alex Graves	1965-07-23	\N
6715	Miguel Sapochnik	1974-07-01	\N
6716	Jeremy Podeswa	1962-01-01	\N
6717	Daniel Minahan	1962-11-30	\N
6718	Alik Sakharov	1959-05-17	\N
6719	Michelle MacLaren	\N	\N
6720	Brian Kirk	1968-01-01	\N
6721	Tim Van Patten	1959-06-10	\N
6722	David Petrarca	1965-11-10	\N
6723	Michael Slovis	\N	\N
6724	Jack Bender	1949-09-25	\N
6725	Daniel Sackheim	\N	\N
6726	Matt Shakman	1975-08-08	\N
6727	Dave Hill	1984-05-15	\N
6728	Bryan Cogman	1979-07-25	\N
6729	Jane Espenson	1964-07-14	\N
6730	Jody Hill	1976-10-15	\N
6731	Rosemary Rodriguez	\N	\N
6732	Brad Anderson	1964-04-05	\N
6733	Greg Yaitanes	1970-06-18	\N
6734	Gabe Fonseca	\N	\N
6735	Clare Kilner	1964-08-04	\N
6736	Loni Peristere	1971-04-21	\N
6737	Andrij Parekh	1971-09-20	\N
6738	Ti Mikkel	\N	\N
6739	Sara Hess	\N	\N
6740	Eileen Shim	\N	\N
6741	David Hancock	\N	\N
6742	Charmaine DeGraté	\N	\N
6743	Ira Parker	\N	\N
6744	Brian Kalin O'Connell	\N	\N
6745	Steward Lee	\N	\N
6746	Kyle Dunlevy	\N	\N
6747	Giancarlo Volpe	1974-07-31	\N
6748	Danny Keller	\N	\N
6749	Bosco Ng	\N	\N
6750	Rob Coleman	1964-04-27	\N
6751	Justin Ridge	\N	\N
6752	Saul Ruiz	\N	\N
6753	Nathaniel Villanueva	\N	\N
6754	Jesse Yeh	\N	\N
6755	Dave Bullock	\N	\N
6756	Atsushi Takeuchi	\N	\N
6757	Robert Dalva	\N	\N
6758	Drew Z. Greenberg	1970-06-08	\N
6759	Katie Lucas	1988-04-13	\N
6760	Christian Taylor	1968-07-17	\N
6761	Matt Michnovetz	\N	\N
6762	Charles Murray	\N	\N
6763	Eoghan Mahony	\N	\N
6764	George Krstic	\N	\N
6765	Daniel Arkin	\N	\N
6766	Steven Mitchell	\N	\N
6767	Craig Van Sickle	\N	\N
6768	Cameron Litvack	1980-09-23	\N
6769	Bonnie Mark	\N	\N
6770	Jose Molina	1971-01-01	\N
6771	Melinda Hsu	\N	\N
6772	Brian Larsen	\N	\N
6773	Julie Siege	\N	\N
6774	J.W. Rinzler	1962-08-17	2021-07-28
6775	Kevin Campbell	\N	\N
6776	Kevin Rubio	1967-12-20	\N
6777	Bill Canterbury	\N	\N
6778	Wendy Mericle	\N	\N
6779	Ben Edlund	1968-09-20	\N
6780	Carl Ellsworth	\N	\N
6781	Randy Stradley	\N	\N
6782	Mel Zwyer	1977-05-15	\N
6783	Sergio Páez	\N	\N
6784	Steven G. Lee	\N	\N
6785	Brad Rau	\N	\N
6786	Kevin Hopps	\N	\N
6787	Greg Weisman	1963-09-28	\N
6788	Bill Wolkoff	\N	\N
6789	Kiri Hart	\N	\N
6790	Jennifer Corbett	1981-02-06	\N
6791	Amanda Rose Muñoz	\N	\N
6792	Ezra Nachman	\N	\N
6793	Damani Johnson	\N	\N
6794	Tamara Becher-Wilkinson	\N	\N
6795	Gursimran Sandhu	\N	\N
6796	Gina Lucita Monreal	\N	\N
6797	Brooke Roberts	\N	\N
6798	Moisés Zamora	\N	\N
6799	Philip Sgriccia	1969-04-20	\N
6800	Frederick E.O. Toye	1967-09-26	\N
6801	Sarah Boyd	\N	\N
6802	Stefan Schwartz	1963-05-01	\N
6803	Nelson Cragg	1978-04-07	\N
6804	Julian Holmes	\N	\N
6805	Shana Stein	\N	\N
6806	Karen Gaviola	\N	\N
6807	Daniel Attias	1951-12-04	\N
6808	Steve Boyum	1952-09-04	\N
6809	Liz Friedlander	1970-12-09	\N
6810	Batan Silva	\N	\N
6811	Ellie Monahan	\N	\N
6812	Anslem Richardson	1975-10-18	\N
6813	Rebecca Sonnenshine	\N	\N
6814	David Reed	\N	\N
6815	Paul Grellong	\N	\N
6816	Jessica Chou	\N	\N
6817	Anne Cofell Saunders	\N	\N
6818	Geoff Aull	\N	\N
6819	George Mastras	1966-04-10	\N
6820	Michael Saltzman	\N	\N
6821	Meredith Glynn	\N	\N
6822	Logan Ritchey	\N	\N
6823	Judalina Neira	\N	\N
6824	Sanaa Hamri	\N	\N
6825	Chelsea Grate	\N	\N
6826	Lauren Greer	\N	\N
6827	Brant Englestein	\N	\N
6828	Lex Edness	\N	\N
6829	Erica Rosbe	\N	\N
6830	Zak Schwartz	\N	\N
6831	Rachel Morrison	1978-04-27	\N
6832	Noah Kloor	\N	\N
6833	Hanelle Culpepper	\N	\N
6834	Alex García López	\N	\N
6835	Kogonada	\N	\N
6836	Jasmyne Flournoy	\N	\N
6837	Jason Micallef	\N	\N
6838	Jocelyn Bioh	\N	\N
6839	Claire Kiechel	\N	\N
6840	Jen Richards	\N	\N
6841	Myung Joh Wesner	\N	\N
6842	Mackenzie Dohr	\N	\N
6843	Bobak Esfarjani	\N	\N
6844	Gretchen Enders	\N	\N
6845	Chuck Hayward	\N	\N
6846	Jamie Childs	\N	\N
6847	Andrés Baiz	1975-01-01	\N
6848	Louise Hooper	\N	\N
6849	Mairzee Almas	\N	\N
6850	Mike Barker	1965-11-29	\N
6851	Coralie Fargeat	1976-11-24	\N
6852	Hisko Hulsing	1971-07-07	\N
6853	Lauren Bello	\N	\N
6854	Vanessa James Benton	\N	\N
6855	Catherine Smyth-McMullen	\N	\N
6856	Jim Campolongo	\N	\N
6857	Austin Guzman	\N	\N
6858	Alexander Newman-Wise	\N	\N
6860	Heather Bellson	\N	\N
6861	Jay Franklin	\N	\N
6862	Kat Coiro	1979-09-17	\N
6863	Anu Valia	\N	\N
6864	Francesca Gailes	\N	\N
6865	Jacqueline J. Gailes	\N	\N
6866	Dana Schwartz	1993-01-07	\N
6868	Kara Brown	\N	\N
6869	Melissa Hunter	\N	\N
6870	Liza Singer	\N	\N
6871	Stu Livingston	\N	\N
6872	Raven Koné	\N	\N
6873	Charlie Neuner	\N	\N
6874	David Boyd	\N	\N
6875	Michael Cuesta	1963-07-08	\N
6876	Jill Blankenship	\N	\N
6877	Jesse Wigutow	\N	\N
6878	David Feige	1965-10-08	\N
6879	Grainne Godfree	\N	\N
6880	Thomas Wong	\N	\N
6881	Wayne Che Yip	\N	\N
6882	Justin Doble	\N	\N
6883	Jason Cahill	\N	\N
6884	Gennifer Hutchison	1977-07-19	\N
6885	Nicholas Adams	\N	\N
6886	Glenise Mullins	\N	\N
6887	Helen Shang	\N	\N
6888	Jeff Allen	\N	\N
6889	Sol Choi	\N	\N
6890	Ian Abando	\N	\N
6891	Tanner Johnson	\N	\N
6892	Jason Zurek	\N	\N
6893	Haylee Herrick	\N	\N
6894	Paul Furminger	\N	\N
6895	Jay Baker	\N	\N
6896	Cory Evans	\N	\N
6897	Jae Harm	\N	\N
6898	Vinton Heuck	\N	\N
6899	William Ruzicka	\N	\N
6900	Robert Valley	\N	\N
6901	Simon Racioppa	\N	\N
6902	Helen Leigh	\N	\N
6903	Curtis Gwinn	\N	\N
6904	Christine Lavaf	\N	\N
6905	Matt Lambert	\N	\N
6906	Adria Lang	\N	\N
6907	Vivian Lee	\N	\N
6908	Tania Lotia	\N	\N
6909	Ross Stracke	\N	\N
6910	Jay Faerber	\N	\N
6911	James Marshall	\N	\N
6912	Kayla Alpert	\N	\N
6913	April Blair	\N	\N
6914	Uta Briesewitz	1967-09-01	\N
6915	Rebecca Thomas	1984-12-10	\N
6916	Paul Dichter	\N	\N
6917	Jessie Nickson-Lopez	\N	\N
6918	Caitlin Schneiderhan	\N	\N
6919	Jessica Mecklenburg	\N	\N
6920	Alison Tatlock	\N	\N
6921	William Bridges	\N	\N
6922	Anne Walker Farrell	\N	\N
6923	Meg Waldow	\N	\N
6924	Cal Ramsey	\N	\N
6925	Gina Gress	\N	\N
6926	Akshara Sekar	\N	\N
6927	Stephanie M. Johnson	\N	\N
6928	Jenna Simmons	\N	\N
6929	Elijah Aron	\N	\N
6930	Stephanie Amante-Ritter	\N	\N
6931	Matt Warburton	1978-02-07	\N
6932	Hiromi Kamata	\N	\N
6933	Andy Goddard	1968-06-05	\N
6934	Andrew Colville	\N	\N
6935	Milla Bell-Hart	\N	\N
6936	Karl Taro Greenfeld	\N	\N
6937	Mariko Tamaki	1975-12-22	\N
6938	Al Letson	\N	\N
6939	Otto Bathurst	1971-01-18	\N
6940	Roel Reiné	1970-07-15	\N
6941	Jessica Lowrey	\N	\N
6942	Silka Luisa	\N	\N
6943	Richard E. Robbins	1969-12-05	\N
6944	Justine Juel Gillmer	\N	\N
6945	Anders Engström	\N	\N
6946	Jet Wilkinson	\N	\N
6947	Joe Tracz	\N	\N
6948	Andrew Miller	\N	\N
6949	Craig Silverstein	\N	\N
6950	Daniel Gray Longino	\N	\N
6951	Chaz Hawkins	\N	\N
6952	Karey Dornetto	\N	\N
6953	Kieran Fitzgerald	\N	\N
6954	Carson Mell	\N	\N
6955	Craig Zobel	1975-09-16	\N
6956	Kevin Bray	\N	\N
6957	Helen Shaver	1951-02-24	\N
6958	Vladimir Cvetko	\N	\N
6959	Breannah Gibson	\N	\N
6960	Erika L. Johnson	\N	\N
6961	John McCutcheon	\N	\N
6962	Shaye Ogbonna	\N	\N
6963	Nick Towne	\N	\N
6964	Noelle Valdivia	\N	\N
6965	Andi Armaganian	\N	\N
6966	Greg Beeman	1962-01-01	\N
6967	Glen Winter	\N	\N
6968	Toa Fraser	1975-01-01	\N
6969	Rob Hardy	1971-07-22	\N
6970	Christopher Manley	\N	\N
6971	Geary McLeod	\N	\N
6972	Michael Nankin	1955-12-26	\N
6973	David Straiton	\N	\N
6974	Paula Sevenbergen	\N	\N
6975	Taylor Streitz	\N	\N
6976	James Robinson	1963-04-01	\N
6977	Melissa Carter	\N	\N
6978	Colleen McGuinness	\N	\N
6979	Evan Ball	\N	\N
6980	Holly Dale	1953-12-23	\N
6981	Carl Seaton	\N	\N
6982	Michael A. Allowitz	1964-01-01	\N
6983	Dermott Downs	1962-05-25	\N
6984	Marcos Siega	1969-06-08	\N
6985	Michael Blundell	\N	\N
6986	Jeffrey Hunt	1973-02-15	\N
6987	Laura Belsey	\N	\N
6988	Scott Peters	\N	\N
6989	James Bamford	1967-02-26	\N
6990	Tara Miele	\N	\N
6991	Sudz Sutherland	\N	\N
6992	Amanda Tapping	1965-08-28	\N
6993	Paul Wesley	1982-07-23	\N
6994	Natalie Abrams	\N	\N
6995	Ebony Gilbert	\N	\N
6996	Daphne Miles	\N	\N
6997	Jerry Shandy	\N	\N
6998	Chad Fiveash	\N	\N
6999	Nancy Kiu	\N	\N
7000	James Stoteraux	\N	\N
7001	Holly Henderson	\N	\N
7002	Don Whitehead	\N	\N
7003	Denise Harkavy	\N	\N
7004	Kelly Larson	\N	\N
7005	Chris Fisher	1971-12-30	\N
7006	Billy Gierhart	\N	\N
7007	Neasa Hardiman	\N	\N
7008	Rick Cleveland	\N	\N
7009	Scott Reynolds	\N	\N
7010	Quinton Peeples	\N	\N
7011	Wendy West	\N	\N
7012	Phil Abraham	\N	\N
7013	Farren Blackburn	\N	\N
7014	Félix Enríquez Alcalá	1951-03-07	\N
7015	Stephen Surjik	1960-01-01	\N
7016	Lauren Schmidt Hissrich	1978-08-01	\N
7017	Jim O'Hanlon	\N	\N
7018	Tom Shankland	1968-05-07	\N
7019	Antonio Campos	1983-08-24	\N
7020	Kevin Hooks	1958-09-19	\N
7021	Marc Jobst	\N	\N
7022	Dearbhla Walsh	\N	\N
7023	Jamie M. Dagg	\N	\N
7024	Stephen Kay	\N	\N
7025	Iain B. MacDonald	\N	\N
7026	Michael Offer	\N	\N
7027	Stacie Passon	1969-10-01	\N
7028	Salli Richardson-Whitfield	1967-11-23	\N
7029	Angela LaManna	\N	\N
7030	Felicia D. Henderson	1961-04-18	\N
7031	Christine Boylan	1977-07-25	\N
7032	Bruce Marshall Romans	\N	\N
7033	Michael Jones-Morales	\N	\N
7034	Laura Jean Leal	\N	\N
7035	John Dahl	1956-06-15	\N
7036	M.J. Bassett	\N	\N
7037	Sanford Bookstaver	1973-09-01	\N
7038	Philip John	\N	\N
7039	Jonas Pate	1970-01-15	\N
7040	Dwain Worrell	\N	\N
7041	Jenny Lynn	\N	\N
7042	Tatiana Suarez-Pico	\N	\N
7043	Matthew White	\N	\N
7044	Pat Charles	\N	\N
7045	Ian Stokes	\N	\N
7046	Cristine Chambers	\N	\N
7047	Rebecca Dameron	\N	\N
7048	Declan de Barra	\N	\N
7049	Melissa Glenn	\N	\N
7050	Daniel Shattuck	\N	\N
7051	Jon Worley	\N	\N
7052	Paul McGuigan	1963-09-19	\N
7053	Magnus Martens	\N	\N
7054	Sam Miller	1962-09-28	\N
7055	Vincenzo Natali	1969-01-06	\N
7056	Guillermo Navarro	1955-07-29	\N
7057	George Tillman Jr.	1969-01-26	\N
7058	Neema Barnette	1949-12-14	\N
7059	Rashaad Ernesto Green	1978-08-19	\N
7060	Millicent Shelton	1966-01-29	\N
7061	Matt Owens	\N	\N
7062	Nathan Louis Jackson	1978-12-04	2023-08-22
7063	Matthew Lopes	\N	\N
7064	Aïda Mashaka Croal	\N	\N
7065	Jason Horwitch	\N	\N
7066	Nicole Mirante-Matthews	\N	\N
7067	Oz Scott	1949-09-16	\N
7068	Bille Woodruff	\N	\N
7069	Benny Boom	1971-07-22	\N
7070	Michael Schultz	1938-11-10	\N
7071	Eric Laneuville	1952-07-14	\N
7072	Mary Lou Belli	\N	\N
7073	Tawnia McKiernan	1968-11-12	\N
7074	Rose Troche	1964-05-30	\N
7075	Jeffrey W. Byrd	\N	\N
7076	Robert Townsend	1957-02-06	\N
7077	Tanya Hamilton	\N	\N
7078	Mark Tonderai	1974-07-16	\N
7079	Lamont Magee	\N	\N
7080	Keli Goff	1979-07-20	\N
7081	Jake Waller	\N	\N
7082	André Edmonds	\N	\N
7083	Charles D. Holland	\N	\N
7084	Adam Giaudrone	\N	\N
7085	Jan Nash	\N	\N
7086	Brusta Brown	\N	\N
7087	John Mitchell Todd	\N	\N
7088	J. Allen Brown	\N	\N
7089	Lynelle White	\N	\N
7090	Asheleigh O. Conley	\N	\N
7091	Melora Rivera	\N	\N
7092	Ramsey Nickell	\N	\N
7093	Patrick Norris	\N	\N
7094	Larry Teng	1977-06-12	\N
7095	Roxann Dawson	1958-09-11	\N
7096	Brett Morgen	1968-10-11	\N
7097	James Madigan	\N	\N
7098	Ami Canaan Mann	1969-01-01	\N
7099	Wendey Stanzler	\N	\N
7100	Katie Eastridge	\N	\N
7101	Vanessa Parise	1970-07-31	\N
7102	Jeff Woolnough	\N	\N
7103	Ashley Wigfield	\N	\N
7104	Mike Vukadinovich	\N	\N
7105	Warren Hsu Leonard	\N	\N
7106	Tracy McMillan	1964-09-12	\N
7107	Kirk A. Moore	\N	\N
7108	Kendall Rogers	\N	\N
7109	Rodney Barnes	\N	\N
7110	Kalinda Vazquez	\N	\N
7111	Russ Cochrane	1971-01-01	\N
7112	Jake Fogelnest	1979-03-14	\N
7113	Jiehae Park	\N	\N
7114	Stu Selonick	\N	\N
7115	Simon Cellan Jones	\N	\N
7116	Michael Rymer	1963-03-01	\N
7117	Zetna Fuentes	\N	\N
7118	Jennifer Lynch	1968-04-07	\N
7119	Minkie Spiro	\N	\N
7120	Anton Cropper	\N	\N
7121	Tim Iacofano	\N	\N
7122	Liesl Tommy	\N	\N
7123	Jamie King	\N	\N
7124	Jesse Harris	\N	\N
7125	Jenna Reback	\N	\N
7126	J. Holtham	\N	\N
7127	Hilly Hicks Jr.	1970-05-11	\N
7128	Lisa Randolph	\N	\N
7129	Dana Baratta	\N	\N
7130	Micah Schraft	\N	\N
7131	Liz Friedman	\N	\N
7132	Jack Kenny	1958-03-09	\N
7133	Raelle Tucker	\N	\N
7134	Nancy Won	\N	\N
7135	Edward Ricourt	\N	\N
7136	Jenny Klein	\N	\N
7137	Ken Girotti	\N	\N
7138	Euros Lyn	\N	\N
7139	Guy Ferland	1966-02-18	\N
7140	Nick Gomez	1963-04-13	\N
7141	Adam Kane	1968-01-23	\N
7142	Nelson McCormick	\N	\N
7143	Brad Turner	\N	\N
7144	Floria Sigismondi	1965-01-01	\N
7145	Michael Uppendahl	\N	\N
7146	Lukas Ettlin	1975-01-01	\N
7147	Alex Zakrzewski	\N	\N
7148	Luke Kalteux	\N	\N
7149	Ruth Fletcher Gage	\N	\N
7150	Christos Gage	1971-07-17	\N
7151	Whit Anderson	\N	\N
7152	Sneha Koorse	\N	\N
7153	Dylan Gallagher	\N	\N
7154	Tonya Kong	\N	\N
7155	Sarah Streicher	\N	\N
7156	Erik Oleson	1973-02-07	\N
7157	Joe Pokaski	\N	\N
7158	John C. Kelley	\N	\N
7159	Mark Verheiden	1956-03-26	\N
7161	Sam Ernst	\N	\N
7162	Dara Resnik	1978-09-29	\N
7163	Sonay Hoffman	\N	\N
7164	Lewaa Nasserdeen	\N	\N
7165	Edwin Lee Gibson	1964-09-24	\N
7166	Janicza Bravo	1981-02-25	\N
7167	John Behring	\N	\N
7168	Gregory Smith	1983-07-06	\N
7169	Guy Bee	1964-08-08	\N
7170	Nick Copus	1966-09-04	\N
7171	Jesse Warn	\N	\N
7172	Gordon Verheul	\N	\N
7173	Antonio Negret	\N	\N
7174	Kristin Windell	\N	\N
7175	Eagle Egilsson	1966-08-31	\N
7176	Mark Bunting	\N	\N
7177	Ben Bray	\N	\N
7178	Joel Novoa	\N	\N
7179	David Barrett	\N	\N
7180	Kenneth Fink	\N	\N
7181	Doug Aarniokoski	1965-08-25	\N
7182	JJ Makaro	\N	\N
7183	Ken Shane	\N	\N
7184	Alexandra La Roche	\N	\N
7185	David Grossman	\N	\N
7186	Vincent Misiano	\N	\N
7187	Bethany Rooney	1956-10-07	\N
7188	Peter Leto	\N	\N
7189	Kevin Fair	\N	\N
7190	John Showalter	\N	\N
7191	Ruba Nadda	1972-12-06	\N
7192	Patia Prouty	\N	\N
7193	Marcus Stokes	\N	\N
7194	Avi Youabian	\N	\N
7195	Brian Ford Sullivan	\N	\N
7196	Beth Schwartz	\N	\N
7197	Sarah Tarkoff	\N	\N
7198	Oscar Balderrama	\N	\N
7199	Emilio Ortega Aldrich	\N	\N
7200	Rebecca Bellotto	\N	\N
7201	Ben Sokolowski	\N	\N
7202	Speed Weed	\N	\N
7203	Keto Shimizu	1984-12-23	\N
7204	Jake Coburn	\N	\N
7205	Elizabeth Kim	\N	\N
7206	Lana Cho	\N	\N
7207	Deric A. Hughes	\N	\N
7208	Onalee Hunter Hughes	\N	\N
7209	Benjamin Raab	1970-10-13	\N
7210	Moira Kirland	\N	\N
7211	Spiro Skentzos	\N	\N
7212	Jeane Wong	\N	\N
7213	Rebecca Rosenberg	\N	\N
7214	Lindsey Allen	\N	\N
7215	Gabrielle Stanton	\N	\N
7216	Mark Bemesderfer	\N	\N
7217	Holly Harold	\N	\N
7218	Nolan Dunbar	\N	\N
7219	Barbara Bloom	\N	\N
7220	Tyron B. Carter	\N	\N
7221	Ubah Mohamed	\N	\N
7222	Maya Houston	\N	\N
7223	Marv Wolfman	1946-05-13	\N
7224	Jesse Bochco	1975-03-02	\N
7225	Garry A. Brown	\N	\N
7226	Bobby Roth	1950-07-09	\N
7227	Milan Cheylov	\N	\N
7228	Ron Underwood	1953-11-06	\N
7229	Kate Woods	\N	\N
7230	David Solomon	\N	\N
7231	John Terlesky	1961-05-30	\N
7232	Michael Zinberg	1944-03-22	\N
7233	Stanley Brooks	\N	\N
7234	Keith Potter	\N	\N
7235	Paul Edwards	\N	\N
7236	Elodie Keene	1949-04-10	\N
7237	Cherie Gierhart	\N	\N
7238	Mark Kolpack	\N	\N
7239	Lou Diamond Phillips	1962-02-17	\N
7240	Chris Cheramie	\N	\N
7241	Eli Gonda	\N	\N
7242	Aprill Winney	\N	\N
7243	DJ Doyle	\N	\N
7244	Sharla Oliver	\N	\N
7245	James C. Oliver	\N	\N
7246	George Kitson	\N	\N
7247	Brent Fletcher	\N	\N
7248	Mark Leitner	\N	\N
7249	Jeffrey Bell	\N	\N
7250	Paul Zbyszewski	\N	\N
7251	Lilla Zuckerman	1974-09-02	\N
7252	Nora Zuckerman	1976-03-06	\N
7253	Iden Baghdadchi	\N	\N
7254	Shalisha Francis	\N	\N
7255	Chris Dingess	\N	\N
7256	Chris Freyer	\N	\N
7257	Stefan Pleszczynski	\N	\N
7258	David McWhirter	\N	\N
7259	Ralph Hemecker	\N	\N
7260	Philip Chipera	\N	\N
7261	Chris Peppe	\N	\N
7262	Menhaj Huda	1967-03-20	\N
7263	Armen V. Kevorkian	\N	\N
7264	Brent Crowell	\N	\N
7265	Eric Dean Seaton	\N	\N
7266	Steve Shill	\N	\N
7267	C. Kim Miles	\N	\N
7268	Harry Jierjian	\N	\N
7269	Rob J. Greenlea	\N	\N
7270	Viet Nguyen	\N	\N
7271	Larry Shaw	\N	\N
7272	Alice Troughton	\N	\N
7273	Kevin Mock	\N	\N
7274	Tara Nicole Weyr	\N	\N
7275	Jeff Cassidy	\N	\N
7276	Rebecca Johnson	\N	\N
7277	Joshua V. Gilbert	\N	\N
7278	Jeff Hersh	\N	\N
7279	Lauren Certo	\N	\N
7280	Jess Carson	\N	\N
7281	Emily Palizzi	\N	\N
7282	Sterling Gates	1981-03-01	\N
7283	Kristen Kim	\N	\N
7284	Thomas Pound	\N	\N
7285	David Kob	\N	\N
7286	Wu Kai-yu	\N	\N
7287	Todd Helbing	\N	\N
7288	Aaron Helbing	\N	\N
7289	Katherine Walczak	\N	\N
7290	Jonathan Butler	\N	\N
7291	Sam Chalsen	\N	\N
7292	Eric Wallace	\N	\N
7293	Gabriel Garza	\N	\N
7294	Kelly Wheeler	\N	\N
7295	Lauren Barnett	\N	\N
7296	Joe Peracchio	\N	\N
7297	Jaime Paglia	\N	\N
7298	Chris Rafferty	\N	\N
7299	Julian Meiojas	\N	\N
7300	Cortney Norris	\N	\N
7301	Ray Utarnachitt	\N	\N
7302	Emily Silver	\N	\N
7303	Lilah Vandenburgh	\N	\N
7304	Bronwen Clark	\N	\N
7305	Carina Adly MacKenzie	\N	\N
7306	Andrew S. Wilder	1974-08-19	\N
7307	Mike Alber	\N	\N
7309	Brooke Eikmeier	\N	\N
7310	Chad Lowe	1968-01-15	\N
7311	Shannon Kohli	\N	\N
7312	Alexis Ostrander	\N	\N
7313	Alysse Leite-Rogers	\N	\N
7314	Jamie Babbit	1970-11-16	\N
7315	John Medlen	\N	\N
7316	Derek Simon	\N	\N
7317	Jessica Kardos	\N	\N
7318	Eric Carrasco	\N	\N
7319	Katie Rose Rogers	\N	\N
7320	Nicki Holcomb	\N	\N
7321	Caitlin Parrish	\N	\N
7322	Anna Musky-Goldwyn	\N	\N
7323	Daniel Beaty	\N	\N
7324	Robert Rovner	\N	\N
7325	Aadrita Mukerji	\N	\N
7326	Jessica Queller	\N	\N
7327	Gabriel Llanas	\N	\N
7328	Dana Horgan	\N	\N
7329	Rob Wright	\N	\N
7330	Paula Yoo	\N	\N
7331	Lindsay Sturman	\N	\N
7332	Yahlin Chang	\N	\N
7333	Michael Grassi	\N	\N
7334	Rachel Shukert	\N	\N
7335	Cindy Lichtman	\N	\N
7336	Ted Sullivan	1971-04-28	\N
7337	Maria Maggenti	\N	\N
7338	Brooke Pohl	\N	\N
7339	James DeWille	\N	\N
7340	Greg Baldwin	\N	\N
7341	Chandler Smidt	\N	\N
7342	Jen Troy	\N	\N
7343	Lindsay Gelfand	\N	\N
7344	Alix Sternberg	\N	\N
7345	Allison Weintraub	\N	\N
7346	David Geddes	\N	\N
7347	April Mullen	\N	\N
7348	Andrew Kasch	1979-11-06	\N
7349	Nico Sachse	\N	\N
7350	Rob Seidenglanz	\N	\N
7351	Chris Tammaro	\N	\N
7352	Dean Choe	\N	\N
7353	Michael Grossman	\N	\N
7354	Cherie Nowlan	\N	\N
7355	Olatunde Osunsanmi	1977-10-23	\N
7356	Mark Bruner	\N	\N
7357	Morgan Faust	\N	\N
7358	Matthew Maala	\N	\N
7359	James Eagan	\N	\N
7360	Leah Poulliot	\N	\N
7361	Chris Fedak	\N	\N
7362	Sarah Nicole Jones	\N	\N
7363	Anderson Mackenzie	\N	\N
7364	Jackie Canino	\N	\N
7365	Sarah Hernandez	\N	\N
7366	Emily Cheever	\N	\N
7367	Robert Forster	1941-07-13	2019-10-11
7368	Finley Jacobsen	2002-10-03	\N
7369	Radha Mitchell	1973-11-12	\N
7370	Manny Montana	1983-09-26	\N
7371	Matthew Elam	\N	\N
7372	Anji White	\N	\N
7373	Jim Rash	1971-07-15	\N
7374	Sonia Denis	\N	\N
7376	Zoe Terakes	2000-03-22	\N
7377	Shakira Barrera	1990-03-07	\N
7378	Sam Bailey	\N	\N
7379	Chinaka Hodge	\N	\N
7380	Malarie Howard	\N	\N
7381	Amir Sulaiman	\N	\N
7382	Angela Barnes	\N	\N
7383	Cristian Martinez	\N	\N
7384	Regan Aliyah	1999-07-08	\N
7385	Paul Calderón	1952-01-25	\N
7386	Victoria Mahoney	\N	\N
7387	Sarah Walker	\N	\N
7388	Nicole Dubuc	1978-11-06	\N
7389	Miles Caton	2005-03-03	\N
7390	Jack O'Connell	1990-08-01	\N
7391	Jayme Lawson	1997-09-19	\N
7392	Omar Miller	1978-10-07	\N
7393	Delroy Lindo	1952-11-18	\N
7394	Damson Idris	1991-09-02	\N
7395	Kerry Condon	1983-01-09	\N
7396	Tobias Menzies	1974-03-07	\N
7397	Babak Najafi	1975-09-14	\N
7398	Chad St. John	\N	\N
7399	Alon Abutbul	1965-05-28	\N
7400	Sean O'Bryan	1963-09-10	\N
7401	Waleed Zuaiter	1971-01-16	\N
7402	Charlotte Riley	1981-12-29	\N
7403	Ric Roman Waugh	1968-02-20	\N
7404	Piper Perabo	1976-10-31	\N
7405	Darren Aronofsky	1969-02-12	\N
7406	Hubert Selby Jr.	1928-07-23	2004-04-26
7407	Ronald Harwood	1934-11-09	2020-09-08
7408	Frank Finlay	1926-08-06	2016-01-30
7409	Maureen Lipman	1946-05-10	\N
7410	Emilia Fox	1974-07-31	\N
7411	Ed Stoppard	1974-09-16	\N
7412	Julia Rayner	\N	\N
7413	Jessica Kate Meyer	\N	\N
7414	Matthew Robinson	1978-05-26	\N
7415	Josh A. Cagan	\N	\N
7416	Malachi Barton	2007-03-10	\N
7417	Freya Skye	2009-10-17	\N
7418	Julian Lerner	2007-11-05	\N
7419	Swayam Bhatia	2007-10-08	\N
7420	Mekonnen Knife	2006-07-06	\N
7421	Lisa Chappell	1968-10-18	\N
7422	Jonno Roberts	1979-07-13	\N
7423	Jay Scherick	\N	\N
7424	David Ronn	\N	\N
7425	Katy Perry	1984-10-25	\N
7426	Danny Pudi	1979-03-10	\N
7427	Meghan Trainor	1993-12-22	\N
7428	Rachel Brosnahan	1990-07-12	\N
7429	Edi Gathegi	1979-03-10	\N
7430	Hayley Squires	1988-04-16	\N
7431	Kylie Rogers	2004-02-18	\N
7432	Frank Coraci	1966-02-03	\N
7433	Jerry Reed	1937-03-20	2008-09-01
7434	Henry Winkler	1945-10-30	\N
7435	Tommy Lister Jr.	1958-06-24	2020-12-10
7436	Rodney Dangerfield	1921-11-22	2004-10-05
7437	Julie Kavner	1950-09-07	\N
7438	Emmanuelle Chriqui	1975-12-10	\N
7439	Nick Swardson	1976-10-09	\N
7440	Judd Apatow	1967-12-06	\N
7441	Fred Wolf	1964-11-07	\N
7442	Brian Doyle-Murray	1945-10-31	\N
7443	Ted Knight	1923-12-07	1986-08-26
7444	Michael O'Keefe	1955-04-24	\N
7445	Alexander Wise	\N	\N
7446	Shadi Petosky	1974-09-18	\N
7447	Greg Goetz	\N	\N
7448	Marina Marlens	\N	\N
7449	John Daly	1966-04-28	\N
7450	Jim Abrahams	1944-05-10	2024-11-26
7451	Priscilla Presley	1945-05-24	\N
7452	George Kennedy	1925-02-18	2016-02-28
7453	O.J. Simpson	1947-07-09	2024-04-10
7454	Robert Goulet	1933-11-26	2007-10-30
7455	Robert LoCash	\N	\N
7456	Fred Ward	1942-12-30	2022-05-08
7457	Todd Harris	\N	\N
7458	John Fang	\N	\N
7459	Geoffrey Thorne	1970-01-20	\N
7460	Marc Bernardin	1971-11-29	\N
7461	Winnie Harlow	1994-07-27	\N
7462	Larry Herron	1980-10-08	\N
7463	Adam Gold	\N	\N
7464	Jacques Colimon	1994-08-27	\N
7465	Jona Xiao	1989-05-18	\N
7467	Zach Lipovsky	1984-02-07	\N
7468	Adam Stein	\N	\N
7469	Lori Evans Taylor	1975-03-12	\N
7470	Kaitlyn Santa Juana	1997-04-19	\N
7471	Teo Briones	2005-01-11	\N
7472	Richard Harmon	1991-08-18	\N
7473	Owen Patrick Joyner	2000-07-19	\N
7474	Rya Kihlstedt	1970-07-23	\N
7475	Anna Lore	1993-03-15	\N
7476	Jeff Kaplan	1972-11-04	\N
7477	Ian Springer	\N	\N
7478	Sarah Niles	1987-06-17	\N
7479	Mark Gatiss	1966-10-17	\N
7480	Heather Hach	1971-01-15	\N
7481	Harold Gould	1923-12-10	2010-09-11
7482	Chad Michael Murray	1981-08-24	\N
7483	Mark Harmon	1951-09-02	\N
7484	Rupert Friend	1981-10-09	\N
7485	Maggie Kang	\N	\N
7486	Chris Appelhans	\N	\N
7487	Danya Jimenez	\N	\N
7488	Hannah McMechan	\N	\N
7489	Arden Cho	1985-08-16	\N
7490	Ahn Hyo-seop	1995-04-17	\N
7491	May Hong	\N	\N
7492	Ji-young Yoo	2000-07-13	\N
7493	Yunjin Kim	1973-11-07	\N
7494	Clive Exton	1930-04-11	2007-08-16
7495	George MacDonald Fraser	1925-04-02	2008-01-02
7496	Ernie Reyes Jr.	1972-01-15	\N
7497	Nick Searcy	1959-03-07	\N
7498	Rich Lee	\N	\N
7499	Kenny Golde	\N	\N
7500	Marc Hyman	\N	\N
7501	Iman Benson	2000-06-25	\N
7502	Henry Hunter Hall	1996-04-05	\N
7503	Michael O'Neill	1951-05-29	\N
7504	Andrea Savage	1973-02-20	\N
7505	Mark Heyman	1979-11-26	\N
7506	Andres Heinz	\N	\N
7507	John McLaughlin	\N	\N
7508	Alex Scharfman	\N	\N
7509	Stephen Park	1962-05-04	\N
7510	Jessica Hynes	1972-10-30	\N
7511	Danny Aiello	1933-06-20	2019-12-12
7512	Gus Van Sant	1952-07-24	\N
7513	Michael J. Leeson	\N	2016-07-27
7514	Marianne Sägebrecht	1945-08-27	\N
7515	Heather Fairfield	1969-06-14	\N
7516	G.D. Spradlin	1920-08-31	2011-07-24
7517	Michael Herz	1949-05-09	\N
7518	Lloyd Kaufman	1945-12-30	\N
7519	Joe Ritter	\N	\N
7520	Andree Maranda	\N	\N
7521	Mitchell Cohen	\N	\N
7522	R.L. Ryan	1946-10-29	1991-03-22
7523	Jennifer Babtist	\N	\N
7524	Robert Prichard	1956-01-01	\N
7525	Cindy Manion	\N	\N
7526	Gary Schneider	\N	\N
7527	Mark Torgl	\N	\N
7528	Mike Hodges	1932-07-29	2022-12-17
7529	Lorenzo Semple Jr.	1923-03-27	2014-03-28
7530	Sam J. Jones	1954-08-12	\N
7531	Melody Anderson	1955-12-03	\N
7532	Ornella Muti	1955-03-09	\N
7533	Chaim Topol	1935-09-09	2023-03-08
7534	Mariangela Melato	1941-09-19	2023-01-11
7535	Peter Wyngarde	1927-08-23	2018-01-15
7536	Alexander DiPersia	1982-03-06	\N
7537	Paco Cabezas	1978-01-11	\N
7538	Valentina L. Garza	1975-03-30	\N
7539	Lauren Otero	\N	\N
7540	Angela Robinson	1971-02-14	\N
7541	Erika Vázquez	\N	\N
7542	Siena Butterfield	\N	\N
7543	Isaac Ordonez	2009-04-15	\N
7544	Owen Painter	\N	\N
7545	Billie Piper	1982-09-22	\N
7546	Luyanda Unati Lewis-Nyawo	\N	\N
7547	Victor Dorobantu	1997-03-05	\N
7548	Noah B. Taylor	\N	\N
7549	Evie Templeton	2008-12-31	\N
7550	Laura Harrington	1958-04-29	\N
7551	Yeardly Smith	1964-07-03	\N
7553	Ellen McElduff	1964-03-07	\N
7554	Frankie Faison	1949-06-10	\N
7555	Leon Rippy	1949-10-30	\N
7556	Christopher Murney	1943-07-20	\N
7557	Michael Engler	\N	\N
7558	Julian Fellowes	1949-08-17	\N
7559	Laura Carmichael	1986-07-16	\N
7560	Raquel Cassidy	1968-01-22	\N
7561	Brendan Coyle	1962-12-02	\N
7562	Michelle Dockery	1981-12-15	\N
7563	Kevin Doyle	1961-01-01	\N
7564	Michael Fox	1989-01-05	\N
7565	Joanne Froggatt	1980-08-23	\N
7566	Harry Hadden-Paton	1981-04-10	\N
7567	Robert James-Collier	1976-09-23	\N
7568	Allen Leech	1981-05-18	\N
7569	Phyllis Logan	1956-01-11	\N
7570	Elizabeth McGovern	1961-07-18	\N
7571	Sophie McShera	1985-05-17	\N
7572	Lesley Nicol	1953-08-07	\N
7573	Simon Curtis	1960-03-11	\N
7574	Nathalie Baye	1948-07-06	\N
7575	Laura Haddock	1985-08-21	\N
7576	Tuppence Middleton	1987-02-21	\N
7577	Jonathan Zaccaï	1970-07-22	\N
7578	June Chadwick	1951-11-30	\N
7579	Tony Hendra	1941-07-10	2021-03-04
7580	Bruno Kirby	1949-04-28	2006-08-14
7581	David Frankel	1959-04-02	\N
7582	Aline Brosh McKenna	1967-08-02	\N
7583	Simon Baker	1969-07-30	\N
7584	Adrian Grenier	1976-07-10	\N
7585	Bennett Miller	1966-12-30	\N
7586	James Marshall	1967-01-02	\N
5264	Diane Ademu-John	\N	\N
5265	Alison Schapker	1971-03-09	\N
5266	Lauren LeFranc	\N	\N
5267	Jac Schaeffer	1978-10-26	\N
5268	Leslye Headland	1980-11-26	\N
5269	John Whittington	\N	\N
5270	Graham Wagner	\N	\N
5271	Geneva Robertson-Dworet	1985-05-08	\N
5272	Marion Dayre	\N	\N
5273	Rick Riordan	1964-06-05	\N
5274	Jonathan E. Steinberg	\N	\N
5275	Chris Black	\N	\N
5276	Matt Fraction	1975-12-01	\N
5277	Craig Rosenberg	\N	\N
5278	Evan Goldberg	1982-09-15	\N
5279	Eric Kripke	1974-04-24	\N
5280	Kyle Bradstreet	1979-12-10	\N
5281	Craig Mazin	1971-04-08	\N
5282	Neil Druckmann	1978-12-05	\N
5283	Charlie Grandy	1974-03-05	\N
5284	Alfred Gough	1967-08-22	\N
5285	Miles Millar	1967-01-01	\N
5286	J.D. Payne	\N	\N
5287	Patrick McKay	\N	\N
6859	Ameni Rozsa	\N	\N
7160	Jim Dunn	\N	\N
2928	Sergio Rubini	1959-12-21	\N
2929	Paul Rudd	1969-04-06	\N
2930	Maya Rudolph	1972-07-27	\N
2931	Mark Ruffalo	1967-11-22	\N
2932	Olesya Rulin	1986-03-17	\N
2933	RuPaul	1960-11-17	\N
2934	Debra Jo Rupp	1951-02-24	\N
2935	Robert Rusler	1965-09-20	\N
2936	Simon Russell Beale	1961-01-12	\N
2937	Betsy Russell	1963-09-06	\N
2938	Chuck Russell	1958-05-09	\N
2939	Wyatt Russell	1986-07-10	\N
2940	Anthony Russo	1970-02-03	\N
2941	Joe Russo	1971-07-18	\N
2942	Amy Ryan	1968-05-03	\N
2943	Mitchell Ryan	1934-01-11	2022-03-04
2944	Remy Ryan	1984-01-24	\N
2945	Mark Rylance	1960-01-18	\N
2946	RZA	1969-07-05	\N
2947	Daryl Sabara	1992-06-14	\N
2948	Ernie Sabella	1949-09-19	\N
2949	Katee Sackhoff	1980-04-08	\N
2950	Jonathan Sagall	1959-04-23	\N
2952	Ludivine Sagnier	1979-07-03	\N
2953	Hironobu Sakaguchi	1962-11-25	\N
2954	Chika Sakamoto	1959-08-17	\N
2955	Rei Sakuma	1965-01-05	\N
2956	Zoe Saldaña	1978-06-19	\N
2957	Carlos Saldanha	1965-01-24	\N
2958	Matt Salinger	1960-02-13	\N
2959	Colin Salmon	1962-12-06	\N
2960	Angus Sampson	1979-02-12	\N
2961	Joanne Samuel	1957-08-05	\N
2962	Hiroyuki Sanada	1960-10-12	\N
2963	Kiele Sanchez	1977-10-13	\N
2964	Chris Sanders	1962-03-12	\N
2965	Ethan Sandler	1972-12-03	\N
2966	Ellen Sandweiss	1958-12-30	\N
2967	Erskine Sanford	1885-11-19	1969-07-07
2968	Rodrigo Santoro	1975-08-22	\N
2969	Danny Sapani	1970-11-15	\N
2970	Joseph Sargent	1925-07-22	2014-12-22
2971	Peter Sarsgaard	1971-03-07	\N
2972	Will Sasso	1975-05-24	\N
2973	Jennifer Saunders	1958-07-06	\N
2974	Yasuko Sawaguchi	1965-06-11	\N
2975	John Saxon	1935-08-05	2020-07-25
2976	Dan Scanlon	1976-06-21	\N
2977	Franklin J. Schaffner	1920-05-30	1989-07-02
2978	Maria Schell	1926-01-15	2005-04-26
2979	Martin Starr	1982-07-30	\N
2980	Ernest B. Schoedsack	1893-06-08	1979-12-23
2981	Matthias Schoenaerts	1977-12-08	\N
2982	Michael Scholes	\N	\N
2983	Max Schreck	1879-09-06	1936-02-20
2984	Greta Schröder	1892-06-27	1980-06-08
2985	John Schultz	1963-05-12	\N
2986	Matt Schulze	1972-07-03	\N
2987	Paul Schulze	1962-11-30	\N
2988	Scott Schwartz	1968-05-12	\N
2989	Robert Schwartzman	1982-12-24	\N
2990	Matthias Schweighöfer	1981-03-11	\N
2991	Robert Schwentke	1968-02-15	\N
2992	Jacob Scipio	1993-01-10	\N
2993	Dougray Scott	1965-11-25	\N
2994	Martha Scott	1912-09-22	2003-05-28
2995	Tom Everett Scott	1970-09-07	\N
2996	Douglas Seale	1913-10-28	1999-06-13
2997	George Seaton	1911-04-17	1979-07-28
2998	Amy Sedaris	1961-03-29	\N
2999	Rhea Seehorn	1972-05-12	\N
3000	Peter Segal	1962-04-20	\N
3001	Pamela Adlon	1966-07-09	\N
3002	Jason Segel	1980-01-18	\N
3003	Henry Selick	1952-11-30	\N
3004	Charles E. Sellier Jr.	1943-11-09	2011-01-31
3005	Peter Serafinowicz	1972-07-10	\N
3007	Andy Serkis	1964-04-20	\N
3008	Roshan Seth	1942-04-02	\N
3009	Matthew Settle	1969-09-17	\N
3010	Brendan Sexton III	1980-02-21	\N
3011	Cara Seymour	1964-01-06	\N
3012	Glenn Shadix	1952-04-15	2010-09-07
3013	Shakira	1977-02-02	\N
3014	Adam Shankman	1964-11-27	\N
3015	Michael Shannon	1974-08-07	\N
3016	Molly Shannon	1964-09-16	\N
3017	Jim Sharman	1945-03-12	\N
3018	Ben Sharpsteen	1895-11-04	1980-12-20
3019	Grant Shaud	1961-02-27	\N
3020	Fiona Shaw	1958-07-10	\N
3021	Michael Sheen	1969-02-05	\N
3022	John Shepherd	1960-11-18	\N
3023	Sherri Shepherd	1967-04-22	\N
3024	Dave Sheridan	1969-03-10	\N
3025	Kô Shibasaki	1981-08-05	\N
3026	Kien Shih	1913-01-01	2009-06-03
3027	Yukiko Shimazaki	1931-02-25	2014-02-15
3028	Sab Shimono	1937-07-31	\N
3029	Takashi Shimura	1905-03-12	1982-02-11
3030	Nelson Shin	1939-01-01	\N
3031	John Wesley Shipp	1955-01-22	\N
3032	Bill Shirley	1921-07-06	1989-08-27
3033	Jack Sholder	1945-06-08	\N
3034	Dorothy Short	1915-06-29	1963-06-04
3035	Cate Shortland	1968-08-10	\N
3036	Robin Shou	1960-07-17	\N
3037	M. Night Shyamalan	1970-08-06	\N
3038	Sylvia Sidney	1910-08-09	1999-07-01
3039	Jim Siedow	1920-06-12	2003-11-20
3040	Brad Silberling	1963-09-08	\N
3041	Sarah Silverman	1970-12-01	\N
3042	J.K. Simmons	1955-01-09	\N
3043	Jaason Simmons	1970-07-12	\N
3044	Madge Sinclair	1938-04-28	1995-12-20
3045	Retta	1978-07-12	\N
3046	Greg Sestero	1978-07-15	\N
3047	Bill Skarsgård	1990-08-09	\N
3048	John Slattery	1962-08-13	\N
3049	Everett Sloane	1909-10-01	1965-08-06
3050	Allison Smith	1969-12-09	\N
3051	Anna Deavere Smith	1950-09-18	\N
3052	Douglas Smith	1985-06-22	\N
3053	Dylan Smith	\N	\N
3054	Lane Smith	1936-04-29	2005-06-13
3055	Lois Smith	1930-11-03	\N
3056	Paul L. Smith	1939-02-05	2012-04-25
3057	Phyllis Smith	1949-08-15	\N
3058	Sarah Smith	\N	\N
3059	Shawnee Smith	1969-07-03	\N
3060	Tasha Smith	1971-02-28	\N
3061	William Smith	1933-03-24	2021-07-05
3062	Jurnee Smollett	1986-10-01	\N
3063	Brittany Snow	1986-03-09	\N
3064	Suzanne Snyder	1962-10-22	\N
3065	Zack Snyder	1966-03-01	\N
3066	Peter Sohn	1975-06-21	\N
3067	Courtney Solomon	1971-09-01	\N
3068	Stephen Sommers	1962-03-20	\N
3069	Song Kang-ho	1967-01-17	\N
3070	Lucille Soong	1938-08-15	\N
3071	Dale Soules	1946-10-02	\N
3072	Octavia Spencer	1970-05-25	\N
3073	Kevin Spirtas	1962-07-29	\N
3074	Lisa Spoonauer	1972-12-06	2017-05-20
3075	Cole Sprouse	1992-08-04	\N
3076	Sam Spruell	1977-01-01	\N
3077	June Squibb	1929-11-06	\N
3078	William Squire	1916-04-29	1989-05-03
3079	Marco St. John	1939-05-07	\N
3080	Michelle St. John	1967-08-26	\N
3081	Robert Stack	1919-01-13	2003-05-14
3082	Krista Stadler	1942-08-15	\N
3083	Chad Stahelski	1968-09-20	\N
3084	Sage Stallone	1976-05-05	2012-07-13
3085	Lionel Stander	1908-01-11	1994-11-30
3086	Aaron Stanford	1976-12-27	\N
3087	Florence Stanley	1924-07-01	2003-10-03
3088	Stephen Stanton	1961-08-22	\N
3089	Sullivan Stapleton	1977-06-14	\N
3090	Beau Starr	1944-09-01	\N
3091	Mike Starr	1950-07-29	\N
3092	Amy Steel	1960-05-03	\N
3093	Danny Steinmann	1942-01-07	2012-12-18
3094	Michael Stephenson	1978-02-28	\N
3095	Pamela Stephenson	1949-12-04	\N
3096	Mindy Sterling	1953-07-11	\N
3097	Daniel Stern	1957-08-28	\N
3098	Frances Sternhagen	1930-01-13	2023-11-27
3099	Connie Stevens	1938-08-08	\N
3100	John Stevenson	\N	\N
3101	Ray Stevenson	1964-05-25	2023-05-21
3102	Robert Stevenson	1905-03-31	1986-04-30
3103	Kristen Stewart	1990-04-09	\N
3104	Paul Stewart	1908-03-13	1986-02-17
3105	Victor Stiles	1951-12-06	\N
3106	Leonard Stone	1923-11-03	2011-11-02
3466	Common	1972-03-13	\N
5231	Michel Gondry	1963-05-08	\N
5232	Kinka Usher	\N	\N
5233	Greg Kinnear	1963-06-17	\N
5234	Kel Mitchell	1978-08-25	\N
5235	Lena Olin	1955-03-22	\N
5236	Tom Waits	1949-12-07	\N
5237	Geraldine Viswanathan	1995-06-20	\N
5238	Chris Bauer	1966-10-28	\N
5239	Wendell Pierce	1962-12-08	\N
5240	Cameron Crowe	1957-07-13	\N
5241	Jay Mohr	1970-08-23	\N
5242	Regina King	1971-01-15	\N
5243	Scott Frank	1960-03-10	\N
5244	Jon Cohen	\N	\N
5245	Josh Friedman	1967-02-14	\N
5246	David Koepp	1963-06-09	\N
5247	Matt Palmer	\N	\N
5248	Donald McLeary	1973-11-27	\N
5249	India Fowler	\N	\N
5250	Suzanna Son	1995-10-31	\N
5251	Fina Strazza	2005-11-03	\N
5252	David Iacono	2002-06-20	\N
5253	Ella Rubin	2001-09-02	\N
5254	Dean Fleischer Camp	1982-02-28	\N
5255	Chris Kekaniokalani Bright	\N	\N
5256	Mike Van Waes	\N	\N
5257	Sydney Elizebeth Agudong	2000-11-13	\N
5258	Maia Kealoha	2016-12-14	\N
5259	Dario Scardapane	1966-05-20	\N
5260	Matt Corman	\N	\N
5261	Chris Ord	\N	\N
5262	Jeff Trammell	1990-03-11	\N
5263	Christopher Ford	\N	\N
5288	Ryan Condal	\N	\N
5289	George R.R. Martin	1948-09-20	\N
5290	Jessica Gao	1984-01-02	\N
5291	Neil Gaiman	1960-11-10	\N
5292	Allan Heinberg	1967-06-29	\N
5293	Bisha K. Ali	1989-03-17	\N
5294	Joby Harold	\N	\N
5295	Jeremy Slater	\N	\N
5296	Kyle Killen	\N	\N
5297	Steven Kane	1968-12-03	\N
5298	Jonathan Igla	\N	\N
5299	Christian Linke	1987-03-11	\N
5300	Alex Yee	\N	\N
5301	Hwang Dong-hyuk	1971-05-26	\N
5302	A.C. Bradley	\N	\N
5303	Michael Waldron	1987-04-23	\N
5304	Robert Kirkman	1978-11-30	\N
5305	Malcolm Spellman	\N	\N
5306	Josh Heald	1977-12-12	\N
5307	Jon Hurwitz	1977-11-15	\N
5308	Hayden Schlossberg	1978-06-09	\N
5309	Matt Duffer	1984-02-15	\N
5310	Ross Duffer	1984-02-15	\N
5311	David Benioff	1970-09-25	\N
5312	D.B. Weiss	1971-04-23	\N
5313	Park Gyu-young	1993-07-27	\N
5314	Eduardo Franco	1994-08-29	\N
5315	Triple H	1969-07-27	\N
1937	David Ganly	\N	\N
2231	Dakota Johnson	1989-10-04	\N
2892	RD Robb	1972-03-31	\N
5059	Kyriana Kratter	2010-04-27	\N
7552	John Short	\N	\N
1518	Chris Buck	1958-02-24	\N
1519	David Buck	1936-10-17	1989-01-27
1520	A.J. Buckley	1977-02-09	\N
1521	John Carl Buechler	1952-06-18	2019-03-18
1522	Rodger Bumpass	1951-11-20	\N
1523	Cara Buono	1971-03-01	\N
1524	Robert John Burke	1960-09-12	\N
1525	Billy Burke	1966-11-25	\N
1526	Tom Burke	1981-06-30	\N
1527	Mark Burnham	\N	\N
1528	Edward Burns	1968-01-29	\N
1529	Marilyn Burns	1949-07-05	2014-08-05
1530	Tim Burns	1957-01-01	\N
1531	Ty Burrell	1967-08-22	\N
1532	Clarissa Burt	1959-04-25	\N
1533	Corey Burton	1955-08-03	\N
1534	Norman Burton	1923-12-05	2003-11-29
1535	CeeLo Green	1975-05-30	\N
1536	Ben Burtt	1948-07-12	\N
1537	Gerard Butler	1969-11-13	\N
1538	Merritt Butrick	1959-09-03	1989-03-17
1539	Norbert Leo Butz	1967-01-30	\N
1540	Eugene Byrd	1975-08-28	\N
1541	Rose Byrne	1979-07-24	\N
1542	Edd Byrnes	1933-07-30	2020-01-08
1543	Arthur Byron	1872-04-03	1943-07-17
1544	Louis C.K.	1967-09-12	\N
1545	Bruce Cabot	1904-04-20	1972-05-03
1546	Christina Cabot	1969-12-16	\N
1547	Adolph Caesar	1933-12-05	1986-03-06
1548	Sid Caesar	1922-09-08	2014-02-12
1549	Christopher Cain	1943-10-29	\N
1550	Niketa Calame	1980-11-10	\N
1551	Zoe Caldwell	1933-09-14	2020-02-16
1552	John Call	1908-11-03	1973-04-03
1553	Kirk Cameron	1970-10-12	\N
1554	Colleen Camp	1953-06-07	\N
1555	Bruce Campbell	1958-06-22	\N
1556	Martin Campbell	1943-10-24	\N
1557	Candy Candido	1913-12-25	1999-05-19
1558	Bobby Cannavale	1970-05-03	\N
1559	Danny Cannon	1968-10-05	\N
1560	Nick Cannon	1980-10-08	\N
1561	Peter Capaldi	1958-04-14	\N
1562	Lizzy Caplan	1982-06-30	\N
1563	Ahna Capri	1944-07-06	2010-08-19
1564	Steve Carell	1962-08-16	\N
1565	Ron Carey	1935-12-11	2007-01-16
1566	Gia Carides	1964-06-07	\N
1567	George Carlin	1937-05-12	2008-06-22
1568	Richard Carlson	1912-04-30	1977-11-26
1569	Art Carney	1918-11-04	2003-11-09
1570	Niki Caro	1966-09-20	\N
1571	Charmian Carr	1942-12-27	2016-09-17
1572	Steve Carr	1965-04-07	\N
1573	Diahann Carroll	1935-07-17	2019-10-04
1574	Pat Carroll	1927-05-04	2022-07-29
1575	David Carson	1948-05-16	\N
1576	Terrence 'T.C.' Carson	1958-11-19	\N
1577	Erinn Hayes	1976-05-25	\N
1578	Jim Carter	1948-08-19	\N
1579	D.J. Caruso	1965-01-17	\N
1580	Richard S. Castellano	1933-09-04	1988-12-10
1581	John Castle	1940-01-14	\N
1582	Reg E. Cathey	1958-08-18	2018-02-09
1583	Mary Jo Catlett	1938-09-02	\N
1584	Dick Cavett	1936-11-19	\N
1585	Henry Cavill	1983-05-05	\N
1586	Cedric The Entertainer	1964-04-24	\N
1587	Angie Cepeda	1974-08-02	\N
1588	Michael Cera	1988-06-07	\N
1589	Tony Cervone	1966-11-15	\N
1590	Alain Chabat	1958-11-24	\N
1591	Don Chaffey	1917-08-05	1990-11-13
1592	Wilt Chamberlain	1936-08-21	1999-10-12
1593	Kevin Chamberlin	1963-11-25	\N
1594	Justin Chambers	1970-07-11	\N
1595	Helen Chandler	1906-02-01	1965-04-30
1596	Kyle Chandler	1965-09-17	\N
1597	Simon Chandler	1953-06-04	\N
1598	Chang Chen	1976-10-14	\N
1599	Winston Chao	1960-06-09	\N
1600	Ben Chapman	1928-10-29	2008-02-21
1601	Brenda Chapman	1962-11-01	\N
1602	Dave Chappelle	1973-08-24	\N
1603	Joe Chappelle	\N	\N
1604	Tara Strong	1973-02-12	\N
1605	Eric Freeman	1965-07-13	\N
1606	Daveigh Chase	1990-07-24	\N
1607	Justin Chatwin	1982-10-31	\N
1608	Lilyan Chauvin	1925-08-06	2008-06-26
1609	Stephen Chbosky	1970-01-25	\N
1610	Jeremiah S. Chechik	1955-06-27	\N
1611	Peter Chelsom	1956-04-20	\N
1612	Yarrow Cheney	1973-06-27	\N
1613	Kristin Chenoweth	1968-07-24	\N
1614	Minoru Chiaki	1917-04-28	1999-11-01
1615	Tsai Chin	1936-11-30	\N
1616	Stephen Chiodo	1954-03-02	\N
1617	John Cho	1972-06-16	\N
1618	Joe Chrest	1963-05-26	\N
1619	Hayden Christensen	1981-04-19	\N
1620	Claudia Christian	1965-08-10	\N
1621	Dennis Christopher	1950-12-02	\N
1622	Jon M. Chu	1979-11-02	\N
1623	Leonardo Cimino	1917-11-04	2012-03-03
1624	Bob Clark	1939-08-05	2007-04-04
1625	Candy Clark	1947-06-20	\N
1626	Clark Gregg	1962-04-02	\N
1627	Les Clark	1907-11-17	1979-09-12
1628	Jason Clarke	1969-07-17	\N
1629	Mae Clarke	1910-08-16	1992-04-29
1630	Patricia Clarkson	1959-12-29	\N
1631	Kevin Clash	1960-09-17	\N
1632	Ron Clements	1953-04-25	\N
1633	Colin Clive	1900-01-20	1937-06-25
1634	E.E. Clive	1879-08-26	1940-06-06
1635	Rosemary Clooney	1928-05-23	2002-06-29
1636	Robert Clouse	1928-03-06	1997-02-04
1637	Bill Cobbs	1934-06-16	2024-06-25
1638	Imogene Coca	1908-11-18	2001-06-02
1639	James Coco	1930-03-21	1987-02-25
1640	Jeff Cohen	1976-06-25	\N
1641	Taika Waititi	1975-08-16	\N
1642	Stephen Colbert	1964-05-13	\N
1643	Gary Cole	1956-09-20	\N
1644	Julie Dawn Cole	1957-10-26	\N
1645	Monique Coleman	1980-11-13	\N
1646	Margaret Colin	1958-05-26	\N
1647	Paul Collins	1937-07-25	\N
1648	Ray Collins	1889-12-10	1965-07-11
1649	Jerry Colonna	1904-09-17	1986-11-21
1650	Dorothy Comingore	1913-08-24	1971-12-30
1651	Scout Taylor-Compton	1989-02-21	\N
1652	Bill Condon	1955-10-22	\N
1653	Donna Conforti	1953-11-14	\N
1654	Didi Conn	1951-07-13	\N
1655	Shelley Conn	1976-09-21	\N
1656	Billy Connolly	1942-11-24	\N
1657	Kevin Connolly	1974-03-05	\N
1658	Hans Conried	1917-04-15	1982-01-05
1659	Frances Conroy	1953-03-15	\N
1660	Kevin Conroy	1955-11-30	2022-11-10
1661	Paddy Considine	1973-09-05	\N
1662	Michael Constantine	1927-05-22	2021-08-31
1663	Keith Coogan	1970-01-13	\N
1664	Steve Coogan	1965-10-14	\N
1665	A.J. Cook	1978-07-22	\N
1666	Barry Cook	1958-08-12	\N
1667	Dane Cook	1972-03-18	\N
1668	Peter Cook	1937-11-17	1995-01-09
1669	Jennifer Cooke	1964-09-19	\N
1670	Jennifer Coolidge	1961-08-28	\N
1671	Bradley Cooper	1975-01-05	\N
1672	Chris Cooper	1951-07-09	\N
1673	Gladys Cooper	1888-12-18	1971-11-17
1674	Jackie Cooper	1922-09-15	2011-05-03
1675	Justin Cooper	1988-11-17	\N
1676	Merian C. Cooper	1893-10-24	1973-04-21
1677	John Corbett	1961-05-09	\N
1678	James Corden	1978-08-22	\N
1679	Wendell Corey	1914-03-20	1968-11-08
1680	Abbie Cornish	1982-08-07	\N
1681	Judy Cornwell	1940-02-22	\N
1682	Adrienne Corri	1930-11-13	2016-03-13
1683	Jesse Corti	1955-07-03	\N
1684	George P. Cosmatos	1941-01-04	2005-04-19
1685	James Cosmo	1948-05-24	\N
1686	Mary Costa	1930-04-05	\N
1687	Nikolaj Coster-Waldau	1970-07-27	\N
1688	Marion Cotillard	1975-09-30	\N
1689	George Coulouris	1903-10-01	1989-04-25
1690	Steve Coulter	1960-10-02	\N
1691	James Jude Courtney	1957-01-31	\N
1692	Jerome Cowan	1897-10-03	1972-01-24
1693	Larry Cox	\N	\N
1694	Michael Graham Cox	1938-01-08	1995-04-30
1695	Tony Cox	1958-03-31	\N
1696	Veanne Cox	1963-01-19	\N
1697	Daniel Craig	1968-03-02	\N
1698	Eli Craig	1972-05-25	\N
1699	Kenneth Craig	1914-12-07	1994-07-12
1700	Grant Cramer	1961-11-10	\N
1701	Kenneth Cranham	1944-12-12	\N
1702	Bryan Cranston	1956-03-07	\N
1703	Terry Crews	1968-07-30	\N
1704	Wendy Crewson	1956-05-09	\N
1705	Harry Crosby	1958-08-08	\N
1706	David Cross	1964-04-04	\N
1707	Joseph Cross	1986-05-28	\N
1708	Raymond Cruz	1961-07-09	\N
1709	Marton Csokas	1966-06-30	\N
1710	Alfonso Cuarón	1961-11-28	\N
1711	Rory Culkin	1989-07-21	\N
1712	Steven Culp	1955-12-03	\N
1713	Jill Culton	1973-03-20	\N
1714	Jim Cummings	1952-11-03	\N
1715	Martin Cummins	1969-11-28	\N
1716	Liam Cunningham	1961-06-02	\N
1717	Sean S. Cunningham	1941-12-31	\N
1718	Kaley Cuoco	1985-11-30	\N
1719	Tony Curran	1969-12-13	\N
1720	Gordon Currie	1965-09-25	\N
1721	Cliff Curtis	1968-07-27	\N
1722	Richard Curtis	1956-11-08	\N
1723	Nicholas D'Agosto	1980-04-17	\N
1724	Brian d'Arcy James	1968-06-29	\N
1725	James D'Arcy	1975-08-24	\N
1726	Daniel Dae Kim	1968-08-04	\N
1727	Jensen Daggett	1969-06-24	\N
1728	Lil Dagover	1887-09-29	1980-01-23
1729	James Badge Dale	1978-05-01	\N
1730	Jim Dale	1935-08-15	\N
1731	John Francis Daley	1985-07-20	\N
1732	Tony Dalton	1975-02-13	\N
1733	Andy Daly	1971-04-15	\N
1734	James Daly	1918-10-23	1978-07-03
1735	Gabriel Damon	1976-04-23	\N
1736	Hugh Dancy	1975-06-19	\N
1737	Eric Dane	1972-11-09	\N
1738	Rod Daniel	1942-08-04	2016-04-16
1739	Gary Daniels	1963-05-09	\N
1740	Paul Dano	1984-06-19	\N
1741	Royal Dano	1922-11-16	1994-05-15
1742	Dany Boon	1966-06-26	\N
1743	Severn Darden	1929-11-09	1995-05-27
1744	Eric Darnell	1961-08-21	\N
1745	Jack Davenport	1973-03-01	\N
1746	Keith David	1956-06-04	\N
1747	Ben Davidson	1940-06-14	2012-07-02
1748	Tommy Davidson	1963-11-10	\N
1749	Desmond Davis	1926-05-24	2021-07-03
1750	Lisa Davis	1936-04-20	\N
1751	Tamra Davis	1962-01-22	\N
1752	Viola Davis	1965-08-11	\N
1753	Rosario Dawson	1979-05-09	\N
1754	Charlie Day	1976-02-09	\N
1755	Frances de la Tour	1944-07-30	\N
1756	Maria de Medeiros	1965-08-19	\N
1757	Kirk DeMicco	1969-05-15	\N
1758	Darin De Paul	1960-11-07	\N
1759	Lezlie Deane	1964-06-01	\N
1760	Dean DeBlois	1970-06-07	\N
1761	Fred Dekker	1959-04-09	\N
1762	Thomas Dekker	1987-12-28	\N
1763	Steven S. DeKnight	1964-04-08	\N
1764	Ronnie Del Carmen	1959-12-31	\N
1765	Kate del Castillo	1972-10-23	\N
1766	Diane Delano	1957-01-29	2024-12-13
1767	Lea DeLaria	1958-05-23	\N
1768	Grey Griffin	1973-08-24	\N
1769	David Della Rocco	1952-05-04	\N
1770	Richard DeManincor	\N	\N
1771	James DeMonaco	1969-10-12	\N
1772	Darcy DeMoss	1963-08-19	\N
1773	Jeffrey DeMunn	1947-04-25	\N
1774	David Denman	1973-07-25	\N
1775	Nora Denney	1927-09-03	2005-11-20
1776	Richard Denning	1914-03-27	1998-10-11
1777	Kassie Wesley DePaiva	1964-03-21	\N
1778	Eugenio Derbez	1962-09-02	\N
1779	Scott Derrickson	1966-07-16	\N
1780	Zooey Deschanel	1980-01-17	\N
1781	Natalie Desselle Reid	1967-07-12	2020-12-07
1782	Alex Diakun	1946-02-08	\N
1783	Chris Diamantopoulos	1975-05-09	\N
1784	Kate Dickie	1971-03-23	\N
1785	August Diehl	1976-01-04	\N
1786	Dudley Digges	1879-06-08	1947-10-24
1787	Garret Dillahunt	1964-11-24	\N
1788	Stephen Dillane	1956-11-30	\N
1789	Bradford Dillman	1930-04-14	2018-01-16
1790	Melinda Dillon	1939-10-13	2023-01-09
1791	Victor DiMattia	1980-12-20	\N
1792	Mark Dindal	1960-05-31	\N
1793	Peter Dinklage	1969-06-11	\N
1794	Mark A.Z. Dippé	1956-11-09	\N
1795	Richard Dixon	\N	\N
1796	Darren Doane	1972-09-20	\N
1797	David Dobkin	1969-06-23	\N
1798	Pete Docter	1968-10-09	\N
1799	Walt Dohrn	1970-12-05	\N
1800	Richard Domeier	\N	\N
1801	Colman Domingo	1969-11-28	\N
1802	Heather Donahue	1974-12-22	\N
1803	Jeffrey Donovan	1968-05-11	\N
1804	Alison Doody	1966-11-11	\N
1805	Richard Dormer	1969-11-11	\N
1806	Karen Dotrice	1955-11-09	\N
1807	Roy Dotrice	1923-05-26	2017-10-16
1808	Portia Doubleday	1988-06-22	\N
1809	Sarah Douglas	1952-12-12	\N
1810	Ann Dowd	1956-01-30	\N
1811	Robin Atkin Downes	1976-09-06	\N
1812	Dr. Dre	1965-02-18	\N
1813	Tom Drake	1918-08-05	1982-08-11
1814	Ashley Eckstein	1981-09-22	\N
1815	Julie Dreyfus	1966-01-24	\N
1816	Bobby Driscoll	1937-03-03	1968-03-30
1817	Derek Drymon	1968-11-19	\N
1818	Karen Duffy	1961-05-23	\N
1819	Troy Duffy	1971-06-08	\N
1820	Dennis Dugan	1946-09-05	\N
1821	Josh Duhamel	1972-11-14	\N
1822	Jean Dujardin	1972-06-19	\N
1823	Clark Duke	1985-05-05	\N
1824	Deanna Dunagan	1940-05-25	\N
1825	Duwayne Dunham	1952-11-17	\N
1826	Kevin Dunn	1956-08-24	\N
1827	Max Martini	1969-12-11	\N
1828	Roland Dupree	1925-09-20	2015-06-21
1829	V.C. Dupree	1955-07-14	\N
1830	Kevin Durand	1974-01-14	\N
1831	Clea DuVall	1977-09-25	\N
1832	Dale Dye	1944-10-08	\N
1833	Marilyn Eastman	1933-12-17	2021-08-22
1834	Joel Edgerton	1974-06-23	\N
1835	Charles Edwards	1969-10-01	\N
1836	Paddi Edwards	1931-12-09	1999-10-18
1837	Susan Egan	1970-02-18	\N
1838	Jesse Eisenberg	1983-10-05	\N
1839	Chiwetel Ejiofor	1977-07-10	\N
1840	Carmen Ejogo	1973-10-22	\N
1841	Idris Elba	1972-09-06	\N
1842	Ron Eldard	1965-02-20	\N
1843	Chris Elliott	1960-05-31	\N
1844	Aunjanue Ellis-Taylor	1969-02-21	\N
1845	David R. Ellis	1952-09-08	2013-01-07
1846	Michael Emerson	1954-09-07	\N
1847	Mireille Enos	1975-09-22	\N
1848	Mike Epps	1970-11-18	\N
1849	Arlen Escarpeta	1981-04-09	\N
1850	Alice Evans	1968-08-02	\N
1851	Chris Evans	1981-06-13	\N
1852	David Mickey Evans	1962-10-20	\N
1853	Maurice Evans	1901-06-03	1989-03-12
1854	Rex Everhart	1920-06-13	2000-03-13
1855	Maynard Eziashi	\N	\N
1860	Stefen Fangmeier	1960-12-09	\N
1861	Dakota Fanning	1994-02-23	\N
1862	Golshifteh Farahani	1983-07-10	\N
1863	Anna Faris	1976-11-29	\N
1864	Vera Farmiga	1973-08-06	\N
1865	Colin Farrell	1976-05-31	\N
1866	Peter Farrelly	1956-12-17	\N
1867	Pierfrancesco Favino	1969-08-24	\N
1868	Jon Favreau	1966-10-19	\N
1869	Frank Faylen	1905-12-08	1985-08-02
1870	Brian Fee	1975-01-29	\N
1871	Friedrich Feher	1889-03-16	1950-09-30
1872	Sam Fell	1965-11-22	\N
1873	Tom Felton	1987-09-22	\N
1874	Verna Felton	1890-07-20	1966-12-14
1875	Colm Feore	1958-08-22	\N
1876	Craig Ferguson	1962-05-17	\N
1877	Rebecca Ferguson	1983-10-19	\N
1878	Jodelle Ferland	1994-10-09	\N
1879	Alex Ferns	1968-10-13	\N
1880	Martin Ferrero	1947-09-29	\N
1881	Pam Ferris	1948-05-11	\N
1882	David S. Goyer	1965-12-22	\N
1883	Tina Fey	1970-05-18	\N
1884	Tom Holland	1943-07-11	\N
1885	Nathan Fillion	1971-03-27	\N
1886	Katie Finneran	1971-01-22	\N
1887	Isla Fisher	1976-02-03	\N
1888	Miles Fisher	1983-06-23	\N
1889	Noel Fisher	1984-03-13	\N
1891	Ryan Fleck	1976-09-20	\N
1892	Charles Fleischer	1950-08-27	\N
1893	Richard Fleischer	1916-12-08	2006-03-25
1894	Ruben Fleischer	1974-10-31	\N
1895	Andrew Fleming	1963-03-14	\N
1896	Victor Fleming	1889-02-23	1949-01-06
1897	Anne Fletcher	1966-05-01	\N
1898	Jerome Flynn	1963-03-16	\N
1899	Dan Fogler	1976-10-20	\N
1900	Marc Forster	1969-11-30	\N
1901	Will Forte	1970-06-17	\N
1902	Gloria Foster	1933-11-15	2001-09-29
1903	Olwen Fouéré	1954-03-02	\N
1904	James Fox	1939-05-19	\N
1905	Claudio Fragasso	1951-10-02	\N
1906	James Frain	1968-03-14	\N
1907	James Franco	1978-04-19	\N
1908	James Frawley	1936-09-29	2019-01-22
1909	William Frawley	1887-02-25	1966-03-03
1910	Stan Freberg	1926-08-07	2015-04-07
1911	J.E. Freeman	1946-02-02	2014-08-09
1912	Jonathan Freeman	1950-02-05	\N
1913	Martin Freeman	1971-09-08	\N
1914	Paul Freeman	1943-01-18	\N
1915	Dawn French	1957-10-11	\N
1916	Juan Carlos Fresnadillo	1967-12-05	\N
1917	Thor Freudenthal	1972-10-20	\N
1918	Tom Fridley	1965-02-15	\N
1919	Judah Friedlander	1969-03-16	\N
1920	Nick Frost	1972-03-28	\N
1921	Nika Futterman	1969-10-25	\N
1922	Dwight Frye	1899-02-22	1943-11-07
1923	Gustav Fröhlich	1902-03-21	1987-12-22
1924	Kamatari Fujiwara	1905-01-15	1985-12-21
1925	Tatsuya Fujiwara	1982-05-15	\N
1926	Kinji Fukasaku	1930-07-03	2003-01-12
1927	Kurt Fuller	1953-09-16	\N
1928	Antoine Fuqua	1965-05-30	\N
1929	John Furey	1951-04-13	\N
1930	Levan Gabriadze	1969-11-16	\N
1931	Mike Gabriel	1954-11-05	\N
1932	Jim Gaffigan	1966-07-07	\N
1933	Johnny Galecki	1975-04-30	\N
1934	Zach Galifianakis	1969-10-01	\N
1935	John Gallagher Jr.	1984-06-17	\N
1936	James Gammon	1940-04-20	2010-07-16
1938	Bobs Gannaway	1965-06-26	\N
1939	Matthew Garber	1956-03-25	1977-06-13
1940	Gael García Bernal	1978-11-30	\N
1941	Vincent Gardenia	1920-01-07	1992-12-09
1942	Ana de la Reguera	1977-04-08	\N
1943	Allen Garfield	1939-11-22	2020-04-07
1944	Alex Garland	1970-05-26	\N
1945	Jeff Garlin	1962-06-05	\N
1946	Stephen Garlick	1959-07-07	\N
1947	Kevin Garnett	1976-05-19	\N
1948	Lorraine Gary	1937-08-16	\N
1949	Louis J. Gasnier	1875-09-13	1963-02-15
1950	Ana Gasteyer	1967-05-04	\N
1951	Cassandra Gava	1959-04-28	\N
1952	Bobby Gaylor	1967-02-18	\N
1953	Ari Graynor	1983-04-27	\N
1954	Grant Gelt	1980-02-01	\N
1955	Melissa George	1976-08-06	\N
1956	Clyde Geronimi	1901-06-12	1989-04-24
1957	Betty Lou Gerson	1914-04-20	1999-01-12
1958	Ricky Gervais	1961-06-25	\N
1959	Alice Ghostley	1923-08-14	2007-09-21
1960	Paul Giamatti	1967-06-06	\N
1961	Donald Gibb	1954-08-04	\N
1962	Mary Gibbs	1996-10-05	\N
1963	Ariadna Gil	1969-01-23	\N
1964	Stuart Gillard	1950-04-28	\N
1965	Aidan Gillen	1968-04-24	\N
1966	Craig Gillespie	1967-09-01	\N
1967	Jim Gillespie	\N	\N
1968	Kim Gillingham	\N	\N
1969	George Givot	1903-02-18	1984-06-07
2254	Mike Judge	1962-10-17	\N
2255	David Kagen	1948-09-27	\N
2256	John Kani	1943-11-30	\N
2257	Terry Kiser	1939-08-01	\N
2258	Elizabeth Kaitan	1960-07-19	\N
2259	Bianca Kajlich	1977-03-26	\N
2260	Tsunehiko Kamijô	1940-03-07	\N
2261	Kenji Kamiyama	1966-03-20	\N
2262	Paul Kandel	1951-02-15	\N
2263	Tom Kane	1962-04-15	\N
2264	Sung Kang	1972-04-08	\N
2265	Wendy Foxworth	1966-02-19	\N
2266	Anil Kapoor	1956-12-24	\N
2267	Miriam Karlin	1925-06-23	2011-06-03
2268	Alex Karras	1935-07-15	2012-10-10
2269	Jake Kasdan	1974-10-28	\N
2270	John Kassir	1957-10-24	\N
2271	Florence Kasumba	1976-10-26	\N
2272	Omri Katz	1976-05-30	\N
2273	Daisuke Katô	1911-02-18	1975-07-31
2274	Momoko Kôchi	1932-03-07	1998-11-05
2275	Charles Kay	1930-08-31	2025-01-10
2276	Stubby Kaye	1918-11-11	1997-12-14
2277	Tony Kaye	1946-01-11	\N
2278	Clay Kaytis	1973-03-22	\N
2279	Lainie Kazan	1940-05-15	\N
2280	Kari Keegan	1969-04-09	\N
2281	Monica Keena	1979-05-28	\N
2282	Tom Kenny	1962-07-13	\N
2283	Matt Keeslar	1972-10-15	\N
2284	David Kelly	1929-07-11	2012-02-12
2285	Jim Kelly	1946-05-05	2013-06-29
2286	Michael Kelly	1969-05-22	\N
2287	Moira Kelly	1968-03-06	\N
2288	Richard Kelly	1975-03-28	\N
2289	Anna Kendrick	1985-08-09	\N
2290	Arthur Kennedy	1914-02-17	1990-01-05
2291	Tig Notaro	1971-03-24	\N
2293	Irvin Kershner	1923-04-29	2010-11-27
2294	Irrfan Khan	1967-01-07	2020-04-29
2295	Margot Kidder	1948-10-17	2018-05-13
2296	Beeban Kidron	1961-05-02	\N
2297	Fritz Kiersch	1951-07-23	\N
2298	Rinko Kikuchi	1981-01-06	\N
2299	Kang Ha-neul	1990-02-21	\N
2300	Randall Duk Kim	1943-09-24	\N
2301	Charles Kimbrough	1936-05-23	2023-01-11
2302	Jimmy Kimmel	1967-11-13	\N
2321	Sebastian Koch	1962-05-31	\N
2322	Kokuten Kôdô	1887-01-29	1960-01-22
2323	David Koechner	1962-08-24	\N
2324	Sergey Kolesnikov	1955-01-04	2023-04-29
2325	Andrey Konchalovskiy	1937-08-20	\N
2326	Harvey Korman	1927-02-15	2008-05-29
2327	John Korty	1936-06-22	2022-03-09
2328	Yoshio Kosugi	1903-09-15	1968-03-12
2329	Ted Kotcheff	1931-04-07	\N
2330	Daniel Kountz	1978-10-16	\N
2334	Werner Krauss	1884-06-23	1959-10-20
2335	Thomas Kretschmann	1962-09-08	\N
2336	David Krumholtz	1978-05-15	\N
2337	Judy Kuhn	1958-05-20	\N
2338	Chiaki Kuriyama	1984-10-10	\N
2339	Alex Kurtzman	1973-09-07	\N
2340	Karyn Kusama	1968-03-21	\N
2253	Paterson Joseph	1964-06-22	\N
3993	Rihanna	1988-02-20	\N
4004	Hayley Atwell	1982-04-05	\N
4261	H.E.R.	1997-06-27	\N
5077	Grace Lu	\N	\N
5380	Wil Traval	1980-07-09	\N
5381	Eka Darville	1989-04-11	\N
5382	J.R. Ramirez	1980-10-08	\N
5383	Terry Chen	1975-02-03	\N
5384	Leah Gibson	1985-01-03	\N
5385	Janet McTeer	1961-08-05	\N
5386	Jeremy Bobb	1981-05-13	\N
5387	Tiffany Mack	\N	\N
5388	Phil Klemmer	\N	\N
5389	Arthur Darvill	1982-06-17	\N
5390	Caity Lotz	1986-12-30	\N
5391	Franz Drameh	1993-01-05	\N
5392	Ciara Renée	1990-10-19	\N
5393	Falk Hentschel	1982-03-31	\N
5394	Amy Pemberton	1988-08-23	\N
5395	Matt Letscher	1970-06-26	\N
5396	Maisie Richardson-Sellers	1992-03-02	\N
5397	Nick Zano	1978-03-08	\N
5398	Tala Ashe	1984-07-24	\N
5399	Jes Macallan	1982-08-09	\N
5400	Courtney Ford	1978-06-27	\N
5401	Ramona Young	1998-05-23	\N
5402	Olivia Swann	1992-09-19	\N
5403	Cheo Hodari Coker	1972-12-12	\N
5404	Simone Missick	1982-01-19	\N
5405	Erik LaRay Harvey	\N	\N
5406	Gabrielle Dennis	1978-10-19	\N
5407	Mustafa Shakir	1976-08-21	\N
5408	Finn Jones	1988-03-24	\N
5409	Scott Buck	\N	\N
5410	Tom Pelphrey	1982-07-28	\N
5411	Jessica Stroup	1986-10-23	\N
5412	Ramón Rodríguez	1979-12-20	\N
5413	Sacha Dhawan	1984-05-01	\N
5414	Douglas Petrie	\N	\N
5415	Marco Ramirez	\N	\N
5416	Serinda Swan	1984-07-11	\N
5417	Eme Ikwuakor	1984-08-13	\N
5418	Isabelle Cornish	1994-07-22	\N
5419	Ellen Woglom	1987-04-18	\N
5420	Steve Lightfoot	\N	\N
5421	Ebon Moss-Bachrach	1977-03-19	\N
5422	Amber Rose Revah	1986-06-24	\N
5423	Daniel Webber	1988-06-28	\N
7602	Burt Reynolds	1936-02-11	2018-09-06
7603	Dillon Freasier	1996-03-06	\N
7604	Sydney Chandler	1996-02-13	\N
7605	Alex Lawther	1995-05-04	\N
7606	Essie Davis	1970-01-19	\N
7607	Samuel Blenkin	1996-04-01	\N
7608	Babou Ceesay	1978-11-17	\N
7609	Adarsh Gourav	1994-07-08	\N
7610	Erana James	1999-02-17	\N
7611	Lily Newmark	1994-05-24	\N
7612	Jonathan Ajayi	1996-08-21	\N
7613	David Rysdahl	1987-04-02	\N
7614	Diêm Camille	1992-03-24	\N
7615	Moe Bar-El	1992-05-18	\N
7616	Adrian Edmondson	1957-01-24	\N
7617	Noah Hawley	1967-05-10	\N
7618	Dana Gonzales	1963-11-18	\N
7619	Bob DeLaurentis	\N	\N
7620	Ugla Hauksdóttir	\N	\N
7621	Lisa Long	\N	\N
7622	Migizi Pensoneau	\N	\N
7623	Todd Williams	1977-09-11	\N
7624	Kenna Ramsey	\N	\N
7625	Feodor Chin	1974-08-18	\N
7626	Rama Vallury	\N	\N
7627	Greg Furman	1989-03-26	\N
7628	Adam Hugill	1997-07-22	\N
7629	Daniel Swain	\N	\N
7630	Sheila Atim	1991-01-01	\N
7631	Brian Jordan Alvarez	1987-07-09	\N
7632	Jen Van Epps	1990-03-12	\N
7633	Aristotle Athari	\N	\N
7634	Joshua Jackson	1978-06-11	\N
7635	Sadie Stanley	2001-11-15	\N
7636	Jonathan Entwistle	1984-03-27	\N
7637	Blair Butler	1977-06-28	\N
7638	Michael Cimino	1999-11-10	\N
7639	Belmont Cameli	1998-02-28	\N
7640	Alfie Williams	2011-01-03	\N
7641	David Stassen	1977-06-14	\N
7642	Aaron Paul	1979-08-27	\N
7643	Pamela Anderson	1967-07-01	\N
7644	Charles Laughton	1899-07-01	1962-12-15
7645	James Agee	1909-11-27	1955-05-16
7646	Lillian Gish	1893-10-14	1993-02-27
7647	James Gleason	1882-05-23	1959-04-12
7648	Evelyn Varden	1893-06-12	1958-07-11
7649	Peter Graves	1926-03-18	2010-03-14
7650	Don Beddoe	1903-07-01	1991-01-19
7651	Gloria Castillo	1933-03-03	1978-10-24
7652	Billy Chapin	1943-12-28	2016-12-02
7653	Sally Jane Bruce	1948-12-02	\N
7654	Tom Six	1973-08-29	\N
7655	Dieter Laser	1942-02-17	2020-02-29
7656	Winter Williams	1984-01-24	\N
7657	Ashlynn Yennie	1985-05-15	\N
7658	Akihiro Kitamura	1979-03-26	\N
7659	Ruggero Deodato	1939-05-07	2022-12-29
7660	Gianfranco Clerici	1941-07-29	\N
7661	Robert Kerman	1947-12-16	2018-12-27
7662	Carl Gabriel Yorke	1952-11-23	\N
7663	Francesca Ciardi	1954-07-26	\N
7664	Luca Barbareschi	1956-07-28	\N
7665	Perry Pirkanen	\N	\N
7666	Greg Mottola	1964-07-11	\N
7667	Peter Sollett	1976-02-09	\N
7668	Alethea Jones	\N	\N
7669	Nico Parker	2004-12-09	\N
7670	Gabriel Howell	1999-02-19	\N
7671	Bronwyn James	1994-07-24	\N
316	Diane Keaton	1946-01-05	2025-10-11
7672	Dario Argento	1940-09-07	\N
7673	Daria Nicolodi	1950-06-19	2020-11-26
7674	Jessica Harper	1949-10-03	\N
7675	Stefania Casini	1948-09-04	\N
7676	Flavio Bucci	1947-05-25	2020-02-18
7677	Miguel Bosé	1956-04-03	\N
7678	Barbara Magnolfi	1955-04-16	\N
7679	Susanna Javicoli	1954-08-07	2005-06-17
7680	Eva Axén	1954-12-12	\N
7681	Alida Valli	1921-05-31	2006-04-22
7682	Joan Bennett	1910-02-27	1990-12-07
7683	David Kajganich	1969-11-15	\N
7684	Angela Winkler	1944-01-22	\N
7685	Ingrid Caven	1938-08-03	\N
7686	Elena Fokina	1977-05-02	\N
7687	Sylvie Testud	1971-01-17	\N
7688	Renée Soutendijk	1957-05-21	\N
7689	Christine Leboutte	\N	\N
7690	Fabrizia Sacchi	1971-02-10	\N
7691	Małgosia Bela	1977-06-06	\N
7692	Robert Hiltzik	1957-02-21	\N
7693	Mike Kellin	1922-04-26	1983-08-26
7694	Katherine Kamhi	1964-02-15	\N
7695	Paul DeAngelo	\N	\N
7696	Jonathan Tiersten	1965-08-11	\N
7697	Felissa Rose	1969-05-23	\N
7698	Christopher Collet	1968-03-13	\N
7699	Karen Fields	\N	\N
7700	William Ragsdale	1961-01-19	\N
7701	Amanda Bearse	1958-08-09	\N
7702	Stephen Geoffreys	1964-11-22	\N
7703	Sam Lansky	1988-09-23	\N
7704	Chase Sui Wonders	1996-05-21	\N
7705	Tyriq Withers	1998-07-15	\N
7706	Sarah Pidgeon	1996-07-07	\N
7707	Billy Campbell	1959-07-07	\N
7708	Gabbriette	1997-07-28	\N
7709	Austin Nichols	1980-04-24	\N
7710	S.S. Wilson	\N	\N
7711	Brent Maddock	\N	\N
7712	Finn Carter	1960-03-09	\N
7713	Michael Gross	1947-06-21	\N
7714	Reba McEntire	1955-03-28	\N
7715	John Fawcett	1968-03-05	\N
7716	Karen Walton	\N	\N
7717	Emily Perkins	1977-05-04	\N
7718	Katharine Isabelle	1981-11-02	\N
7719	Kris Lemche	1978-02-23	\N
7720	Danielle Hampton	1978-08-29	\N
7721	John Bourgeois	\N	\N
7722	Peter Keleghan	1959-09-16	\N
7723	Andrzej Bartkowiak	1950-03-06	\N
7724	Razaaq Adoti	1973-06-27	\N
7725	Ben Daniels	1964-06-10	\N
7726	Richard Brake	1964-11-30	\N
7727	Freddy Rodriguez	1975-01-17	\N
7728	Jeff Fahey	1952-11-29	\N
7729	Vanessa Ferlito	1977-12-28	\N
7730	Jordan Ladd	1975-01-14	\N
7731	Sydney Tamiia Poitier	1973-11-15	\N
7732	Tracie Thoms	1975-08-19	\N
7733	Zoë Bell	1978-11-17	\N
7734	Alrick Riley	1962-01-21	\N
7735	Thomas Schnauz	1966-12-02	\N
7736	Justine Ferrara	\N	\N
7737	Michele Fazekas	\N	\N
7738	Hamish Linklater	1976-07-07	\N
7739	Randy Pearlstein	1971-04-21	\N
7740	Rider Strong	1979-12-11	\N
7741	James DeBello	1980-06-09	\N
7742	Cerina Vincent	1979-02-07	\N
7743	Joey Kern	1976-09-05	\N
7744	Arie Verveen	1976-09-28	\N
7745	Giuseppe Andrews	1979-04-25	\N
7746	Sid Haig	1939-07-14	2019-09-21
7747	Bill Moseley	1951-11-11	\N
7748	Karen Black	1939-07-01	2013-08-08
7749	Ken Foree	1948-02-29	\N
7750	Matthew McGrory	1973-05-17	2005-08-09
7751	Cary Christopher	2016-05-06	\N
7752	Toby Huss	1966-12-09	\N
7753	Amy Madigan	1950-09-11	\N
7754	David Cronenberg	1943-03-15	\N
7755	Charles Edward Pogue	1950-01-18	\N
7756	John Getz	1946-10-15	\N
7757	Chris Walas	1955-09-17	\N
7758	Lee Richardson	1926-09-11	1999-10-02
7759	Harley Cross	1978-03-10	\N
7760	Alejandro Amenábar	1972-03-31	\N
7761	Elaine Cassidy	1979-12-31	\N
7762	Eric Sykes	1923-05-04	2012-07-04
7763	Alakina Mann	1990-08-01	\N
7764	James Bentley	1992-07-14	\N
7765	Marty Feldman	1934-07-08	1982-12-02
7766	Steph Lady	\N	\N
7767	Aidan Quinn	1959-03-08	\N
7768	Martin Landau	1928-06-20	2017-07-15
7769	Charlie Tahan	1998-06-11	\N
7770	Atticus Shaffer	1998-06-19	\N
7771	Jacob Elordi	1997-06-26	\N
7772	Felix Kammerer	1995-09-19	\N
7773	Richard Dawson	1932-11-20	2012-06-02
7774	Paul Michael Glaser	1943-03-25	\N
7775	Jay Chou	1979-01-18	\N
7776	Nisha Ganatra	1974-06-25	\N
7777	Jordan Weiss	1993-01-28	\N
7778	Sophia Hammons	2006-11-16	\N
7779	Daniel Ezra	1991-12-15	\N
7780	Michael Ward	1997-11-18	\N
7781	Timo Tjahjanto	1980-09-04	\N
7782	Aaron Rabin	\N	\N
7783	Diana Ross	1944-03-26	\N
7784	Michael Jackson	1958-08-29	2009-06-25
7785	Nipsey Russell	1918-09-15	2005-10-02
7786	Ted Ross	1934-06-30	2002-09-03
7787	Mabel King	1932-12-25	1999-11-09
7788	Theresa Merritt	1922-09-24	1998-06-12
7789	Thelma Carpenter	1922-01-15	1997-05-14
7790	Lena Horne	1917-06-30	2010-05-09
7791	Samuel D. Hunter	1981-09-11	\N
7792	Hong Chau	1979-06-25	\N
7793	Jalmari Helander	1976-07-21	\N
7794	Jorma Tommila	1959-01-01	\N
7795	Jack Doolan	1987-07-28	\N
7796	Mimosa Willamo	1994-11-09	\N
7797	Onni Tommila	1999-07-18	\N
7798	Maria Bakalova	1996-06-04	\N
2844	James Ransone	1979-06-02	2025-12-19
3140	Cary-Hiroyuki Tagawa	1950-09-27	2025-12-04
2013	Peter Greene	1965-10-08	2025-12-12
868	Rob Reiner	1947-03-06	2025-12-14
7799	Mia Tomlinson	1995-05-31	\N
7800	Jimmy Hayward	1970-09-17	\N
7801	Luis Llosa	1951-01-01	\N
7802	Hans Bauer	\N	\N
7803	David E. Kelley	1956-04-04	\N
7804	Alan Alda	1936-01-28	\N
7805	Merritt Wever	1980-08-11	\N
7806	John Madden	1949-04-08	\N
7807	Marc Norman	1941-02-10	\N
7808	Tom Stoppard	1937-07-03	2025-11-29
7809	Joseph Fiennes	1970-05-27	\N
7810	Martin Clunes	1961-11-28	\N
7811	Antony Sher	1949-06-14	2021-12-02
7812	Mark Williams	1959-08-22	\N
7813	Noah Segan	1983-10-05	\N
7814	Xu Qing	1969-01-22	\N
7815	Jerry Ciccoritti	1956-08-05	\N
7816	Russell Hainline	\N	\N
7817	Lacey Chabert	1982-09-30	\N
7818	Dustin Milligan	1985-07-28	\N
7819	Katy Mixon Greer	1981-03-30	\N
7820	Chrishell Stause	1981-07-21	\N
7821	Joe Lo Truglio	1970-12-02	\N
7822	David E. Talbert	1966-02-10	\N
7823	Madalen Mills	2009-01-01	\N
7824	Ricky Martin	1971-12-24	\N
7825	Steven LaMorte	\N	\N
7826	Flip Kobler	\N	\N
7827	Finn Kobler	\N	\N
7828	Krystle Martin	\N	\N
7829	Chase Mullins	\N	\N
7830	John Bigham	\N	\N
7831	Erik Baker	\N	\N
7832	Amy Schumacher	\N	\N
7833	Thomas Bezucha	1964-03-08	\N
7834	Andrew Scott	1976-10-21	\N
7835	Daryl McCormack	1993-01-22	\N
7836	Andrew Bernstein	\N	\N
7837	Guadalís Del Carmen	\N	\N
7838	Gabe Hobson	\N	\N
7839	Emmanuel Osei-Kuffour Jr.	\N	\N
7840	Brad Kane	1973-09-29	\N
7841	Jamie Travis	1979-08-13	\N
7842	Cord Jefferson	\N	\N
7843	Jovan Adepo	1988-09-06	\N
7844	Matilda Lawler	2008-09-08	\N
7845	Amanda Christine	2008-12-31	\N
7846	Clara Stack	2010-10-19	\N
7847	Blake Cameron James	\N	\N
7848	Arian S. Cartaya	\N	\N
7849	Miles Ekhardt	\N	\N
7850	Mikkal Karim-Fidler	\N	\N
7851	Jack Molloy Legault	\N	\N
7852	Matilda Legault	\N	\N
7853	Chris Chalk	1978-12-07	\N
7854	Madeleine Stowe	1958-08-18	\N
7855	Keisha Castle-Hughes	1990-03-24	\N
7856	Alexander Siddig	1965-11-21	\N
7857	Debra Frank	\N	\N
7858	Steve L. Hayes	\N	\N
7859	French Stewart	1964-02-20	\N
7860	Erick Avari	1952-04-13	\N
7862	Jason Beghe	1960-03-12	\N
7863	Clare Carey	1967-06-11	\N
7864	Joanna Going	1963-07-22	\N
7865	Mike Weinberg	1993-02-16	\N
7861	Barbara Babcock	1937-02-27	\N
7866	Aaron Ginsburg	\N	\N
7867	Wade McIntyre	\N	\N
7868	Christian Martyn	2000-02-23	\N
7869	Eddie Steeples	1973-11-25	\N
7870	Doug Murray	\N	\N
7871	Ellie Harvie	1965-04-07	\N
7872	Debi Mazar	1964-08-13	\N
7873	Mikey Day	1980-03-20	\N
7874	Streeter Seidell	1982-12-02	\N
7875	Archie Yates	2009-02-22	\N
7876	Aisling Bea	1984-03-16	\N
7877	Pete Holmes	1979-03-30	\N
7878	Roger O. Hirson	1926-05-05	2019-05-27
7879	Clive Donner	1926-01-21	2010-09-06
7880	Angela Pleasence	1941-09-17	\N
7881	Edward Woodward	1930-06-01	2009-11-16
7882	Roger Rees	1944-05-05	2015-07-10
7883	Kathryn Hunter	1957-04-09	\N
7884	Grace VanderWaal	2004-01-15	\N
7885	Chloe Fineman	1988-07-20	\N
7886	Holt McCallany	1963-09-03	\N
7887	Tramell Tillman	1985-06-17	\N
7888	Chase Infiniti	2000-05-05	\N
625	Benicio del Toro	1967-02-19	\N
7889	Susan McMartin	1968-02-24	\N
7890	Sam Morelos	2005-07-07	\N
7891	Willa Fitzgerald	1991-01-17	\N
509	Javier Bardem	1969-03-01	\N
2292	Frederick Kerr	1858-10-11	1933-05-03
7892	Charlie Chaplin	1889-04-16	1977-12-25
7893	Virginia Cherrill	1908-04-12	1996-11-14
7894	Florence Lee	1864-02-01	1933-02-17
7895	Harry C. Myers	1882-09-05	1938-12-25
7896	Al Ernest Garcia	1887-03-11	1938-09-04
7897	Paulette Goddard	1910-06-03	1990-04-23
7898	Henry Bergman	1868-02-23	1946-10-22
7899	Tiny Sandford	1894-02-26	1961-10-29
7900	Chester Conklin	1886-01-11	1971-10-11
\.


--
-- Data for Name: seasons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seasons (season, show_id, episodes, start_date, end_date, date_added, runtime, grade) FROM stdin;
1	1094	10	2023-01-12	2023-02-09	\N	252	D
2	1497	16	2018-10-09	2019-03-18	\N	675	C+
3	1497	16	2019-10-07	2020-03-09	\N	667	C+
5	1488	19	2019-10-06	2020-05-17	\N	798	C+
6	1486	19	2019-10-08	2020-05-12	\N	797	C+
1	1182	5	2024-01-09	2024-01-09	\N	208	C+
1	1202	6	2024-04-26	2024-04-26	\N	168	C+
3	104	8	2024-12-22	2024-12-29	\N	235	C+
3	1496	10	2019-12-13	2019-12-13	\N	475	B-
1	1492	13	2017-03-17	2017-03-17	\N	718	B-
2	423	6	2023-10-05	2023-11-09	\N	299	B+
2	865	8	2025-08-06	2025-09-03	\N	463	B+
1	1149	8	2023-09-29	2023-11-03	\N	375	B+
1	1502	3	2023-09-22	2023-10-06	\N	268	B+
1	972	6	2021-11-24	2021-12-22	\N	282	B+
1	844	8	2021-03-25	2021-04-29	\N	362	B+
1	865	8	2022-11-23	2022-11-23	\N	390	B+
1	736	11	2022-08-05	2022-08-19	\N	544	B+
1	807	12	2022-09-21	2022-11-23	\N	555	B+
1	740	9	2021-09-17	2021-09-17	\N	485	A-
1	1250	8	2024-04-10	2024-04-10	\N	473	A-
3	529	8	2022-06-03	2022-07-08	\N	492	A-
3	844	8	2025-02-06	2025-03-13	\N	397	A-
3	1002	8	2019-07-04	2019-07-04	\N	444	A-
4	1002	9	2022-05-27	2022-07-01	\N	769	A-
1	1512	8	2022-06-23	2022-06-23	\N	244	A-
2	1512	10	2023-06-22	2023-06-22	\N	358	A-
4	1512	10	2025-06-25	2025-06-25	\N	377	A-
1	1484	23	2012-10-10	2013-05-15	\N	1012	A-
2	1484	23	2013-10-09	2014-05-14	\N	1002	A-
3	517	22	2010-09-17	2011-04-01	\N	503	A-
7	517	12	2020-02-21	2020-05-04	\N	283	A-
3	1487	13	2018-10-19	2018-10-19	\N	669	A-
2	550	8	2020-10-30	2020-12-18	\N	323	A-
1	1462	9	2025-03-04	2025-04-15	\N	435	A-
1	583	9	2021-01-15	2021-03-05	\N	321	A-
2	466	8	2025-08-21	2025-10-09	\N	332	A-
1	364	10	2011-04-17	2011-06-19	\N	567	A
2	364	10	2012-04-01	2012-06-03	\N	549	A
3	364	10	2013-03-31	2013-06-09	\N	558	A
4	364	10	2014-04-06	2014-06-15	\N	545	A
5	364	10	2015-04-12	2015-06-14	\N	563	A
6	364	10	2016-04-24	2016-06-26	\N	562	A
1	423	6	2021-06-09	2021-07-14	\N	287	A
1	905	9	2023-01-15	2023-03-12	\N	526	A
1	529	8	2019-07-26	2019-07-26	\N	471	A
2	529	8	2020-09-04	2020-10-09	\N	494	A
1	1350	8	2024-09-19	2024-11-10	\N	462	A
1	1002	8	2016-07-15	2016-07-15	\N	395	A
2	1002	9	2017-10-27	2017-10-27	\N	464	A
1	789	10	2022-08-21	2022-10-23	\N	615	A
4	517	22	2011-09-16	2012-03-16	\N	502	A
5	517	20	2012-09-29	2013-03-02	\N	459	A
1	1487	13	2015-04-10	2015-04-10	\N	707	A
2	1487	13	2016-03-18	2016-03-18	\N	704	A
1	466	8	2022-01-13	2022-02-17	\N	343	A
1	550	8	2019-11-12	2019-12-27	\N	315	A
1	309	9	2021-11-06	2021-11-20	\N	369	A
2	309	9	2024-11-09	2024-11-23	\N	370	A
7	1484	22	2018-10-15	2019-05-13	\N	919	B-
1	1497	13	2018-01-16	2018-04-17	\N	545	B-
1	1499	13	2020-05-18	2020-08-10	\N	566	B-
2	1491	13	2018-06-22	2018-06-22	\N	761	B-
4	1488	22	2018-10-14	2019-05-19	\N	922	B-
5	1486	22	2018-10-09	2019-05-14	\N	922	B-
1	197	6	2022-05-27	2022-06-22	\N	261	B-
1	1075	6	2023-06-21	2023-07-26	\N	261	B-
2	104	9	2023-12-22	2023-12-30	\N	281	B-
1	1192	9	2022-03-24	2022-05-19	\N	458	B-
2	1496	13	2018-12-21	2018-12-21	\N	610	B-
2	1492	10	2018-09-07	2018-09-07	\N	526	B
6	1484	23	2017-10-12	2018-05-17	\N	959	B
2	736	12	2025-07-03	2025-07-31	\N	642	B
6	1485	13	2019-05-10	2019-08-02	\N	547	B
1	1491	13	2016-09-30	2016-09-30	\N	706	B
1	609	16	2021-05-04	2021-08-13	\N	457	B
2	609	16	2023-01-04	2023-03-29	\N	423	B
3	609	15	2024-02-21	2024-05-01	\N	394	B
4	1490	16	2018-10-22	2019-05-20	\N	670	B
5	1490	15	2020-01-21	2020-06-02	\N	624	B
3	1488	23	2017-10-09	2018-06-18	\N	965	B
4	1486	23	2017-10-10	2018-05-22	\N	959	B
1	1544	4	2025-08-01	2025-08-01	\N	119	B
8	364	6	2019-04-14	2019-05-19	\N	430	B
1	1365	6	2024-11-17	2024-12-22	\N	391	B
1	130	7	2021-12-29	2022-02-09	\N	330	B
1	783	8	2022-09-01	2022-10-14	\N	557	B
2	783	8	2024-08-29	2024-10-03	\N	538	B
1	104	9	2021-08-11	2021-10-06	\N	289	B
1	1198	8	2023-12-19	2024-01-30	\N	313	B
2	789	8	2024-06-16	2024-08-04	\N	511	B
1	1493	8	2017-08-18	2017-08-18	\N	398	B
1	1185	10	2023-11-17	2024-01-12	\N	455	B
1	1496	10	2017-11-21	2018-01-09	\N	495	B
1	1578	4	2025-09-24	2025-09-24	\N	124	B
1	1577	8	2025-08-12	2025-09-23	\N	443	B
2	1488	22	2016-10-10	2017-05-22	\N	921	B
3	1486	23	2016-10-04	2017-05-23	\N	965	B
3	550	8	2023-03-01	2023-04-19	\N	340	B
2	1149	8	2025-09-17	2025-10-22	\N	380	B
7	364	7	2017-07-16	2017-08-27	\N	440	B+
1	453	6	2022-03-30	2022-05-04	\N	287	B+
2	740	7	2024-12-26	2024-12-26	\N	427	B+
3	740	6	2025-06-27	2025-06-27	\N	366	B+
1	601	6	2022-06-08	2022-07-13	\N	271	B+
1	536	6	2021-03-19	2021-04-23	\N	302	B+
1	1373	7	2024-12-05	2025-01-09	\N	165	B+
2	905	7	2025-04-13	2025-05-25	\N	381	B+
1	1377	8	2024-12-02	2025-01-14	\N	295	B+
4	529	8	2024-06-13	2024-07-18	\N	506	B+
2	844	8	2023-11-03	2024-04-04	\N	403	B+
1	1131	8	2023-08-22	2023-10-03	\N	362	B+
3	1512	10	2024-06-26	2024-06-26	\N	354	B+
1	1343	9	2024-09-18	2024-10-30	\N	353	B+
1	248	10	2018-05-02	2018-05-02	\N	290	B+
1	1432	10	2025-01-29	2025-02-19	\N	308	B+
3	1484	23	2014-10-08	2015-05-13	\N	968	B+
4	1484	23	2015-10-07	2016-05-25	\N	968	B+
5	1484	23	2016-10-05	2017-05-24	\N	964	B+
8	1484	10	2019-10-15	2020-01-28	\N	421	B+
2	807	12	2025-04-22	2025-05-13	\N	595	B+
1	517	22	2008-10-03	2009-03-20	\N	481	B+
2	517	22	2009-10-02	2010-04-30	\N	479	B+
6	517	13	2014-03-07	2014-03-07	\N	294	B+
2	1495	13	2019-01-18	2019-01-18	\N	694	B+
2	1489	13	2018-03-08	2018-03-08	\N	675	B+
3	1489	13	2019-06-14	2019-06-14	\N	656	B+
1	1485	22	2013-09-24	2014-05-13	\N	950	B+
2	1485	22	2014-09-23	2015-05-12	\N	942	B+
3	1485	22	2015-09-29	2016-05-17	\N	939	B+
4	1485	22	2016-09-20	2017-05-16	\N	934	B+
1	1494	8	2017-09-29	2017-11-10	\N	338	C
1	781	9	2022-08-18	2022-10-13	\N	289	C
1	1295	8	2024-06-04	2024-07-16	\N	304	C
1	1498	20	2019-10-06	2020-05-17	\N	834	C
5	1485	22	2017-12-01	2018-05-18	\N	926	B+
7	1485	13	2020-05-27	2020-08-12	\N	553	B+
1	167	15	2014-10-03	2015-03-02	\N	327	B+
2	167	22	2015-06-20	2016-03-30	\N	483	B+
3	167	22	2016-09-24	2017-03-25	\N	482	B+
4	167	15	2017-10-16	2018-03-05	\N	354	B+
1	1490	16	2016-01-21	2016-05-19	\N	674	B+
2	1490	17	2016-10-13	2017-04-04	\N	708	B+
3	1490	18	2017-10-10	2018-04-09	\N	755	B+
1	1488	20	2015-10-26	2016-04-18	\N	862	B+
1	1486	23	2014-10-07	2015-05-19	\N	972	B+
2	1486	23	2015-10-06	2016-05-24	\N	966	B+
1	1495	13	2017-11-17	2017-11-17	\N	688	A-
1	1489	13	2015-11-20	2015-11-20	\N	673	A-
1	1637	8	2025-10-26	2025-12-14	2025-12-14 16:23:26.252-05	482	B+
1	46	2	1990-11-18	1990-11-20	\N	187	C+
5	1002	8	2025-11-26	2025-12-31	2025-12-31 23:09:49.555-05	620	A-
1	1518	6	2025-06-24	2025-07-01	\N	289	C
\.


--
-- Data for Name: seasons_cast; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seasons_cast (ordering, season, show_id, actor_id) FROM stdin;
6	3	517	2263
7	1	536	2271
12	3	517	2348
12	4	517	2348
10	6	517	2348
12	1	517	2348
11	2	517	2348
2	3	740	2372
2	2	740	2372
1	1	740	2373
1	3	740	2373
2	1	1295	2373
1	2	740	2373
3	1	1494	2395
7	1	1182	2410
8	1	781	2417
6	1	309	2426
6	2	309	2426
9	1	364	2426
1	1	807	2450
1	2	807	2450
11	1	1343	2451
13	1	364	2470
12	2	364	2470
2	2	865	50
6	3	364	2470
2	3	167	2510
2	1	167	2510
2	4	167	2510
2	2	167	2510
1	2	1002	140
5	3	517	1072
9	3	517	477
13	3	517	234
15	3	517	209
7	1	529	1342
6	1	536	339
12	1	536	218
12	1	529	147
2	1	1462	231
8	1	309	3519
4	1	1365	2523
18	8	364	2530
17	1	364	2530
18	2	364	2530
14	2	1002	186
15	2	1002	870
28	3	364	2530
24	4	364	2530
13	6	364	2530
22	7	364	2530
6	1	1182	2533
11	1	972	2533
16	2	865	987
26	5	364	2541
26	6	364	2541
17	2	1496	2558
4	1	865	2565
12	1	789	2566
7	1	583	2571
10	2	807	2574
2	1	1075	2574
8	1	1131	2585
7	2	309	3519
1	1	466	3522
9	1	1487	231
1	1	423	3532
1	2	423	3532
2	2	1002	3533
2	3	1002	3533
2	4	1002	3533
5	1	1373	3533
2	1	1002	3533
2	1	1094	3539
3	1	529	3541
3	2	529	3541
3	3	529	3541
3	4	529	3541
1	1	536	3547
2	1	1182	3553
15	1	601	3558
4	3	517	1389
3	1	248	3564
1	1	781	3565
7	1	789	1448
11	1	536	1517
3	1	309	3601
3	2	309	3601
1	1	453	3605
1	2	1487	3611
1	3	1487	3611
1	1	1462	3611
1	1	1487	3611
4	1	1182	3611
1	1	1493	3611
14	3	517	1989
6	1	1487	2044
15	2	865	2046
5	1	789	2194
13	2	1002	1523
10	3	517	1533
8	3	517	1576
1	1	789	1661
3	1	1462	1732
8	1	1487	1753
3	3	517	1814
11	3	517	1921
1	3	1002	140
5	4	517	1072
7	1	1343	1324
9	4	517	477
13	4	517	234
16	4	517	209
7	2	529	1342
21	3	364	3766
20	7	364	3766
22	2	789	3780
4	4	517	1389
14	4	517	1447
6	2	789	1448
9	8	1484	3814
2	1	1484	3814
2	4	1484	3814
8	6	1484	3814
10	7	1484	3814
2	3	1484	3814
2	2	1484	3814
7	1	1462	3820
6	3	1487	3820
19	1	783	3822
15	2	783	3822
14	1	601	3825
4	3	167	3827
4	1	167	3827
4	4	167	3827
4	2	167	3827
3	1	1489	3830
10	1	1493	3830
2	2	1489	3830
2	3	1489	3830
6	1	248	3831
8	2	1485	3832
8	3	1485	3832
2	2	1495	3838
3	1	1495	3838
2	1	423	3843
2	2	423	3843
13	1	783	3847
5	2	783	3847
13	3	1002	3856
12	4	1002	3856
3	1	865	3858
4	1	309	3859
4	2	309	3859
2	1	536	3862
5	1	466	3879
12	1	781	3886
5	1	807	3904
4	2	807	3904
2	1	789	3905
1	2	789	3905
20	2	364	3908
14	3	364	3908
8	4	364	3908
8	5	364	3908
6	6	364	3908
11	1	529	3911
11	2	529	3911
11	3	529	3911
10	4	529	3911
4	1	1462	3913
11	1	1295	3913
1	3	517	3919
1	4	517	3919
1	5	517	3919
1	7	517	3919
1	6	517	3919
1	1	517	3919
1	2	517	3919
11	5	1490	3926
11	4	1490	3926
3	1	423	3933
3	2	423	3933
16	1	601	3935
9	1	1343	3951
3	1	1295	3952
1	3	1484	3953
1	2	1484	3953
1	4	1484	3953
1	5	1484	3953
5	5	517	1072
9	5	517	477
1	4	1002	140
5	7	517	1072
13	5	517	209
7	3	529	1342
14	3	529	1317
6	2	783	719
15	4	1002	362
16	4	1002	870
8	2	1487	231
8	5	1486	1170
13	1	1131	234
4	5	517	1389
4	7	517	1389
7	1	1491	1288
4	3	1487	463
4	6	517	1072
8	6	517	477
13	6	517	228
3	1	807	915
6	4	529	1342
8	3	1487	231
3	6	517	1389
15	1	1518	1404
11	6	517	1447
9	2	1491	1288
2	1	130	966
2	2	807	915
11	2	807	551
13	2	807	969
5	1	517	1072
9	1	517	477
13	1	517	234
4	1	517	1389
3	1	130	1395
9	1	1185	414
3	3	167	1230
7	1	1497	871
1	1	248	782
5	2	517	1072
9	2	517	477
12	2	517	234
3	1	167	1230
15	1	781	3611
7	1	1432	3611
6	1	453	3619
3	1	740	3626
23	2	789	3632
7	1	309	3640
5	2	309	3640
17	1	1462	3641
1	2	1495	3641
4	2	517	1389
1	1	550	1395
5	1	167	1470
2	1	1192	501
12	1	1192	797
1	6	1484	3953
1	7	1484	3953
1	8	1484	3953
1	1	1484	3953
18	1	783	3959
16	2	783	3959
3	2	905	3965
6	1	529	3967
6	2	529	3967
6	3	529	3967
5	4	529	3967
2	1	1497	3978
2	2	1497	3978
2	3	1497	3978
10	1	309	3983
9	2	309	3983
2	1	1485	966
19	8	364	3986
21	4	364	3986
17	5	364	3986
23	6	364	3986
21	7	364	3986
6	1	1343	3990
1	1	1432	3998
8	1	529	4001
8	2	529	4001
8	3	529	4001
7	4	529	4001
9	1	536	4003
6	5	1484	4006
2	1	781	4006
20	1	601	4012
4	1	1250	4013
15	4	529	4015
3	1	453	4016
7	2	740	4029
7	3	740	4029
4	1	1094	4031
8	2	1497	871
6	1	740	4037
6	1	781	4039
2	1	1350	4041
14	1	789	4043
16	2	789	4043
4	1	423	4051
4	2	423	4051
12	1	1343	4062
5	2	1512	4067
5	4	1512	4067
5	3	1512	4067
5	1	1512	4067
3	1	466	4073
13	2	529	4080
10	1	1490	2597
16	4	529	2626
1	1	130	2636
1	1	1494	2646
12	2	783	2649
4	1	1350	2703
11	1	1131	2717
2	1	807	2717
3	2	807	2717
2	1	844	2725
2	2	844	2725
2	3	844	2725
1	1	583	2730
10	1	783	4084
12	2	529	4090
12	3	529	4090
11	4	529	4090
4	1	1192	4100
1	1	167	4107
1	4	167	4107
1	2	167	4107
1	3	167	4107
2	1	1250	4108
16	8	364	4112
25	4	364	4112
18	5	364	4112
25	6	364	4112
19	7	364	4112
20	1	783	4115
14	2	783	4115
17	1	1518	4137
4	1	1343	4142
7	1	1185	4152
8	1	740	4154
4	1	453	4155
14	4	529	4162
17	1	601	4170
17	4	1002	4179
6	2	423	4186
10	2	423	4205
4	1	781	4206
5	1	1182	4212
10	1	601	4214
10	2	309	4217
14	1	783	4221
11	2	783	4221
21	8	364	4224
7	1	1518	4225
13	1	789	4226
8	2	789	4226
20	3	364	4227
2	1	453	4232
1	1	309	4234
1	2	309	4234
2	1	972	4234
4	1	601	4237
10	8	364	4244
23	5	364	4244
11	6	364	4244
11	7	364	4244
5	1	1075	4247
5	1	1462	4248
2	1	1487	4248
2	2	1487	4248
2	3	1487	4248
11	1	1493	4248
10	1	1495	4248
9	1	1295	4250
24	5	364	4250
18	6	364	4250
2	2	736	4272
2	1	736	4272
13	1	601	4285
5	1	1185	4290
8	1	423	2735
4	2	736	2741
4	1	736	2741
17	1	783	2748
13	2	783	2748
11	8	364	2750
1	2	550	1395
1	1	905	1395
14	1	364	2750
15	2	364	2750
18	3	364	2750
12	4	364	2750
13	5	364	2750
16	6	364	2750
13	7	364	2750
10	5	1490	2823
9	1	1490	2823
10	2	1490	2823
10	3	1490	2823
10	4	1490	2823
13	2	423	2830
3	2	1487	2848
3	3	1487	2848
6	1	1462	2848
3	1	1487	2848
6	1	1493	2848
1	1	972	2871
4	1	1491	2919
3	2	1491	2919
1	5	1490	2923
2	1	1490	2923
2	2	1490	2923
2	3	1490	2923
1	4	1490	2923
5	1	1295	4299
6	1	1192	4300
3	4	167	1230
9	1	783	4302
17	2	783	4302
9	2	1002	4303
9	3	1002	4303
9	4	1002	4303
7	1	1002	4303
1	1	844	4312
1	1	1502	86
1	1	364	196
1	2	844	4312
1	3	844	4312
2	2	1485	966
5	1	423	4313
5	2	423	4313
22	1	783	4322
6	1	1185	4323
9	1	453	4338
1	1	1498	4341
5	8	364	4350
10	1	364	4350
8	2	364	4350
5	3	364	4350
5	4	364	4350
5	5	364	4350
4	6	364	4350
5	7	364	4350
8	1	1295	4361
2	1	601	4368
23	3	364	4372
23	4	364	4372
9	1	781	4388
10	1	1365	4394
17	2	789	4398
2	1	309	4402
2	1	364	1095
2	2	309	4402
1	1	1250	4402
12	1	601	4406
3	1	583	4407
3	2	865	4411
7	1	865	4411
3	1	1343	4416
3	1	781	4417
7	8	364	4422
12	1	364	4422
14	2	364	4422
17	3	364	4422
17	4	364	4422
16	5	364	4422
14	6	364	4422
9	7	364	4422
8	3	1497	871
4	8	364	4423
6	1	364	4423
5	2	364	4423
4	3	364	4423
4	4	364	4423
11	1	1075	4423
4	5	364	4423
5	6	364	4423
4	7	364	4423
1	1	1149	4424
5	1	1365	4429
8	1	1192	4433
13	8	364	4434
15	1	364	4434
11	2	364	4434
15	3	364	4434
15	4	364	4434
21	6	364	4434
17	7	364	4434
1	1	1185	4437
18	1	601	4438
26	4	364	4444
27	5	364	4444
7	1	1494	4444
27	6	364	4444
11	1	423	4447
12	2	423	4447
2	1	1492	4448
2	2	1492	4448
6	2	1491	4448
7	1	1493	4448
14	8	364	4449
2	1	865	4449
18	4	364	4449
20	5	364	4449
19	6	364	4449
14	7	364	4449
11	1	1365	4455
3	1	1149	4462
7	2	807	4468
6	8	364	4469
11	1	364	4469
13	2	364	4469
16	3	364	4469
16	4	364	4469
15	5	364	4469
8	6	364	4469
8	7	364	4469
6	1	1295	4470
4	1	1373	4471
4	1	529	4492
4	2	529	4492
5	1	1489	4492
4	3	529	4492
4	4	529	4492
3	1	1094	4493
1	1	1295	4500
6	1	865	4509
4	1	1485	4515
4	2	1485	4515
12	1	865	135
4	3	1485	4515
3	4	1485	4515
3	5	1485	4515
3	6	1485	4515
3	7	1485	4515
25	2	789	4524
5	1	248	4529
12	1	453	4534
11	1	601	4535
2	1	1185	4538
8	2	807	4544
12	2	1002	4545
12	3	1002	4545
12	8	364	4550
16	2	364	4550
19	3	364	4550
13	4	364	4550
14	5	364	4550
17	6	364	4550
16	7	364	4550
7	1	1365	4569
9	2	423	4570
8	1	789	4571
9	2	789	4571
2	1	529	4573
2	2	529	4573
2	3	529	4573
2	4	529	4573
18	2	789	4592
4	1	1185	4594
3	1	1075	4604
13	3	529	4612
12	4	529	4612
3	1	1496	4615
3	2	1496	4615
3	3	1496	4615
5	1	781	4616
20	4	1002	4629
5	1	1131	4636
6	1	972	4641
1	1	865	4643
1	2	865	4643
4	1	248	4645
5	2	807	4649
6	1	807	4649
3	1	789	4651
3	2	789	4651
11	1	781	4661
4	2	905	4665
6	2	1002	4672
6	3	1002	4672
6	4	1002	4672
6	1	1002	4672
4	1	807	4678
6	2	807	4678
6	1	601	4679
4	2	740	4685
3	3	740	4685
2	1	466	4695
19	2	789	4697
20	2	789	4700
9	1	309	4713
8	2	309	4713
5	1	865	4722
4	2	865	4722
1	3	550	1395
1	2	905	1395
5	4	167	1470
5	3	167	1470
8	2	1002	4728
2	3	1485	966
8	3	1002	4728
8	4	1002	4728
4	1	1002	4732
4	2	1002	4732
4	3	1002	4732
3	4	1002	4732
3	1	1198	4733
8	1	1365	4740
5	1	1149	4741
4	1	1149	4746
3	3	1002	4760
9	2	364	613
4	4	1002	4760
3	1	1002	4760
3	2	1002	4760
2	1	1499	4763
3	1	972	4765
1	1	783	4766
2	2	783	4766
16	1	789	4767
10	2	789	4767
9	1	529	4776
9	2	529	4776
9	3	529	4776
8	4	529	4776
10	2	1002	4799
10	3	1002	4799
10	4	1002	4799
8	1	1002	4799
11	2	1002	4815
11	3	1002	4815
11	4	1002	4815
16	1	1518	4817
8	1	536	4824
15	1	789	4829
13	2	789	4829
6	1	1075	4831
4	1	1295	4832
7	2	865	4833
9	1	865	4833
2	1	1131	4837
10	1	789	4840
7	2	1002	4843
7	3	1002	4843
7	4	1002	4843
11	1	789	4846
3	1	1182	1006
10	1	1295	4847
7	1	1502	4850
24	2	789	4854
21	1	783	4855
8	1	1182	692
9	1	1182	231
1	1	1365	962
7	1	783	4857
3	2	783	4857
3	2	736	4858
3	1	736	4858
7	1	1192	4859
2	1	1198	4864
2	1	1518	4866
5	2	1002	4867
5	3	1002	4867
5	4	1002	4867
5	1	1002	4867
5	1	536	4872
10	1	529	4875
15	1	1365	1095
10	2	529	4875
3	1	1250	781
10	3	529	4875
9	4	529	4875
17	1	789	4883
11	2	789	4883
3	1	1432	4886
14	3	1002	4888
14	4	1002	4888
2	1	1377	4891
7	1	1295	1211
12	1	1131	4900
6	1	423	4904
9	1	601	4907
2	1	740	4912
13	4	529	4921
1	1	1496	4929
3	1	1350	4929
1	2	1496	4929
1	1	1002	140
1	3	1496	4929
11	1	453	4932
6	1	1365	4934
5	2	865	4939
8	1	865	4939
3	1	601	4940
3	1	1192	4941
2	1	905	4942
10	1	1002	362
2	2	905	4942
15	1	783	4945
1	2	783	4945
7	1	423	4950
4	1	789	4963
2	2	789	4963
5	1	1192	4966
18	1	789	4970
14	2	789	4970
9	1	1131	4971
19	1	789	4977
15	2	789	4977
8	3	740	4979
8	2	740	4979
3	3	1512	4980
3	1	1512	4980
3	2	1512	4980
3	4	1512	4980
3	1	1377	4982
13	1	781	4983
9	1	789	4986
7	2	789	4986
10	1	1131	4996
2	1	1149	4997
21	2	789	5001
7	1	601	5003
5	1	783	5005
7	2	783	5005
10	3	740	5010
10	2	740	5010
5	1	740	5014
14	1	1365	5018
13	1	1295	5020
1	1	1518	5023
4	1	740	5026
3	2	740	5026
5	3	740	5026
5	1	1377	5027
13	1	1365	5031
14	1	1295	5042
6	1	783	5045
8	2	783	5045
6	2	865	5053
11	1	865	5053
4	1	1377	5059
8	1	601	5060
10	1	865	5061
7	1	781	5071
9	2	807	5079
20	1	789	5082
12	2	789	5082
7	1	1149	5084
6	1	1149	5086
11	1	783	5087
18	2	783	5087
16	1	783	5088
10	2	783	5088
5	1	1250	5091
1	1	1198	5095
1	1	601	5097
8	1	1343	5099
12	1	1365	5100
1	1	1182	5101
5	1	972	5101
7	1	740	5103
2	1	1343	5108
7	1	453	5111
3	1	1185	5112
12	1	1295	5125
11	3	740	5130
11	2	740	5130
5	2	905	5197
8	1	1462	5202
9	1	1462	5203
10	1	1462	5204
11	1	1462	5205
12	1	1462	5206
13	1	1462	5207
14	1	1462	5208
10	3	364	613
2	4	1485	966
7	4	1485	702
1	1	1377	109
2	5	1485	966
7	1	972	231
6	2	740	5313
6	3	740	5313
19	4	1002	5314
3	1	1484	5318
2	1	583	1449
5	2	167	1470
3	3	1484	5319
3	2	1484	5319
3	4	1484	5319
2	5	1484	5319
2	6	1484	5319
2	7	1484	5319
2	8	1484	5319
4	1	1484	5319
7	4	364	613
8	2	1484	5320
6	1	1484	5320
8	3	1484	5321
1	1	1490	675
9	2	1484	5321
7	4	1484	5321
7	5	1484	5321
9	6	1484	5321
7	1	1484	5321
4	3	1484	5322
4	2	1484	5322
4	4	1484	5322
3	5	1484	5322
3	6	1484	5322
5	1	1484	5322
5	3	1484	5323
5	2	1484	5323
11	1	1499	1257
12	1	1499	1285
5	4	1484	5323
4	5	1484	5323
4	6	1484	5323
3	7	1484	5323
6	3	1484	5324
6	2	1484	5324
7	7	1484	5324
7	2	1484	5325
7	3	1484	5326
6	4	1484	5326
5	5	1484	5327
5	6	1484	5327
4	7	1484	5327
6	6	1484	5328
5	7	1484	5328
3	8	1484	5328
7	6	1484	5329
6	7	1484	5329
4	8	1484	5329
8	7	1484	5330
9	7	1484	5331
5	8	1484	5332
6	8	1484	5333
7	8	1484	5334
7	6	1486	5335
8	8	1484	5335
11	5	1488	5335
3	1	1485	5338
3	2	1485	5338
3	3	1485	5338
5	1	1485	5339
5	2	1485	5339
9	1	972	1301
5	3	1485	5339
10	1	972	1318
4	5	1485	5339
12	1	972	1117
13	1	972	569
4	4	1485	5339
1	1	1075	100
4	6	1485	5339
6	1	1485	5340
6	2	1485	5340
6	3	1485	5340
5	5	1485	5340
7	1	1075	364
5	4	1485	5340
9	1	1075	794
5	6	1485	5340
4	7	1485	5340
7	2	1485	5341
13	1	1075	218
7	3	1485	5341
9	3	1485	5342
6	5	1485	5342
6	4	1485	5342
6	6	1485	5342
5	7	1485	5342
10	3	1485	5343
7	5	1485	5344
7	6	1485	5344
6	7	1485	5344
8	6	1485	5345
7	7	1485	5345
1	3	1486	5347
1	4	1486	5347
1	5	1486	5347
1	6	1486	5347
1	1	1486	5347
1	2	1486	5347
3	2	167	1230
2	3	1486	5348
2	4	1486	5348
2	5	1486	5348
2	6	1486	5348
2	1	1486	5348
3	1	1373	3217
13	1	453	3224
1	1	529	3227
1	2	529	3227
1	3	529	3227
1	4	529	3227
3	1	536	3234
1	1	1373	3241
12	5	364	3241
12	6	364	3241
12	7	364	3241
7	5	364	613
2	6	1485	966
1	2	1490	675
8	1	783	3270
4	2	783	3270
4	3	1489	3270
8	1	1492	3311
2	1	1365	3351
3	1	1131	3371
25	5	364	3378
28	6	364	3378
16	1	781	3379
4	1	1075	3383
11	1	1192	3384
1	1	104	3395
1	2	104	3395
1	3	104	3395
6	3	1488	3437
2	1	248	3438
5	1	1432	3441
16	1	1462	3448
7	1	1487	3448
2	1	1491	3463
8	1	583	3465
15	1	1462	3480
5	1	601	3480
9	3	740	3483
9	2	740	3483
17	3	517	3485
18	4	517	3485
10	7	517	3485
17	5	517	3485
6	4	1488	3485
19	1	601	3488
4	1	466	3489
1	1	1192	3491
5	1	309	3492
8	1	453	3502
1	1	1343	3509
9	1	583	3509
5	1	529	3514
5	2	529	3514
5	3	529	3514
3	1	783	3515
10	1	1192	3517
4	2	1487	3641
2	2	1486	5348
4	1	1486	5349
4	3	1486	5350
4	4	1486	5350
4	5	1486	5350
4	6	1486	5350
5	1	1486	5350
4	2	1486	5350
6	3	1486	5351
7	4	1486	5351
9	5	1486	5351
9	6	1486	5351
6	1	1486	5351
6	2	1486	5351
7	3	1486	5352
8	4	1486	5352
10	5	1486	5352
10	6	1486	5352
7	1	1486	5352
7	2	1486	5352
5	3	1486	5353
5	4	1486	5353
8	3	1490	5353
5	2	1486	5353
6	4	1486	5354
5	5	1486	5355
5	6	1486	5355
6	6	1486	5356
6	5	1486	5356
7	5	1486	5357
16	3	517	3088
8	6	1486	5358
4	1	1487	5359
5	1	1487	5360
6	2	1487	5361
7	3	1487	5361
8	2	1491	5361
5	3	1487	5362
1	1	1488	5364
1	2	1488	5364
7	4	1488	5372
6	5	1488	5372
8	4	1488	5373
7	5	1488	5374
8	5	1488	5375
9	5	1488	5376
10	5	1488	5377
1	1	1491	5379
1	2	1491	5379
3	1	1493	5379
2	1	1489	5379
4	1	1489	5380
5	1	1493	5381
3	2	1489	5381
6	1	1489	5381
3	3	1489	5381
4	2	1489	5382
5	2	1489	5383
6	2	1489	5384
8	2	1489	5385
9	1	1502	5386
6	3	1489	5386
7	3	1489	5387
3	1	1490	5389
3	2	1490	5389
2	5	1490	5390
4	1	1490	5390
4	2	1490	5390
2	4	1490	5390
1	3	1490	5390
5	1	1490	5391
5	2	1490	5391
4	3	1490	5391
6	1	1490	5392
7	1	1490	5393
8	5	1490	5394
8	1	1490	5394
8	2	1490	5394
7	4	1490	5394
6	3	1490	5394
6	2	1490	5395
3	5	1490	5396
7	2	1490	5396
2	2	609	1355
3	4	1490	5396
5	3	1490	5396
9	5	1490	5397
9	2	1490	5397
9	4	1490	5397
9	3	1490	5397
4	5	1490	5398
4	4	1490	5398
7	3	1490	5398
5	5	1490	5399
5	4	1490	5399
6	5	1490	5400
6	4	1490	5400
8	4	1490	5401
7	5	1490	5402
6	2	1492	5404
3	1	1491	5404
7	1	1489	1211
2	2	1491	5404
8	1	1493	5404
5	1	1491	5405
4	2	1491	5406
5	2	1491	5407
1	1	1492	5408
1	2	1492	5408
7	1	1495	5424
8	1	1495	5425
9	1	1495	5426
2	7	1485	966
5	2	1495	5427
7	2	1495	5428
2	1	1496	5431
2	2	1496	5431
2	3	1496	5431
4	1	1496	5432
4	2	1496	5432
4	3	1496	5432
5	1	1496	5433
5	2	1496	5433
5	3	1496	5433
3	3	1490	675
6	1	1496	5434
6	2	1496	5434
6	3	1496	5434
7	1	1496	5435
7	2	1496	5435
7	3	1496	5435
8	1	1496	5436
8	2	1496	5436
8	3	1496	5436
9	1	1496	5437
9	2	1496	5437
9	3	1496	5437
10	1	1496	5438
10	2	1496	5438
11	1	1496	5439
11	2	1496	5439
11	3	1496	5439
12	1	1496	5440
12	2	1496	5440
12	3	1496	5440
13	1	1496	5441
13	2	1496	5441
13	3	1496	5441
14	1	1496	5442
14	2	1496	5442
14	3	1496	5442
15	1	1496	5443
15	2	1496	5443
15	3	1496	5443
16	1	1496	5444
16	2	1496	5444
16	3	1496	5444
10	3	1496	5445
2	1	1544	5447
1	1	1497	5447
1	2	1497	5447
1	3	1497	5447
3	1	1497	5448
3	2	1497	5448
3	3	1497	5448
4	1	1497	5449
4	2	1497	5449
4	3	1497	5449
5	1	1497	5450
5	2	1497	5450
5	3	1497	5450
6	1	1497	5451
6	2	1497	5451
6	3	1497	5451
7	2	1497	5452
7	3	1497	5452
2	1	1498	5454
3	1	1498	5455
5	1	1498	5456
4	1	1498	5457
6	1	1498	5458
1	1	1499	5459
3	1	1499	5460
4	1	1499	5461
5	1	1499	5462
6	1	1499	5463
7	1	1499	5464
8	1	1499	5465
9	1	1499	5466
10	1	1499	5467
2	1	1502	6050
3	1	1502	6051
4	1	1502	6052
5	1	1502	6053
6	1	1502	6054
8	1	1502	6055
1	3	1512	6570
1	1	1512	6570
1	2	1512	6570
1	4	1512	6570
4	3	1512	6571
4	1	1512	6571
4	2	1512	6571
4	4	1512	6571
7	3	1512	6572
6	1	1512	6572
7	2	1512	6572
7	4	1512	6572
6	3	1512	6573
6	2	1512	6573
6	4	1512	6573
8	4	1512	7165
3	1	1518	7370
4	1	1518	7371
5	1	1518	7372
15	6	364	393
6	1	1518	7373
11	1	1518	7374
12	1	1518	7375
13	1	1518	7376
14	1	1518	7377
10	1	1518	7384
8	1	1518	7385
10	1	423	689
12	1	423	1286
1	1	1544	7461
3	1	1544	7462
4	1	1544	7463
5	1	1544	7464
6	1	1544	7465
7	1	1544	7466
8	2	865	7543
9	2	865	7544
10	2	865	7545
11	2	865	7546
12	2	865	7547
13	2	865	7548
14	2	865	7549
1	2	609	1389
2	1	609	1355
14	2	423	1286
18	1	781	412
14	1	1493	680
15	1	1493	166
7	2	1489	1211
1	1	609	1389
6	1	466	1327
7	1	466	832
2	3	609	1355
1	1	197	120
10	1	453	478
5	3	1489	1010
8	3	1489	1211
14	1	453	92
1	3	609	1389
1	1	1495	3641
3	3	1486	3646
3	4	1486	3646
3	5	1486	3646
3	6	1486	3646
3	1	1486	3646
3	2	1486	3646
2	1	1202	3651
1	1	1489	3652
2	1	1493	3652
1	2	1489	3652
1	3	1489	3652
2	1	1432	3674
5	1	583	3679
10	1	536	3682
3	1	1365	3717
5	2	1487	3723
12	1	1493	3723
6	1	167	3726
6	3	167	3726
6	4	167	3726
6	2	167	3726
25	2	364	3729
26	3	364	3729
22	4	364	3729
5	1	1343	3730
4	1	583	3730
7	2	1492	3731
1	1	1094	3736
2	1	1488	3743
2	2	1488	3743
2	3	1488	3743
2	4	1488	3743
2	5	1488	3743
13	4	1002	3754
14	1	781	2931
10	1	1343	2934
6	1	583	2934
26	2	789	2936
4	1	536	2939
8	1	1185	2939
9	7	517	2949
16	5	517	2949
2	3	550	2949
9	1	1192	2969
6	1	1495	2987
7	1	1498	2993
7	1	807	3020
3	1	844	3042
3	2	844	3042
3	3	844	3042
4	1	783	3053
17	4	517	3088
8	7	517	3088
14	5	517	3088
12	6	517	3088
14	2	517	3088
4	1	1131	3101
9	1	1365	3120
1	2	736	3126
1	1	736	3126
9	1	1518	3132
7	3	517	3139
7	4	517	3139
7	5	517	3139
6	6	517	3139
7	1	517	3139
7	2	517	3139
2	3	517	3160
2	4	517	3160
2	5	517	3160
2	7	517	3160
2	6	517	3160
2	1	517	3160
2	2	517	3160
7	1	1131	3166
8	1	1489	3166
11	2	309	3177
6	1	789	3203
5	2	789	3203
8	1	1544	3203
12	2	309	3216
12	2	807	3217
12	1	1075	3762
20	8	364	3766
1	3	1488	5364
1	4	1488	5364
1	5	1488	5364
3	1	1488	5365
3	2	1488	5365
3	3	1488	5365
3	4	1488	5365
3	5	1488	5365
4	1	1488	5366
4	2	1488	5366
4	3	1488	5366
6	1	1488	5367
6	2	1495	5368
5	2	1488	5368
6	2	1488	5369
7	3	1488	5369
5	3	1488	5370
4	4	1488	5370
4	5	1488	5370
5	4	1488	5371
5	5	1488	5371
15	3	1002	1523
18	4	1002	1523
9	1	1002	1523
10	4	517	1533
10	5	517	1533
9	6	517	1533
10	1	517	1533
10	2	517	1533
4	1	1432	1540
8	4	517	1576
8	5	517	1576
7	7	517	1576
7	6	517	1576
8	1	517	1576
8	2	517	1576
9	1	423	1604
7	2	423	1604
14	1	1131	1619
1	1	1485	1626
1	2	1485	1626
1	3	1485	1626
1	4	1485	1626
1	5	1485	1626
1	6	1485	1626
1	7	1485	1626
8	1	1149	1655
22	2	364	1685
24	3	364	1685
2	8	364	1687
3	1	364	1687
3	2	364	1687
2	3	364	1687
2	4	364	1687
3	5	364	1687
2	6	364	1687
2	7	364	1687
10	1	781	1690
12	5	517	1714
14	1	517	1714
13	2	517	1714
8	8	364	1716
10	2	364	1716
11	3	364	1716
9	4	364	1716
10	5	364	1716
7	6	364	1716
7	7	364	1716
8	1	972	1724
4	1	972	1732
6	1	1432	1736
7	1	1492	1753
1	1	1131	1753
7	2	1487	1753
6	1	1491	1753
13	1	1493	1753
8	2	423	1784
19	2	364	1788
12	3	364	1788
10	4	364	1788
9	5	364	1788
1	8	364	1793
18	1	364	1793
1	2	364	1793
1	3	364	1793
1	4	364	1793
1	5	364	1793
1	6	364	1793
1	7	364	1793
11	2	423	1795
8	1	1432	1801
8	1	1075	1805
3	4	517	1814
3	5	517	1814
3	7	517	1814
3	1	517	1814
3	2	517	1814
12	1	783	1835
9	2	783	1835
1	1	1202	1841
4	1	364	1857
4	2	364	1857
8	3	364	1857
14	1	972	1864
1	1	1350	1865
15	5	517	1868
15	2	517	1868
10	1	1075	1886
17	8	364	1898
23	2	364	1898
27	3	364	1898
19	4	364	1898
21	5	364	1898
20	6	364	1898
18	7	364	1898
6	1	1377	1920
11	4	517	1921
11	5	517	1921
11	1	517	1921
5	1	453	1937
6	4	517	2263
6	5	517	2263
6	7	517	2263
5	6	517	2263
6	1	517	2263
6	2	517	2263
5	2	740	2299
4	3	740	2299
8	1	364	1965
6	2	364	1965
9	3	364	1965
6	4	364	1965
6	5	364	1965
9	6	364	1965
6	7	364	1965
16	1	364	1973
17	2	364	1973
22	3	364	1973
14	4	364	1973
22	8	364	1974
7	1	364	1974
7	2	364	1974
7	3	364	1974
27	4	364	1974
28	5	364	1974
29	6	364	1974
23	7	364	1974
6	1	1250	1978
17	1	781	1981
15	4	517	1989
10	1	1502	2013
6	1	1373	2027
2	1	1373	2043
5	1	1488	2081
7	2	1488	2081
8	3	1488	2081
9	4	1488	2081
15	1	1295	2081
12	5	1488	2081
3	8	364	2104
5	1	364	2104
2	2	364	2104
3	3	364	2104
3	4	364	2104
2	5	364	2104
3	6	364	2104
3	7	364	2104
2	1	783	2117
15	8	364	2140
24	2	364	2140
25	3	364	2140
20	4	364	2140
19	5	364	2140
22	6	364	2140
15	7	364	2140
9	8	364	2172
21	2	364	2172
13	3	364	2172
11	4	364	2172
11	5	364	2172
10	6	364	2172
10	7	364	2172
22	5	364	2183
24	6	364	2183
4	2	789	2194
6	1	1131	2198
7	2	1491	5408
4	1	1493	5408
3	1	1492	5410
3	2	1492	5410
4	1	1492	5411
4	2	1492	5411
5	1	1492	5412
9	1	1493	5412
6	1	1492	5413
5	2	1492	5413
2	1	1494	5416
4	1	1494	5417
5	1	1494	5418
6	1	1494	5419
2	3	1512	5421
2	1	1512	5421
2	2	1512	5421
2	4	1512	5421
2	1	1495	5421
3	2	1495	5422
4	1	1495	5422
5	1	1495	5423
4	2	1495	5424
1	1	1577	7604
2	1	1577	7605
3	1	1577	7606
4	1	1577	7607
5	1	1577	7608
6	1	1577	7609
7	1	1577	7610
8	1	1577	7611
9	1	1577	7612
10	1	1577	7613
11	1	1577	7614
12	1	1577	7615
13	1	1577	7616
14	1	1577	2733
1	1	1578	2730
2	1	1578	2929
3	1	1578	4765
4	1	1578	3533
5	1	1578	3974
6	1	1578	4637
7	1	1578	4705
8	1	1578	4234
9	1	1578	2939
10	1	1578	3679
11	1	1578	5097
12	1	1578	5023
13	1	1578	3998
14	1	1578	7623
15	1	1578	7624
16	1	1578	7395
17	1	1578	3674
18	1	1578	7625
19	1	1578	7626
20	1	1578	7627
21	1	1578	7628
22	1	1578	7630
23	1	1578	478
24	1	1578	4237
1	2	466	3522
2	2	466	4695
3	2	466	4073
4	2	466	3879
5	2	466	1327
6	2	466	2027
7	2	466	832
1	2	1149	4424
2	2	1149	4462
3	2	1149	4746
4	2	1149	4741
5	2	1149	5086
6	2	1149	5084
7	2	1149	3179
8	2	1149	7738
1	1	1637	4440
2	1	1637	7843
3	1	1637	871
4	1	1637	5361
5	1	1637	7844
6	1	1637	7845
7	1	1637	7846
8	1	1637	7847
9	1	1637	7848
10	1	1637	7849
11	1	1637	7850
12	1	1637	7851
13	1	1637	7852
14	1	1637	2745
15	1	1637	7854
16	1	1637	7853
17	1	1637	3047
3	1	46	2517
5	1	46	1234
1	1	46	1348
4	1	46	823
7	1	46	945
6	1	46	410
8	1	46	228
2	1	46	1621
1	5	1002	140
2	5	1002	3533
3	5	1002	4732
4	5	1002	4760
5	5	1002	4867
6	5	1002	4672
7	5	1002	4843
8	5	1002	4728
9	5	1002	4303
10	5	1002	4799
11	5	1002	4815
12	5	1002	3856
13	5	1002	3754
14	5	1002	4888
15	5	1002	89
16	5	1002	1523
17	5	1002	4179
18	5	1002	5081
\.


--
-- Data for Name: seasons_directors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seasons_directors (ordering, show_id, season, director_id) FROM stdin;
1	865	2	210
1	130	1	879
8	1486	5	3646
6	1486	6	3646
1	783	1	3663
5	167	3	3726
5	130	1	3726
1	1131	1	3726
2	517	1	3726
8	517	2	3726
1	517	3	3726
7	517	4	3726
2	517	5	3726
3	167	1	3726
1	167	4	3726
3	167	2	3726
1	550	1	3726
5	517	4	1093
4	550	2	963
6	550	2	879
4	550	3	963
1	865	1	210
4	1002	2	1084
4	1002	4	1360
2	1182	1	6595
3	1495	1	6601
1	536	1	6601
1	972	1	6604
1	1198	1	1471
7	1499	1	447
2	1492	2	1068
1	1491	2	1183
2	972	1	6605
3	972	1	6606
1	453	1	6613
1	1462	1	6614
1	423	2	6614
2	453	1	6614
2	1462	1	6615
2	423	2	6615
3	453	1	6615
4	905	2	6622
1	423	1	6622
3	423	2	6625
4	423	2	6626
3	550	1	6629
1	1489	3	2378
13	1484	3	2420
4	1484	4	2601
5	1484	4	503
11	1484	5	1175
2	1489	3	3652
11	1487	1	1763
9	1484	3	1917
1	1484	4	1917
1	1512	4	6569
2	1512	4	6585
8	1485	1	270
11	1486	2	1068
17	1486	2	1079
7	1486	3	1079
9	1486	3	1068
16	1486	4	1079
18	1486	4	1068
14	1486	5	1068
4	1485	2	6659
2	1485	3	6659
7	1485	4	6659
11	1485	5	6659
2	1485	6	6659
1	1485	7	6659
14	1486	1	6659
8	1486	2	6659
10	1486	5	6659
2	364	5	6666
4	364	6	6666
2	364	7	6666
5	905	2	6667
5	1149	1	6669
2	1343	1	6669
2	865	1	6670
3	1343	1	6670
2	550	1	6677
7	550	2	6677
1	550	3	6677
6	1131	1	6677
7	1489	2	6678
9	1489	3	6678
3	1487	3	6678
4	1350	1	6678
4	1131	1	6678
9	1496	3	6679
1	517	1	6755
7	517	1	6756
6	517	2	6757
6	167	2	6782
1	1432	1	6782
2	167	3	6782
4	167	4	6783
4	167	2	6783
2	167	1	6784
2	167	2	6785
4	609	2	6785
2	1488	2	1068
7	1488	2	1079
4	1488	3	1079
7	1488	4	1079
8	1488	4	1068
6	1490	1	615
10	1490	1	1068
5	550	2	3726
8	1496	2	3758
1	1373	1	3837
1	1202	1	3901
3	550	3	3934
7	1377	1	3934
4	1377	1	4343
3	1377	1	4396
3	1512	2	4473
2	601	1	4549
1	601	1	4631
3	1512	3	4980
1	1365	1	5172
12	1491	1	5206
9	1491	2	5206
5	1377	1	5227
1	1343	1	5267
1	1295	1	5268
8	529	1	5279
6	529	4	5279
1	905	1	5281
1	905	2	5281
3	364	4	6719
2	364	1	6720
1	364	1	6721
3	364	2	6722
2	1489	1	6722
1	364	5	6723
3	364	6	6724
2	364	6	6725
3	364	7	6726
2	529	1	6726
1	583	1	6726
1	1185	1	6726
2	466	1	6730
3	466	1	6731
6	1489	1	6731
9	1489	2	6731
4	466	1	6732
2	789	1	6733
3	789	1	6735
2	789	2	6735
4	1149	1	6735
3	1250	1	6735
5	789	2	6736
4	789	2	6737
2	517	4	6744
5	517	5	6744
2	517	6	6744
3	517	2	6744
3	517	3	6744
4	517	7	6744
3	517	1	6744
2	517	7	6745
5	517	3	6745
4	517	4	6745
1	517	5	6745
5	517	6	6745
1	167	1	6745
1	529	4	6799
2	1149	1	6799
4	529	1	6800
4	529	2	6800
3	529	4	6800
4	1250	1	6800
6	529	2	6801
4	529	3	6801
11	1489	3	6801
8	1485	6	6801
7	1486	5	6801
3	1486	6	6801
5	529	1	6802
7	529	2	6802
3	529	3	6803
1	1149	1	6803
2	529	3	6804
2	1185	1	6804
8	1492	2	6804
5	1487	3	6804
4	529	4	6805
6	1149	1	6805
2	529	4	6806
14	1485	2	6806
7	1488	1	6806
7	529	1	6807
3	529	2	6808
3	1149	1	6808
2	529	2	6809
12	1489	2	6809
5	529	2	6810
2	905	1	5282
6	905	2	5282
2	167	4	6745
1	609	2	6745
1	609	1	6745
3	609	3	6745
8	517	1	6745
4	517	2	6745
3	167	3	6745
1	517	7	6746
7	517	2	6746
2	517	3	6746
6	517	4	6746
3	517	5	6746
4	517	6	6746
9	517	1	6747
5	517	2	6747
4	517	3	6747
3	517	4	6748
6	517	5	6748
3	517	6	6748
3	517	7	6749
8	517	4	6749
4	517	5	6749
1	517	6	6749
1	740	1	5301
1	740	2	5301
1	740	3	5301
1	248	1	5306
2	248	1	5307
3	248	1	5308
1	1002	1	5309
1	1002	2	5309
1	1002	3	5309
1	1002	4	5309
2	1002	1	5310
2	1002	2	5310
2	1002	3	5310
2	1002	4	5310
3	364	8	5311
2	364	3	5311
4	364	8	5312
1	364	4	5312
11	1490	5	5316
9	1484	7	5319
3	1484	8	5319
11	1485	4	5336
15	1485	5	5336
9	1485	7	5340
16	1486	3	5351
4	1486	4	5351
9	1486	5	5351
9	1488	5	5364
6	1490	5	5390
1	1497	1	5446
1	1497	2	5446
1	1497	3	5446
1	1250	1	5555
4	1512	3	6009
2	1512	1	6009
2	1512	2	6009
4	1462	1	6515
1	1512	3	6569
1	1512	1	6569
1	1512	2	6569
2	1512	3	6585
1	1502	1	6591
9	1484	4	6592
2	1502	1	6592
3	783	1	6592
1	783	2	6592
1	1182	1	6594
5	529	4	6595
4	1489	2	6629
1	197	1	6629
10	1492	1	6629
10	1495	2	6631
3	601	1	6631
4	601	1	6632
1	1075	1	6638
5	1202	1	6642
4	1202	1	6643
3	1202	1	6644
2	1202	1	6645
3	1365	1	6648
2	1365	1	6649
2	1491	2	6658
2	130	1	6658
2	1131	1	6658
17	1484	4	6659
14	1484	5	6659
3	1484	6	6659
4	1488	1	6659
3	1490	2	6659
2	1490	3	6659
4	1494	1	6659
7	1492	1	6659
3	130	1	6659
3	1487	2	6660
2	1493	1	6660
9	1492	1	6660
7	1496	1	6660
3	905	1	6660
3	905	2	6660
7	905	1	6661
5	1495	1	6662
2	1495	2	6662
9	1496	1	6662
13	1496	2	6662
4	1496	3	6662
4	905	1	6662
6	905	1	6663
5	905	1	6664
9	1485	4	6665
7	1485	5	6665
11	1485	6	6665
3	1485	7	6665
15	1486	3	6665
7	905	2	6665
3	1496	1	6665
2	905	2	6666
5	1131	1	6679
4	789	1	6679
3	789	2	6679
1	807	1	6680
1	807	2	6681
3	807	1	6682
2	807	1	6683
2	807	2	6684
3	807	2	6685
1	104	1	6689
2	104	2	6689
2	104	3	6689
1	104	3	6690
1	104	2	6690
1	309	1	6692
3	309	2	6692
2	309	1	6693
1	309	2	6693
2	309	2	6694
5	309	2	6695
4	309	2	6696
4	248	1	6706
5	248	1	6707
1	364	8	6713
4	364	2	6713
6	364	3	6713
5	364	5	6713
1	1484	1	6713
1	1486	1	6713
3	364	3	6714
2	364	4	6714
8	529	2	6714
2	364	8	6715
4	364	5	6715
5	364	6	6715
1	789	1	6715
3	1492	1	6715
3	364	5	6716
1	364	6	6716
1	364	7	6716
3	364	1	6717
1	364	3	6717
2	364	2	6718
4	364	3	6718
4	364	4	6718
5	364	3	6719
5	167	4	6749
1	167	2	6749
1	167	3	6749
5	517	1	6750
2	517	2	6750
4	517	1	6751
1	517	2	6751
4	167	1	6751
6	167	3	6751
4	167	3	6752
5	517	7	6752
3	167	4	6752
5	167	2	6752
3	609	2	6752
2	609	1	6752
1	609	3	6752
6	517	7	6753
2	609	2	6753
3	609	1	6753
2	609	3	6753
6	517	1	6754
4	609	1	6785
4	609	3	6785
3	529	1	6799
1	529	2	6799
1	529	3	6799
7	1149	1	6824
3	1490	3	6849
11	1490	4	6849
1	736	1	6850
5	736	1	6851
7	736	1	6852
1	781	1	6862
2	781	1	6863
2	1432	1	6870
3	1432	1	6871
5	1462	1	6874
3	1462	1	6875
2	783	1	6881
5	1250	1	6881
3	844	1	6888
1	844	2	6889
3	844	3	6889
2	844	2	6890
4	844	3	6890
3	844	2	6891
5	844	3	6891
4	844	2	6892
1	844	3	6892
5	844	2	6893
2	844	3	6893
2	844	1	6894
5	844	1	6895
4	844	1	6896
6	844	1	6897
7	844	1	6898
8	844	1	6899
1	844	1	6900
3	865	1	6911
3	1488	2	6911
4	1002	3	6914
4	1493	1	6914
4	1492	1	6914
7	1489	1	6914
13	1489	2	6914
5	1002	2	6915
1	1094	1	6922
3	1094	1	6923
2	1094	1	6924
4	1094	1	6925
4	1185	1	6932
5	1185	1	6933
2	1495	1	6933
11	1492	1	6933
6	1491	1	6933
10	1491	2	6933
5	1487	2	6933
1	1192	1	6939
2	1192	1	6940
1	1494	1	6940
4	1192	1	6941
2	1198	1	6945
3	1198	1	6946
10	1495	1	6946
6	1495	2	6946
8	1492	1	6946
6	1489	2	6946
10	1487	3	6946
2	1250	1	6950
1	1350	1	6955
3	1350	1	6956
2	1350	1	6957
10	1499	1	6965
16	1484	6	6965
8	1484	7	6965
3	1486	5	6965
11	1488	3	6965
12	1488	4	6965
6	1488	5	6965
8	1490	5	6965
2	1499	1	6966
15	1498	1	6966
1	1499	1	6967
3	1484	2	6967
1	1484	3	6967
18	1484	4	6967
10	1484	7	6967
7	1484	8	6967
3	1486	1	6967
14	1486	2	6967
1	1486	4	6967
1	1488	1	6967
1	1488	2	6967
8	1488	3	6967
1	1490	1	6967
12	1499	1	6968
3	1492	2	6968
7	1487	3	6968
4	1499	1	6969
9	1497	2	6969
5	1496	3	6969
9	1484	2	6969
7	1484	3	6969
15	1484	4	6969
10	1486	1	6969
9	1486	2	6969
12	1486	3	6969
6	1499	1	6970
8	1499	1	6971
3	1499	1	6972
8	1486	6	6972
5	1499	1	6973
3	1494	1	6973
2	1485	1	6973
3	1498	1	6980
10	1485	1	6980
5	1485	2	6980
4	1498	1	6981
14	1488	4	6981
6	1498	1	6982
10	1486	2	6982
19	1486	3	6982
11	1488	2	6982
4	1490	2	6982
2	1498	1	6983
11	1484	3	6983
3	1484	5	6983
4	1486	1	6983
7	1486	2	6983
8	1486	3	6983
8	1486	4	6983
2	1488	1	6983
3	1488	3	6983
2	1490	1	6983
1	1490	2	6983
8	1490	3	6983
1	1498	1	6984
11	1498	1	6985
8	1498	1	6986
7	1498	1	6987
16	1484	4	6987
4	1484	5	6987
2	1484	6	6987
2	1484	7	6987
6	1484	8	6987
5	1486	4	6987
5	1498	1	6988
5	1496	2	6988
14	1498	1	6989
7	1484	4	6989
1	1484	5	6989
1	1484	6	6989
1	1484	7	6989
1	1484	8	6989
4	1488	2	6989
10	1498	1	6990
17	1484	6	6990
16	1484	7	6990
8	1484	8	6990
3	783	2	6824
2	550	3	6831
4	1295	1	6833
13	1486	2	6833
17	1486	3	6833
17	1486	4	6833
15	1488	3	6833
3	1295	1	6834
9	1495	2	6834
13	1491	2	6834
4	1487	3	6834
2	1295	1	6835
1	736	2	6846
2	736	1	6846
4	736	1	6847
6	736	1	6848
2	783	2	6848
3	736	1	6849
3	1185	1	6849
9	1498	1	6849
5	1492	2	6849
3	1489	2	6849
5	1489	3	6849
18	1484	5	6849
9	1484	6	6849
14	1488	3	6849
14	1490	2	6849
12	1498	1	6991
11	1486	6	6991
16	1498	1	6992
17	1486	6	6992
13	1498	1	6993
2	1494	1	7005
2	1496	2	7005
12	1488	1	7005
6	1494	1	7006
8	1489	1	7006
9	1485	1	7006
8	1485	2	7006
13	1485	3	7006
1	1485	4	7006
5	1494	1	7007
10	1489	2	7007
12	1489	3	7007
3	1493	1	7012
11	1491	1	7012
1	1487	1	7012
1	1487	2	7012
11	1487	3	7012
7	1493	1	7013
6	1492	1	7013
4	1487	1	7013
6	1493	1	7014
5	1493	1	7015
11	1495	1	7015
12	1492	1	7015
7	1492	2	7015
4	1484	8	3814
1	1489	2	5172
9	1491	1	7015
11	1491	2	7015
12	1496	2	7015
3	1489	1	7015
8	1489	3	7015
7	1487	1	7015
8	1487	2	7015
6	1487	3	7015
3	1484	3	7015
11	1486	1	7015
8	1495	1	7017
1	1495	2	7017
1	1495	1	7018
2	1492	1	7018
8	1491	1	7018
6	1495	1	7019
9	1495	1	7020
11	1485	1	7020
12	1485	2	7020
3	1485	5	7020
7	1495	1	7021
4	1491	1	7021
3	1491	2	7021
10	1496	1	7021
2	1487	2	7021
1	1487	3	7021
4	1495	1	7022
5	1495	2	7023
11	1495	2	7024
3	1495	2	7025
7	1495	2	7026
13	1484	1	7026
4	1495	2	7027
8	1495	2	7028
4	1491	2	7028
4	1497	2	7028
12	1485	5	7028
1	1492	1	7035
5	1489	1	7035
9	1484	1	7035
4	1492	2	7036
9	1492	2	7037
10	1489	3	7037
6	1492	2	7038
2	1496	3	7038
10	1492	2	7039
1	1491	1	7052
7	1491	1	7053
3	1485	4	7053
5	1491	1	7054
12	1487	3	7054
3	1491	1	7055
2	1491	1	7056
10	1491	1	7057
8	1491	2	7058
7	1497	3	7058
7	1491	2	7059
6	1491	2	7060
8	1496	1	7060
5	1489	2	7060
5	1486	1	7060
12	1486	2	7060
10	1486	3	7060
16	1488	2	7060
2	1497	1	7067
2	1497	2	7067
2	1497	3	7067
12	1485	4	7067
7	1497	1	7068
11	1497	3	7068
6	1497	1	7069
8	1497	2	7069
3	1497	3	7069
10	1497	3	7070
5	1484	1	7070
8	1484	2	7070
5	1484	3	7070
14	1484	4	7070
12	1484	5	7070
4	1497	1	7070
5	1497	2	7070
10	1497	1	7071
6	1497	2	7071
9	1497	3	7071
13	1485	4	7071
9	1485	5	7071
2	1485	7	7071
9	1490	2	7071
4	1497	3	7072
9	1497	1	7073
7	1497	2	7073
10	1488	2	7073
10	1488	3	7073
13	1488	4	7073
8	1488	5	7073
5	1497	1	7074
3	1497	2	7074
10	1497	2	7075
6	1497	3	7075
5	1496	1	7075
10	1496	2	7075
16	1486	6	7075
11	1497	2	7076
5	1497	3	7076
8	1497	1	7077
3	1497	1	7078
4	1496	1	7092
11	1496	2	7092
10	1496	3	7092
6	1496	1	7093
4	1496	2	7093
3	1496	2	7094
1	1496	3	7094
7	1489	3	7094
10	1484	2	7094
6	1488	1	7094
5	1488	2	7094
7	1488	3	7094
2	1496	1	7095
4	1485	1	7095
10	1485	2	7095
1	1496	1	7096
7	1496	2	7097
6	1496	2	7098
9	1496	2	7099
12	1484	1	7099
5	1484	2	7099
2	1484	3	7099
3	1484	4	7099
17	1484	5	7099
8	1484	6	7099
11	1485	3	7099
10	1485	4	7099
15	1486	1	7099
7	1496	3	7100
6	1496	3	7101
8	1496	3	7102
4	1489	1	7115
9	1489	1	7116
8	1489	2	7117
11	1489	2	7118
9	1487	3	7118
13	1485	5	7118
2	1489	2	7119
3	1489	3	7120
6	1489	3	7121
4	1489	3	7122
3	1487	1	7137
6	1487	2	7137
10	1487	1	7138
9	1487	2	7138
5	1487	1	7139
9	1487	1	7140
13	1488	1	7140
2	1487	1	7141
14	1488	1	7141
8	1487	1	7142
6	1487	1	7143
4	1485	4	7143
6	1485	5	7143
4	1487	2	7144
7	1487	2	7145
2	1487	3	7146
8	1487	3	7147
3	1512	4	7166
6	1484	1	7167
1	1484	2	7167
4	1484	3	7167
2	1484	4	7167
5	1484	5	7167
13	1486	1	7167
12	1484	3	7168
12	1484	4	7168
2	1484	5	7168
4	1484	6	7168
11	1484	7	7168
14	1486	3	7168
14	1486	4	7168
20	1486	5	7168
1	1486	6	7168
9	1488	3	7168
12	1488	5	7168
5	1490	1	7168
7	1490	2	7168
7	1490	3	7168
1	1490	4	7168
1	1490	5	7168
3	1484	1	7169
6	1484	2	7169
11	1484	1	7170
2	1484	2	7170
10	1484	3	7170
8	1486	1	7170
11	1484	2	7171
8	1484	3	7171
8	1484	4	7171
19	1484	5	7171
2	1486	1	7171
2	1486	2	7171
1	1486	3	7171
5	1488	1	7171
1	1488	3	7171
1	1488	4	7171
1	1488	5	7171
11	1484	4	7172
6	1484	5	7172
7	1484	6	7172
3	1484	7	7172
7	1484	5	7173
6	1484	6	7173
2	1484	8	7173
18	1486	2	7173
13	1488	3	7173
5	1488	4	7173
3	1490	1	7173
11	1490	2	7173
15	1484	3	7173
6	1484	4	7173
10	1484	5	7174
12	1484	6	7174
6	1484	7	7174
5	1484	8	7174
7	1485	6	7174
19	1486	5	7174
3	1490	4	7174
10	1484	1	7175
4	1484	2	7175
8	1484	5	7176
13	1484	6	7176
5	1484	7	7176
7	1490	5	7177
9	1484	5	7177
14	1484	6	7177
4	1484	7	7177
15	1488	2	7177
15	1488	4	7177
13	1490	2	7177
9	1490	3	7177
8	1490	4	7177
16	1484	5	7178
5	1484	6	7178
2	1484	1	7179
8	1484	1	7180
12	1485	1	7180
12	1484	2	7181
14	1484	3	7181
17	1486	1	7181
15	1484	5	7182
10	1484	6	7182
6	1486	2	7182
6	1486	3	7182
13	1484	5	7183
11	1484	6	7183
15	1484	6	7184
7	1484	7	7184
13	1486	3	7184
2	1486	4	7184
13	1486	5	7184
14	1486	6	7184
12	1488	3	7184
5	1490	3	7184
5	1490	4	7184
4	1490	5	7184
7	1484	1	7185
4	1484	1	7186
6	1485	1	7186
1	1485	2	7186
1	1485	3	7186
2	1485	4	7186
7	1484	2	7187
6	1484	3	7188
10	1484	4	7189
13	1484	4	7190
9	1486	1	7190
3	1486	2	7190
10	1488	1	7190
7	1490	1	7190
13	1484	7	7191
14	1484	7	7192
12	1484	7	7193
11	1486	5	7193
4	1486	6	7193
7	1488	5	7193
15	1484	7	7194
14	1488	5	7194
5	1490	5	7194
7	1485	7	7224
5	1485	1	7224
2	1485	2	7224
5	1485	3	7224
6	1488	2	7257
10	1488	4	7257
18	1486	3	7258
7	1486	4	7258
1	1486	5	7258
9	1486	6	7258
9	1488	2	7258
2	1488	3	7258
4	1488	4	7258
2	1488	5	7258
7	1486	1	7259
1	1486	2	7259
2	1486	3	7259
13	1486	4	7259
8	1490	2	7259
14	1490	3	7259
10	1486	4	7260
5	1486	5	7260
18	1486	6	7260
11	1486	4	7261
6	1486	5	7261
2	1486	6	7261
5	1486	6	7262
16	1486	2	7263
3	1486	3	7263
3	1486	4	7263
13	1488	2	7263
16	1488	3	7263
3	1488	4	7263
13	1488	5	7263
6	1486	4	7264
4	1486	5	7264
12	1486	6	7264
13	1486	6	7265
3	1488	5	7265
16	1486	1	7266
5	1486	2	7266
8	1488	1	7266
4	1490	1	7266
5	1486	3	7267
2	1486	5	7267
11	1486	3	7268
15	1486	4	7268
2	1488	4	7268
19	1486	4	7269
17	1486	5	7269
14	1488	2	7269
5	1488	3	7269
21	1486	4	7270
16	1486	5	7270
11	1490	3	7270
10	1490	4	7270
6	1486	1	7271
15	1486	2	7272
11	1490	1	7272
10	1490	2	7272
20	1486	4	7273
12	1490	2	7273
4	1490	3	7273
2	1490	4	7273
2	1490	5	7273
12	1486	4	7274
18	1486	5	7275
12	1486	5	7276
8	1488	2	7276
15	1486	6	7281
7	1486	6	7310
6	1488	3	7310
6	1488	4	7310
9	1488	4	7311
5	1488	5	7311
11	1488	4	7312
11	1488	5	7312
4	1488	5	7313
9	1488	1	7314
12	1488	2	7315
8	1490	1	7346
5	1490	2	7346
6	1490	3	7346
4	1490	4	7346
3	1490	5	7346
12	1490	3	7347
7	1490	4	7347
9	1490	4	7348
10	1490	5	7348
9	1490	5	7349
15	1490	2	7350
1	1490	3	7350
10	1490	3	7351
12	1490	4	7351
13	1490	3	7352
6	1490	4	7352
2	1490	2	7353
6	1490	2	7354
12	1490	1	7355
1	1518	1	7378
2	1518	1	7382
1	1544	1	7457
2	1544	1	7458
2	865	2	7537
3	865	2	7540
5	1491	2	2382
3	1002	1	2401
3	1002	2	2401
3	1002	3	2401
3	1002	4	2401
1	1496	2	2407
3	1496	3	2407
3	1192	1	2409
6	1485	3	2420
2	1373	1	2421
5	364	2	2508
5	364	4	2508
4	364	1	3157
1	364	2	3157
4	364	7	3157
1	789	2	3157
1	529	1	3204
1	1485	1	3319
2	1377	1	3548
1	1377	1	3614
1	1493	1	3629
1	1489	1	3629
11	1488	1	2601
10	1485	6	2795
6	529	1	2795
11	1499	1	2795
3	1131	1	2841
5	550	3	2841
2	550	2	2859
12	1491	2	1999
1	466	1	2041
16	1488	4	2081
10	1488	5	2081
4	130	1	2174
4	550	1	2174
3	550	2	2174
6	550	3	2174
6	1377	1	2174
5	1492	1	2946
8	1497	3	3060
5	1485	5	1626
1	1485	6	1626
5	550	1	1641
9	1499	1	1751
1	1492	2	1797
6	517	3	1825
1	517	4	1825
1	550	2	1868
12	1486	1	1917
3	1488	1	1917
9	1490	1	1917
6	1485	4	7224
1	1485	5	7224
3	1485	6	7224
13	1485	2	7225
3	1485	3	7225
8	1485	4	7225
8	1485	5	7225
9	1485	6	7225
4	1485	7	7225
7	1485	1	7226
3	1485	2	7226
3	1485	1	7227
7	1485	2	7227
6	1485	2	7228
4	1485	3	7228
8	1485	3	7229
5	1485	4	7229
10	1485	5	7229
11	1485	2	7230
7	1485	3	7230
2	1485	5	7230
14	1485	1	7231
9	1485	3	7231
9	1485	2	7232
10	1485	3	7232
4	1485	5	7233
5	1485	7	7233
6	1485	6	7234
10	1485	7	7234
13	1485	1	7235
12	1485	3	7236
14	1485	5	7237
4	1485	6	7238
5	1485	6	7239
11	1485	7	7240
8	1485	7	7241
6	1485	7	7242
4	1486	2	7257
4	1486	3	7257
9	1486	4	7257
15	1486	5	7257
10	1486	6	7257
1	1577	1	7617
2	1577	1	7618
3	1577	1	7620
1	1578	1	6689
1	466	2	2041
2	466	2	7666
3	466	2	7667
4	466	2	7668
1	1149	2	6808
2	1149	2	6806
3	1149	2	7734
4	1149	2	6595
5	1149	2	7735
1	1637	1	2660
2	1637	1	7836
3	1637	1	7839
4	1637	1	7841
1	46	1	3274
1	1002	5	5309
2	1002	5	5310
3	1002	5	616
4	1002	5	2401
\.


--
-- Data for Name: seasons_writers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.seasons_writers (ordering, show_id, season, writer_id) FROM stdin;
1	1497	1	5446
1	1497	2	5446
1	1497	3	5446
5	197	1	1084
1	807	1	1305
1	807	2	1305
4	167	4	6005
5	609	2	6005
3	550	1	6005
7	1512	4	6009
3	1512	3	6009
1	364	6	5311
1	364	7	5311
4	364	8	5312
2	364	1	5312
2	364	2	5312
2	364	3	5312
2	364	4	5312
2	364	5	5312
2	364	6	5312
2	364	7	5312
2	1490	1	5316
1	1490	2	5316
1	1490	3	5316
1	1484	1	5316
1	1484	2	5316
1	1484	3	5316
1	1484	4	5316
1	1484	6	5316
1	1490	1	1443
11	1484	7	5316
2	1484	8	5316
1	1486	2	5317
1	1486	3	5317
2	1488	1	5317
1	1488	2	5317
3	1490	1	5317
2	1484	1	5317
2	1484	2	5317
1	1486	1	5317
8	517	2	5317
2	1485	1	5336
1	1485	2	5336
1	1485	3	5336
1	1485	4	5336
1	1485	5	5336
1	1485	6	5336
14	1485	7	5336
3	1485	1	5337
2	1485	2	5337
2	1485	3	5337
2	1485	4	5337
2	1485	5	5337
2	1485	6	5337
1	1499	1	5346
7	1484	1	5346
9	1484	2	5346
2	1486	1	5346
1	1488	1	5363
1	1489	1	5378
1	1489	2	5378
1	1489	3	5378
1	1182	1	5272
1	1198	1	5273
2	1198	1	5274
3	844	1	5275
1	1185	1	5275
1	1498	1	5453
7	1485	1	5496
7	1485	2	5496
1	1492	2	5573
4	167	3	5626
5	167	4	5626
19	1486	2	5692
9	1486	3	5692
14	1486	5	5692
9	1485	2	5745
6	1485	3	5745
8	1185	1	5276
1	736	2	5292
1	601	1	5293
3	423	1	5293
1	197	1	5294
1	453	1	5295
1	1192	1	5296
2	1192	1	5297
1	972	1	5298
1	309	1	5299
7	309	2	5299
2	309	1	5300
8	309	2	5300
1	740	3	5301
1	740	1	5301
1	740	2	5301
12	1484	2	5302
4	601	1	5302
1	104	1	5302
2	104	2	5302
3	104	3	5302
1	423	1	5303
1	844	1	5304
6	844	2	5304
7	844	3	5304
1	536	1	5305
1	248	1	5306
2	248	1	5307
4	1485	4	5745
7	1485	5	5745
6	1485	6	5745
2	1485	7	5745
11	517	1	5745
12	517	2	5745
4	844	1	5817
2	197	1	5911
3	167	3	5956
4	517	1	5956
3	517	2	5956
7	517	4	5956
4	167	1	5956
2	167	4	5956
2	167	2	5956
4	167	2	5957
1	167	3	5957
1	517	1	5957
13	517	2	5957
2	517	3	5957
3	167	4	5957
13	517	1	5958
7	167	3	6005
2	1512	1	6009
2	1512	2	6009
6	783	1	6027
1	1502	1	6047
2	1502	1	6048
3	1502	1	6049
3	536	1	6076
1	517	5	6077
12	1486	2	6088
13	1484	1	6088
10	1484	2	6088
2	807	1	6098
3	807	2	6098
6	1491	1	6140
2	1491	2	6140
3	583	1	6157
2	423	1	6158
6	167	3	6193
2	517	7	6193
9	517	4	6193
3	517	5	6193
6	1002	2	6256
4	1002	3	6256
5	1002	4	6256
3	197	1	6290
6	517	1	6387
1	517	2	6387
4	536	1	6453
7	1488	1	6456
7	781	1	6516
4	364	2	6539
3	364	3	6539
1	1512	4	6569
1	1512	3	6569
1	1512	1	6569
1	1512	2	6569
5	1512	4	6571
2	1512	3	6583
5	1512	1	6583
4	1512	2	6583
2	1512	4	6583
4	1512	3	6584
7	1512	2	6584
3	1512	1	6586
6	1512	2	6586
6	1512	4	6587
4	1512	1	6587
3	1512	2	6587
3	1512	4	6588
6	1512	1	6588
8	1512	2	6588
5	1512	2	6589
9	1512	2	6590
8	1495	1	6593
2	1495	2	6593
4	1502	1	6593
3	248	1	5308
1	1002	1	5309
1	1002	2	5309
1	1002	3	5309
1	1002	4	5309
2	1002	1	5310
2	1002	2	5310
2	1002	3	5310
2	1002	4	5310
3	364	8	5311
1	364	1	5311
1	364	2	5311
1	364	3	5311
4	1182	1	6593
2	1182	1	6596
3	1182	1	6597
5	1182	1	6598
6	1182	1	6599
7	1182	1	6600
2	453	1	6602
2	536	1	6602
5	536	1	6603
2	972	1	6607
3	972	1	6608
4	972	1	6609
5	972	1	6610
6	972	1	6611
7	972	1	6612
3	453	1	6616
4	453	1	6617
8	1343	1	6617
5	583	1	6617
3	529	1	5277
3	529	2	5277
1	529	3	5277
1	1149	1	5277
2	1149	1	5278
1	529	1	5279
1	529	2	5279
3	1149	1	5279
1	1075	1	5280
1	905	1	5281
1	905	2	5281
2	905	1	5282
2	905	2	5282
1	1094	1	5283
1	865	1	5284
1	865	2	5284
2	865	1	5285
2	865	2	5285
1	783	1	5286
7	783	2	5286
2	783	1	5287
8	783	2	5287
1	789	1	5288
1	789	2	5288
5	364	1	5289
5	364	2	5289
5	364	3	5289
3	364	4	5289
1	781	1	5290
1	736	1	5291
11	736	2	5291
3	736	1	5292
1	364	4	5311
1	364	5	5311
4	1490	1	5388
2	1490	2	5388
2	1490	3	5388
1	1490	4	5388
1	1491	1	5403
1	1491	2	5403
1	1494	1	5409
1	1492	1	5409
5	1487	1	5414
1	1487	2	5414
1	1493	1	5414
14	517	2	5414
2	1487	1	5415
2	1487	2	5415
2	1493	1	5415
1	1495	2	5420
1	1495	1	5420
1	1496	1	5429
1	1496	2	5429
2	1496	1	5430
2	1496	2	5430
6	601	1	6618
5	453	1	6618
10	609	2	6618
6	453	1	6619
7	453	1	6620
8	453	1	6621
4	423	1	6623
1	423	2	6623
5	423	1	6624
2	423	2	6626
3	423	2	6627
4	423	2	6628
4	197	1	6630
7	601	1	6633
5	601	1	6634
2	104	1	6634
1	104	2	6634
2	104	3	6634
8	601	1	6635
2	601	1	6636
3	601	1	6637
2	1075	1	6639
4	1075	1	6640
3	1075	1	6641
2	1202	1	6646
3	1202	1	6647
9	865	2	6647
7	1365	1	6650
2	1365	1	6651
7	1295	1	6652
3	1365	1	6652
9	1365	1	6653
5	1365	1	6654
6	1365	1	6655
6	789	1	6655
4	1365	1	6656
9	1485	1	6656
4	1485	2	6656
4	1485	3	6656
3	1198	1	6656
8	1365	1	6657
3	905	2	6668
2	1343	1	6671
9	583	1	6671
7	1343	1	6672
5	1343	1	6673
6	1343	1	6674
4	1343	1	6675
6	309	2	6675
3	1343	1	6676
8	1295	1	6676
8	583	1	6676
4	550	1	6677
3	550	2	6677
4	807	1	6686
2	807	2	6686
4	807	2	6687
3	807	1	6688
3	104	2	6691
1	104	3	6691
8	309	1	6697
4	309	1	6698
5	309	1	6699
5	309	2	6700
3	309	2	6701
3	309	1	6702
2	309	2	6702
4	309	2	6703
6	309	1	6704
1	309	2	6704
4	1185	1	6704
7	309	1	6705
7	248	1	6708
4	248	1	6709
5	248	1	6710
6	248	1	6711
8	248	1	6712
1	364	8	6727
3	364	5	6727
3	364	6	6727
4	364	7	6727
4	364	3	6728
2	364	8	6728
3	364	1	6728
3	364	2	6728
4	364	4	6728
4	364	5	6728
3	364	7	6728
4	364	6	6728
4	364	1	6729
9	1489	3	6729
8	1489	2	6734
2	789	1	6734
4	789	2	6738
5	789	1	6739
2	789	2	6739
7	789	1	6740
5	789	2	6740
5	1295	1	6740
3	789	2	6741
4	789	1	6742
3	1295	1	6742
3	789	1	6743
10	517	1	6758
11	517	2	6758
12	1484	1	6758
8	1484	2	6758
5	1485	2	6758
7	1485	3	6758
3	1485	4	6758
6	1485	5	6758
14	1485	6	6758
11	1485	7	6758
8	517	1	6759
4	517	3	6759
10	517	4	6759
1	517	6	6759
8	517	4	6760
2	517	5	6760
2	517	6	6760
5	609	1	6760
8	1491	1	6760
8	517	3	6760
1	517	7	6761
2	609	3	6761
9	517	3	6761
6	517	4	6761
6	167	4	6761
3	167	2	6761
4	609	2	6761
4	609	1	6761
2	167	3	6761
4	517	7	6762
4	517	5	6762
5	1494	1	6762
5	167	1	6762
3	1491	1	6762
3	517	3	6763
15	517	1	6763
7	517	2	6763
2	517	1	6764
2	517	2	6764
7	517	3	6765
2	517	4	6765
5	517	3	6766
4	517	4	6766
6	517	3	6767
5	517	4	6767
1	517	3	6768
10	517	3	6769
3	517	4	6769
1	517	4	6770
5	517	2	6771
12	517	1	6772
6	517	2	6772
7	517	1	6773
3	517	6	6774
3	517	1	6775
5	517	1	6776
9	517	1	6777
4	517	2	6778
5	1484	1	6778
6	1484	2	6778
6	1484	3	6778
2	1484	4	6778
1	1484	5	6778
2	1484	6	6778
9	517	2	6779
10	517	2	6780
14	517	1	6781
5	609	3	6785
3	167	1	6786
5	167	2	6786
2	167	1	6787
6	167	2	6788
7	167	4	6789
1	609	3	6790
1	609	2	6790
2	609	1	6790
4	609	3	6791
3	609	2	6791
7	609	1	6791
3	609	3	6792
6	609	2	6792
7	609	2	6793
8	609	1	6793
6	609	1	6794
7	1492	1	6794
4	1496	1	6794
10	1487	3	6794
3	609	1	6795
7	1250	1	6795
2	609	2	6796
8	609	2	6797
18	1486	2	6797
2	1486	3	6797
9	609	2	6798
6	529	1	6811
5	529	2	6811
6	529	3	6811
3	529	4	6811
6	529	2	6812
3	529	3	6812
6	529	4	6812
5	529	1	6813
2	529	2	6813
2	529	3	6814
1	529	4	6814
8	529	3	6815
7	529	4	6815
7	529	3	6816
2	529	4	6816
7	1149	1	6816
4	529	1	6817
4	529	3	6818
4	529	4	6818
2	529	1	6819
4	529	2	6820
5	529	3	6821
9	529	3	6822
5	529	4	6823
5	1486	3	6823
6	1486	4	6823
4	1486	5	6823
10	1149	1	6825
9	1149	1	6826
5	1149	1	6827
8	1149	1	6828
6	1149	1	6829
4	1149	1	6830
2	550	3	6832
4	1295	1	6836
2	1295	1	6837
9	1295	1	6838
6	1295	1	6839
10	1295	1	6840
3	1377	1	6841
6	583	1	6842
4	583	1	6843
2	583	1	6844
7	583	1	6845
7	736	1	6853
7	736	2	6854
10	736	1	6854
12	736	1	6855
6	736	2	6856
4	736	1	6856
4	736	2	6857
5	736	1	6857
9	736	1	6858
2	736	2	6859
6	736	1	6859
8	736	1	6860
9	1462	1	6860
8	736	2	6861
11	736	1	6861
3	1518	1	6864
2	781	1	6864
4	1518	1	6865
3	781	1	6865
5	781	1	6866
8	781	1	6867
6	781	1	6868
4	781	1	6869
3	1432	1	6872
2	1432	1	6873
4	1462	1	6876
3	1484	7	6876
3	1484	8	6876
6	1462	1	6877
5	1462	1	6878
7	1462	1	6879
9	1484	3	6879
4	1486	1	6879
10	1486	2	6879
12	1486	3	6879
8	1490	1	6879
5	1490	2	6879
4	1490	3	6879
2	1490	4	6879
3	1490	5	6879
8	1462	1	6880
5	783	1	6882
6	783	2	6882
4	1002	1	6882
3	1002	2	6882
4	783	1	6883
2	783	2	6883
3	783	1	6884
1	783	2	6884
7	783	1	6885
5	783	2	6885
4	783	2	6886
3	783	2	6887
5	844	3	6887
2	844	1	6901
1	844	2	6901
1	844	3	6901
4	844	2	6902
2	844	3	6902
6	844	1	6903
6	1002	3	6903
6	1002	4	6903
5	844	1	6904
3	865	2	6905
2	844	2	6905
5	865	1	6905
3	844	2	6906
5	844	2	6907
4	844	3	6908
6	844	3	6909
3	844	3	6910
7	1488	5	6910
8	865	2	6912
3	865	1	6912
4	865	1	6913
4	1002	2	6916
5	1002	3	6916
4	1002	4	6916
6	1002	1	6917
5	1002	2	6917
3	1002	4	6918
3	1002	1	6919
5	1002	1	6920
3	1002	3	6921
2	1094	1	6926
7	1094	1	6927
6	1094	1	6928
4	1094	1	6929
3	1094	1	6930
5	1094	1	6931
2	1185	1	6934
3	1185	1	6935
5	1185	1	6936
6	1185	1	6937
14	1488	5	6937
7	1185	1	6938
5	1192	1	6942
4	1192	1	6943
3	1192	1	6944
4	1198	1	6947
5	1198	1	6948
6	1198	1	6949
6	1250	1	6951
5	1250	1	6952
3	1250	1	6953
4	1250	1	6954
8	1350	1	6958
5	1350	1	6959
2	1350	1	6960
4	1350	1	6961
6	1350	1	6962
7	1350	1	6963
3	1350	1	6964
10	1484	1	6967
7	1499	1	6974
5	1499	1	6975
3	1499	1	6976
4	1499	1	6977
2	1499	1	6978
6	1499	1	6979
10	1498	1	6994
16	1488	4	6994
7	1498	1	6995
11	1498	1	6996
11	1490	3	6996
11	1490	4	6996
6	1498	1	6997
9	1498	1	6998
4	1498	1	6999
8	1498	1	7000
2	1498	1	7001
3	1498	1	7002
5	1498	1	7003
12	1498	1	7004
2	1494	1	7008
4	1494	1	7009
3	1492	1	7009
4	1489	1	7009
8	1489	3	7009
6	1494	1	7010
2	1492	1	7010
7	1496	1	7010
8	1496	2	7010
5	1496	3	7010
3	1494	1	7011
3	1493	1	7016
5	1487	2	7016
7	1495	1	7029
3	1495	2	7029
6	1495	1	7030
6	1495	2	7030
4	1495	1	7031
5	1495	2	7031
5	1495	1	7032
7	1495	2	7032
3	1495	1	7033
8	1495	2	7034
5	1492	1	7040
4	1492	2	7041
13	1484	4	7041
10	1484	5	7041
3	1492	2	7042
6	1492	2	7043
8	1492	1	7044
3	1497	1	7044
6	1497	2	7044
3	1497	3	7044
6	1492	1	7045
5	1491	2	7045
4	1492	1	7046
7	1492	2	7047
5	1492	2	7048
8	1492	2	7049
9	1492	2	7050
2	1492	2	7051
2	1491	1	7061
3	1491	2	7061
5	1485	4	7061
9	1485	5	7061
5	1491	1	7062
8	1491	2	7062
4	1491	2	7063
7	1491	1	7064
6	1491	2	7064
2	1489	2	7064
4	1491	1	7065
7	1491	2	7066
6	1497	1	7079
5	1497	2	7079
7	1497	3	7079
7	1497	1	7080
7	1497	2	7080
8	1497	2	7081
9	1497	3	7081
11	1497	3	7082
5	1497	1	7083
2	1497	2	7083
2	1497	3	7083
4	1497	1	7084
4	1497	2	7084
4	1497	3	7084
2	1497	1	7085
3	1497	2	7085
5	1497	3	7086
6	1497	3	7087
9	1497	2	7088
10	1497	3	7088
8	1497	3	7089
12	1497	3	7090
8	1497	1	7091
7	1496	2	7103
6	1496	3	7103
6	1496	1	7104
3	1496	2	7105
2	1496	3	7105
5	1496	2	7106
1	1496	3	7106
4	1496	2	7107
3	1496	3	7107
9	1496	1	7108
9	1496	2	7108
7	1496	3	7108
5	1496	1	7109
3	1496	1	7110
4	1496	3	7111
6	1496	2	7112
8	1496	1	7113
8	1496	3	7114
9	1489	1	7123
5	1489	2	7123
4	1489	3	7123
6	1489	3	7124
8	1489	1	7125
5	1489	3	7126
6	1488	5	7126
5	1489	1	7127
7	1489	2	7127
2	1489	3	7127
3	1489	2	7128
3	1489	3	7128
6	1489	1	7129
2	1489	1	7130
3	1489	1	7131
4	1489	2	7132
6	1489	2	7133
7	1489	3	7134
7	1489	1	7135
9	1489	2	7136
4	1487	1	7148
7	1487	2	7148
8	1487	1	7149
7	1487	1	7150
8	1487	2	7151
6	1487	2	7152
6	1487	3	7153
5	1487	3	7154
8	1484	7	7154
7	1487	3	7155
1	1487	3	7156
4	1484	3	7156
3	1487	1	7157
4	1487	2	7158
3	1487	2	7159
2	1487	3	7160
9	1487	3	7161
8	1487	3	7162
3	1487	3	7163
4	1487	3	7164
8	1484	3	7195
7	1484	4	7195
6	1484	5	7195
8	1484	1	7196
4	1484	2	7196
5	1484	3	7196
5	1484	4	7196
3	1484	5	7196
3	1484	6	7196
1	1484	7	7196
1	1484	8	7196
7	1490	1	7196
10	1484	4	7197
8	1484	5	7197
6	1484	6	7197
6	1484	7	7197
4	1484	8	7197
11	1484	3	7198
8	1484	4	7198
7	1484	5	7198
5	1484	6	7198
2	1484	7	7198
7	1484	8	7198
10	1484	3	7199
9	1484	4	7199
5	1484	5	7199
7	1484	6	7199
7	1484	7	7199
5	1484	8	7199
12	1488	5	7199
11	1484	4	7200
11	1484	5	7200
10	1484	6	7200
4	1484	7	7200
13	1484	8	7200
6	1484	1	7201
3	1484	2	7201
7	1484	3	7201
6	1484	4	7201
4	1484	5	7201
8	1484	6	7201
11	1486	1	7201
9	1486	2	7201
4	1484	4	7202
2	1484	5	7202
4	1484	6	7202
5	1484	2	7203
3	1484	3	7203
3	1484	4	7203
13	1486	1	7203
7	1490	2	7203
3	1490	3	7203
3	1490	4	7203
1	1490	5	7203
11	1484	1	7204
7	1484	2	7204
2	1484	3	7204
12	1484	5	7205
12	1484	6	7205
14	1484	7	7205
6	1484	8	7205
4	1484	1	7206
10	1484	7	7207
10	1484	8	7207
15	1486	2	7207
8	1486	3	7207
5	1484	7	7208
11	1484	8	7208
9	1484	7	7209
9	1484	8	7209
14	1486	2	7209
7	1486	3	7209
3	1484	1	7210
9	1484	6	7211
11	1484	6	7212
12	1484	7	7212
8	1484	8	7212
13	1484	7	7213
14	1484	1	7214
9	1484	1	7215
16	1486	1	7215
2	1486	2	7215
11	1484	2	7216
13	1484	2	7217
12	1484	4	7218
9	1484	5	7219
14	1484	6	7220
10	1490	3	7220
8	1490	4	7220
7	1490	5	7220
13	1484	6	7221
9	1490	3	7221
9	1490	4	7221
2	1490	5	7221
12	1484	8	7222
14	1484	8	7223
11	1485	1	7243
10	1485	2	7243
3	1485	3	7243
9	1485	4	7243
3	1485	5	7243
10	1485	6	7243
7	1485	7	7243
12	1485	3	7244
13	1485	4	7244
11	1485	5	7244
4	1485	6	7244
10	1485	7	7244
12	1485	4	7245
10	1485	5	7245
3	1485	6	7245
9	1485	7	7245
11	1485	3	7246
14	1485	4	7246
12	1485	5	7246
9	1485	6	7246
1	1485	7	7246
5	1485	1	7247
6	1485	2	7247
9	1485	3	7247
11	1485	4	7247
8	1485	5	7247
5	1485	6	7247
8	1485	7	7247
15	1485	5	7248
11	1485	6	7248
5	1485	7	7248
4	1485	1	7249
11	1485	2	7249
10	1485	3	7249
8	1485	4	7249
13	1485	5	7249
12	1485	6	7249
13	1485	7	7249
6	1485	1	7250
3	1485	2	7250
5	1485	3	7250
10	1485	4	7250
7	1485	4	7251
5	1485	5	7251
8	1485	6	7251
4	1485	7	7251
6	1485	4	7252
4	1485	5	7252
7	1485	6	7252
3	1485	7	7252
14	1485	5	7253
13	1485	6	7253
6	1485	7	7253
10	1485	1	7254
13	1485	3	7255
12	1485	7	7256
16	1486	3	7277
13	1486	4	7277
12	1486	5	7277
9	1486	6	7277
14	1486	4	7278
13	1486	5	7278
4	1486	6	7278
16	1486	2	7279
11	1486	3	7279
9	1486	4	7279
8	1486	5	7279
7	1486	6	7279
13	1486	6	7280
7	1486	4	7282
10	1486	5	7282
8	1486	6	7282
13	1488	2	7282
10	1486	4	7283
11	1486	5	7283
12	1486	6	7283
8	1486	4	7284
9	1486	5	7284
6	1486	6	7284
13	1486	2	7285
6	1486	3	7285
5	1486	1	7286
7	1486	2	7286
7	1486	1	7287
4	1486	2	7287
4	1486	3	7287
1	1486	4	7287
1	1486	5	7287
6	1486	1	7288
3	1486	2	7288
3	1486	3	7288
12	1486	1	7289
6	1486	2	7289
3	1486	4	7290
5	1486	5	7290
10	1486	6	7290
5	1486	4	7291
2	1486	5	7291
3	1486	6	7291
2	1486	4	7292
4	1488	3	7322
4	1488	4	7323
10	1488	5	7323
12	1488	1	7324
3	1488	2	7324
1	1488	3	7324
11	1488	4	7324
2	1488	4	7325
13	1488	1	7326
2	1488	2	7326
5	1488	3	7326
12	1488	4	7326
8	1488	2	7327
3	1488	3	7327
1	1488	4	7327
9	1488	4	7328
3	1488	5	7328
5	1488	4	7329
9	1488	5	7329
6	1488	2	7330
7	1488	3	7330
15	1488	4	7331
5	1488	5	7331
5	1488	1	7332
3	1488	1	7333
4	1488	1	7334
14	1488	1	7335
12	1488	2	7335
10	1488	3	7335
6	1488	1	7336
3	1488	4	7337
14	1488	4	7338
15	1488	5	7338
11	1488	1	7339
14	1488	2	7340
13	1488	4	7340
13	1488	5	7341
11	1488	5	7342
14	1488	3	7343
12	1488	3	7344
15	1488	3	7345
9	1490	5	7356
8	1490	3	7357
6	1490	4	7357
8	1490	5	7357
7	1490	3	7358
4	1490	4	7358
6	1490	5	7358
12	1490	1	7358
8	1490	2	7358
5	1490	3	7359
5	1490	4	7359
4	1490	5	7359
11	1490	5	7360
5	1490	1	7361
3	1490	2	7361
6	1490	1	7362
4	1490	2	7362
10	1490	1	7363
9	1490	2	7363
10	1490	4	7364
10	1490	5	7364
10	1490	2	7365
12	1490	5	7366
1	1518	1	7379
2	1518	1	7380
5	1518	1	7381
6	1518	1	7383
5	167	3	7388
3	736	2	7445
5	736	2	7446
9	736	2	7447
10	736	2	7448
1	1544	1	7459
2	1544	1	7460
4	865	2	7538
5	865	2	7539
6	865	2	7541
7	865	2	7542
1	1485	1	3319
4	1493	1	3602
1	1487	1	3602
1	1377	1	3614
1	167	1	3690
8	167	4	3690
1	167	2	3690
2	130	1	3726
1	1131	1	3726
8	167	3	3726
3	517	7	3726
15	517	2	3726
1	167	4	3726
1	609	1	3726
2	550	1	3726
2	550	2	3726
3	550	3	3726
4	1512	4	4980
1	1462	1	5259
2	1495	1	5259
4	1495	2	5259
2	1462	1	5260
3	1462	1	5261
1	1432	1	5262
2	1377	1	5263
1	1365	1	5264
3	1486	1	5265
1	1350	1	5266
8	1485	1	5266
8	1485	2	5266
8	1485	3	5266
1	1343	1	5267
1	583	1	5267
1	1295	1	5268
1	1202	1	5269
1	1373	1	2041
1	466	1	2041
1	1250	1	5270
2	1250	1	5271
6	1487	1	1763
1	130	1	1868
1	550	1	1868
1	550	2	1868
1	550	3	1868
2	736	1	1882
3	1486	5	7292
1	1486	6	7292
4	1486	4	7293
6	1486	5	7293
11	1486	6	7293
7	1486	5	7294
2	1486	6	7294
5	1486	6	7295
8	1486	2	7296
9	1486	1	7297
10	1486	1	7298
5	1486	2	7299
15	1486	1	7300
11	1490	1	7300
16	1488	3	7301
9	1490	1	7301
6	1490	2	7301
6	1490	3	7301
7	1490	4	7301
5	1490	5	7301
14	1486	1	7301
10	1486	3	7302
17	1486	2	7303
15	1486	3	7304
14	1486	3	7305
13	1486	3	7306
11	1486	4	7307
12	1486	4	7308
8	1486	1	7309
11	1486	2	7309
9	1488	1	7316
5	1488	2	7316
6	1488	3	7316
6	1488	4	7316
1	1488	5	7316
10	1488	2	7317
11	1488	3	7317
8	1488	4	7317
8	1488	5	7317
7	1488	2	7318
9	1488	3	7318
10	1488	4	7318
11	1488	2	7319
8	1488	3	7319
7	1488	4	7319
4	1488	5	7319
13	1488	3	7320
2	1488	5	7320
8	1488	1	7321
4	1488	2	7321
2	1488	3	7321
10	1488	1	7322
9	1488	2	7322
1	1577	1	7617
2	1577	1	7619
3	1577	1	6843
4	1577	1	7621
5	1577	1	5591
6	1577	1	7622
1	1578	1	6516
1	466	2	2041
1	1149	2	6811
2	1149	2	6816
3	1149	2	6676
4	1149	2	6827
5	1149	2	7255
6	1149	2	6826
7	1149	2	6825
8	1149	2	7735
9	1149	2	7736
10	1149	2	7737
1	1637	1	5539
2	1637	1	6857
3	1637	1	7837
4	1637	1	7838
5	1637	1	6887
6	1637	1	7840
7	1637	1	7842
1	46	1	3274
2	46	1	5563
1	1002	5	5309
2	1002	5	5310
3	1002	5	6918
4	1002	5	6916
5	1002	5	6903
6	1002	5	6256
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, is_admin, email, password, rating_scale) FROM stdin;
1	t	austinrock03@gmail.com	$2a$12$AOV0G6DRHhHgUdKAJvNgE.L3vyBjM.6xfjO0rZQKCetMoJPfnEz5S	3
\.


--
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.people_id_seq', 7637, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: media_cast media_cast_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_cast
    ADD CONSTRAINT media_cast_pk PRIMARY KEY (media_id, actor_id);


--
-- Name: media_directors media_directors_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_directors
    ADD CONSTRAINT media_directors_pk PRIMARY KEY (media_id, director_id);


--
-- Name: media media_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_id_key UNIQUE (id);


--
-- Name: media media_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id);


--
-- Name: media_writers media_writers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_writers
    ADD CONSTRAINT media_writers_pkey PRIMARY KEY (media_id, writer_id);


--
-- Name: people people_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pk PRIMARY KEY (id);


--
-- Name: seasons_directors season_directors_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_directors
    ADD CONSTRAINT season_directors_pk PRIMARY KEY (show_id, season, director_id);


--
-- Name: seasons_cast seasons_cast_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_cast
    ADD CONSTRAINT seasons_cast_pk PRIMARY KEY (season, show_id, actor_id);


--
-- Name: seasons seasons_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pk PRIMARY KEY (season, show_id);


--
-- Name: seasons_writers seasons_writers_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_writers
    ADD CONSTRAINT seasons_writers_pk PRIMARY KEY (show_id, season, writer_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fki_media_cast_actor_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_cast_actor_id_fkey ON public.media_cast USING btree (actor_id);


--
-- Name: fki_media_directors_director_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_directors_director_id_fkey ON public.media_directors USING btree (director_id);


--
-- Name: fki_media_writers_media_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_writers_media_id_fkey ON public.media_writers USING btree (media_id);


--
-- Name: fki_media_writers_writer_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_media_writers_writer_id_fkey ON public.media_writers USING btree (writer_id);


--
-- Name: media_cast_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX media_cast_idx ON public.media_cast USING btree (actor_id) WITH (deduplicate_items='true');


--
-- Name: media_directors_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX media_directors_idx ON public.media_directors USING btree (director_id) WITH (deduplicate_items='true');


--
-- Name: media_cast media_cast_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_cast
    ADD CONSTRAINT media_cast_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- Name: media_cast media_cast_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_cast
    ADD CONSTRAINT media_cast_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: media_directors media_directors_director_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_directors
    ADD CONSTRAINT media_directors_director_id_fkey FOREIGN KEY (director_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- Name: media_directors media_directors_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_directors
    ADD CONSTRAINT media_directors_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: media_writers media_writers_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_writers
    ADD CONSTRAINT media_writers_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: media_writers media_writers_writer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_writers
    ADD CONSTRAINT media_writers_writer_id_fkey FOREIGN KEY (writer_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- Name: seasons_directors season_directors_director_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_directors
    ADD CONSTRAINT season_directors_director_id_fkey FOREIGN KEY (director_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- Name: seasons_directors season_directors_show_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_directors
    ADD CONSTRAINT season_directors_show_id_fkey FOREIGN KEY (show_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: seasons_cast seasons_cast_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_cast
    ADD CONSTRAINT seasons_cast_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- Name: seasons_cast seasons_cast_show_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_cast
    ADD CONSTRAINT seasons_cast_show_id_fkey FOREIGN KEY (show_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: seasons seasons_show_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_show_id_fkey FOREIGN KEY (show_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: seasons_writers seasons_writers_show_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_writers
    ADD CONSTRAINT seasons_writers_show_id_fkey FOREIGN KEY (show_id) REFERENCES public.media(id) ON UPDATE CASCADE;


--
-- Name: seasons_writers seasons_writers_writer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_writers
    ADD CONSTRAINT seasons_writers_writer_id_fkey FOREIGN KEY (writer_id) REFERENCES public.people(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict yVqph0gUKFFOsd38XzbEDQ9Mchef2MSfh0eRqGVPb1axKsiShtVy2CyBLk8rCKz

