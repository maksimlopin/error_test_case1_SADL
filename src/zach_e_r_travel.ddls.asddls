@AbapCatalog.sqlViewName: 'ZACHERTRAVEL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extension for Travel Basic'
@VDM.viewType: #EXTENSION
define view ZACH_E_R_TRAVEL
  as select from zlxtravel as Persistence
{
  key Persistence.traveluuid as TrevelUUID
}
