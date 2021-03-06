/*
  Copyright (C) 2014,2016 Marcus Soll
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "uiconnection.h"
#include <sailfishapp.h>
#include "Settings.hpp"

UIConnection::UIConnection(QTranslator *translator, QObject *parent) :
    QObject(parent),
    _translator(translator)
    //_coreTranslator(coreTranslator)
{
    if(!(settings.getValueFor("language", "") == QString()))
    {
        changeLanguage(settings.getValueFor("language", ""));
    }
}


void UIConnection::changeLanguage(QString language)
{
    settings.saveValueFor("language", language);
    if(_translator != NULL)
    {
       // _translator->load((QString(":translation/harbour-reversi-ui_%1").arg(language)));
       // _coreTranslator->load(QString(":translation/reversi-core_%1").arg(language));

        _translator->load(SailfishApp::pathTo("translations").toLocalFile() + "/" + language + ".qm");
      //  _coreTranslator->load(QString(":translation/reversi-thakir_prayer_times %1").arg(language));


    }
    else
    {
      //  REVERSI_ERROR_MSG("Trying to change language with NULL-Translator");
    }
}


