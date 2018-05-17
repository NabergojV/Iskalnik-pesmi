CREATE TABLE izvajalec (
  izvajalecID integer PRIMARY KEY, 
  ime text NOT NULL);

CREATE TABLE album(
  albumID integer PRIMARY KEY,
  naslov text NOT NULL);

CREATE TABLE zvrst(
  zvrstID integer PRIMARY KEY,
  ime text NOT NULL);

CREATE TABLE pesem(
  pesemID integer PRIMARY KEY,
  naslov text NOT NULL,
  dolžina integer NOT NULL,
  leto date NOT NULL);


# dodaj pravice vsem članom
GRANT ALL ON ALL TABLES IN SCHEMA public TO tajad;
GRANT ALL ON ALL TABLES IN SCHEMA public TO veronikan;
GRANT ALL ON ALL TABLES IN SCHEMA public TO marinas;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO tajad;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO veronikan;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO marinas;