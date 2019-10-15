import numpy as np
import pandas as pd
import datetime as dt
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, jsonify

engine = create_engine("sqlite:///Resources/hawaii.sqlite", connect_args={'check_same_thread': False}, echo=True)

Base = automap_base()
Base.prepare(engine, reflect=True)
Base.classes.keys()

Measurement = Base.classes.measurement
Station = Base.classes.station

session = Session(engine)

#Flask Setup
app = Flask(__name__)

latestDate = (session.query(Measurement.date)
             .order_by(Measurement.date.desc())
             .first())
latestDate = list(np.ravel(latestDate))[0]

latestDate = dt.datetime.strptime(latestDate, '%Y-%m-%d')
latestYear = int(dt.datetime.strftime(latestDate, '%Y'))
latestMonth = int(dt.datetime.strftime(latestDate, '%m'))
latestDay = int(dt.datetime.strftime(latestDate, '%d'))

yearBefore = dt.date(latestYear, latestMonth, latestDay) - dt.timedelta(days=365)
yearBefore = dt.datetime.strftime(yearBefore, '%Y-%m-%d')

@app.route("/")
def home():
    return (f"Surf's Up!: Hawai'i Climate API<br/>"
            f"Available Routes:<br/>"
            f"/api/v1.0/stations - a list of all weather stations<br/>"
            f"/api/v1.0/precipitaton - latest year of preceipitation data<br/>"
            f"/api/v1.0/temperature - latest year of temperature data<br/>"
            f"/api/v1.0/datesearch/2015-05-30 - weather information for date and every day after<br/>"
            f"/api/v1.0/datesearch/2015-05-30/2016-01-30 weather information dates specified <br/>")

@app.route("/api/v1.0/stations")
def stations():
    results = session.query(Station.name).all()
    stations_list = list(np.ravel(results))
    return jsonify(stations_list)

    results =  session.query(Measurement.station).group_by(Measurement.station).all()

@app.route("/api/v1.0/precipitaton")
def precipitation():
    
    results = (session.query(Measurement.date, Measurement.prcp, Measurement.station).filter(Measurement.date > yearBefore).order_by(Measurement.date)
.all())
    
    preci_list = []
    for result in results:
        preci_dict = {result.date: result.prcp, "Station": result.station}
        preci_list.append(preci_dict)

    return jsonify(preci_list)

@app.route("/api/v1.0/tobs")
def tobs():

    results = (session.query(Measurement.date, Measurement.tobs, Measurement.station).filter(Measurement.date > yearBefore).order_by(Measurement.date).all())

    tobs_list = []
    for result in results:
        tobs_result = {result.date: result.tobs, "Station": result.station}
        tobs_list.append(tobs_result)

    return jsonify(tobs_list)

@app.route("/api/v1.0/<start>")
def start(start=None):

    from_start = session.query(Measurement.date, func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= start).group_by(Measurement.date).all()
    from_start_list=list(from_start)
    return jsonify(from_start_list)

@app.route("/api/v1.0/<start>/<end>")
def start_end(start=None, end=None):
    
    between_dates = session.query(Measurement.date, func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= start).filter(Measurement.date <= end).group_by(Measurement.date).all()
    between_dates_list=list(between_dates)
    return jsonify(between_dates_list)

if __name__ == '__main__':
    app.run(debug=True)