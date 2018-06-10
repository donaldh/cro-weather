import React from 'react';
import { render } from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { Provider, connect } from 'react-redux';
import thunkMiddleware from 'redux-thunk';
import WSAction from 'redux-websocket-action';
import * as Actions from './actions';
import { weatherReducer } from './reducer';

var Weather = props => (
    <div className='container'>
        <div id="now" className="alert alert-info">
            Currently {props.data}
        </div>
    </div>
);

var App = props => (
    <div>
        <Weather data={props.data} />
    </div>
);

function mapProps(state) {
    return state;
}
function mapDispatch(dispatch) {
    return {
    };
}

let store = createStore(weatherReducer, applyMiddleware(thunkMiddleware));

['latest-data'].forEach(endpoint => {
    let host = window.location.host;
    let wsAction = new WSAction(store, 'ws://' + host + '/' + endpoint, {
        retryCount:3,
        reconnectInterval: 3
    });
    wsAction.start();
});

let ConnectedApp = connect(mapProps, mapDispatch)(App);
render(
    <Provider store={store}>
        <ConnectedApp />
    </Provider>,
    document.getElementById('app'));
