import * as ActionTypes from './actions';

const initialState = {
    data: ''
};

export function weatherReducer(state = initialState, action) {
    switch (action.type) {
        case ActionTypes.LATEST_DATA:
            return { ...state, data: action.text };
        default:
            return state;
    }
}
