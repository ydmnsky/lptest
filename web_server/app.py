# app.py
import os

from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy

database_name = os.getenv('DATABASE_NAME')
database_user = os.getenv('DATABASE_USER')
database_password = os.getenv('DATABASE_PASSWORD')
database_host = os.getenv('DATABASE_HOST')
database_port = os.getenv('DATABASE_PORT')

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = (
    f'postgresql://{database_user}:{database_password}@{database_host}:{database_port}/{database_name}'
)

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


class User(db.Model):
    __tablename__ = 'User'
    UserID = db.Column(db.Integer, primary_key=True)
    FullName = db.Column(db.String(255))
    Login = db.Column(db.String(255))
    HashPassword = db.Column(db.String(255))
    Email = db.Column(db.String(255))
    PhoneNumber = db.Column(db.String(255))
    # Establish a relationship with the UserPermission table
    permissions = db.relationship('UserPermission', backref='user')


class Permission(db.Model):
    __tablename__ = 'Permission'
    PermissionID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(255))
    users = db.relationship('UserPermission', backref='permission')


class UserPermission(db.Model):
    __tablename__ = 'UserPermission'
    UserPermissionID = db.Column(db.Integer, primary_key=True)
    UserID = db.Column(db.Integer, db.ForeignKey('User.UserID'))
    PermissionID = db.Column(db.Integer, db.ForeignKey('Permission.PermissionID'))


@app.route('/')
def index():
    users = User.query.all()
    return render_template('index.html', users=users)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
