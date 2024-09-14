import { AddressAutofill } from '@mapbox/search-js-react';
import { AddressBar } from './address-bar'
import { ForecastResults } from './forecast-results';


function App() {

  return (
    <>
   
      <h1>Weather Forecast</h1>


    <AddressBar/>
    <form>
            <AddressAutofill accessToken="my-access-token-here">
                <input
                    name="address" placeholder="Address" type="text"
                    autoComplete="address-line1"
                />
            </AddressAutofill>
            </form>
    <ForecastResults>

    </ForecastResults>
    </>
  )
}

export default App
