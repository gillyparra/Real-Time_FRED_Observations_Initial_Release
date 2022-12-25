# Real-Time_FRED_Observations_Initial_Release
Script to pull, clean and format FRED/ALFRED data to obtain observations when they where first released to the public.

In the code, the data for each variable is obtained using the get_alfred_series function and is then formatted by selecting the first observation for each release date using the aggregate and tail functions. This means that the data for each variable includes the first observation of the data when the observation was initially released to the public.
This is useful because it ensures that the data is as unbiased as possible and does not have a forward-looking bias. This can be important for analyzing macroeconomic trends and decisions based on the data.
Additionally, the data is expanded daily using the seq and left_join functions, allowing for more granular analysis and a more straightforward comparison with other time series data. Finally, any missing values in the data are filled using the fill function, ensuring that the data is complete and ready for analysis.
