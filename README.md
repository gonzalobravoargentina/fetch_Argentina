
Wind fetch
==========

The fetch length, is the length of water over which a given wind can blown. The higher the wind fetch
from a certain direction, then more wave energy could be imparted if the wind blows for that direction. Wind Fetch should be analysed along with the predominant wind speed and direction of the sites. If you got a high fetch value but the wind blows few times in the year from that direction, then wave energy will not be well represented by fetch.

fetch_Argentina
==========
With this R scrip you can calculate wind fetch in any point of the Argentinean coast. The shapefile used is [ARG_adm0](https://data.amerigeoss.org/id/dataset/argentina-administrative-level-0-boundaries) which is store in the folder **ARG_adm0**.


## Sources

Package used for calculating fetch:
* [fetchR](https://github.com/blasee/fetchR)


## Installation packages

Install `fetchR`

Only available in the development version from GitHub
```{r eval=FALSE}
devtools::install_github("blasee/fetchR")
```

## Results can be stored in KML and imported into Google Earth
![KML](https://www.proyectosub.org.ar/wp-content/uploads/2020/06/Screen-Shot-2020-06-08-at-15.49.04.png)



[![psub_footer](https://www.proyectosub.org.ar/wp-content/uploads/2020/04/logoletras_org.png)](https://proyectosub.org.ar)
