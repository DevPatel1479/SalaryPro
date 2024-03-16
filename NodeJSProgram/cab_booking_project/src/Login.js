import React from 'react';
import { Link } from 'react-router-dom';
import "./Login.css";

const Login = () => {
    return (
        <div className="content">
            <h2>Login</h2>
            <p>Choose how you want to login:</p>
            <div className='"navbar-item"'>
                <Link to="/login/driver" className='nav-item link'>Login as Driver</Link>
            </div>
            <div className='"navbar-item"'>
                <Link to="/login/passenger" className='nav-item link'>Login as Passenger</Link>
            </div>
        </div>
    );
}

export default Login;
