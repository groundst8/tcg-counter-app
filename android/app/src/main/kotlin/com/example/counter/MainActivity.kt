package com.example.counter

import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

import android.nfc.tech.NfcV
import java.io.IOException
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity(), NfcAdapter.ReaderCallback {

    private val CHANNEL = "nfc_channel"
    private lateinit var methodChannel: MethodChannel
    private var nfcAdapter: NfcAdapter? = null
    private var tagInRange = false
    private var nfcV : NfcV? = null;
    private var scheduler : ScheduledExecutorService? = null;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
    }

    override fun onResume() {
        super.onResume()
        enableReaderMode()
    }

    override fun onPause() {
        super.onPause()
        disableReaderMode()
    }

    private fun enableReaderMode() {
        val flags = NfcAdapter.FLAG_READER_NFC_A or
                NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or
                NfcAdapter.FLAG_READER_NFC_V or
                NfcAdapter.FLAG_READER_NFC_BARCODE or
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS

        val options = Bundle()
        // Work around for some broken Nfc firmware implementations that poll the card too fast
        options.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)

        nfcAdapter?.enableReaderMode(this, this, flags, options)
    }

    private fun disableReaderMode() {
        nfcAdapter?.disableReaderMode(this)
        if (tagInRange) {
            tagInRange = false
            sendTagLost()
        }
    }

    override fun onTagDiscovered(tag: Tag?) {
        if (!tagInRange) {
            tagInRange = true
            sendTagDiscovered()
        }

        // Establish connection to the tag
        nfcV = NfcV.get(tag)
        try {
            nfcV?.connect()
            // Start periodic communication
            startPeriodicTask()
        } catch (e: IOException) {
            e.printStackTrace()
            handleTagLost()
        }
    }

    private fun handleTagLost() {
        if (tagInRange) {
            tagInRange = false
            sendTagLost()
        }
        // Clean up
        try {
            nfcV?.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        nfcV = null
        stopPeriodicTask()
        // Re-enable NFC reader mode
        runOnUiThread {
            enableReaderMode()
        }
    }
    private fun startPeriodicTask() {
        scheduler = Executors.newSingleThreadScheduledExecutor()
        scheduler?.scheduleAtFixedRate({
            try {
                // Send getSystemInfo command
                val response = nfcV?.transceive(getSystemInfoCommand())
                if (response == null || response.isEmpty()) {
                    // No response, tag might be lost
                    handleTagLost()
                }
            } catch (e: IOException) {
                // Exception occurred, tag is likely out of range
                handleTagLost()
            }
        }, 0, 1, TimeUnit.SECONDS)
    }

    private fun stopPeriodicTask() {
        scheduler?.shutdownNow()
        scheduler = null
    }

    private fun getSystemInfoCommand(): ByteArray {
        // ISO 15693 Get System Info command
        return byteArrayOf(0x02.toByte(), 0x2B.toByte())
    }

    private fun sendTagDiscovered() {
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onTagDiscovered", null)
        }
    }

    private fun sendTagLost() {
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onTagLost", null)
        }
    }
}
