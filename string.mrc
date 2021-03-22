alias lineChar {

        var %nameTable lineHorizontal lineVertical cornerTopLeft cornerTopRight cornerBottomLeft cornerBottomRight splitRight splitLeft splitDown splitUp cross
        var %valueTable 9552 9553 9556 9559 9562 9565 9568 9571 9574 9577 9580

        var %token $findtok(%nameTable, $1, 1, 32)

        if (%token != $null) {

                return $chr($gettok(%valueTable, %token, 32))
        }

        else {

                mError [getLineChar] no such line character: $1
        }
}