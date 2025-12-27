@AbapCatalog.sqlViewAppendName: 'ZACHERTRAVELTP'
@EndUserText.label: 'Extension foe Travel'
extend view ZACH_E_R_TRAVEL with ZACH_E_R_TRAVELTP
{
    Persistence.zach_incl_field as zach_incl_field
}
