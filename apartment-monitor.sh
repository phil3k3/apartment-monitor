#!/usr/bin/env bash

# Read current state
current=0
FILE=./state
if [ -f $FILE ];
then
	current=$(<state)
fi	

echo $current
target=$(($current%2))
echo $target
mkdir -p $target

# Get apartment data
curl http://www.aufbau.at/wohnungen-wiedervermietung.html > $target/aufbau_wiedervermietung.html 2>> err.log
curl http://www.aufbau.at/neueProjekte.html > $target/aufbau_neu.html 2>> err.log
curl http://www.bauhilfe.at/html/wo-mi.html > $target/bauhilfe.html 2>> err.log
curl http://www.ebg-wohnen.at/ > $target/ebg.html 2>> err.log
curl "http://www.bwsg.at/de/objektsuche?state_id=3&unit_type_id=1&ownership%5B%5D=R&surface_from=&surface_until=&rooms_from=3&rooms_until=3&searchtype=quick" > $target/bwsg.html 2>> err.log
curl "http://www.ebg-wohnen.at/Suche.aspx?typ=1&zmin=3&zmax=5&art=$1$3$6&rg=$1$6&wa=$0$1" > $target/ebg.html 2>> err.log
curl http://www.egw.at/immobilien/bestands-wohnungen/miete/ > $target/egw_bestand.html 2>> err.log
curl http://www.egw.at/immobilien/vormerkung-neubau/in-bau/ > $target/egw_bau.html 2>> err.log
curl http://www.egw.at/immobilien/vormerkung-neubau/in-planung/ > $target/egw_planung.html 2>> err.log
curl "http://www.heimbau.at/wohnungen?searchcrit=1&zimmer=3&flaeche=0&objecttype=wohnung&search=1" > $target/heimbau.html 2>> err.log
curl http://www.sozialbau.at/nc/home/suche/neubau-wohnungen/in-bau/ | python xpath.py '//tr/td[position()=2]' > $target/sozialbau_bau.html  2>> err.log
curl http://www.sozialbau.at/nc/home/suche/neubau-wohnungen/in-planung/ | python xpath.py '//tr/td[position()=2]' > $target/sozialbau_planung.html 2>> err.log
curl "http://www.familienwohnbau.at/immobiliensuche/?nutzungsart=W&verwertung=miete" > $target/familien.html 2>> err.log
curl 'http://www.frieden.at/umbraco/Surface/ProjectSearch/SearchProjects' --data 'SelectedDistrictIds=21%2C22%2C26%2C27%2C28%2C32%2C35%2C36%2C38%2C42%2C43%2C102%2C113%2C114%2C115&SelectedLivingUnitType=18&SelectedLegalForm=0&Rooms2=false&Rooms3=true&Rooms4=false&RoomsSpecial=false&Available=true&InBau=true&InPlan=true&RequestCount=1' > $target/frieden.html 2>> err.log
curl http://www.gartenheim.at/projekte.html > $target/gartenheim.html 2>> err.log
curl 'http://www.gesiba.at/portlets/at.gesiba.portal.web.portlets.GesibaMap/gesibamaprpc' -H 'Origin: http://www.gesiba.at' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36" -H 'Content-Type: text/x-gwt-rpc; charset=UTF-8' -H 'Accept: */*' -H 'X-GWT-Module-Base: http://www.gesiba.at/portlets/at.gesiba.portal.web.portlets.GesibaMap/' -H 'X-GWT-Permutation: 09A8C21C24FE7BE3AE9A9E9417B686B2' -H 'Referer: http://www.gesiba.at/en/angebote' -H 'Connection: keep-alive' --data-binary '7|0|4|http://www.gesiba.at/portlets/at.gesiba.portal.web.portlets.GesibaMap/|267A7360645A49A60D28AABDA8E2FFF3|at.gesiba.portal.web.portlets.client.maps.GesibaMapRPC|getData|1|2|3|4|0|' --compressed > $target/gesiba 2>> err.log
curl http://www.gewog-wohnen.at/immobilienangebot/projekte-in-planung/ > $target/gewog_planung.html 2>> err.log
curl http://www.gewog-wohnen.at/immobilienangebot/projekte-in-bau/ > $target/gewog_bau.html 2>> err.log
curl 'http://www.gewog-wohnen.at/umbraco/Surface/LivingUnits/Search?Length=11' --data 'Filter.City=&Filter.LegalForm=&Filter.Room=3&Filter.UnitType=&Filter.MonthlyCostTo=&Filter.SquareMeterFrom=&Filter.SquareMeterTo=&X-Requested-With=XMLHttpRequest' > $target/gewog.html 2>> err.log
curl http://www.gsgwohnen.at/sofort-verfuegbar/ | python xpath.py '//article' > $target/gsg.html 2>> err.log
curl http://www.gsgwohnen.at/projekte/ | python xpath.py '//article' > $target/gsg_projekte.html 2>> err.log
curl http://www.heim-wohnen.at/niederoesterreich/ > $target/heim_wohnen_noe.html 2>> err.log
curl http://www.heim-wohnen.at/wien/ > $target/heim_wohnen_wien.html 2>> err.log
curl http://www.wiensued.at/neue-projekte/7.htm > $target/wiensued_neu.html 2>> err.log
curl http://www.wiensued.at/bestandswohnung/8.htm > $target/wiensued_bestand.html 2>> err.log

# div id="block-migra-projekte-block-migra-suchergebnis"
curl 'http://www.migra.at/Wohnungen/Wohnungssuche/Wohnungen-mieten-kaufen?Miete=1&inBau=1&sofort=1&idProviders1=1&size%5Bvalue%5D=10&size%5Bvalue2%5D=200&rooms%5Bvalue%5D=1&rooms%5Bvalue2%5D=5&form_id=migra_projekte_wohnungssuche&email_me=' | python xpath.py '//div[@id="block-migra-projekte-block-migra-suchergebnis"]' > $target/migra.html 2>> err.log
curl 'https://www.wohnen.at/umbraco/Surface/UnitSearch/Filter' --data 'FilterState.DistrictChecked.Index=0&FilterState.DistrictsChecked%5B0%5D.Id=101&FilterState.DistrictsChecked%5B0%5D.Checked=false&FilterState.DistrictChecked.Index=1&FilterState.DistrictsChecked%5B1%5D.Id=102&FilterState.DistrictsChecked%5B1%5D.Checked=false&FilterState.DistrictChecked.Index=2&FilterState.DistrictsChecked%5B2%5D.Id=113&FilterState.DistrictsChecked%5B2%5D.Checked=false&FilterState.DistrictChecked.Index=3&FilterState.DistrictsChecked%5B3%5D.Id=114&FilterState.DistrictsChecked%5B3%5D.Checked=false&FilterState.DistrictChecked.Index=4&FilterState.DistrictsChecked%5B4%5D.Id=-1&FilterState.DistrictsChecked%5B4%5D.Checked=false&FilterState.IsCompletedChecked=true&FilterState.IsCompletedChecked=false&FilterState.IsInConstructionChecked=true&FilterState.IsInConstructionChecked=false&FilterState.IsPlannedChecked=true&FilterState.IsPlannedChecked=false&FilterState.IsRentalChecked=true&FilterState.IsRentalChecked=false&FilterState.IsOwnershipChecked=false&X-Requested-With=XMLHttpRequest' > $target/wohnen_at.html 2>> err.log
curl http://www.neusiedlerbau.at/index.php?id=34 | python xpath.py '//div[@id="col1"]' > $target/neusiedler.html 2>> err.log
curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36" http://www.wbvgoed.at/in-planung > $target/wbvgoed_planung.html 2>> err.log
curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36" http://www.wbvgoed.at/in-bau > $target/wbvgoed_neu.html 2>> err.log
curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36" http://www.wbvgoed.at/wohnungen > $target/wbvgoed.html 2>> err.log
curl 'http://www.oesw.at/immobilienangebot/sofort-wohnen/wohnungsliste.html' --data '_Q_MIETE_WE=2&_Q_Zimmer_3=%3D3&_Q_GroesseQm=&_Q_GroesseQmmin=&_Q_GroesseQmmax=&mode=1&clear=1' > $target/oesw.html 2>> err.log
curl http://www.oesw.at/immobilienangebot/in-bau.html?pos=0 > $target/oesw_bau.html 2>> err.log
curl http://www.oesw.at/immobilienangebot/in-planung.html?pos=0 > $target/oesw_planung.html 2>> err.log
curl http://www.wbv-gpa.at/angebot/freie-wohnungen > $target/wbv_gpa.html 2>> err.log
# div id="content"
curl http://www.schwarzatal.at/projekte/neubau.html | python xpath.py '//div[@id="content"]' > $target/schwarzatal_neu.html 2>> err.log
# div id="content"
curl http://www.schwarzatal.at/projekte/geplant.html | python xpath.py '//div[@id="content"]' > $target/schwarzatal_geplant.html 2>> err.log
# div id="content"
curl http://www.schwarzatal.at/projekte/freie-wohnungen.html | python xpath.py '//div[@id="content"]' > $target/schwarzatal_frei.html 2>> err.log
curl http://www.siedlungsunion.at/wohnen/sofort > $target/siedlungsunion.html 2>> err.log
curl http://www.siedlungsunion.at/wohnen/inbau > $target/siedlungsunion_bau.html 2>> err.log
curl http://www.siedlungsunion.at/wohnen/inplanung > $target/siedlungsunion_planung.html 2>> err.log
# div id="ebsg_result_listing_box" //div[@id="ebsg_result_listing_box"]
curl https://www.ebsg.at/neues-zuhause-finden/objektsuche/wohnung_in_planung+wohnung_in_bau+wohnung_bezugsfertig/zimmer_min/3/zimmer_max/5.html | python xpath.py '//div[@id="ebsg_result_listing_box"]' > $target/ebsg.html 2>> err.log

# h1 class="search"
curl -L 'https://www.oevw.at/wohnungen/' --data 'objektart2=w&projektart2=n&sofortbezug=n&objektart=m' | python xpath.py '//h1[@class="search"]' > $target/oevw1.html 2>> err.log
# h1 class="search"	
curl -L 'https://www.oevw.at/wohnungen/' --data 'objektart2=w&projektart2=r' | python xpath.py '//h1[@class="search"]' > $target/oevw2.html 2>> err.log

curl 'http://www.noe-wohnbaugruppe.at/server/api/search/get/queryNew?json=' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' --data-binary '{"village":"","district":"","postalcode":0,"sizeFrom":0,"sizeTo":2147483647,"roomsFrom":3,"roomsTo":2147483647,"monthlyCostsFrom":0,"monthlyCostsTo":2147483647,"ownFundsFrom":0,"ownFundsTo":2147483647,"feature":[],"estateType":"","contractType":"","neighbourhood":""}' > $target/noe.json 2>> err.log

# Write new state
echo $(($current+1)) > ./state

# Compare previous state (if available with current)

previous=$(($current-1))
previous_target=$(($previous%2))
if [ -d $previous_target ];
then
	echo Comparing current with previous result
	if [ -f ./comparison ]; 
	then	
		rm comparison
	fi
	echo $previous_target
	echo $target
	diff -rq $previous_target/ $target/ > comparison 2>&1
	if [ -s ./comparison ];
	then
	    echo Found new apartments
	    source mail.cfg
	    echo Sending mail from $sender to $receiver
	    text=$(<comparison)
	    python mail.py "$sender" "$receiver" "$text" && echo E-Mail sent successfully
	else
		echo No new apartments
	fi
else 
	echo Directory does not exist	
fi
