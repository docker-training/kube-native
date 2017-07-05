-- create table for product

CREATE TABLE products
(
  productid serial UNIQUE PRIMARY KEY,
  description character varying(10485760) NOT NULL,
  image character varying(255) NOT NULL,
  name character varying(255) NOT NULL,
  price double precision NOT NULL
);

ALTER TABLE products
  OWNER TO gordonuser;

CREATE TABLE images
(
  imageid serial UNIQUE PRIMARY KEY,
  description character varying(10485760) NOT NULL,
  url character varying(255) NOT NULL
);

ALTER TABLE images
  OWNER TO gordonuser;
ALTER ROLE gordonuser CONNECTION LIMIT -1;

-- add product data
-- note: images are pulled from the public folder at atsea/app/react-app/public
INSERT INTO products (name, description, image, price) VALUES ('Unusable Security', 'Unusuable security is not security', '/images/1.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Valentine''s Day', 'Love is meant to be shared', '/images/2.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Docker Tooling', 'Docker provides a whole suite of tools', '/images/3.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Docker Presents', 'Giving gifts every day', '/images/4.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Valentine''s Day', 'Love is in the air', '/images/5.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Docker Babies', 'For those with a cute little whale', '/images/6.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Experimental', 'Trying the latest', '/images/7.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('Docker for Developers', 'Escape the App Dependency Matrix', '/images/8.png', 25);
INSERT INTO products (name, description, image, price) VALUES ('DockerCon Copenhagen', 'DockerCon returns to Europe', '/images/9.png', 25);

INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26388-1381844103-11.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr01/15/9/anigif_enhanced-buzz-31540-1381844535-8.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26390-1381844163-18.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr06/15/10/anigif_enhanced-buzz-1376-1381846217-0.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr03/15/9/anigif_enhanced-buzz-3391-1381844336-26.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr06/15/10/anigif_enhanced-buzz-29111-1381845968-0.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr03/15/9/anigif_enhanced-buzz-3409-1381844582-13.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr02/15/9/anigif_enhanced-buzz-19667-1381844937-10.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26358-1381845043-13.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr06/15/9/anigif_enhanced-buzz-18774-1381844645-6.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr06/15/9/anigif_enhanced-buzz-25158-1381844793-0.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://ak-hdl.buzzfed.com/static/2013-10/enhanced/webdr03/15/10/anigif_enhanced-buzz-11980-1381846269-1.gif');
INSERT INTO products (description, url) VALUES('cat image', 'http://placekitten.com/g/400/400');'