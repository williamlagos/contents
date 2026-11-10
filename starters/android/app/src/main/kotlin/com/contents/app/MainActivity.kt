package com.contents.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import com.contents.app.data.model.ContentItem
import com.contents.app.data.network.ContentsClient
import com.contents.app.ui.ArticleDetailScreen
import com.contents.app.ui.FeedScreen

class MainActivity : ComponentActivity() {
    private val contentsClient = ContentsClient()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(color = MaterialTheme.colorScheme.background) {
                    var selectedArticle by remember { mutableStateOf<ContentItem?>(null) }

                    if (selectedArticle != null) {
                        ArticleDetailScreen(
                            article = selectedArticle!!,
                            onBack = { selectedArticle = null }
                        )
                    } else {
                        FeedScreen(
                            client = contentsClient,
                            onArticleClick = { article -> selectedArticle = article }
                        )
                    }
                }
            }
        }
    }
}
