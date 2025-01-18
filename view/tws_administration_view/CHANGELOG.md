# CHANGELOG

## CURRENT

- Notes:

    1. Refatoring sets and classes implementations from the newest [tws_foundation_client] version.
    2. Widget newest version migrated from [tws_guard_view] project. The migrated widgets are the following:
        - [TWSAutocompleteField]
        - [TWSArticleTable]
        - [TWSDatepickerField]
        - [TWSInputText]
        - [TWSSectionDivider]
        - [TWSImageViewer]
    3. Removed unnecesary whispers views:
        - Manufacturers
        - Situations
    4. [Truck] view table and table viewer implementation.
    5. Added new [TWSCascadeSection] component.
    6. Added new [TWSIncrementalList] component.
    7. Added exceptions dialogs for Trucks creation form.
    8. Now the [Truck] creation form can set and create [TruckExternal] & [Truck] models
    in the same operation.
    9. added a new [updateFactory] method in [TWSArticleCreatorItemState] to allow switch between sets models.
    10. [Truck] plates creation form now allow creating a [Truck] with a single plate with any country setting.
    11. [Truck] update implementation.
    12. Added custom dialogs for [Truck] create and update forms.
    13. [TWSAutocompleteField] Fix: change local lists on rebuild component not update the content.
    14. Added [TruckExternal] table to Trucks Article. Now you can switch between Truck view table or External view table in the same article.
    15. Added [Yardlog] option page in main menu.
    16. Added [Yardlog] view table and trucks inventory whispers.
    17. Plates creation option changed to a [TWSIncrementalList] control.

    18. Added [Human_Resources] page.

        1. Added [Contact] article.
    
    19. Migrated TWS widget changes from [GuardView] environment: 
        - The [TWSAutocompleteField] future mode, now perform a database search to avoid data overflow.
        - [TWSArticleTableFieldOptions] Width property added.
        - Now each [TWSArticleTable] column width can be changed using the [TWSArticleTableFieldOptions] width property.
        - Added a doble tap summit button preventions on [WisperFrame].

    20. Added [Trailer] Article page.
    21. Added the view table for [Trailer] and [TrailerExternal].
    22. Added the creation whisper for [Trailers] article.
    23. Added update feature on table for [Traile] and [TrailerExternal].
    24. Fixed some state and view bugs for [TWSAutocompleteField] widget.
    25. Changed [Trucks] article icon.
    26. Added a [SingleChildScrollView] for content in [TWSConfirmationDialog] widget.
    27. Added a [suffixLabel] param to [TWSDatepicker] widget to show secundary text.
    28. Added [TWSCascadeSection] function boolean parameter [onPressed] to return the show button state.
    29. Changed name properties for [TWSAutocompleteField] to fit property name and functionality:
        - [isOptionalLabel] -> [suffixLabel].
        - [suffixLabel] -> [suffixResultLabel].
    30. Added missing information in [Trucks] & [Trailers] view tables.
    31. Now the [TWSAutocompleteField] updates the [localList] data when the parameter changes on rebuild.
    32. Added [color] & [foreColor] parameter in [TWSDisplayFlat].
    33. Added [TWSCascadeSection] in optionals sets objects in update view to all articles in [Business] page.
    34. Added [DateTime] extension [fullDateString] to convert a datetime property in a string that contains date and hour.
    35. Added an optional [TimePicker] dialog in [TWSDatetimePicker] to add the time to the date.
    36. Added update feature to [Yardlog] view table.
    37. Removing text gap in [TWSImageViewer] when is not necesary.
    38. Added [Locations] Article.
    39. Added [View] table, [Create] & [Update] whispers for [Locations] article.
    40. Added the following parameters for [TWSInputText]:
        - [Formatter] Property.
        - [KeyboardType] Property.
    41. Extensions files removed and migrated to foundation environment.
    42. Added [Sections] article.
    43. Added [View] table, [Create] & [Update] whispers for [Locations] article.
    44. Added search filters to [View] table whispers for all articles in [Business] module.
    45. Added exceptions notifications in update forms in all articles for [Business] module.

- Dependencies upgrade:
    1. (-) tws_foundation_client: Deprecated now used tws_foundation_client
    2. (-) csm_view: Deprecated now used csm_view
    3. (+) tws_foundation ([])
    4. (+) csm_view ([])
    5. tws_administration_service ([2.0.0] -> [2.1.0])
    6. web ([0.5.1] -> [1.0.0])
    7. http ([1.2.1] -> [1.2.2])
    8. args ([2.5.0] -> [2.6.0])
    9. go_router ([14.2.7] -> [14.3.0])
    10. loggin ([1.3.0] -> [.1.2.0])
    11. path_provider_android ([2.2.10] -> [2.2.12])
    12. platform ([3.1.5] -> [3.1.6])
    13. typed_data ([1.3.2] -> [1.4.0])
    14. web ([1.0.0] -> [1.1.0])
    15. xdg_directories ([1.0.4] -> [1.1.0])

## 1.0.0-alpha [09/07/2024]

- Notes:

    1. Included new major version of [tws_foundation_client]
    2. Removed old deprecated services from [tws_foundation_client]

- Dependencies upgrade:

    1. path_provider_android ([2.2.6] -> [2.2.7])
    2. path_provider_windows ([2.2.1] -> [2.3.0])

        - Major Versions:

            1. tws_foundation_client ([1.1.3] -> [2.0.0])
