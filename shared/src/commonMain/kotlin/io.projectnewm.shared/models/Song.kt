package io.projectnewm.shared.models

data class Song (
    val image: String,
    val title: String,
    val artist: Artist,
    val isNft: Boolean,
    val songId: String,
)