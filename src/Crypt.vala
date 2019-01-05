using Soup;
using Gtk;
using Json;
using WebKit;
using Gee;
using Cairo;

/*
- Split up code and condense it
- remove warnings and errors
- make sure numbers don't go null because of length
*/
//valac --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg webkit2gtk-4.0 --pkg gee-0.8 --pkg gstreamer-1.0 Crypt.vala

public class Crypt: Gtk.Window{

  public double windowWidth;
  public double windowHeight;
  public Gtk.Window window = new Gtk.Window();
  public Gtk.Notebook notebook = new Gtk.Notebook();
  public Gtk.ComboBoxText comboBox = new Gtk.ComboBoxText();
  public Caroline caroline = new Caroline();
  public Gtk.CssProvider provider = new Gtk.CssProvider();
  public Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
  public Gtk.Box secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  public Gtk.Grid chartGrid = new Gtk.Grid ();
  public Gtk.Grid mainGrid = new Gtk.Grid ();
  public MainLoop m = new MainLoop();
  public Coin currentCoin = new Coin();
  public Coin currentCoinHour = new Coin();
  public Draw drawClass = new Draw();
  public Gtk.Spinner spinner = new Gtk.Spinner();
  private double[] DATA = {};
  private double[] HIGH = {};
  private double[] LOW = {};
  public int signalDampener = 0;
  public int signalDampenerSecondary = 0;
  public string CODE_STYLE = """
    .box{
      padding-left: 10px;
    }

    .area{
      padding: 10px;
      background-color: #3a3f44;
    }

    .padding-top{
      padding-top: 10px;
    }

    .title-text{
      font-size: 20px;
    }

    .large-text{
      font-size: 18px;
    }

    .sub-text-coin-view{
      font-size: 14px;
    }

    .price-text{
      font-size: 18px;
      color: #00db3c;
    }

    .price-red-text{
      font-size: 18px;
      color: #ff0000;
    }

    .price-blue-text{
      font-size: 18px;
      color: #00aeae;
    }
  """;

  public void getCoins(){

    this.comboBox = new Gtk.ComboBoxText ();
    this.comboBox.append("0","BTC");
    this.comboBox.append("1","LTC");
    this.comboBox.append("2","ETH");
    this.comboBox.append("3","BCH");
    this.comboBox.append("4","XMR");
    this.comboBox.append("5","DASH");
    this.comboBox.append("6","ZEC");
    this.comboBox.append("7","ETC");
    this.comboBox.active = 0;

  }

  public void addCoinTab(string coinAbrv){

    this.spinner.active = true;
    Gtk.Grid coinGridHorizontal = new Gtk.Grid ();

    this.currentCoin.getCoinInfoFull(coinAbrv);
    this.windowHeight = 600;

    Gtk.Label priceTitle = new Gtk.Label (coinAbrv
    .concat(": ",this.currentCoin.price.to_string()," | ",this.currentCoin.change24Hour.to_string(),
    " | ",this.currentCoin.changeP24Hour.to_string()));
    priceTitle.xalign = 0;
    Gtk.Label price = new Gtk.Label ("Price: " + this.currentCoin.price);
    Gtk.Label lastUpdate = new Gtk.Label ("Last Update: " + this.currentCoin.lastUpdate);
    Gtk.Label lastVolume = new Gtk.Label ("Last Volume: " + this.currentCoin.lastVolume);
    Gtk.Label lastVolumeTo = new Gtk.Label ("Last Volume To: " + this.currentCoin.lastVolumeTo);
    Gtk.Label lastTradeID = new Gtk.Label ("Last TradeID: " + this.currentCoin.lastTradeID);
    Gtk.Label volumeDay = new Gtk.Label ("Volume Day: " + this.currentCoin.volumeDay);
    Gtk.Label volumeDayTo = new Gtk.Label ("Volume Day To: " + this.currentCoin.volumeDayTo);
    Gtk.Label volume24Hour = new Gtk.Label ("Volume 24 Hour: " + this.currentCoin.volume24Hour);
    Gtk.Label volume24HourTo = new Gtk.Label ("Volume 24 Hour To: " + this.currentCoin.volume24HourTo);
    Gtk.Label openDay = new Gtk.Label ("Open Day: " + this.currentCoin.openDay);
    Gtk.Label highDay = new Gtk.Label ("Open High Day: " + this.currentCoin.highDay);
    Gtk.Label lowDay = new Gtk.Label ("Open Low Day: " + this.currentCoin.lowDay);
    Gtk.Label open24Hour = new Gtk.Label ("Open 24h: " + this.currentCoin.open24Hour);
    Gtk.Label high24Hour = new Gtk.Label ("Open High 24h: " + this.currentCoin.high24Hour);
    Gtk.Label low24Hour = new Gtk.Label ("Open Low 24h: " + this.currentCoin.high24Hour);
    Gtk.Label lastMarket = new Gtk.Label ("Last Market: " + this.currentCoin.lastMarket);
    Gtk.Label change24Hour = new Gtk.Label ("Change Last 24h: " + this.currentCoin.change24Hour);
    Gtk.Label changeP24Hour = new Gtk.Label ("Change Percent Last 24h: " + this.currentCoin.changeP24Hour);
    Gtk.Label changeDay = new Gtk.Label ("Change Day: " + this.currentCoin.changeDay);
    Gtk.Label changePDay = new Gtk.Label ("Change Percent Day: " + this.currentCoin.changePDay);
    Gtk.Label supply = new Gtk.Label ("Supply: " + this.currentCoin.supply);
    Gtk.Label mCap = new Gtk.Label ("Market Cap: " + this.currentCoin.mCap);
    Gtk.Label totalVolume24Hour = new Gtk.Label ("Total Volume 24h: " + this.currentCoin.totalVolume24Hour);
    Gtk.Label totalVolume24HTo = new Gtk.Label ("Total Volume 24h To: " + this.currentCoin.totalVolume24HTo);
    priceTitle.get_style_context().add_class("title-text");
    priceTitle.xalign = 0;
    price.get_style_context().add_class("sub-text-coin-view");
    price.xalign = 0;
    lastUpdate.get_style_context().add_class("sub-text-coin-view");
    lastUpdate.xalign = 0;
    lastVolume.get_style_context().add_class("sub-text-coin-view");
    lastVolume.xalign = 0;
    lastVolumeTo.get_style_context().add_class("sub-text-coin-view");
    lastVolumeTo.xalign = 0;
    lastTradeID.get_style_context().add_class("sub-text-coin-view");
    lastTradeID.xalign = 0;
    volumeDay.get_style_context().add_class("sub-text-coin-view");
    volumeDay.xalign = 0;
    volumeDayTo.get_style_context().add_class("sub-text-coin-view");
    volumeDayTo.xalign = 0;
    volume24Hour.get_style_context().add_class("sub-text-coin-view");
    volume24Hour.xalign = 0;
    volume24HourTo.get_style_context().add_class("sub-text-coin-view");
    volume24HourTo.xalign = 0;
    openDay.get_style_context().add_class("sub-text-coin-view");
    openDay.xalign = 0;
    highDay.get_style_context().add_class("sub-text-coin-view");
    highDay.xalign = 0;
    lowDay.get_style_context().add_class("sub-text-coin-view");
    lowDay.xalign = 0;
    open24Hour.get_style_context().add_class("sub-text-coin-view");
    open24Hour.xalign = 0;
    high24Hour.get_style_context().add_class("sub-text-coin-view");
    high24Hour.xalign = 0;
    low24Hour.get_style_context().add_class("sub-text-coin-view");
    low24Hour.xalign = 0;
    lastMarket.get_style_context().add_class("sub-text-coin-view");
    lastMarket.xalign = 0;
    change24Hour.get_style_context().add_class("sub-text-coin-view");
    change24Hour.xalign = 0;
    changeP24Hour.get_style_context().add_class("sub-text-coin-view");
    changeP24Hour.xalign = 0;
    changeDay.get_style_context().add_class("sub-text-coin-view");
    changeDay.xalign = 0;
    changePDay.get_style_context().add_class("sub-text-coin-view");
    changePDay.xalign = 0;
    supply.get_style_context().add_class("sub-text-coin-view");
    supply.xalign = 0;
    mCap.get_style_context().add_class("sub-text-coin-view");
    mCap.xalign = 0;
    totalVolume24Hour.get_style_context().add_class("sub-text-coin-view");
    totalVolume24Hour.xalign = 0;
    totalVolume24HTo.get_style_context().add_class("sub-text-coin-view");
    totalVolume24HTo.xalign = 0;

    Gtk.Box verticalBoxSecondary = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    verticalBoxSecondary.pack_start(priceTitle,false,false);
    verticalBoxSecondary.pack_start(price,false,false);
    verticalBoxSecondary.pack_start(lastUpdate,false,false);
    verticalBoxSecondary.pack_start(lastVolume,false,false);
    verticalBoxSecondary.pack_start(lastVolumeTo,false,false);
    verticalBoxSecondary.pack_start(lastTradeID,false,false);
    verticalBoxSecondary.pack_start(volumeDay,false,false);
    verticalBoxSecondary.pack_start(volumeDayTo,false,false);
    verticalBoxSecondary.pack_start(volume24Hour,false,false);
    verticalBoxSecondary.pack_start(volume24HourTo,false,false);
    verticalBoxSecondary.pack_start(openDay,false,false);
    verticalBoxSecondary.pack_start(highDay,false,false);
    verticalBoxSecondary.pack_start(lowDay,false,false);
    verticalBoxSecondary.pack_start(open24Hour,false,false);
    verticalBoxSecondary.pack_start(high24Hour,false,false);
    verticalBoxSecondary.pack_start(low24Hour,false,false);
    verticalBoxSecondary.pack_start(lastMarket,false,false);
    verticalBoxSecondary.pack_start(change24Hour,false,false);
    verticalBoxSecondary.pack_start(changeP24Hour,false,false);
    verticalBoxSecondary.pack_start(changeDay,false,false);
    verticalBoxSecondary.pack_start(changePDay,false,false);
    verticalBoxSecondary.pack_start(supply,false,false);
    verticalBoxSecondary.pack_start(mCap,false,false);
    verticalBoxSecondary.pack_start(totalVolume24Hour,false,false);
    verticalBoxSecondary.pack_start(totalVolume24HTo,false,false);

    Caroline hourLineChart = drawClass.drawLargeChartHour(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/2) - 50);
    Caroline dayLineChart = drawClass.drawLargeChartDay(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);
    Caroline weekLineChart = drawClass.drawLargeChartWeek(coinAbrv,((int)this.windowWidth) - 50,(int)(this.windowHeight/3) - 50);

    Timeout.add(500,()=>{
      hourLineChart.queue_draw();
      dayLineChart.queue_draw();
      weekLineChart.queue_draw();
      this.notebook.show_all();
      return true;
    });

    Gtk.Box chartBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

    chartBox.pack_start (hourLineChart);
    chartBox.pack_start (new Gtk.Label ("Minute"), false, false, 0);
    chartBox.pack_start (dayLineChart);
    chartBox.pack_start (new Gtk.Label ("Day"), false, false, 0);
    chartBox.pack_start (weekLineChart);
    chartBox.pack_start (new Gtk.Label ("Week"), false, false, 0);
    chartBox.get_style_context().add_class("area");

    Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
    scrolled.set_min_content_width((int)(this.windowWidth/1.7));
    scrolled.set_min_content_height((int)this.windowHeight/3);
    scrolled.add(chartBox);
    scrolled.get_style_context().add_class("area");

    Gtk.Grid coinGrid = new Gtk.Grid ();
    coinGrid.orientation = Gtk.Orientation.HORIZONTAL;
    coinGrid.attach(scrolled,0,0,3,1);
    coinGrid.attach(verticalBoxSecondary, 3,0,1,1);
    coinGrid.get_style_context().add_class("box");
    coinGrid.set_row_homogeneous(true);
    coinGrid.set_column_homogeneous(true);

    Gtk.Label title = new Gtk.Label (coinAbrv);
    this.notebook.insert_page (coinGrid, title,1);
    this.notebook.show_all();

    Timeout.add (20 * 1000, () => {

      this.spinner.active = true;

      this.currentCoin.getCoinInfoFull(coinAbrv);

      priceTitle.label = coinAbrv
      .concat(": ",this.currentCoin.price.to_string()," | ",this.currentCoin.change24Hour.to_string(),
      " | ",this.currentCoin.changeP24Hour.to_string());
      priceTitle.xalign = 0;
      price.label = "Price: " + this.currentCoin.price;
      lastUpdate.label = "Last Update: " + this.currentCoin.lastUpdate;
      lastVolume.label = "Last Volume: " + this.currentCoin.lastVolume;
      lastVolumeTo.label = "Last Volume To: " + this.currentCoin.lastVolumeTo;
      lastTradeID.label = "Last TradeID: " + this.currentCoin.lastTradeID;
      volumeDay.label = "Volume Day: " + this.currentCoin.volumeDay;
      volumeDayTo.label = "Volume Day To: " + this.currentCoin.volumeDayTo;
      volume24Hour.label = "Volume 24 Hour: " + this.currentCoin.volume24Hour;
      volume24HourTo.label = "Volume 24 Hour To: " + this.currentCoin.volume24HourTo;
      openDay.label = "Open Day: " + this.currentCoin.openDay;
      highDay.label = "Open High Day: " + this.currentCoin.highDay;
      lowDay.label = "Open Low Day: " + this.currentCoin.lowDay;
      open24Hour.label = "Open 24h: " + this.currentCoin.open24Hour;
      high24Hour.label = "Open High 24h: " + this.currentCoin.high24Hour;
      low24Hour.label = "Open Low 24h: " + this.currentCoin.low24Hour;
      lastMarket.label = "Last Market: " + this.currentCoin.lastMarket;
      change24Hour.label = "Change Last 24h: " + this.currentCoin.change24Hour;
      changeP24Hour.label = "Change Percent Last 24h: " + this.currentCoin.changeP24Hour;
      changeDay.label = "Change Day: " + this.currentCoin.changeDay;
      changePDay.label = "Change Percent Day: " + this.currentCoin.changePDay;
      supply.label = "Supply: " + this.currentCoin.supply;
      mCap.label = "Market Cap: " + this.currentCoin.mCap;
      totalVolume24Hour.label = "Total Volume 24h: " + this.currentCoin.totalVolume24Hour;
      totalVolume24HTo.label ="Total Volume 24h To: " + this.currentCoin.totalVolume24HTo;

      currentCoin.getPriceDataHour(coinAbrv);

      hourLineChart.DATA = currentCoin.DATA;
      hourLineChart.HIGH = currentCoin.HIGH;
      hourLineChart.LOW = currentCoin.LOW;
      hourLineChart.calculations();

      currentCoin.getPriceDataDay(coinAbrv);

      dayLineChart.DATA = currentCoin.DATA;
      dayLineChart.HIGH = currentCoin.HIGH;
      dayLineChart.LOW = currentCoin.LOW;
      dayLineChart.calculations();

      currentCoin.getPriceDataWeek(coinAbrv);

      weekLineChart.DATA = currentCoin.DATA;
      weekLineChart.HIGH = currentCoin.HIGH;
      weekLineChart.LOW = currentCoin.LOW;
      weekLineChart.calculations();

      this.notebook.show_all();
      this.spinner.active = false;

      return true;

    });

    this.spinner.active = false;

  }

  public void getMainPageCoins(){

    MainLoop loop = new MainLoop ();

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,BCH,LTC,ETH&tsyms=USD");

    session.queue_message (message, (sess, message) => {

		  try {

			  var parser = new Json.Parser ();
        parser.load_from_data((string) message.response_body.flatten().data, -1);
        var root_object = parser.get_root ().get_object ();
        var btcData = root_object.get_object_member ("RAW").get_object_member("BTC").get_object_member("USD");
        var bchData = root_object.get_object_member ("RAW").get_object_member("BCH").get_object_member("USD");
        var ltcData = root_object.get_object_member ("RAW").get_object_member("LTC").get_object_member("USD");
        var ethData = root_object.get_object_member ("RAW").get_object_member("ETH").get_object_member("USD");

        Gtk.Label pricesHomeLabel = new Gtk.Label ("Current Coin Prices");
        pricesHomeLabel.get_style_context().add_class("title-text");
        pricesHomeLabel.get_style_context().add_class("padding-top");

        Gtk.Box verticalGridBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        verticalGridBox.get_style_context().add_class("area");
        verticalGridBox.set_spacing(10);
        verticalGridBox.pack_start(pricesHomeLabel);

        double btcPrice = btcData.get_double_member("PRICE");
        double btcHigh = btcData.get_double_member("HIGH24HOUR");
        double btcLow = btcData.get_double_member("LOW24HOUR");
        int64 btcTime = btcData.get_int_member("LASTUPDATE");
        DateTime btcTimeObject = new DateTime.from_unix_utc (btcTime);

        Gtk.Label btcLabel = new Gtk.Label ("Bitcoin");

        Gtk.Label btcPriceLabel;

        if (btcPrice.to_string().len() > 5){

          btcPriceLabel = new Gtk.Label (" Current: $".concat(btcPrice.to_string().slice(0,6)));

        }else{

          btcPriceLabel = new Gtk.Label (" Current: Unavailable");

        }

        Gtk.Label btcHighLabel;

        if (btcHigh.to_string().len() > 5){

          btcHighLabel = new Gtk.Label (" | High: $".concat(btcHigh.to_string().slice(0,6)));

        }else{

          btcHighLabel = new Gtk.Label (" | High: Unavailable");

        }


        Gtk.Label btcLowLabel;

        if (btcLow.to_string().len() > 5){

          btcLowLabel = new Gtk.Label (" | Low: $".concat(btcLow.to_string().slice(0,6)));

        }else{

          btcLowLabel = new Gtk.Label (" | Low: Unavailable");

        }

        Gtk.Label btcDateLabel = new Gtk.Label ("Last Update: ".concat(btcTimeObject.to_string()));
        btcLabel.get_style_context().add_class("large-text");
        btcPriceLabel.get_style_context().add_class("price-blue-text");
        btcHighLabel.get_style_context().add_class("price-text");
        btcLowLabel.get_style_context().add_class("price-red-text");
        btcLabel.set_alignment(0,0);
        btcDateLabel.set_alignment(0,0);

        var btcGrid = new Gtk.Grid ();
        btcGrid.orientation = Gtk.Orientation.HORIZONTAL;
        btcGrid.attach (btcLabel,      0, 0, 1, 1);
        btcGrid.attach (btcPriceLabel, 1, 0, 1, 1);
        btcGrid.attach (btcHighLabel,  2, 0, 1, 1);
        btcGrid.attach (btcLowLabel,   3, 0, 1, 1);
        btcGrid.attach (btcDateLabel,  0, 1, 1, 1);

        verticalGridBox.pack_start(btcGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        double bchPrice = bchData.get_double_member("PRICE");
        double bchHigh = bchData.get_double_member("HIGH24HOUR");
        double bchLow = bchData.get_double_member("LOW24HOUR");
        int64 bchTime = bchData.get_int_member("LASTUPDATE");
        DateTime bchTimeObject = new DateTime.from_unix_utc (bchTime);

        Gtk.Label bchLabel = new Gtk.Label ("Bitcoin Cash");

        Gtk.Label bchPriceLabel;

        if (bchPrice.to_string().len() > 4){

          bchPriceLabel = new Gtk.Label (" Current: $".concat(bchPrice.to_string().slice(0,5)));

        }else{

          bchPriceLabel = new Gtk.Label (" Current: Unavailable");

        }

        Gtk.Label bchHighLabel;

        if (bchHigh.to_string().len() > 4){

          bchHighLabel = new Gtk.Label (" | High: $".concat(bchHigh.to_string().slice(0,5)));

        }else{

          bchHighLabel = new Gtk.Label (" | High: Unavailable");

        }


        Gtk.Label bchLowLabel;

        if (bchLow.to_string().len() > 4){

          bchLowLabel = new Gtk.Label (" | Low: $".concat(bchLow.to_string().slice(0,5)));

        }else{

          bchLowLabel = new Gtk.Label (" | Low: Unavailable");

        }

        Gtk.Label bchDateLabel = new Gtk.Label ("Last Update: ".concat(bchTimeObject.to_string()));
        bchLabel.get_style_context().add_class("large-text");
        bchPriceLabel.get_style_context().add_class("price-blue-text");
        bchHighLabel.get_style_context().add_class("price-text");
        bchLowLabel.get_style_context().add_class("price-red-text");
        bchLabel.set_alignment(0,0);
        bchDateLabel.set_alignment(0,0);

        var bchGrid = new Gtk.Grid ();
        bchGrid.orientation = Gtk.Orientation.HORIZONTAL;
        bchGrid.attach (bchLabel,      0, 0, 1, 1);
        bchGrid.attach (bchPriceLabel, 1, 0, 1, 1);
        bchGrid.attach (bchHighLabel,  2, 0, 1, 1);
        bchGrid.attach (bchLowLabel,   3, 0, 1, 1);
        bchGrid.attach (bchDateLabel,  0, 1, 1, 1);
        bchGrid.get_style_context().add_class("off-row-color");

        verticalGridBox.pack_start(bchGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        double ltcPrice = ltcData.get_double_member("PRICE");
        double ltcHigh = ltcData.get_double_member("HIGH24HOUR");
        double ltcLow = ltcData.get_double_member("LOW24HOUR");
        double ltcTime = ltcData.get_double_member("LASTUPDATE");
        DateTime ltcTimeObject = new DateTime.from_unix_utc ((int64)ltcTime);

        Gtk.Label ltcLabel = new Gtk.Label ("Litecoin");

        Gtk.Label ltcPriceLabel;

        if (ltcPrice.to_string().len() > 3){

          ltcPriceLabel = new Gtk.Label (" Current: $".concat(ltcPrice.to_string().slice(0,4)));

        }else{

          ltcPriceLabel = new Gtk.Label (" Current: Unavailable");

        }

        Gtk.Label ltcHighLabel;

        if (ltcHigh.to_string().len() > 3){

          ltcHighLabel = new Gtk.Label (" | High: $".concat(ltcHigh.to_string().slice(0,4)));

        }else{

          ltcHighLabel = new Gtk.Label (" | High: Unavailable");

        }


        Gtk.Label ltcLowLabel;

        if (ltcLow.to_string().len() > 3){

          ltcLowLabel = new Gtk.Label (" | Low: $".concat(ltcLow.to_string().slice(0,4)));

        }else{

          ltcLowLabel = new Gtk.Label (" | Low: Unavailable");

        }

        Gtk.Label ltcDateLabel = new Gtk.Label ("Last Update: ".concat(ltcTimeObject.to_string()));
        ltcLabel.get_style_context().add_class("large-text");
        ltcPriceLabel.get_style_context().add_class("price-blue-text");
        ltcHighLabel.get_style_context().add_class("price-text");
        ltcLowLabel.get_style_context().add_class("price-red-text");
        ltcLabel.set_alignment(0,0);
        ltcDateLabel.set_alignment(0,0);

        var ltcGrid = new Gtk.Grid ();
        ltcGrid.orientation = Gtk.Orientation.HORIZONTAL;
        ltcGrid.attach (ltcLabel,      0, 0, 1, 1);
        ltcGrid.attach (ltcPriceLabel, 1, 0, 1, 1);
        ltcGrid.attach (ltcHighLabel,  2, 0, 1, 1);
        ltcGrid.attach (ltcLowLabel,   3, 0, 1, 1);
        ltcGrid.attach (ltcDateLabel,  0, 1, 1, 1);

        verticalGridBox.pack_start(ltcGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        double ethPrice = ethData.get_double_member("PRICE");
        double ethHigh = ethData.get_double_member("HIGH24HOUR");
        double ethLow = ethData.get_double_member("LOW24HOUR");
        double ethTime = ethData.get_double_member("LASTUPDATE");
        DateTime ethTimeObject = new DateTime.from_unix_utc ((int64)ethTime);

        Gtk.Label ethLabel = new Gtk.Label ("Etherum");

        Gtk.Label ethPriceLabel;

        if (ethPrice.to_string().len() > 5){

          ethPriceLabel = new Gtk.Label (" Current: $".concat(ethPrice.to_string().slice(0,6)));

        }else{

          ethPriceLabel = new Gtk.Label (" Current: Unavailable");

        }

        Gtk.Label ethHighLabel;

        if (ethHigh.to_string().len() > 5){

          ethHighLabel = new Gtk.Label (" | High: $".concat(ethHigh.to_string().slice(0,6)));

        }else{

          ethHighLabel = new Gtk.Label (" | High: Unavailable");

        }


        Gtk.Label ethLowLabel;

        if (ethLow.to_string().len() > 5){

          ethLowLabel = new Gtk.Label (" | Low: $".concat(ethLow.to_string().slice(0,6)));

        }else{

          ethLowLabel = new Gtk.Label (" | Low: Unavailable");

        }

        Gtk.Label ethDateLabel = new Gtk.Label ("Last Update: ".concat(ethTimeObject.to_string()));
        ethLabel.get_style_context().add_class("large-text");
        ethPriceLabel.get_style_context().add_class("price-blue-text");
        ethHighLabel.get_style_context().add_class("price-text");
        ethLowLabel.get_style_context().add_class("price-red-text");
        ethLabel.set_alignment(0,0);
        ethDateLabel.set_alignment(0,0);

        var ethGrid = new Gtk.Grid ();
        ethGrid.orientation = Gtk.Orientation.HORIZONTAL;
        ethGrid.attach (ethLabel,      0, 0, 1, 1);
        ethGrid.attach (ethPriceLabel, 1, 0, 1, 1);
        ethGrid.attach (ethHighLabel,  2, 0, 1, 1);
        ethGrid.attach (ethLowLabel,   3, 0, 1, 1);
        ethGrid.attach (ethDateLabel,  0, 1, 1, 1);
        ethGrid.get_style_context().add_class("off-row-color");

        verticalGridBox.pack_start(ethGrid,false,false);
        verticalGridBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

        this.secondaryBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        this.secondaryBox.pack_start(verticalGridBox,false,false);

      }catch (Error e) {

        stderr.printf ("Something is wrong in getMainPageCoins");

      }

      loop.quit();

    });

    loop.run();

  }

  public void getNewsMainPage(){

    Soup.Session session = new Soup.Session();
		Soup.Message message = new Soup.Message("GET", "https://min-api.cryptocompare.com/data/v2/news/?lang=EN");
		session.send_message (message);
    Gtk.Box newsBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    newsBox.set_spacing(10);
    Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);

    Gtk.Label currentNewsLabel = new Gtk.Label ("Current News");
    currentNewsLabel.get_style_context().add_class("title-text");
    currentNewsLabel.get_style_context().add_class("padding-top");

    newsBox.pack_start(currentNewsLabel);

		try {

			var parser = new Json.Parser ();
      parser.load_from_data((string) message.response_body.flatten().data, -1);
      var root_object = parser.get_root ().get_object ();
      var response = root_object.get_array_member("Data");

      foreach (var news in response.get_elements()) {

        var newsObject = news.get_object();

        Gtk.Label titleLabel = new Gtk.Label (newsObject.get_string_member("title"));
        Gtk.Label linkLabel = new Gtk.Label (newsObject.get_string_member("url"));
        linkLabel.set_markup("<a href='".concat(newsObject.get_string_member("url"),"'>",newsObject.get_string_member("url"),"</a>"));
        titleLabel.set_alignment(0,0);
        titleLabel.set_line_wrap(true);
        titleLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        titleLabel.set_max_width_chars(100);
        linkLabel.set_alignment(0,0);
        linkLabel.set_use_markup(true);
        linkLabel.set_line_wrap(true);
        linkLabel.set_selectable(true);
        linkLabel.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR);
        linkLabel.set_max_width_chars(100);

        newsBox.get_style_context().add_class("area");
        newsBox.pack_start(titleLabel);
        newsBox.pack_start(linkLabel);
        newsBox.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);

      }

    }catch (Error e) {

      stderr.printf ("Something is wrong in getNewsMainPage");

    }

    scrolled.set_max_content_width(200);
    scrolled.set_min_content_height(540);
    scrolled.add(newsBox);

    this.secondaryBox.pack_end(scrolled);

  }

}

int main (string[] args){
  Gtk.init (ref args);

  Crypt crypt = new Crypt();
  Draw drawClass = new Draw();

  try {

    crypt.provider.load_from_data (crypt.CODE_STYLE, crypt.CODE_STYLE.length);
    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), crypt.provider,
    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

  } catch (Error e) {

    warning("css didn't load %s",e.message);

  }

  Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);

  crypt.spinner.active = true;

  crypt.windowWidth = 1200;

  var windowTitle = "Crypt";
  crypt.window.title = windowTitle;
  crypt.window.set_default_size (1300,600);
  crypt.window.set_position (Gtk.WindowPosition.CENTER);
  Gtk.Label title = new Gtk.Label ("Home");

  Gtk.Label btcLabel = new Gtk.Label ("Bitcoin (BTC)");
  Gtk.Label ltcLabel = new Gtk.Label ("Litecoin (LTC)");
  Gtk.Label ethLabel = new Gtk.Label ("Etherum (ETH)");

  Caroline btcLineChart = drawClass.drawSmallChartHour("BTC",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);
  Caroline ltcLineChart = drawClass.drawSmallChartHour("LTC",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);
  Caroline ethLineChart = drawClass.drawSmallChartHour("ETH",((int)crypt.windowWidth) - 50,(int)(crypt.windowHeight/3) - 50);

  Timeout.add(500,()=>{
    btcLineChart.queue_draw();
    ltcLineChart.queue_draw();
    ethLineChart.queue_draw();
    crypt.notebook.show_all();
    return true;
  });


  Gtk.Label chartHomeLabel = new Gtk.Label ("Last Hour");
  chartHomeLabel.get_style_context().add_class("title-text");

  Gtk.Box chartBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

  chartBox.pack_start (chartHomeLabel, false, false, 0);
  chartBox.pack_start (btcLineChart);
  chartBox.pack_start (btcLabel, false, false, 0);
  chartBox.pack_start (ltcLineChart);
  chartBox.pack_start (ltcLabel, false, false, 0);
  chartBox.pack_start (ethLineChart);
  chartBox.pack_start (ethLabel, false, false, 0);
  chartBox.get_style_context().add_class("area");

  crypt.getMainPageCoins();
  crypt.getNewsMainPage();

  crypt.mainGrid.orientation = Gtk.Orientation.HORIZONTAL;
  crypt.mainGrid.attach(chartBox,0,0,1,1);
  crypt.mainGrid.attach(crypt.secondaryBox, 1,0,1,1);
  crypt.mainGrid.get_style_context().add_class("box");
  crypt.mainGrid.set_row_homogeneous(true);
  crypt.mainGrid.set_column_homogeneous(true);

  Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
  scrolled.add(crypt.mainGrid);
  scrolled.set_max_content_width(1200);
  scrolled.set_min_content_height(700);

  crypt.notebook.insert_page (scrolled, title,0);

  crypt.getCoins();

  Gtk.Button addCoinButton = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
  addCoinButton.clicked.connect (() => {

    crypt.addCoinTab(crypt.comboBox.get_active_text());

  });

  var header = new Gtk.HeaderBar ();
  header.show_close_button = true;
  header.title = windowTitle;
  header.pack_start (crypt.comboBox);
  header.pack_start (addCoinButton);
  header.pack_end (crypt.spinner);
  header.show_all();
  crypt.window.set_titlebar(header);
  crypt.window.add(crypt.notebook);
  crypt.window.show_all();
  crypt.window.destroy.connect(()=>{
    crypt.m.quit();
    Gtk.main_quit();
  });

  crypt.spinner.active = false;

  Timeout.add (30 * 1000, () => {

    crypt.spinner.active = true;

    crypt.currentCoinHour.getPriceDataHour("BTC");

    btcLineChart.DATA = crypt.currentCoinHour.DATA;
    btcLineChart.HIGH = crypt.currentCoinHour.HIGH;
    btcLineChart.LOW = crypt.currentCoinHour.LOW;
    btcLineChart.calculations();

    crypt.currentCoinHour.getPriceDataHour("LTC");

    ltcLineChart.DATA = crypt.currentCoinHour.DATA;
    ltcLineChart.HIGH = crypt.currentCoinHour.HIGH;
    ltcLineChart.LOW = crypt.currentCoinHour.LOW;
    ltcLineChart.calculations();

    crypt.currentCoinHour.getPriceDataHour("ETH");

    ethLineChart.DATA = crypt.currentCoinHour.DATA;
    ethLineChart.HIGH = crypt.currentCoinHour.HIGH;
    ethLineChart.LOW = crypt.currentCoinHour.LOW;
    ethLineChart.calculations();

    crypt.getMainPageCoins();
    crypt.getNewsMainPage();

    crypt.mainGrid.remove_column(1);
    crypt.mainGrid.attach(crypt.secondaryBox,1,0,1,1);
    crypt.notebook.show_all();
    crypt.spinner.active = false;

    return true;

  });

  Gtk.main();
  return 0;

}
