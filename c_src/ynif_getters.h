/*
 *     ynif_getters.h
 *
 *     simple getters for existing object, all they are read-only
 *
 *     this file is part of 'yalinka' project, http://yalinka.heim.in.ua
 *
 *     Erlang NIF interface to K-dimensional trees
 *
 *     Copyright 2013 Serge A. Ribalchenko <fisher@heim.in.ua>
 *
 *     Redistribution and use in source and binary forms, with or without
 *     modification, are permitted provided that the following conditions are
 *     met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *     A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *     OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *     LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *     DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *     THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *     OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef YNIF_GETTERS_H
#define YNIF_GETTERS_H

extern ERL_NIF_TERM size_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM dimension_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM is_ready_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM compare_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM gettree_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM root_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);
extern ERL_NIF_TERM node_nif(ErlNifEnv*, int, const ERL_NIF_TERM []);

#endif

/*
 * Local Variables:
 * indent-tabs-mode: nil
 * show-trailing-whitespace: t
 * mode: c
 * End:
 *
 */
