//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Booking'
@Metadata.allowExtensions: true
@VDM: {
    viewType: #CONSUMPTION,
    usage.type: [#TRANSACTIONAL_PROCESSING_SERVICE]
}

@Search.searchable: true

define view entity ZACH_C_BOOKINGTP as projection on ZACH_R_BOOKINGTP as Booking
{
    key Bookinguuid,
    Traveluuid,
    @Search.defaultSearchElement: true
    Bookingid,
    Bookingdate,
    Customerid,
    Flightdate,
    Flightprice,
    Currencycode,
    Createdby,
    Lastchangedby,
    Locallastchangedat,
    /* Associations */
    _Customer,
    _Travel : redirected to parent ZACH_C_TRAVELTP
}
