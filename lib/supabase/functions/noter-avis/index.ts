/*
  Edge Function: noter-avis

  BUT : cette fonction est une “structure” (architecture) pour recevoir un payload
  depuis l’app (Flutter) et préparer l’insertion d’un avis.

  Payload attendu (en l’état de l’app actuelle) :
  {
    "commerceId": string,
    "commentaire": string,
    // Optionnel : noteIA / note
    "noteIA": number,
    "note": number
  }

  Note : La logique d’écriture DB est volontairement minimale/placeholder ici.
  À compléter selon le schéma réel Supabase.
*/

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type RequestBody = {
  commerceId: string;
  commentaire: string;
  noteIA?: number;
  note?: number;
};

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
  const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    return new Response(
      JSON.stringify({ error: "Missing env SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  let body: RequestBody;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const commerceId = body.commerceId;
  const commentaire = body.commentaire;
  const noteIA = (body.noteIA ?? body.note ?? 0) as number;

  if (!commerceId || !commentaire) {
    return new Response(JSON.stringify({ error: "commerceId and commentaire are required" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  // ------------------------------------------------------------
  // PLACEHOLDER : insertion DB (à adapter au schéma réel)
  // ------------------------------------------------------------
  // Exemple (à activer si la table et les colonnes existent) :
  // const { data, error } = await supabase
  //   .from('avis')
  //   .insert({
  //     commerce_id: commerceId,
  //     commentaire,
  //     note_ia: noteIA,
  //   })
  //   .select()
  //   .single();
  // if (error) throw error;
  // return new Response(JSON.stringify(data), { ... });

  return new Response(
    JSON.stringify({
      ok: true,
      payload: {
        commerceId,
        commentaire,
        noteIA,
      },
      // Insérer ici l’objet DB une fois le schéma confirmé.
      // inserted: data,
    }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});

