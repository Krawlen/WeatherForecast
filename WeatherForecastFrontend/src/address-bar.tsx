import { AddressAutofill } from "@mapbox/search-js-react"

import React from 'react';
import ReactDOM from 'react-dom';
import { AddressAutofill } from '@mapbox/search-js-react';



export const AddressBar = () =>{

return (<>
  <form id="weather-form">

 
  <AddressAutofill accessToken="my-access-token-here">
                <input
                    name="address" placeholder="Address" type="text"
                    autoComplete="address-line1"
                />
            </AddressAutofill>

    </form>

</>)
}