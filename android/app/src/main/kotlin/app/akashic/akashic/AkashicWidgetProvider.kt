package app.akashic.akashic

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class AkashicWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.akashic_widget).apply {
                setTextViewText(R.id.widget_item_count, widgetData.getString("itemCount", "—"))
                setTextViewText(R.id.widget_latest, widgetData.getString("latestAdditions", ""))
                setTextViewText(R.id.widget_loans, widgetData.getString("loans", ""))
                setOnClickPendingIntent(R.id.widget_root, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java))
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
