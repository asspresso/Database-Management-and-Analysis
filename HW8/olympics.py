import configparser
from operator import itemgetter

import sqlalchemy
from sqlalchemy import create_engine

# columns and their types, including fk relationships
from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

# declarative base, session, and datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# configuring your database connection
config = configparser.ConfigParser()
config.read('config.ini')
u, pw, host, db = itemgetter('username', 'password', 'host', 'database')(config['db'])
dsn = f'postgresql://{u}:{pw}@{host}/{db}'
print(f'using dsn: {dsn}')

# SQLAlchemy engine, base class and session setup
engine = create_engine(dsn, echo=True)
Base = declarative_base()
Session = sessionmaker(engine)
session = Session()

# TODO: Write classes and code here
class AthleteEvent(Base):
    __tablename__ = 'AthleteEvent'

    # columns
    athlete_event_id = Column('athlete_event_id', Integer, primary_key = True)
    id = Column('id', Integer)
    name = Column('name', String)
    age = Column('age', Integer)
    height = Column('height', Float)
    weight = Column('weight', Float)
    team = Column('team', String)
    noc = Column(String, ForeignKey('NOCRegion.noc'))
    games = Column('games', String) 
    year = Column('years', Integer)
    season = Column('season', String)
    city = Column('city', String)
    sport = Column('sport', String)
    event = Column('event', String)
    medal = Column('medal', String)

    # property
    noc_region = relationship("NOCRegion", back_populates="athlete_events")

    # methods
    def __repr__(self):
        return f'{self.name, self.noc, self.season, self.year, self.event, self.medal}'
    
    def __str__(self):
        return self.__repr__() 


class NOCRegion(Base):
    __tablename__ = 'NOCRegion'

    # columns
    noc = Column('noc', String, primary_key = True)
    region = Column('region', String)
    note = Column('note', String)

    # property
    athlete_events = relationship("AthleteEvent", back_populates="noc_region")

# create tables
Base.metadata.create_all(engine)

# This part is used to delete previously added objects for testing purpose
session.query(AthleteEvent).filter(AthleteEvent.name=="Yuto Horigome").delete()
session.commit()
session.query(NOCRegion).filter(NOCRegion.region=="Japan").delete()
session.commit()

# insert new objects
r = NOCRegion(noc = 'JPN', region = 'Japan')
session.add(r)
session.commit()

a = AthleteEvent(
    name = "Yuto Horigome", age = 21, team = 'Japan', medal = 'Gold', year = 2020, season = 'Summer', 
    city = 'Tokyo', noc = 'JPN', sport = 'Skateboarding', event = 'Skatboarding, Street, Men')
session.add(a)
session.commit()

# filter
result = session.query(AthleteEvent).filter(
    AthleteEvent.noc == 'JPN', 
    AthleteEvent.year >= 2016,
    AthleteEvent.medal == 'Gold')

# display results
for r in result:
    print(f'{r.name,r.noc_region.region,r.event,r.year,r.season}')
    print(r.name)
    print(r.noc_region.region)
    print(r.event)
    print(r.year)
    print(r.season)

session.close()