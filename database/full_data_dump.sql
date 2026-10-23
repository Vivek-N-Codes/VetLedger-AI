--
-- PostgreSQL database dump
--

\restrict 6LgqrAzNSoidrHrq4w2JeeewBJ4X9DSls0QtQ4iCzim6pluyTL6Oe6h4RKhaw9p

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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

--
-- Data for Name: villages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.villages (id, name, district, state, latitude, longitude, created_at) FROM stdin;
1	Sangamner	Ahmednagar	Maharashtra	19.5772	74.2185	2026-10-22 14:58:13.628864+05:30
2	Rahata	Ahmednagar	Maharashtra	19.6976	74.4921	2026-10-22 14:58:13.634253+05:30
3	Akole	Ahmednagar	Maharashtra	19.5441	73.9961	2026-10-22 14:58:13.634975+05:30
4	Kopargaon	Ahmednagar	Maharashtra	19.8887	74.4789	2026-10-22 14:58:13.635404+05:30
5	Shrirampur	Ahmednagar	Maharashtra	19.6198	74.6599	2026-10-22 14:58:13.635755+05:30
\.


--
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.owners (id, owner_code, full_name, contact_number, email, address, village_id, notes, created_at) FROM stdin;
1	OWN-001	Ramesh Patil	9822011234	\N	Patil Dairy Farm, Sangamner	1	Registered farm owner for Patil Dairy Farm	2026-10-22 20:56:52.704237+05:30
2	OWN-002	Balasaheb Shinde	9822011235	\N	Shinde Livestock, Sangamner	1	Registered farm owner for Shinde Livestock	2026-10-22 20:56:52.704237+05:30
3	OWN-003	Sunil Deshmukh	9822011236	\N	Deshmukh Cattle Yard, Sangamner	1	Registered farm owner for Deshmukh Cattle Yard	2026-10-22 20:56:52.704237+05:30
4	OWN-004	Dattatray Tambe	9822011237	\N	Tambe Agro Farm, Sangamner	1	Registered farm owner for Tambe Agro Farm	2026-10-22 20:56:52.704237+05:30
5	OWN-005	Kishore Thorat	9822011238	\N	Thorat Dairy Complex, Sangamner	1	Registered farm owner for Thorat Dairy Complex	2026-10-22 20:56:52.704237+05:30
6	OWN-006	Ashok Vikhe	9822011239	\N	Vikhe Cattle Station, Sangamner	1	Registered farm owner for Vikhe Cattle Station	2026-10-22 20:56:52.704237+05:30
7	OWN-007	Ganesh Kadam	9822022341	\N	Sai Krupa Dairy, Rahata	2	Registered farm owner for Sai Krupa Dairy	2026-10-22 20:56:52.704237+05:30
8	OWN-008	Nitin Ghadge	9822022342	\N	Godavari Valley Farm, Rahata	2	Registered farm owner for Godavari Valley Farm	2026-10-22 20:56:52.704237+05:30
9	OWN-009	Eknath Navale	9822033451	\N	Sahyadri Cattle Shelter, Akole	3	Registered farm owner for Sahyadri Cattle Shelter	2026-10-22 20:56:52.704237+05:30
10	OWN-010	Pandurang Pichad	9822033452	\N	Pravara River Farm, Akole	3	Registered farm owner for Pravara River Farm	2026-10-22 20:56:52.704237+05:30
11	OWN-011	Sanjay Kolhe	9822044561	\N	Panchvati Dairy, Kopargaon	4	Registered farm owner for Panchvati Dairy	2026-10-22 20:56:52.704237+05:30
12	OWN-012	Vikas Sasane	9822055671	\N	Belapur Green Livestock, Shrirampur	5	Registered farm owner for Belapur Green Livestock	2026-10-22 20:56:52.704237+05:30
13	OWN-013	Narayan Rao	+91 99220 99999	\N	\N	1	Created during farm registration	2026-10-22 23:00:53.250523+05:30
14	OWN-014	Pandurang Patil	+91 98811 22334	\N	Survey 104, Sangamner Bypass	1	Farmer registered with farm: Surya Valley Agro	2026-10-22 23:08:30.10245+05:30
15	OWN-015	Vivek Nehe	7878841232	\N	Sangamner, new nagar road	1	Farmer registered with farm: Vivek Dairy Farm	2026-10-22 23:12:31.083571+05:30
\.


--
-- Data for Name: farms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.farms (id, farm_code, farm_name, owner_name, contact_number, village_id, latitude, longitude, created_at, owner_id, address, notes) FROM stdin;
1	FARM-SNG-01	Patil Dairy Farm	Ramesh Patil	9822011234	1	19.578	74.219	2026-10-22 14:58:13.639001+05:30	1	\N	\N
2	FARM-SNG-02	Shinde Livestock	Balasaheb Shinde	9822011235	1	19.5765	74.217	2026-10-22 14:58:13.641725+05:30	2	\N	\N
3	FARM-SNG-03	Deshmukh Cattle Yard	Sunil Deshmukh	9822011236	1	19.5795	74.221	2026-10-22 14:58:13.642226+05:30	3	\N	\N
4	FARM-SNG-04	Tambe Agro Farm	Dattatray Tambe	9822011237	1	19.575	74.2155	2026-10-22 14:58:13.642712+05:30	4	\N	\N
5	FARM-SNG-05	Thorat Dairy Complex	Kishore Thorat	9822011238	1	19.581	74.223	2026-10-22 14:58:13.643243+05:30	5	\N	\N
6	FARM-SNG-06	Vikhe Cattle Station	Ashok Vikhe	9822011239	1	19.574	74.214	2026-10-22 14:58:13.64396+05:30	6	\N	\N
7	FARM-RHT-01	Sai Krupa Dairy	Ganesh Kadam	9822022341	2	19.698	74.493	2026-10-22 14:58:13.644914+05:30	7	\N	\N
8	FARM-RHT-02	Godavari Valley Farm	Nitin Ghadge	9822022342	2	19.6965	74.491	2026-10-22 14:58:13.64552+05:30	8	\N	\N
9	FARM-AKL-01	Sahyadri Cattle Shelter	Eknath Navale	9822033451	3	19.545	73.997	2026-10-22 14:58:13.64593+05:30	9	\N	\N
10	FARM-AKL-02	Pravara River Farm	Pandurang Pichad	9822033452	3	19.543	73.995	2026-10-22 14:58:13.64627+05:30	10	\N	\N
11	FARM-KPG-01	Panchvati Dairy	Sanjay Kolhe	9822044561	4	19.889	74.4795	2026-10-22 14:58:13.646691+05:30	11	\N	\N
12	FARM-SRP-01	Belapur Green Livestock	Vikas Sasane	9822055671	5	19.6205	74.661	2026-10-22 14:58:13.647052+05:30	12	\N	\N
13	FRM-SAN-013	Sahyadri Gold Dairy	Narayan Rao	+91 99220 99999	1	\N	\N	2026-10-22 23:00:53.250523+05:30	13	\N	\N
14	FRM-SAN-014	Surya Valley Agro	Pandurang Patil	+91 98811 22334	1	\N	\N	2026-10-22 23:08:30.10245+05:30	14	Survey 104, Sangamner Bypass	New dairy farm facility
15	FRM-SAN-015	Vivek Dairy Farm	Vivek Nehe	7878841232	1	\N	\N	2026-10-22 23:12:31.083571+05:30	15	Sangamner, new nagar road	\N
\.


--
-- Data for Name: animals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.animals (id, animal_code, name, species, breed, age_years, sex, farm_id, tag_rfid, notes, created_at) FROM stdin;
1	CAT-SNG-001	Shyama	Cattle	Holstein Friesian Cross	2.8	FEMALE	1	RFID-982-0000001	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.648028+05:30
2	CAT-SNG-002	Kalyani	Cattle	Sahiwal	3.6	FEMALE	1	RFID-982-0000002	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.650312+05:30
3	BUF-SNG-003	Kamdhenu	Buffalo	Murrah	4.4	FEMALE	1	RFID-982-0000003	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.65099+05:30
4	CAT-SNG-004	Arjun	Cattle	Jersey Cross	5.2	MALE	1	RFID-982-0000004	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.651593+05:30
5	GOA-SNG-005	Manik	Goat	Beetal	6.0	FEMALE	1	RFID-982-0000005	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.653047+05:30
6	BUF-SNG-006	Lakshmi	Buffalo	Murrah	2.0	FEMALE	1	RFID-982-0000006	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.653678+05:30
7	CAT-SNG-007	Shyama	Cattle	Sahiwal	2.8	FEMALE	1	RFID-982-0000007	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.654331+05:30
8	CAT-SNG-008	Bheema	Cattle	Khillari	3.6	MALE	2	RFID-982-0000008	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.654779+05:30
9	BUF-SNG-009	Sonali	Buffalo	Murrah	4.4	FEMALE	2	RFID-982-0000009	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.655123+05:30
10	GOA-SNG-010	Gauri	Goat	Sirohi	5.2	FEMALE	2	RFID-982-0000010	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.655424+05:30
11	CAT-SNG-011	Radha	Cattle	Holstein Friesian Cross	6.0	FEMALE	2	RFID-982-0000011	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.655753+05:30
12	BUF-SNG-012	Ganga	Buffalo	Murrah	2.0	FEMALE	2	RFID-982-0000012	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.65615+05:30
13	CAT-SNG-013	Champa	Cattle	Khillari	2.8	FEMALE	2	RFID-982-0000013	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.656513+05:30
14	CAT-SNG-014	Kavya	Cattle	Jersey Cross	3.6	FEMALE	2	RFID-982-0000014	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.656913+05:30
15	GOA-SNG-015	Veer	Goat	Osmanabadi	4.4	MALE	3	RFID-982-0000015	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.657365+05:30
16	CAT-SNG-016	Arjun	Cattle	Holstein Friesian Cross	5.2	MALE	3	RFID-982-0000016	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.657704+05:30
17	CAT-SNG-017	Nandini	Cattle	Sahiwal	6.0	FEMALE	3	RFID-982-0000017	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.65829+05:30
18	BUF-SNG-018	Manik	Buffalo	Murrah	2.0	FEMALE	3	RFID-982-0000018	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.658718+05:30
19	CAT-SNG-019	Lakshmi	Cattle	Jersey Cross	2.8	FEMALE	3	RFID-982-0000019	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.659162+05:30
20	GOA-SNG-020	Shyama	Goat	Beetal	3.6	FEMALE	3	RFID-982-0000020	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.659497+05:30
21	BUF-SNG-021	Kalyani	Buffalo	Murrah	4.4	FEMALE	3	RFID-982-0000021	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.659789+05:30
22	CAT-SNG-022	Sonali	Cattle	Sahiwal	5.2	FEMALE	4	RFID-982-0000022	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.660168+05:30
23	CAT-SNG-023	Gauri	Cattle	Khillari	6.0	FEMALE	4	RFID-982-0000023	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.662087+05:30
24	BUF-SNG-024	Radha	Buffalo	Murrah	2.0	FEMALE	4	RFID-982-0000024	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.663142+05:30
25	GOA-SNG-025	Ganga	Goat	Sirohi	2.8	FEMALE	4	RFID-982-0000025	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.664056+05:30
26	CAT-SNG-026	Champa	Cattle	Holstein Friesian Cross	3.6	FEMALE	4	RFID-982-0000026	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.665066+05:30
27	BUF-SNG-027	Kavya	Buffalo	Murrah	4.4	FEMALE	4	RFID-982-0000027	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.665845+05:30
28	CAT-SNG-028	Chetak	Cattle	Khillari	5.2	MALE	4	RFID-982-0000028	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.666201+05:30
29	CAT-SNG-029	Kamdhenu	Cattle	Jersey Cross	6.0	FEMALE	5	RFID-982-0000029	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.666491+05:30
30	GOA-SNG-030	Sheru	Goat	Osmanabadi	2.0	MALE	5	RFID-982-0000030	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.66677+05:30
31	CAT-SNG-031	Manik	Cattle	Holstein Friesian Cross	2.8	FEMALE	5	RFID-982-0000031	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.66703+05:30
32	CAT-SNG-032	Veer	Cattle	Sahiwal	3.6	MALE	5	RFID-982-0000032	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.667277+05:30
33	BUF-SNG-033	Shyama	Buffalo	Murrah	4.4	FEMALE	5	RFID-982-0000033	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.667724+05:30
34	CAT-SNG-034	Kalyani	Cattle	Jersey Cross	5.2	FEMALE	5	RFID-982-0000034	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.668082+05:30
35	GOA-SNG-035	Lakshmi	Goat	Beetal	6.0	FEMALE	6	RFID-982-0000035	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.668655+05:30
36	BUF-SNG-036	Shyama	Buffalo	Murrah	2.0	FEMALE	6	RFID-982-0000036	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.669269+05:30
37	CAT-SNG-037	Kalyani	Cattle	Sahiwal	2.8	FEMALE	6	RFID-982-0000037	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.66985+05:30
38	CAT-SNG-038	Kamdhenu	Cattle	Khillari	3.6	FEMALE	6	RFID-982-0000038	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.670678+05:30
39	BUF-SNG-039	Nandini	Buffalo	Murrah	4.4	FEMALE	6	RFID-982-0000039	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.671359+05:30
40	GOA-SNG-040	Manik	Goat	Sirohi	5.2	FEMALE	6	RFID-982-0000040	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.671928+05:30
41	CAT-RHT-041	Kamdhenu	Cattle	Holstein Friesian Cross	6.0	FEMALE	7	RFID-982-0000041	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.672443+05:30
42	BUF-RHT-042	Nandini	Buffalo	Murrah	2.0	FEMALE	7	RFID-982-0000042	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.674434+05:30
43	CAT-RHT-043	Manik	Cattle	Khillari	2.8	FEMALE	7	RFID-982-0000043	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.675181+05:30
44	CAT-RHT-044	Arjun	Cattle	Jersey Cross	3.6	MALE	7	RFID-982-0000044	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.676062+05:30
45	GOA-RHT-045	Nandi	Goat	Osmanabadi	4.4	MALE	7	RFID-982-0000045	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.676816+05:30
46	CAT-RHT-046	Kalyani	Cattle	Holstein Friesian Cross	5.2	FEMALE	7	RFID-982-0000046	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.678108+05:30
47	CAT-RHT-047	Lakshmi	Cattle	Sahiwal	6.0	FEMALE	8	RFID-982-0000047	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.679178+05:30
48	BUF-RHT-048	Shyama	Buffalo	Murrah	2.0	FEMALE	8	RFID-982-0000048	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.679894+05:30
49	CAT-RHT-049	Kalyani	Cattle	Jersey Cross	2.8	FEMALE	8	RFID-982-0000049	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.680594+05:30
50	GOA-RHT-050	Kamdhenu	Goat	Beetal	3.6	FEMALE	8	RFID-982-0000050	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.681244+05:30
51	BUF-RHT-051	Nandini	Buffalo	Murrah	4.4	FEMALE	8	RFID-982-0000051	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.681814+05:30
52	CAT-RHT-052	Arjun	Cattle	Sahiwal	5.2	MALE	8	RFID-982-0000052	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.682339+05:30
53	CAT-AKL-053	Kamdhenu	Cattle	Khillari	6.0	FEMALE	9	RFID-982-0000053	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.682787+05:30
54	BUF-AKL-054	Nandini	Buffalo	Murrah	2.0	FEMALE	9	RFID-982-0000054	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.683265+05:30
55	GOA-AKL-055	Manik	Goat	Sirohi	2.8	FEMALE	9	RFID-982-0000055	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.683577+05:30
56	CAT-AKL-056	Nandi	Cattle	Holstein Friesian Cross	3.6	MALE	9	RFID-982-0000056	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.68386+05:30
57	BUF-AKL-057	Shyama	Buffalo	Murrah	4.4	FEMALE	9	RFID-982-0000057	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.684226+05:30
58	CAT-AKL-058	Kalyani	Cattle	Khillari	5.2	FEMALE	9	RFID-982-0000058	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.684863+05:30
59	CAT-AKL-059	Lakshmi	Cattle	Jersey Cross	6.0	FEMALE	10	RFID-982-0000059	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.685478+05:30
60	GOA-AKL-060	Sheru	Goat	Osmanabadi	2.0	MALE	10	RFID-982-0000060	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.685998+05:30
61	CAT-AKL-061	Kalyani	Cattle	Holstein Friesian Cross	2.8	FEMALE	10	RFID-982-0000061	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.686389+05:30
62	CAT-AKL-062	Kamdhenu	Cattle	Sahiwal	3.6	FEMALE	10	RFID-982-0000062	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.686723+05:30
63	BUF-AKL-063	Nandini	Buffalo	Murrah	4.4	FEMALE	10	RFID-982-0000063	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.687089+05:30
64	CAT-AKL-064	Nandi	Cattle	Jersey Cross	5.2	MALE	10	RFID-982-0000064	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.687359+05:30
65	GOA-KPG-065	Kamdhenu	Goat	Beetal	6.0	FEMALE	11	RFID-982-0000065	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.687613+05:30
66	BUF-KPG-066	Nandini	Buffalo	Murrah	2.0	FEMALE	11	RFID-982-0000066	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.687889+05:30
67	CAT-KPG-067	Manik	Cattle	Sahiwal	2.8	FEMALE	11	RFID-982-0000067	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.688138+05:30
68	CAT-KPG-068	Sheru	Cattle	Khillari	3.6	MALE	11	RFID-982-0000068	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.688482+05:30
69	BUF-KPG-069	Shyama	Buffalo	Murrah	4.4	FEMALE	11	RFID-982-0000069	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.688746+05:30
70	GOA-KPG-070	Kalyani	Goat	Sirohi	5.2	FEMALE	11	RFID-982-0000070	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.689198+05:30
71	CAT-KPG-071	Kamdhenu	Cattle	Holstein Friesian Cross	6.0	FEMALE	11	RFID-982-0000071	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.689757+05:30
72	BUF-KPG-072	Nandini	Buffalo	Murrah	2.0	FEMALE	11	RFID-982-0000072	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.690207+05:30
73	CAT-SRP-073	Shyama	Cattle	Khillari	2.8	FEMALE	12	RFID-982-0000073	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.690838+05:30
74	CAT-SRP-074	Kalyani	Cattle	Jersey Cross	3.6	FEMALE	12	RFID-982-0000074	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.691416+05:30
75	GOA-SRP-075	Arjun	Goat	Osmanabadi	4.4	MALE	12	RFID-982-0000075	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.691889+05:30
76	CAT-SRP-076	Nandi	Cattle	Holstein Friesian Cross	5.2	MALE	12	RFID-982-0000076	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.692497+05:30
77	CAT-SRP-077	Manik	Cattle	Sahiwal	6.0	FEMALE	12	RFID-982-0000077	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.693061+05:30
78	BUF-SRP-078	Lakshmi	Buffalo	Murrah	2.0	FEMALE	12	RFID-982-0000078	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.693563+05:30
79	CAT-SRP-079	Shyama	Cattle	Jersey Cross	2.8	FEMALE	12	RFID-982-0000079	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.694445+05:30
80	GOA-SRP-080	Kalyani	Goat	Beetal	3.6	FEMALE	12	RFID-982-0000080	Primary milking stock, vaccinated for FMD, regular health screening on record.	2026-10-22 14:58:13.695321+05:30
81	COW-RAH-081	Gauri	CATTLE	Indian	5.0	FEMALE	7	\N	2 white patches on the back	2026-10-22 22:31:58.959704+05:30
82	CAT-TEST-DYN-999	Dynamo	CATTLE	Gir	\N	FEMALE	12	\N	\N	2026-10-22 22:53:24.597873+05:30
83	COW-SAN-083	Kalyani	CATTLE	Khillari	\N	FEMALE	13	\N	\N	2026-10-22 23:01:05.257102+05:30
84	COW-SAN-084	Basanti	CATTLE	Sahiwal	3.5	FEMALE	14	\N	\N	2026-10-22 23:08:30.284906+05:30
85	COW-SAN-085	Mhais no 2	CATTLE	Hybrid	6.0	FEMALE	15	\N	Completely Black	2026-10-22 23:14:38.54351+05:30
\.


--
-- Data for Name: visits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visits (id, animal_id, visit_date, presenting_complaint, observations, severity, temperature_celsius, treatment_notes, follow_up_notes, created_at, consultation_fee, service_fee, medicine_fee, other_fee, total_charge, symptom_onset_duration, physical_exam_findings, treatments_administered_prior, prior_treatment_response, final_clinical_assessment, actual_treatment_administered, owner_advice, follow_up_due_date, follow_up_status) FROM stdin;
196	81	2026-10-22	Fever	Mucous	MODERATE	\N	given a injection of fever	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-22 22:33:57.587537+05:30	250.00	150.00	300.00	0.00	700.00	2 days	Mucous	yesterday paracetamol	no	Suspected: General Febrile / Metabolic Indisposition. Differential consideration based on longitudinal history.	given a injection of fever	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-25	SCHEDULED
197	83	2026-10-22	Acute mastitis and swelling	Left quarter severely inflamed, fever 40.2C	MODERATE	40.2	Intramammary cefquinome infusion and flunixin	Review after 48 hours	2026-10-22 23:01:12.70508+05:30	250.00	150.00	400.00	0.00	800.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
198	84	2026-10-22	Post-calving hypocalcemia and weakness	Downer cow posture, cold extremities, subnormal temperature 37.8C	SEVERE	37.8	Slow IV calcium borogluconate 450ml with phosphorus and neurotropic B-vitamins	Provide warm bedding, support standing in 4 hours	2026-10-22 23:08:30.32855+05:30	250.00	200.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
199	85	2026-10-22	High Fever	Eyes were red	SEVERE	39.0	Paracetamol 500	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-22 23:16:09.912674+05:30	250.00	150.00	300.00	0.00	700.00	2 days	Eyes were red	Home Remedy	no	Suspected: General Febrile / Metabolic Indisposition. Differential consideration based on longitudinal history.	Paracetamol 500	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-25	SCHEDULED
87	29	2026-09-10	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.748634+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
1	1	2026-10-11	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.1	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.696727+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
2	2	2026-10-12	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.3	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.698993+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
3	3	2026-10-13	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.5	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.699464+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
4	8	2026-10-14	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.7	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.699956+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
5	9	2026-10-15	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.9	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.700534+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
6	10	2026-10-15	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.1	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.701179+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
7	15	2026-10-16	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.3	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.701782+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
8	16	2026-10-17	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.5	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.702233+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
26	26	2026-09-02	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.713448+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
195	54	2026-10-22	nasal dishcharge	\N	MODERATE	39.5	\N	\N	2026-10-22 20:52:04.937297+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
9	17	2026-10-18	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.7	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.702884+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
10	22	2026-10-18	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.9	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.70332+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
11	23	2026-10-19	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.1	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.703927+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
12	24	2026-10-19	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.3	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.704478+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
13	29	2026-10-20	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.5	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.704831+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
14	30	2026-10-20	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.7	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.705184+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
45	8	2026-09-25	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.723076+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
80	26	2026-06-05	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.743559+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
15	31	2026-10-21	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.9	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.705521+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
16	35	2026-10-21	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	MODERATE	40.1	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.707388+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
17	36	2026-10-22	High fever, persistent nasal discharge, severe appetite loss	Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales.	SEVERE	40.3	Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench.	Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity.	2026-10-22 14:58:13.708061+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
18	2	2026-05-10	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.708595+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
19	5	2026-05-25	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.709171+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
20	8	2026-06-08	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.709651+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
21	11	2026-06-22	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.710122+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
22	14	2026-07-05	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.710824+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
23	17	2026-07-19	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.711633+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
24	20	2026-08-04	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.712283+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
25	23	2026-08-18	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.712909+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
27	29	2026-09-16	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.714037+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
28	32	2026-09-28	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.714612+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
29	35	2026-10-02	Routine mild fever or off-feed	Slightly elevated temperature, normal lung sounds, responsive.	MILD	39.2	Symptomatic treatment, B-complex injection.	Resolved after 48 hours.	2026-10-22 14:58:13.715246+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
30	1	2026-08-19	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.715907+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
31	1	2026-09-03	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.716407+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
32	2	2026-04-26	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.716858+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
33	2	2026-05-10	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.717401+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
34	3	2026-07-06	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.717875+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
35	3	2026-08-17	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.718391+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
36	4	2026-10-13	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.718899+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
37	4	2026-04-24	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.719341+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
38	5	2026-06-20	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.719803+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
39	5	2026-07-04	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.720238+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
40	6	2026-09-27	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.720761+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
41	6	2026-10-11	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.721265+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
42	7	2026-05-07	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.721768+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
43	7	2026-06-18	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.722148+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
44	8	2026-08-14	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.722679+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
46	9	2026-04-21	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.723612+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
47	9	2026-05-05	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.724341+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
48	10	2026-07-01	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.724895+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
49	10	2026-08-12	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.725476+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
50	11	2026-10-08	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.72606+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
51	11	2026-04-19	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.726647+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
52	12	2026-06-15	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.727529+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
53	12	2026-07-26	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.728436+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
54	13	2026-09-22	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.729086+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
55	13	2026-10-06	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.729575+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
56	14	2026-05-02	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.730152+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
57	14	2026-06-13	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.730664+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
58	15	2026-08-09	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.731225+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
59	15	2026-09-20	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.731729+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
60	16	2026-04-16	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.732157+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
61	16	2026-05-27	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.732712+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
62	17	2026-07-23	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.733204+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
63	17	2026-08-07	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.733654+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
64	18	2026-10-03	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.734093+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
65	18	2026-04-14	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.734637+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
66	19	2026-06-10	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.735168+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
67	19	2026-07-21	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.735742+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
68	20	2026-09-17	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.736369+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
69	20	2026-10-01	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.736912+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
70	21	2026-05-24	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.737496+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
71	21	2026-06-08	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.738112+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
72	22	2026-08-04	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.738716+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
73	22	2026-09-15	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.739348+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
74	23	2026-04-11	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.739934+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
75	23	2026-05-22	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.740553+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
76	24	2026-07-18	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.741112+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
77	24	2026-08-02	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.741716+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
78	25	2026-10-05	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.742324+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
79	25	2026-04-09	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.742936+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
81	26	2026-07-16	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.744595+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
82	27	2026-09-12	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.745535+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
83	27	2026-10-05	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.746136+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
84	28	2026-05-19	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.746755+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
85	28	2026-06-03	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.747378+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
86	29	2026-08-26	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.747978+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
88	30	2026-04-06	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.749262+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
89	30	2026-05-17	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.749787+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
90	31	2026-07-13	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.750372+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
91	31	2026-08-24	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.75101+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
92	32	2026-10-20	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.751627+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
93	32	2026-04-04	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.752272+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
94	33	2026-06-27	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.752778+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
95	33	2026-07-11	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.753269+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
96	34	2026-09-07	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.753844+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
97	34	2026-10-18	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.754304+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
98	35	2026-05-14	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.754893+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
99	35	2026-06-25	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.755419+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
100	36	2026-08-21	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.755961+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
101	36	2026-09-05	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.756486+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
102	37	2026-04-01	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.757008+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
103	37	2026-05-12	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.757538+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
104	38	2026-07-08	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.758047+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
105	38	2026-08-19	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.758598+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
106	39	2026-10-15	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.759191+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
107	39	2026-04-26	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.759751+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
108	40	2026-06-22	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.760536+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
109	40	2026-07-06	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.761401+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
110	41	2026-09-02	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.762102+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
111	41	2026-10-13	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.762655+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
112	42	2026-05-09	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.763243+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
113	42	2026-06-20	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.76385+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
114	43	2026-08-16	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.76446+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
115	43	2026-09-27	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.765115+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
116	44	2026-04-23	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.765727+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
117	44	2026-05-07	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.766345+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
118	45	2026-07-03	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.766932+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
119	45	2026-08-14	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.767485+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
120	46	2026-10-10	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.767962+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
121	46	2026-04-21	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.768375+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
122	47	2026-06-17	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.768807+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
123	47	2026-07-01	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.769409+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
124	48	2026-09-24	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.770021+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
125	48	2026-10-08	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.770654+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
126	49	2026-05-04	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.771187+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
127	49	2026-06-15	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.771635+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
128	50	2026-08-11	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.772105+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
129	50	2026-09-22	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.772586+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
130	51	2026-04-18	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.773051+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
131	51	2026-05-02	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.773544+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
132	52	2026-07-25	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.774027+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
133	52	2026-08-09	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.774455+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
134	53	2026-10-05	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.774984+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
135	53	2026-04-16	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.77552+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
136	54	2026-06-12	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.776067+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
137	54	2026-07-23	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.776544+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
138	55	2026-09-19	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.777007+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
139	55	2026-10-03	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.77764+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
140	56	2026-05-26	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.778427+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
141	56	2026-06-10	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.779107+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
142	57	2026-08-06	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.779705+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
143	57	2026-09-17	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.780305+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
144	58	2026-04-13	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.780943+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
145	58	2026-05-24	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.781516+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
146	59	2026-07-20	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.782012+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
147	59	2026-08-04	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.782443+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
148	60	2026-10-05	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.782965+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
149	60	2026-04-11	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.783544+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
150	61	2026-06-07	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.78402+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
151	61	2026-07-18	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.784441+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
152	62	2026-09-14	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.784989+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
153	62	2026-10-05	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.785511+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
154	63	2026-05-21	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.785957+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
155	63	2026-06-05	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.786451+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
156	64	2026-08-01	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.786944+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
157	64	2026-09-12	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.787442+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
158	65	2026-04-08	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.787906+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
159	65	2026-05-19	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.788462+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
160	66	2026-07-15	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.78899+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
161	66	2026-08-26	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.78948+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
162	67	2026-10-22	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.789982+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
163	67	2026-04-06	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.790477+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
164	68	2026-06-02	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.790959+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
165	68	2026-07-13	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.791511+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
166	69	2026-09-09	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.792093+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
167	69	2026-10-20	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.792635+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
168	70	2026-05-16	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.793123+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
169	70	2026-06-27	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.793596+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
170	71	2026-08-23	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.794162+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
171	71	2026-09-07	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.794839+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
172	72	2026-04-03	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.795311+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
173	72	2026-05-14	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.795895+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
174	73	2026-07-10	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.796485+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
175	73	2026-08-21	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.796993+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
176	74	2026-10-17	Persistent dry cough after pasture grazing	Mild bronchial wheeze, clear nasal passages	MODERATE	39.0	Bromhexine mucolytic, antihistamine	Keep in well-ventilated dry shed	2026-10-22 14:58:13.797422+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
177	74	2026-04-01	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.797998+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
178	75	2026-06-24	Excessive drooling and mouth discomfort	Oral examination showed minor forage trauma, no vesicles	MILD	38.6	Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet	Recheck oral mucosa in 3 days	2026-10-22 14:58:13.79847+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
179	75	2026-07-08	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.798994+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
180	76	2026-09-04	Mild bloating and digestive lethargy	Left paralumbar fossa distended with gas, drum sound	MODERATE	38.7	Bloat-guard drench (Poloxalene), stomach tube gas relief	Review legume grazing duration	2026-10-22 14:58:13.799486+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
181	76	2026-10-15	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.799904+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
182	77	2026-05-11	Post-calving checkup and metritis screening	Mild vaginal discharge, subclinical hypocalcemia	MODERATE	38.8	Calcium borogluconate 450ml SC, intrauterine pessary	Monitor milk output and appetite	2026-10-22 14:58:13.800402+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
183	77	2026-06-22	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.800935+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
184	78	2026-08-18	Lactation fatigue and sudden drop in milk	BCS 2.5, dull coat, rumen motility slow	MILD	38.5	Mineral mixture supplement, bypass fat	Follow up in 14 days	2026-10-22 14:58:13.80145+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
185	78	2026-09-02	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.801866+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
186	79	2026-04-25	Routine deworming and health assessment	Normal vitals, healthy body score	MILD	38.5	Albendazole oral suspension administered	Repeat in 6 months	2026-10-22 14:58:13.802287+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
187	79	2026-05-09	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.803163+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
188	80	2026-07-05	Decreased milk yield during morning milking	Mild udder swelling, right quarter tender	MODERATE	38.9	Intramammary infusion, anti-inflammatory	Strip test daily, hygiene protocol review	2026-10-22 14:58:13.803703+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
189	80	2026-08-16	Acute watery diarrhea and dehydration	Profuse scouring, sunken eyes, skin tenting	SEVERE	39.4	IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin	Withhold concentrate, feed clean dry hay	2026-10-22 14:58:13.804139+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
190	42	2026-10-14	Mild digestive slowdown	Slightly low rumen fill	MILD	38.5	Digestive tonic, probiotic bolus	Normal response expected	2026-10-22 14:58:13.804526+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
191	55	2026-10-16	Minor hoof scrape during grazing	Small abrasion on lateral claw, clean	MILD	38.6	Povidone iodine dressing, zinc oxide paste	Keep on dry bedding	2026-10-22 14:58:13.805038+05:30	200.00	50.00	150.00	0.00	400.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
192	68	2026-10-18	Acute calf diarrhea	Watery feces, moderate dehydration	MODERATE	39.1	Electrolyte drench, probiotic paste	Review milk replacer feeding schedule	2026-10-22 14:58:13.805574+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
193	75	2026-10-19	Sudden milk drop	Left hind quarter slightly warm, somatic cell count elevated	MODERATE	38.9	Intramammary infusion, NSAID	Monitor CMT score daily	2026-10-22 14:58:13.806126+05:30	200.00	100.00	350.00	0.00	650.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
194	1	2026-10-22	Sudden high fever and severe coughing during hackathon demonstration	Auscultation shows harsh bronchial sounds in right lung	SEVERE	40.5	Administered Flunixin meglumine and supportive hydration	Strict isolation pen for 48 hours	2026-10-22 15:41:53.200497+05:30	200.00	250.00	550.00	0.00	1000.00	\N	\N	\N	\N	\N	\N	\N	\N	NONE
\.


--
-- Data for Name: clinical_follow_ups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clinical_follow_ups (id, animal_id, visit_id, reason, due_date, status, completion_notes, completed_at, created_at) FROM stdin;
1	81	196	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-25	PENDING	\N	\N	2026-10-22 22:33:57.587537+05:30
2	85	199	Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.	2026-10-25	PENDING	\N	\N	2026-10-22 23:16:09.912674+05:30
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, payment_number, owner_id, amount, payment_date, payment_method, reference_number, notes, created_at) FROM stdin;
1	REC-2026-0001	1	8680.00	2026-10-18	CASH	REF-ONB-0001	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
2	REC-2026-0002	2	8435.00	2026-10-18	UPI	REF-ONB-0002	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
3	REC-2026-0003	3	8575.00	2026-10-18	CASH	REF-ONB-0003	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
4	REC-2026-0004	4	8155.00	2026-10-18	UPI	REF-ONB-0004	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
5	REC-2026-0005	5	7490.00	2026-10-18	CASH	REF-ONB-0005	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
6	REC-2026-0006	6	6265.00	2026-10-18	UPI	REF-ONB-0006	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
7	REC-2026-0007	7	5110.00	2026-10-18	CASH	REF-ONB-0007	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
8	REC-2026-0008	8	5425.00	2026-10-18	UPI	REF-ONB-0008	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
9	REC-2026-0009	9	5810.00	2026-10-18	CASH	REF-ONB-0009	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
10	REC-2026-0010	10	4830.00	2026-10-18	UPI	REF-ONB-0010	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
11	REC-2026-0011	11	7175.00	2026-10-18	CASH	REF-ONB-0011	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
12	REC-2026-0012	12	7175.00	2026-10-18	UPI	REF-ONB-0012	Initial ledger account payment	2026-10-22 20:56:52.757346+05:30
13	REC-2026-0013	1	500.00	2026-10-22	UPI	UPI-TEST-12345	Doorstep test payment	2026-10-22 21:57:35.580699+05:30
\.


--
-- Data for Name: payment_allocations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_allocations (id, payment_id, visit_id, allocated_amount, created_at) FROM stdin;
1	13	37	500.00	2026-10-22 21:57:35.580699+05:30
\.


--
-- Data for Name: visit_symptoms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visit_symptoms (id, visit_id, symptom_code, severity, created_at) FROM stdin;
1	1	FEVER	SEVERE	2026-10-22 14:58:13.807423+05:30
2	1	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.809086+05:30
3	1	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.809719+05:30
4	1	COUGH	MODERATE	2026-10-22 14:58:13.810143+05:30
5	1	LETHARGY	SEVERE	2026-10-22 14:58:13.811018+05:30
6	2	FEVER	MODERATE	2026-10-22 14:58:13.811825+05:30
7	2	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.812455+05:30
8	2	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.812964+05:30
9	3	FEVER	SEVERE	2026-10-22 14:58:13.813495+05:30
10	3	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.814026+05:30
11	3	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.81448+05:30
12	3	LETHARGY	SEVERE	2026-10-22 14:58:13.814963+05:30
13	4	FEVER	MODERATE	2026-10-22 14:58:13.815451+05:30
14	4	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.815964+05:30
15	4	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.816384+05:30
16	4	COUGH	MODERATE	2026-10-22 14:58:13.816822+05:30
17	5	FEVER	SEVERE	2026-10-22 14:58:13.817253+05:30
18	5	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.817704+05:30
19	5	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.818147+05:30
20	5	LETHARGY	SEVERE	2026-10-22 14:58:13.818563+05:30
21	6	FEVER	MODERATE	2026-10-22 14:58:13.819065+05:30
22	6	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.819519+05:30
23	6	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.819945+05:30
24	7	FEVER	SEVERE	2026-10-22 14:58:13.820273+05:30
25	7	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.820709+05:30
26	7	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.821074+05:30
27	7	COUGH	MODERATE	2026-10-22 14:58:13.821582+05:30
28	7	LETHARGY	SEVERE	2026-10-22 14:58:13.822064+05:30
29	8	FEVER	MODERATE	2026-10-22 14:58:13.822582+05:30
30	8	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.823088+05:30
31	8	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.823641+05:30
32	9	FEVER	SEVERE	2026-10-22 14:58:13.824095+05:30
33	9	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.824579+05:30
34	9	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.825048+05:30
35	9	LETHARGY	SEVERE	2026-10-22 14:58:13.825492+05:30
36	10	FEVER	MODERATE	2026-10-22 14:58:13.82596+05:30
37	10	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.826409+05:30
38	10	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.826976+05:30
39	10	COUGH	MODERATE	2026-10-22 14:58:13.827579+05:30
40	11	FEVER	SEVERE	2026-10-22 14:58:13.828067+05:30
41	11	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.828537+05:30
42	11	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.829079+05:30
43	11	LETHARGY	SEVERE	2026-10-22 14:58:13.829529+05:30
44	12	FEVER	MODERATE	2026-10-22 14:58:13.830004+05:30
45	12	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.830437+05:30
46	12	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.830915+05:30
47	13	FEVER	SEVERE	2026-10-22 14:58:13.831427+05:30
48	13	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.831912+05:30
49	13	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.832378+05:30
50	13	COUGH	MODERATE	2026-10-22 14:58:13.832847+05:30
51	13	LETHARGY	SEVERE	2026-10-22 14:58:13.83337+05:30
52	14	FEVER	MODERATE	2026-10-22 14:58:13.833903+05:30
53	14	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.834451+05:30
54	14	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.834834+05:30
55	15	FEVER	SEVERE	2026-10-22 14:58:13.835302+05:30
56	15	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.835752+05:30
57	15	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.836164+05:30
58	15	LETHARGY	SEVERE	2026-10-22 14:58:13.836636+05:30
59	16	FEVER	MODERATE	2026-10-22 14:58:13.837085+05:30
60	16	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.837628+05:30
61	16	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.838178+05:30
62	16	COUGH	MODERATE	2026-10-22 14:58:13.838783+05:30
63	17	FEVER	SEVERE	2026-10-22 14:58:13.839471+05:30
64	17	NASAL_DISCHARGE	MODERATE	2026-10-22 14:58:13.840116+05:30
65	17	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.840683+05:30
66	17	LETHARGY	SEVERE	2026-10-22 14:58:13.84131+05:30
67	18	FEVER	MILD	2026-10-22 14:58:13.841904+05:30
68	18	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.842491+05:30
69	19	FEVER	MILD	2026-10-22 14:58:13.842965+05:30
70	20	FEVER	MILD	2026-10-22 14:58:13.843589+05:30
71	20	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.844262+05:30
72	21	FEVER	MILD	2026-10-22 14:58:13.844978+05:30
73	22	FEVER	MILD	2026-10-22 14:58:13.845561+05:30
74	22	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.846026+05:30
75	23	FEVER	MILD	2026-10-22 14:58:13.846618+05:30
76	24	FEVER	MILD	2026-10-22 14:58:13.847209+05:30
77	24	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.847775+05:30
78	25	FEVER	MILD	2026-10-22 14:58:13.848327+05:30
79	26	FEVER	MILD	2026-10-22 14:58:13.848876+05:30
80	26	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.849429+05:30
81	27	FEVER	MILD	2026-10-22 14:58:13.849984+05:30
82	28	FEVER	MILD	2026-10-22 14:58:13.850546+05:30
83	28	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.851116+05:30
84	29	FEVER	MILD	2026-10-22 14:58:13.851613+05:30
85	30	DIARRHEA	SEVERE	2026-10-22 14:58:13.852105+05:30
86	30	LETHARGY	SEVERE	2026-10-22 14:58:13.852668+05:30
87	30	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.853113+05:30
88	31	COUGH	MODERATE	2026-10-22 14:58:13.853657+05:30
89	32	COUGH	MODERATE	2026-10-22 14:58:13.854159+05:30
90	33	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.854675+05:30
91	33	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.855217+05:30
92	34	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.855764+05:30
93	34	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.856331+05:30
94	35	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.856879+05:30
95	35	LETHARGY	MODERATE	2026-10-22 14:58:13.857325+05:30
96	36	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.857704+05:30
97	36	LETHARGY	MODERATE	2026-10-22 14:58:13.858229+05:30
98	37	LETHARGY	MODERATE	2026-10-22 14:58:13.858737+05:30
99	37	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.859237+05:30
100	38	LETHARGY	MODERATE	2026-10-22 14:58:13.859785+05:30
101	38	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.860336+05:30
102	39	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.861042+05:30
103	39	LETHARGY	MILD	2026-10-22 14:58:13.86172+05:30
104	40	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.862179+05:30
105	40	LETHARGY	MILD	2026-10-22 14:58:13.862663+05:30
106	41	LETHARGY	MILD	2026-10-22 14:58:13.863054+05:30
107	42	LETHARGY	MILD	2026-10-22 14:58:13.863568+05:30
108	43	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.863961+05:30
109	43	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.864538+05:30
110	44	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.865074+05:30
111	44	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.866635+05:30
112	45	DIARRHEA	SEVERE	2026-10-22 14:58:13.867225+05:30
113	45	LETHARGY	SEVERE	2026-10-22 14:58:13.867754+05:30
114	45	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.868332+05:30
115	46	DIARRHEA	SEVERE	2026-10-22 14:58:13.868833+05:30
116	46	LETHARGY	SEVERE	2026-10-22 14:58:13.869247+05:30
117	46	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.869733+05:30
118	47	COUGH	MODERATE	2026-10-22 14:58:13.870179+05:30
119	48	COUGH	MODERATE	2026-10-22 14:58:13.87061+05:30
120	49	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.871061+05:30
121	49	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.871599+05:30
122	50	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.872048+05:30
123	50	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.87259+05:30
124	51	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.873052+05:30
125	51	LETHARGY	MODERATE	2026-10-22 14:58:13.873524+05:30
126	52	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.874026+05:30
127	52	LETHARGY	MODERATE	2026-10-22 14:58:13.874468+05:30
128	53	LETHARGY	MODERATE	2026-10-22 14:58:13.87498+05:30
129	53	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.875454+05:30
130	54	LETHARGY	MODERATE	2026-10-22 14:58:13.875917+05:30
131	54	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.876408+05:30
132	55	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.876973+05:30
133	55	LETHARGY	MILD	2026-10-22 14:58:13.877768+05:30
134	56	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.878458+05:30
135	56	LETHARGY	MILD	2026-10-22 14:58:13.878969+05:30
136	57	LETHARGY	MILD	2026-10-22 14:58:13.879478+05:30
137	58	LETHARGY	MILD	2026-10-22 14:58:13.879966+05:30
138	59	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.880527+05:30
139	59	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.881091+05:30
140	60	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.881633+05:30
141	60	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.882164+05:30
142	61	DIARRHEA	SEVERE	2026-10-22 14:58:13.882714+05:30
143	61	LETHARGY	SEVERE	2026-10-22 14:58:13.883205+05:30
144	61	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.883706+05:30
145	62	DIARRHEA	SEVERE	2026-10-22 14:58:13.884184+05:30
146	62	LETHARGY	SEVERE	2026-10-22 14:58:13.884848+05:30
147	62	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.885334+05:30
148	63	COUGH	MODERATE	2026-10-22 14:58:13.885813+05:30
149	64	COUGH	MODERATE	2026-10-22 14:58:13.886337+05:30
150	65	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.886875+05:30
151	65	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.887402+05:30
152	66	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.887906+05:30
153	66	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.888397+05:30
154	67	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.888946+05:30
155	67	LETHARGY	MODERATE	2026-10-22 14:58:13.889499+05:30
156	68	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.890053+05:30
157	68	LETHARGY	MODERATE	2026-10-22 14:58:13.890668+05:30
158	69	LETHARGY	MODERATE	2026-10-22 14:58:13.891255+05:30
159	69	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.891758+05:30
160	70	LETHARGY	MODERATE	2026-10-22 14:58:13.892332+05:30
161	70	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.892903+05:30
162	71	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.89355+05:30
163	71	LETHARGY	MILD	2026-10-22 14:58:13.894345+05:30
164	72	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.895091+05:30
165	72	LETHARGY	MILD	2026-10-22 14:58:13.895558+05:30
166	73	LETHARGY	MILD	2026-10-22 14:58:13.89601+05:30
167	74	LETHARGY	MILD	2026-10-22 14:58:13.896441+05:30
168	75	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.896935+05:30
169	75	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.897502+05:30
170	76	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.89798+05:30
171	76	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.898372+05:30
172	77	DIARRHEA	SEVERE	2026-10-22 14:58:13.898893+05:30
173	77	LETHARGY	SEVERE	2026-10-22 14:58:13.899432+05:30
174	77	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.899872+05:30
175	78	DIARRHEA	SEVERE	2026-10-22 14:58:13.900462+05:30
176	78	LETHARGY	SEVERE	2026-10-22 14:58:13.900979+05:30
177	78	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.901472+05:30
178	79	COUGH	MODERATE	2026-10-22 14:58:13.901894+05:30
179	80	COUGH	MODERATE	2026-10-22 14:58:13.902277+05:30
180	81	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.902828+05:30
181	81	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.903421+05:30
182	82	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.903874+05:30
183	82	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.904397+05:30
184	83	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.904837+05:30
185	83	LETHARGY	MODERATE	2026-10-22 14:58:13.905421+05:30
186	84	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.90593+05:30
187	84	LETHARGY	MODERATE	2026-10-22 14:58:13.906474+05:30
188	85	LETHARGY	MODERATE	2026-10-22 14:58:13.906962+05:30
189	85	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.907467+05:30
190	86	LETHARGY	MODERATE	2026-10-22 14:58:13.907983+05:30
191	86	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.908446+05:30
192	87	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.908863+05:30
193	87	LETHARGY	MILD	2026-10-22 14:58:13.909321+05:30
194	88	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.909787+05:30
195	88	LETHARGY	MILD	2026-10-22 14:58:13.910418+05:30
196	89	LETHARGY	MILD	2026-10-22 14:58:13.911161+05:30
197	90	LETHARGY	MILD	2026-10-22 14:58:13.911703+05:30
198	91	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.912225+05:30
199	91	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.912714+05:30
200	92	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.913296+05:30
201	92	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.913868+05:30
202	93	DIARRHEA	SEVERE	2026-10-22 14:58:13.914326+05:30
203	93	LETHARGY	SEVERE	2026-10-22 14:58:13.914766+05:30
204	93	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.915322+05:30
205	94	DIARRHEA	SEVERE	2026-10-22 14:58:13.915783+05:30
206	94	LETHARGY	SEVERE	2026-10-22 14:58:13.916294+05:30
207	94	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.916773+05:30
208	95	COUGH	MODERATE	2026-10-22 14:58:13.917216+05:30
209	96	COUGH	MODERATE	2026-10-22 14:58:13.917612+05:30
210	97	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.918067+05:30
211	97	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.918578+05:30
212	98	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.919121+05:30
213	98	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.919585+05:30
214	99	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.920075+05:30
215	99	LETHARGY	MODERATE	2026-10-22 14:58:13.920533+05:30
216	100	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.921067+05:30
217	100	LETHARGY	MODERATE	2026-10-22 14:58:13.921812+05:30
218	101	LETHARGY	MODERATE	2026-10-22 14:58:13.9223+05:30
219	101	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.922789+05:30
220	102	LETHARGY	MODERATE	2026-10-22 14:58:13.923299+05:30
221	102	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.923768+05:30
222	103	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.924128+05:30
223	103	LETHARGY	MILD	2026-10-22 14:58:13.924618+05:30
224	104	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.925049+05:30
225	104	LETHARGY	MILD	2026-10-22 14:58:13.92553+05:30
226	105	LETHARGY	MILD	2026-10-22 14:58:13.926108+05:30
227	106	LETHARGY	MILD	2026-10-22 14:58:13.92656+05:30
228	107	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.927232+05:30
229	107	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.9281+05:30
230	108	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.928712+05:30
231	108	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.929174+05:30
232	109	DIARRHEA	SEVERE	2026-10-22 14:58:13.929643+05:30
233	109	LETHARGY	SEVERE	2026-10-22 14:58:13.930099+05:30
234	109	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.930575+05:30
235	110	DIARRHEA	SEVERE	2026-10-22 14:58:13.931098+05:30
236	110	LETHARGY	SEVERE	2026-10-22 14:58:13.931569+05:30
237	110	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.932014+05:30
238	111	COUGH	MODERATE	2026-10-22 14:58:13.932449+05:30
239	112	COUGH	MODERATE	2026-10-22 14:58:13.932879+05:30
240	113	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.933313+05:30
241	113	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.933815+05:30
242	114	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.934286+05:30
243	114	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.934775+05:30
244	115	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.93522+05:30
245	115	LETHARGY	MODERATE	2026-10-22 14:58:13.93567+05:30
246	116	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.936095+05:30
247	116	LETHARGY	MODERATE	2026-10-22 14:58:13.936544+05:30
248	117	LETHARGY	MODERATE	2026-10-22 14:58:13.936947+05:30
249	117	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.937419+05:30
250	118	LETHARGY	MODERATE	2026-10-22 14:58:13.937867+05:30
251	118	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.938353+05:30
252	119	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.938879+05:30
253	119	LETHARGY	MILD	2026-10-22 14:58:13.939381+05:30
254	120	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.93988+05:30
255	120	LETHARGY	MILD	2026-10-22 14:58:13.940453+05:30
256	121	LETHARGY	MILD	2026-10-22 14:58:13.941021+05:30
257	122	LETHARGY	MILD	2026-10-22 14:58:13.941547+05:30
258	123	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.942133+05:30
259	123	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.942725+05:30
260	124	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.943226+05:30
261	124	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.944062+05:30
262	125	DIARRHEA	SEVERE	2026-10-22 14:58:13.94454+05:30
263	125	LETHARGY	SEVERE	2026-10-22 14:58:13.94509+05:30
264	125	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.945492+05:30
265	126	DIARRHEA	SEVERE	2026-10-22 14:58:13.945952+05:30
266	126	LETHARGY	SEVERE	2026-10-22 14:58:13.946444+05:30
267	126	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.94691+05:30
268	127	COUGH	MODERATE	2026-10-22 14:58:13.94734+05:30
269	128	COUGH	MODERATE	2026-10-22 14:58:13.947821+05:30
270	129	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.948219+05:30
271	129	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.948751+05:30
272	130	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.949338+05:30
273	130	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.949791+05:30
274	131	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.950289+05:30
275	131	LETHARGY	MODERATE	2026-10-22 14:58:13.950716+05:30
276	132	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.951214+05:30
277	132	LETHARGY	MODERATE	2026-10-22 14:58:13.951657+05:30
278	133	LETHARGY	MODERATE	2026-10-22 14:58:13.952114+05:30
279	133	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.952663+05:30
280	134	LETHARGY	MODERATE	2026-10-22 14:58:13.95314+05:30
281	134	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.953617+05:30
282	135	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.95404+05:30
283	135	LETHARGY	MILD	2026-10-22 14:58:13.954583+05:30
284	136	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.955142+05:30
285	136	LETHARGY	MILD	2026-10-22 14:58:13.955651+05:30
286	137	LETHARGY	MILD	2026-10-22 14:58:13.956206+05:30
287	138	LETHARGY	MILD	2026-10-22 14:58:13.956774+05:30
288	139	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.957246+05:30
289	139	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.957753+05:30
290	140	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.9583+05:30
291	140	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.958971+05:30
292	141	DIARRHEA	SEVERE	2026-10-22 14:58:13.959746+05:30
293	141	LETHARGY	SEVERE	2026-10-22 14:58:13.960658+05:30
294	141	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.961527+05:30
295	142	DIARRHEA	SEVERE	2026-10-22 14:58:13.962162+05:30
296	142	LETHARGY	SEVERE	2026-10-22 14:58:13.96276+05:30
297	142	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.963338+05:30
298	143	COUGH	MODERATE	2026-10-22 14:58:13.963763+05:30
299	144	COUGH	MODERATE	2026-10-22 14:58:13.96406+05:30
300	145	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.964586+05:30
301	145	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.965099+05:30
302	146	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.965455+05:30
303	146	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.966009+05:30
304	147	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.966486+05:30
305	147	LETHARGY	MODERATE	2026-10-22 14:58:13.96694+05:30
306	148	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.967446+05:30
307	148	LETHARGY	MODERATE	2026-10-22 14:58:13.967941+05:30
308	149	LETHARGY	MODERATE	2026-10-22 14:58:13.968405+05:30
309	149	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.968848+05:30
310	150	LETHARGY	MODERATE	2026-10-22 14:58:13.969245+05:30
311	150	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.96969+05:30
312	151	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.970227+05:30
313	151	LETHARGY	MILD	2026-10-22 14:58:13.970646+05:30
314	152	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.971094+05:30
315	152	LETHARGY	MILD	2026-10-22 14:58:13.971615+05:30
316	153	LETHARGY	MILD	2026-10-22 14:58:13.972118+05:30
317	154	LETHARGY	MILD	2026-10-22 14:58:13.972605+05:30
318	155	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.973119+05:30
319	155	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.973605+05:30
320	156	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.974198+05:30
321	156	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.974718+05:30
322	157	DIARRHEA	SEVERE	2026-10-22 14:58:13.975332+05:30
323	157	LETHARGY	SEVERE	2026-10-22 14:58:13.975943+05:30
324	157	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.976537+05:30
325	158	DIARRHEA	SEVERE	2026-10-22 14:58:13.977403+05:30
326	158	LETHARGY	SEVERE	2026-10-22 14:58:13.978086+05:30
327	158	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.978576+05:30
328	159	COUGH	MODERATE	2026-10-22 14:58:13.9791+05:30
329	160	COUGH	MODERATE	2026-10-22 14:58:13.979627+05:30
330	161	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.980171+05:30
331	161	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.98071+05:30
332	162	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.981306+05:30
333	162	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.981926+05:30
334	163	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.982541+05:30
335	163	LETHARGY	MODERATE	2026-10-22 14:58:13.983113+05:30
336	164	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.983682+05:30
337	164	LETHARGY	MODERATE	2026-10-22 14:58:13.984187+05:30
338	165	LETHARGY	MODERATE	2026-10-22 14:58:13.984628+05:30
339	165	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.985158+05:30
340	166	LETHARGY	MODERATE	2026-10-22 14:58:13.985683+05:30
341	166	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.98622+05:30
342	167	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.986698+05:30
343	167	LETHARGY	MILD	2026-10-22 14:58:13.987236+05:30
344	168	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:13.987738+05:30
345	168	LETHARGY	MILD	2026-10-22 14:58:13.988167+05:30
346	169	LETHARGY	MILD	2026-10-22 14:58:13.988601+05:30
347	170	LETHARGY	MILD	2026-10-22 14:58:13.989111+05:30
348	171	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.989581+05:30
349	171	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.990075+05:30
350	172	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:13.990491+05:30
351	172	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.990933+05:30
352	173	DIARRHEA	SEVERE	2026-10-22 14:58:13.991501+05:30
353	173	LETHARGY	SEVERE	2026-10-22 14:58:13.991977+05:30
354	173	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.992551+05:30
355	174	DIARRHEA	SEVERE	2026-10-22 14:58:13.993038+05:30
356	174	LETHARGY	SEVERE	2026-10-22 14:58:13.993614+05:30
357	174	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:13.994629+05:30
358	175	COUGH	MODERATE	2026-10-22 14:58:13.995177+05:30
359	176	COUGH	MODERATE	2026-10-22 14:58:13.995719+05:30
360	177	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.996275+05:30
361	177	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.996756+05:30
362	178	EXCESSIVE_SALIVATION	MILD	2026-10-22 14:58:13.997294+05:30
363	178	REDUCED_APPETITE	MILD	2026-10-22 14:58:13.997761+05:30
364	179	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.998287+05:30
365	179	LETHARGY	MODERATE	2026-10-22 14:58:13.998793+05:30
366	180	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:13.999231+05:30
367	180	LETHARGY	MODERATE	2026-10-22 14:58:13.999595+05:30
368	181	LETHARGY	MODERATE	2026-10-22 14:58:14.000113+05:30
369	181	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:14.000641+05:30
370	182	LETHARGY	MODERATE	2026-10-22 14:58:14.001204+05:30
371	182	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:14.001755+05:30
372	183	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:14.002307+05:30
373	183	LETHARGY	MILD	2026-10-22 14:58:14.002762+05:30
374	184	REDUCED_MILK_PRODUCTION	MILD	2026-10-22 14:58:14.003328+05:30
375	184	LETHARGY	MILD	2026-10-22 14:58:14.003787+05:30
376	185	LETHARGY	MILD	2026-10-22 14:58:14.004355+05:30
377	186	LETHARGY	MILD	2026-10-22 14:58:14.004924+05:30
378	187	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:14.005426+05:30
379	187	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:14.006076+05:30
380	188	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:14.006698+05:30
381	188	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:14.007334+05:30
382	189	DIARRHEA	SEVERE	2026-10-22 14:58:14.007851+05:30
383	189	LETHARGY	SEVERE	2026-10-22 14:58:14.008341+05:30
384	189	REDUCED_APPETITE	SEVERE	2026-10-22 14:58:14.008952+05:30
385	190	REDUCED_APPETITE	MILD	2026-10-22 14:58:14.009724+05:30
386	191	LETHARGY	MILD	2026-10-22 14:58:14.010448+05:30
387	192	DIARRHEA	MODERATE	2026-10-22 14:58:14.011268+05:30
388	192	REDUCED_APPETITE	MODERATE	2026-10-22 14:58:14.011954+05:30
389	193	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 14:58:14.01246+05:30
390	194	FEVER	SEVERE	2026-10-22 15:41:53.200497+05:30
391	194	COUGH	SEVERE	2026-10-22 15:41:53.200497+05:30
392	194	REDUCED_APPETITE	SEVERE	2026-10-22 15:41:53.200497+05:30
393	195	NASAL_DISCHARGE	MODERATE	2026-10-22 20:52:04.937297+05:30
394	196	FEVER	MODERATE	2026-10-22 22:33:57.587537+05:30
395	197	FEVER	MODERATE	2026-10-22 23:01:12.70508+05:30
396	197	REDUCED_MILK_PRODUCTION	MODERATE	2026-10-22 23:01:12.70508+05:30
397	198	LETHARGY	SEVERE	2026-10-22 23:08:30.32855+05:30
398	198	REDUCED_MILK_PRODUCTION	SEVERE	2026-10-22 23:08:30.32855+05:30
399	199	FEVER	SEVERE	2026-10-22 23:16:09.912674+05:30
\.


--
-- Name: animals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.animals_id_seq', 85, true);


--
-- Name: clinical_follow_ups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clinical_follow_ups_id_seq', 2, true);


--
-- Name: farms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.farms_id_seq', 15, true);


--
-- Name: owners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.owners_id_seq', 15, true);


--
-- Name: payment_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payment_allocations_id_seq', 1, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 13, true);


--
-- Name: villages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.villages_id_seq', 5, true);


--
-- Name: visit_symptoms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visit_symptoms_id_seq', 399, true);


--
-- Name: visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visits_id_seq', 199, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 6LgqrAzNSoidrHrq4w2JeeewBJ4X9DSls0QtQ4iCzim6pluyTL6Oe6h4RKhaw9p

